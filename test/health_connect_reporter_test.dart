import 'package:flutter/foundation.dart'
    show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/availability.dart';

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
}
