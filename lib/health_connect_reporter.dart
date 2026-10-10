import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/aggregate.dart';
import 'model/anchor.dart';
import 'model/availability.dart';
import 'model/change_set.dart';
import 'model/data_origin.dart';
import 'model/decorator/extensions.dart';
import 'model/decorator/platform.dart';
import 'model/decorator/subscription.dart';
import 'model/page.dart';
import 'model/payload/sample.dart';
import 'model/permission.dart';
import 'model/time_group.dart';
import 'model/time_range.dart';
import 'model/type/aggregation.dart';
import 'model/type/feature.dart';
import 'model/type/health_type.dart';
import 'model/type/ordering.dart';

/// [HealthConnectReporter] class.
/// Reads, writes and observes Android Health Connect data
/// through the Kotlin library HealthConnectReporter
/// https://github.com/kvs-coder/HealthConnectReporter.
/// Invokes calls to native side. Channel: [health_connect_reporter_method_channel]
/// All responses are the library's JSON payloads, parsed into the models
/// of `health_connect_reporter/model/`.
///
/// The list of Platform methods:
/// - [availability]
/// - [requestPermissions]
/// - [grantedPermissions]
/// - [revokeAllPermissions]
/// - [isFeatureAvailable]
/// - [openSettings]
/// - [openInstall]
/// - [read]
/// - [readPage]
/// - [readById]
/// - [aggregate]
/// - [aggregateGroups]
/// - [insert]
/// - [update]
/// - [delete]
/// - [deleteByIds]
/// - [deleteByRange]
/// - [anchor]
/// - [changes]
/// - [observe]
///
/// Health Connect is available only on Android: on any other platform
/// [availability] returns [Availability.unavailable] and every other method
/// throws an [UnsupportedError].
/// For Apple Health on iOS see https://pub.dev/packages/health_kit_reporter,
/// for Samsung Health see https://pub.dev/packages/samsung_health_reporter.
///
/// The app needs Android 8 (API 26) or later; Health Connect is part of
/// Android 14+ and an app from Google Play on Android 9–13.
///
/// The app declares every `android.permission.health.*` permission it
/// requests in its manifest, the permissions-rationale activity and
/// (Android 14+) the `VIEW_PERMISSION_USAGE` activity-alias; the plugin
/// adds nothing to the manifest.
///
/// Timestamps are epoch milliseconds, as in the library.
/// Errors arrive as [PlatformException]s whose code is the method name,
/// whose message is the library's error message and whose details name the error:
/// `NotAuthorized`, `InvalidType`, `InvalidValue`, `NotAvailable`,
/// `AnchorExpired` or `Platform`.
///
class HealthConnectReporter {
  /// [MethodChannel] link to `HealthConnectReporterPlugin.kt`
  ///
  static const MethodChannel _channel =
      MethodChannel('health_connect_reporter_method_channel');

  /// The method channel, only on Android: elsewhere every method but
  /// [availability] throws an [UnsupportedError].
  ///
  static MethodChannel get _methodChannel {
    requirePlatform(TargetPlatform.android, 'Health Connect');
    return _channel;
  }

  static Set<Permission> _permissions(String json) =>
      Permission.collect(jsonDecode(json)).toSet();

  static List<Map<String, dynamic>> _origins(Set<DataOrigin> origins) =>
      origins.map((e) => e.map).toList();

  static Future<bool> _status(String method,
      [Map<String, dynamic>? arguments]) async {
    return await _methodChannel.invokeMethod(method, arguments);
  }

  /// Checks whether Health Connect can be used on this device.
  ///
  /// Returns [Availability.unavailable] without a channel call
  /// on any platform but Android.
  ///
  static Future<Availability> availability() async {
    if (!runsOn(TargetPlatform.android)) return Availability.unavailable;
    final reply = await _channel.invokeMethod<String>('availability');
    return Availability.from(reply == null ? '' : '${jsonDecode(reply)}');
  }

  /// Shows the Health Connect permission screen on the app's activity
  /// and returns the permissions granted afterwards.
  /// Build the [permissions] with [Permission.of], [PermissionData] and
  /// the special permissions, e.g. [PermissionReadInBackground].
  ///
  /// Fails with `InvalidValue` when [permissions] is empty or names
  /// a permission the app's manifest doesn't declare, and with `NotAvailable`
  /// when a permission needs a [Feature] the device lacks.
  ///
  static Future<Set<Permission>> requestPermissions(
      Set<Permission> permissions) async {
    final String json = await _methodChannel.invokeMethod('requestPermissions',
        {'permissions': permissions.map((e) => e.map).toList()});
    return _permissions(json);
  }

  /// The permissions the user granted this app, without showing any screen.
  ///
  static Future<Set<Permission>> grantedPermissions() async {
    final String json = await _methodChannel.invokeMethod('grantedPermissions');
    return _permissions(json);
  }

  /// Revokes every permission the user granted this app.
  ///
  static Future<bool> revokeAllPermissions() => _status('revokeAllPermissions');

  /// Whether the Health Connect on this device supports a [feature],
  /// e.g. [Feature.skinTemperature] for [HealthType.skinTemperature].
  ///
  static Future<bool> isFeatureAvailable(Feature feature) =>
      _status('isFeatureAvailable', {'feature': feature.value});

  /// Opens Health Connect's data management screen,
  /// or its settings on older versions.
  ///
  static Future<bool> openSettings() => _status('openSettings');

  /// Opens Health Connect on Google Play, to install or update it when
  /// [availability] is [Availability.updateRequired].
  ///
  static Future<bool> openInstall() => _status('openInstall');

  /// Reads the samples of a [type] in the [range], following pages
  /// until [limit] (no limit by default). Newest first by default;
  /// [origins] reads only the records of these apps.
  ///
  /// Without the [PermissionReadHistory] permission Health Connect returns
  /// only data from 30 days before the first grant onwards.
  /// Fails with `NotAuthorized` without the read permission, with
  /// `NotAvailable` when the type needs a [Feature] the device lacks
  /// and with `InvalidValue` when [limit] is less than 1.
  ///
  static Future<List<Sample>> read(HealthType type, TimeRange range,
      {Ordering ordering = Ordering.descending,
      int? limit,
      Set<DataOrigin> origins = const {}}) async {
    final String json = await _methodChannel.invokeMethod('read', {
      'type': type.identifier,
      'range': range.map,
      'ordering': ordering.value,
      if (limit != null) 'limit': limit,
      'origins': _origins(origins),
    });
    return Sample.collect(jsonDecode(json));
  }

  /// Reads one page of the samples of a [type] in the [range]:
  /// at most [pageSize] (1–5000) samples. Pass [Page.nextPageToken]
  /// as [pageToken] for the next page.
  ///
  static Future<Page> readPage(HealthType type, TimeRange range,
      {int pageSize = 1000,
      String? pageToken,
      Ordering ordering = Ordering.descending,
      Set<DataOrigin> origins = const {}}) async {
    final String json = await _methodChannel.invokeMethod('readPage', {
      'type': type.identifier,
      'range': range.map,
      'pageSize': pageSize,
      if (pageToken != null) 'pageToken': pageToken,
      'ordering': ordering.value,
      'origins': _origins(origins),
    });
    return Page.fromJson(parseObject(json));
  }

  /// Reads the record of a [type] with the Health Connect [id],
  /// a [Sample.id]. Fails with `InvalidValue` when there is none.
  ///
  static Future<Sample> readById(HealthType type, String id) async {
    final String json = await _methodChannel
        .invokeMethod('readById', {'type': type.identifier, 'id': id});
    return Sample.factory(parseObject(json));
  }

  /// Aggregates one metric over the [range], e.g. the total steps.
  /// Its [Aggregate.value] is null when there is no data.
  ///
  static Future<Aggregate> aggregate(Aggregation aggregation, TimeRange range,
      {Set<DataOrigin> origins = const {}}) async {
    final String json = await _methodChannel.invokeMethod('aggregate', {
      'aggregation': aggregation.value,
      'range': range.map,
      'origins': _origins(origins),
    });
    return Aggregate.fromJson(parseObject(json));
  }

  /// Aggregates [aggregations] over the [range] in buckets of [group]:
  /// one [Aggregate] per bucket and metric, buckets in time order.
  /// [TimeGroupDuration] buckets have a fixed length; [TimeGroupPeriod]
  /// buckets are calendar periods in their zone.
  /// Fails with `InvalidValue` when [aggregations] is empty.
  ///
  static Future<List<Aggregate>> aggregateGroups(
      Set<Aggregation> aggregations, TimeRange range, TimeGroup group,
      {Set<DataOrigin> origins = const {}}) async {
    final String json = await _methodChannel.invokeMethod('aggregateGroups', {
      'aggregations': aggregations.map((e) => e.value).toList(),
      'range': range.map,
      'group': group.map,
      'origins': _origins(origins),
    });
    return Aggregate.collect(jsonDecode(json));
  }

  /// Inserts [samples] of one or more types and returns them as inserted,
  /// with their Health Connect [Sample.id], in input order.
  /// A sample without a [Sample.clientRecordId] gets a random one,
  /// so it can be updated and deleted later; one whose client record id
  /// is stored already replaces that record unless its
  /// [Sample.clientRecordVersion] is lower.
  ///
  /// Fails with `NotAuthorized` without the write permission and with
  /// `InvalidValue` for a value Health Connect rejects.
  ///
  static Future<List<WritableSample>> insert(
      List<WritableSample> samples) async {
    final String json = await _methodChannel.invokeMethod(
        'insert', {'samples': samples.map((e) => e.map).toList()});
    return Sample.collect(jsonDecode(json)).cast<WritableSample>();
  }

  /// Replaces stored records: a sample with a [Sample.clientRecordId]
  /// replaces the record with that client id unless its
  /// [Sample.clientRecordVersion] is lower, any other the record
  /// with its [Sample.id]. Fails with `InvalidValue` for a sample
  /// with neither.
  ///
  static Future<bool> update(List<WritableSample> samples) =>
      _status('update', {'samples': samples.map((e) => e.map).toList()});

  /// Deletes a stored [sample] by its [Sample.id],
  /// else by its [Sample.clientRecordId].
  ///
  static Future<bool> delete(WritableSample sample) =>
      _status('delete', {'sample': sample.map});

  /// Deletes records of a [type] by their Health Connect [ids] and
  /// their [clientRecordIds], all or none.
  /// Fails with `InvalidValue` when both are empty.
  ///
  static Future<bool> deleteByIds(HealthType type,
          {List<String> ids = const [],
          List<String> clientRecordIds = const []}) =>
      _status('deleteByIds', {
        'type': type.identifier,
        'ids': ids,
        'clientRecordIds': clientRecordIds,
      });

  /// Deletes the records of a [type] the app wrote in the [range].
  ///
  static Future<bool> deleteByRange(HealthType type, TimeRange range) =>
      _status('deleteByRange', {'type': type.identifier, 'range': range.map});

  /// Creates an [Anchor] at the current end of the change history
  /// of [types]; [origins] observes only the changes of these apps.
  /// Store it and pass it to [changes] or [observe].
  ///
  /// Fails with `InvalidValue` when [types] is empty.
  ///
  static Future<Anchor> anchor(Set<HealthType> types,
      {Set<DataOrigin> origins = const {}}) async {
    final String json = await _methodChannel.invokeMethod('anchor', {
      'types': types.map((e) => e.identifier).toList(),
      'origins': _origins(origins),
    });
    return Anchor.fromJson(parseObject(json));
  }

  /// Reads every change since [anchor]: upserted samples, deleted ids
  /// and the next anchor. Store [ChangeSet.anchor] for the next call.
  ///
  /// Health Connect keeps changes for 30 days: an older anchor fails with
  /// `AnchorExpired`, so read the data again in full and take a new anchor.
  /// In the background reading changes also needs
  /// [PermissionReadInBackground].
  ///
  static Future<ChangeSet> changes(Anchor anchor) async {
    final String json =
        await _methodChannel.invokeMethod('changes', {'anchor': anchor.map});
    return ChangeSet.fromJson(parseObject(json));
  }

  /// Polls the changes since [anchor] every [interval] while subscribed,
  /// first right away, and calls [onUpdate] with every non-empty [ChangeSet].
  /// Store the last [ChangeSet.anchor] to resume later.
  /// Every subscription polls on an [EventChannel] of its own;
  /// cancel it to stop polling. Errors, e.g. `AnchorExpired`, end polling
  /// and reach [onError]; so does a non-positive [interval].
  ///
  static StreamSubscription<dynamic> observe(Anchor anchor,
      {Duration interval = const Duration(minutes: 1),
      required void Function(ChangeSet changeSet) onUpdate,
      Function? onError}) {
    return subscribe<ChangeSet>(
        _methodChannel,
        'observe',
        {'anchor': anchor.map, 'interval': interval.inMilliseconds},
        (event) => ChangeSet.fromJson(parseObject(event)),
        onUpdate,
        onError);
  }
}
