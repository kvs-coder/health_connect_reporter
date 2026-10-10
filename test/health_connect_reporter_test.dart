import 'dart:convert';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/availability.dart';
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
}
