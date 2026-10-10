import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/availability.dart';
import 'package:health_connect_reporter/model/decorator/platform.dart';

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
