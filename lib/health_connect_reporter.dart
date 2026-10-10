import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/availability.dart';
import 'model/decorator/platform.dart';
import 'model/permission.dart';
import 'model/type/feature.dart';

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
}
