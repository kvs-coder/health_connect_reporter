import 'dart:convert';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/aggregate.dart';
import 'package:health_connect_reporter/model/anchor.dart';
import 'package:health_connect_reporter/model/availability.dart';
import 'package:health_connect_reporter/model/change_set.dart';
import 'package:health_connect_reporter/model/data_origin.dart';
import 'package:health_connect_reporter/model/payload/sample.dart';
import 'package:health_connect_reporter/model/payload/intermenstrual_bleeding.dart';
import 'package:health_connect_reporter/model/payload/steps.dart';
import 'package:health_connect_reporter/model/payload/weight.dart';
import 'package:health_connect_reporter/model/time_group.dart';
import 'package:health_connect_reporter/model/time_range.dart';
import 'package:health_connect_reporter/model/type/aggregation.dart';
import 'package:health_connect_reporter/model/type/ordering.dart';
import 'package:health_connect_reporter/model/type/time_group_unit.dart';
import 'package:health_connect_reporter/model/permission.dart';
import 'package:health_connect_reporter/model/type/access_type.dart';
import 'package:health_connect_reporter/model/type/feature.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';

import 'fixtures.dart' as fixtures;

/// Every method sends the arguments the Kotlin dispatcher reads
/// and parses the reply it sends.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Health Connect runs only on Android
  setUpAll(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);
  tearDownAll(() => debugDefaultTargetPlatformOverride = null);

  const channel = MethodChannel('health_connect_reporter_method_channel');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <String, dynamic>{};
  final replies = <String, Object?>{};

  setUp(() {
    calls.clear();
    replies.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls[call.method] = call.arguments;
      final reply = replies[call.method];
      if (reply is PlatformException) throw reply;
      return reply;
    });
  });
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  group('availability', () {
    test('availability_parses_every_library_value', () async {
      const expected = {
        '"available"': Availability.available,
        '"update_required"': Availability.updateRequired,
        '"unavailable"': Availability.unavailable,
      };
      for (final entry in expected.entries) {
        replies['availability'] = entry.key;

        expect(await HealthConnectReporter.availability(), entry.value);
      }
      expect(calls.keys, ['availability']);
      expect(calls['availability'], isNull);
    });

    test('availability_of_an_unknown_value_throws_invalid_value', () async {
      replies['availability'] = '"sometimes"';

      expect(
          HealthConnectReporter.availability(),
          throwsA(isA<InvalidValueException>().having(
              (e) => e.cause, 'cause', 'Invalid Availability: sometimes')));
    });

    test('availability_without_a_reply_throws_invalid_value', () async {
      expect(HealthConnectReporter.availability(),
          throwsA(isA<InvalidValueException>()));
    });

    test('availability_passes_platform_errors_on', () async {
      replies['availability'] = PlatformException(
          code: 'availability', message: 'boom', details: 'Platform');

      expect(
          HealthConnectReporter.availability(),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'availability')
              .having((e) => e.details, 'details', 'Platform')));
    });
  });

  group('manager', () {
    final permissions = {
      const PermissionData(
          healthType: HealthType.steps, access: AccessType.read),
      const PermissionReadInBackground(),
      const PermissionReadHistory(),
      const PermissionWriteExerciseRoute(),
    };
    final permissionsJson = jsonEncode(fixtures.permissions);

    test('request_permissions_sends_every_permission_and_parses_the_granted',
        () async {
      replies['requestPermissions'] = permissionsJson;

      expect(await HealthConnectReporter.requestPermissions(permissions),
          permissions);
      expect(
          calls['requestPermissions'], {'permissions': fixtures.permissions});
    });

    test('request_permissions_passes_manifest_errors_on', () async {
      replies['requestPermissions'] = PlatformException(
          code: 'requestPermissions',
          message: 'Permissions missing from the app manifest',
          details: 'InvalidValue');

      expect(
          HealthConnectReporter.requestPermissions(
              Permission.of([HealthType.weight])),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'requestPermissions')
              .having((e) => e.details, 'details', 'InvalidValue')));
    });

    test('granted_permissions_parses_the_library_json', () async {
      replies['grantedPermissions'] = permissionsJson;

      expect(await HealthConnectReporter.grantedPermissions(), permissions);
      expect(calls['grantedPermissions'], isNull);
      replies['grantedPermissions'] = '[]';
      expect(await HealthConnectReporter.grantedPermissions(), isEmpty);
    });

    test('granted_permissions_of_an_unknown_kind_throw_invalid_value',
        () async {
      replies['grantedPermissions'] = '[{"type":"read_minds"}]';

      expect(HealthConnectReporter.grantedPermissions(),
          throwsA(isA<InvalidValueException>()));
    });

    test('revoke_all_permissions_replies_true', () async {
      replies['revokeAllPermissions'] = true;

      expect(await HealthConnectReporter.revokeAllPermissions(), isTrue);
      expect(calls.keys, ['revokeAllPermissions']);
    });

    test('is_feature_available_sends_the_kotlin_name', () async {
      replies['isFeatureAvailable'] = true;

      expect(
          await HealthConnectReporter.isFeatureAvailable(
              Feature.plannedExercise),
          isTrue);
      expect(calls['isFeatureAvailable'], {'feature': 'PLANNED_EXERCISE'});
    });

    test('screens_open', () async {
      replies['openSettings'] = true;
      replies['openInstall'] = true;

      expect(await HealthConnectReporter.openSettings(), isTrue);
      expect(await HealthConnectReporter.openInstall(), isTrue);
      expect(calls.keys, ['openSettings', 'openInstall']);
    });
  });

  group('reader', () {
    final range = TimeRange.fromJson(fixtures.timeRange);
    final origins = {const DataOrigin(packageName: 'com.example')};
    final originMaps = [fixtures.dataOrigin];

    test('read_sends_every_argument_and_parses_mixed_samples', () async {
      replies['read'] = jsonEncode([fixtures.steps, fixtures.weight]);

      final samples = await HealthConnectReporter.read(HealthType.steps, range,
          ordering: Ordering.ascending, limit: 10, origins: origins);

      expect(samples.map((e) => e.runtimeType), [Steps, Weight]);
      expect(samples.first, Sample.factory(fixtures.steps));
      expect(calls['read'], {
        'type': 'steps',
        'range': fixtures.timeRange,
        'ordering': 'ASCENDING',
        'limit': 10,
        'origins': originMaps,
      });
    });

    test('read_defaults_to_newest_first_from_every_app', () async {
      replies['read'] = '[]';

      expect(
          await HealthConnectReporter.read(HealthType.weight, range), isEmpty);
      expect(calls['read'], {
        'type': 'weight',
        'range': fixtures.timeRange,
        'ordering': 'DESCENDING',
        'origins': [],
      });
    });

    test('read_of_an_unknown_sample_type_throws_invalid_value', () async {
      replies['read'] = jsonEncode([
        {...fixtures.steps, 'type': 'steps_per_hour'}
      ]);

      expect(HealthConnectReporter.read(HealthType.steps, range),
          throwsA(isA<InvalidValueException>()));
    });

    test('read_page_sends_the_page_and_parses_its_token', () async {
      replies['readPage'] = jsonEncode(fixtures.page);

      final page = await HealthConnectReporter.readPage(HealthType.steps, range,
          pageSize: 1, pageToken: 'token');

      expect(page.items, [Sample.factory(fixtures.steps)]);
      expect(page.nextPageToken, 'next');
      expect(calls['readPage'], {
        'type': 'steps',
        'range': fixtures.timeRange,
        'pageSize': 1,
        'pageToken': 'token',
        'ordering': 'DESCENDING',
        'origins': [],
      });
    });

    test('read_page_defaults_to_the_library_page_size', () async {
      replies['readPage'] = '{"items":[]}';

      final page = await HealthConnectReporter.readPage(HealthType.steps, range,
          ordering: Ordering.ascending, origins: origins);

      expect(page.items, isEmpty);
      expect(page.nextPageToken, isNull);
      expect(calls['readPage'], {
        'type': 'steps',
        'range': fixtures.timeRange,
        'pageSize': 1000,
        'ordering': 'ASCENDING',
        'origins': originMaps,
      });
    });

    test('read_by_id_sends_the_type_and_id', () async {
      replies['readById'] = jsonEncode(fixtures.stepsMetadata);

      final sample =
          await HealthConnectReporter.readById(HealthType.steps, 'id-1');

      expect(sample.id, 'id-1');
      expect(calls['readById'], {'type': 'steps', 'id': 'id-1'});
    });

    test('aggregate_sends_the_kotlin_name_and_parses_the_value', () async {
      replies['aggregate'] = jsonEncode(fixtures.aggregate);

      final aggregate = await HealthConnectReporter.aggregate(
          Aggregation.stepsCountTotal, range,
          origins: origins);

      expect(aggregate, Aggregate.fromJson(fixtures.aggregate));
      expect(calls['aggregate'], {
        'aggregation': 'STEPS_COUNT_TOTAL',
        'range': fixtures.timeRange,
        'origins': originMaps,
      });
    });

    test('aggregate_without_data_has_no_value', () async {
      replies['aggregate'] = jsonEncode(fixtures.aggregateEmpty);

      final aggregate = await HealthConnectReporter.aggregate(
          Aggregation.stepsCountTotal, range);

      expect(aggregate.value, isNull);
    });

    test('aggregate_groups_sends_the_group_and_parses_every_bucket', () async {
      replies['aggregateGroups'] =
          jsonEncode([fixtures.aggregate, fixtures.aggregateEmpty]);

      final aggregates = await HealthConnectReporter.aggregateGroups(
          {Aggregation.stepsCountTotal, Aggregation.heartRateBpmAvg},
          range,
          TimeGroupPeriod(unit: TimeGroupUnit.daily, zoneId: 'Europe/Berlin'));

      expect(aggregates.map((e) => e.value), [1.0, null]);
      expect(calls['aggregateGroups'], {
        'aggregations': ['STEPS_COUNT_TOTAL', 'HEART_RATE_BPM_AVG'],
        'range': fixtures.timeRange,
        'group': {
          'type': 'period',
          'unit': 'DAILY',
          'count': 1,
          'zoneId': 'Europe/Berlin'
        },
        'origins': [],
      });
    });

    test('reader_passes_platform_errors_on', () async {
      replies['read'] = PlatformException(
          code: 'read', message: 'no permission', details: 'NotAuthorized');

      expect(
          HealthConnectReporter.read(HealthType.steps, range),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'read')
              .having((e) => e.details, 'details', 'NotAuthorized')));
    });
  });

  group('writer', () {
    final steps = Steps.fromJson(fixtures.steps);
    final range = TimeRange.fromJson(fixtures.timeRange);

    test('insert_sends_every_sample_map_and_parses_the_inserted', () async {
      final samples =
          fixtures.samples.values.map(Sample.factory).cast<WritableSample>();
      final inserted = fixtures.samples.values
          .map((e) => {...e, 'id': 'id-${e['type']}'})
          .toList();
      replies['insert'] = jsonEncode(inserted);

      final result = await HealthConnectReporter.insert(samples.toList());

      expect(result.map((e) => e.id), inserted.map((e) => e['id']));
      expect(result.map((e) => e.clientRecordId),
          samples.map((e) => e.clientRecordId));
      expect(calls['insert'], {
        'samples': samples.map((e) => e.map).toList(),
      });
    });

    test('update_and_delete_send_the_sample_identity', () async {
      replies['update'] = true;
      replies['delete'] = true;

      expect(await HealthConnectReporter.update([steps]), isTrue);
      expect(await HealthConnectReporter.delete(steps), isTrue);
      expect(calls['update'], {
        'samples': [steps.map]
      });
      expect(calls['delete'], {'sample': steps.map});
      expect(calls['delete']['sample'], containsPair('id', null));
      expect(calls['delete']['sample'],
          containsPair('clientRecordId', 'client-steps'));
      expect(calls['delete']['sample'], containsPair('clientRecordVersion', 1));
    });

    test('a_sample_without_values_sends_no_harmonized_part', () async {
      replies['delete'] = true;

      await HealthConnectReporter.delete(const IntermenstrualBleeding(
          startTimestamp: fixtures.start, id: 'id-1'));

      expect(calls['delete']['sample']['harmonized'], isNull);
    });

    test('delete_by_ids_sends_both_lists', () async {
      replies['deleteByIds'] = true;

      expect(
          await HealthConnectReporter.deleteByIds(HealthType.steps,
              ids: ['id-1'], clientRecordIds: ['client-1']),
          isTrue);
      expect(calls['deleteByIds'], {
        'type': 'steps',
        'ids': ['id-1'],
        'clientRecordIds': ['client-1'],
      });
      await HealthConnectReporter.deleteByIds(HealthType.weight, ids: ['id-2']);
      expect(calls['deleteByIds'], {
        'type': 'weight',
        'ids': ['id-2'],
        'clientRecordIds': [],
      });
    });

    test('delete_by_range_sends_the_type_and_range', () async {
      replies['deleteByRange'] = true;

      expect(await HealthConnectReporter.deleteByRange(HealthType.steps, range),
          isTrue);
      expect(calls['deleteByRange'],
          {'type': 'steps', 'range': fixtures.timeRange});
    });

    test('writer_passes_platform_errors_on', () async {
      replies['update'] = PlatformException(
          code: 'update',
          message: 'update needs an id or a clientRecordId',
          details: 'InvalidValue');

      expect(
          HealthConnectReporter.update([steps]),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'update')
              .having((e) => e.details, 'details', 'InvalidValue')));
    });
  });

  group('observer', () {
    const anchor = Anchor(token: 'token');

    test('anchor_sends_the_types_and_origins', () async {
      replies['anchor'] = jsonEncode(fixtures.anchor);

      final sut = await HealthConnectReporter.anchor(
          {HealthType.steps, HealthType.heartRate},
          origins: {const DataOrigin(packageName: 'com.example')});

      expect(sut, anchor);
      expect(calls['anchor'], {
        'types': ['steps', 'heart_rate'],
        'origins': [fixtures.dataOrigin],
      });
    });

    test('changes_send_the_anchor_and_parse_the_change_set', () async {
      replies['changes'] = jsonEncode(fixtures.changeSet);

      final sut = await HealthConnectReporter.changes(anchor);

      expect(calls['changes'], {'anchor': fixtures.anchor});
      expect(sut, ChangeSet.fromJson(fixtures.changeSet));
    });

    test('changes_of_an_expired_anchor_throw_anchor_expired', () async {
      replies['changes'] = PlatformException(
          code: 'changes', message: 'expired', details: 'AnchorExpired');

      expect(
          HealthConnectReporter.changes(anchor),
          throwsA(isA<PlatformException>()
              .having((e) => e.details, 'details', 'AnchorExpired')));
    });

    test('observe_listens_to_its_channel_and_reports_change_sets_and_errors',
        () async {
      const name = 'health_connect_reporter_event_channel_observe_1';
      final cancelled = <String>[];
      replies['observe'] = name;
      messenger.setMockStreamHandler(
          const EventChannel(name),
          MockStreamHandler.inline(
              onListen: (arguments, sink) {
                sink.success(jsonEncode(fixtures.changeSet));
                sink.error(
                    code: 'observe',
                    message: 'expired',
                    details: 'AnchorExpired');
              },
              onCancel: (_) => cancelled.add(name)));
      final updates = <ChangeSet>[];
      final errors = <Object>[];

      final sut = HealthConnectReporter.observe(anchor,
          interval: const Duration(seconds: 30),
          onUpdate: updates.add,
          onError: errors.add);
      await pumpEventQueue();
      await sut.cancel();

      expect(calls['observe'], {'anchor': fixtures.anchor, 'interval': 30000});
      expect(updates.single, ChangeSet.fromJson(fixtures.changeSet));
      expect(
          errors.single,
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'observe')
              .having((e) => e.details, 'details', 'AnchorExpired'));
      expect(cancelled, [name]);
      messenger.setMockStreamHandler(const EventChannel(name), null);
    });

    test('observe_events_that_are_no_change_set_reach_on_error', () async {
      const name = 'health_connect_reporter_event_channel_observe_2';
      replies['observe'] = name;
      messenger.setMockStreamHandler(const EventChannel(name),
          MockStreamHandler.inline(onListen: (arguments, sink) {
        sink.success('[]');
      }));
      final errors = <Object>[];

      final sut = HealthConnectReporter.observe(anchor,
          onUpdate: (_) {}, onError: errors.add);
      await pumpEventQueue();
      await sut.cancel();

      expect(errors.single, isA<InvalidValueException>());
      messenger.setMockStreamHandler(const EventChannel(name), null);
    });

    test('observe_failing_its_call_reports_the_error', () async {
      replies['observe'] = PlatformException(
          code: 'observe',
          message: 'Invalid interval',
          details: 'InvalidValue');
      final errors = <Object>[];

      final sut = HealthConnectReporter.observe(anchor,
          interval: Duration.zero, onUpdate: (_) {}, onError: errors.add);
      await pumpEventQueue();
      await sut.cancel();

      expect(calls['observe'], {'anchor': fixtures.anchor, 'interval': 0});
      expect(
          errors.single,
          isA<PlatformException>()
              .having((e) => e.details, 'details', 'InvalidValue'));
    });

    test('observe_cancelled_while_planned_releases_its_channel', () async {
      const name = 'health_connect_reporter_event_channel_observe_3';
      final cancelled = <String>[];
      replies['observe'] = name;
      messenger.setMockStreamHandler(
          const EventChannel(name),
          MockStreamHandler.inline(
              onListen: (arguments, sink) {},
              onCancel: (_) => cancelled.add(name)));

      final sut = HealthConnectReporter.observe(anchor, onUpdate: (_) {});
      await sut.cancel();
      await pumpEventQueue();

      expect(cancelled, [name]);
      messenger.setMockStreamHandler(const EventChannel(name), null);
    });
  });
}
