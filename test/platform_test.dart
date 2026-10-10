import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/availability.dart';
import 'package:health_connect_reporter/model/decorator/platform.dart';
import 'package:health_connect_reporter/model/payload/steps.dart';
import 'package:health_connect_reporter/model/permission.dart';
import 'package:health_connect_reporter/model/time_group.dart';
import 'package:health_connect_reporter/model/time_range.dart';
import 'package:health_connect_reporter/model/type/aggregation.dart';
import 'package:health_connect_reporter/model/type/feature.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';

/// Health Connect is available only on Android: elsewhere nothing reaches the channel.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('health_connect_reporter_method_channel'),
            (call) async {
      calls.add(call.method);
      return '"available"';
    });
  });
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
    group('on ${platform.name}', () {
      setUp(() => debugDefaultTargetPlatformOverride = platform);

      test('availability_is_unavailable_without_a_channel_call', () async {
        expect(await HealthConnectReporter.availability(),
            Availability.unavailable);
        expect(calls, isEmpty);
      });

      test('every_other_method_throws_unsupported_error', () {
        final range = TimeRange(startTimestamp: 0, endTimestamp: 1);
        const steps = Steps(
            startTimestamp: 0,
            endTimestamp: 1,
            harmonized: StepsHarmonized(count: 1));
        final methods = <String, Future<Object?> Function()>{
          'requestPermissions': () => HealthConnectReporter.requestPermissions(
              Permission.of([HealthType.steps])),
          'grantedPermissions': HealthConnectReporter.grantedPermissions,
          'revokeAllPermissions': HealthConnectReporter.revokeAllPermissions,
          'isFeatureAvailable': () =>
              HealthConnectReporter.isFeatureAvailable(Feature.skinTemperature),
          'openSettings': HealthConnectReporter.openSettings,
          'openInstall': HealthConnectReporter.openInstall,
          'read': () => HealthConnectReporter.read(HealthType.steps, range),
          'readPage': () =>
              HealthConnectReporter.readPage(HealthType.steps, range),
          'readById': () =>
              HealthConnectReporter.readById(HealthType.steps, 'id-1'),
          'aggregate': () => HealthConnectReporter.aggregate(
              Aggregation.stepsCountTotal, range),
          'aggregateGroups': () => HealthConnectReporter.aggregateGroups(
              {Aggregation.stepsCountTotal},
              range,
              TimeGroupDuration(durationMillis: 60000)),
          'insert': () => HealthConnectReporter.insert([steps]),
          'update': () => HealthConnectReporter.update([steps]),
          'delete': () => HealthConnectReporter.delete(steps),
          'deleteByIds': () =>
              HealthConnectReporter.deleteByIds(HealthType.steps, ids: ['id']),
          'deleteByRange': () =>
              HealthConnectReporter.deleteByRange(HealthType.steps, range),
        };
        for (final entry in methods.entries) {
          expect(entry.value, throwsUnsupportedError, reason: entry.key);
        }
        expect(calls, isEmpty);
      });

      test('require_platform_throws_unsupported_error_naming_the_platforms',
          () {
        expect(
            () => requirePlatform(TargetPlatform.android, 'Health Connect'),
            throwsA(isA<UnsupportedError>().having(
                (e) => e.message,
                'message',
                'Health Connect is available only on android, not on '
                    '${platform.name}')));
      });
    });
  }

  test('require_platform_passes_on_android', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(() => requirePlatform(TargetPlatform.android, 'Health Connect'),
        returnsNormally);
  });
}
