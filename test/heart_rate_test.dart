import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/device.dart';
import 'package:health_connect_reporter/model/payload/heart_rate.dart';
import 'package:health_connect_reporter/model/type/device_type.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter/model/type/recording_method.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('heart_rate_parses_every_field', () {
    final sut = HeartRate.fromJson(fixtures.heartRate);
    expect(sut.healthType, HealthType.heartRate);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.clientRecordId, 'client-heartRate');
    expect(sut.clientRecordVersion, 1);
    expect(sut.recordingMethod, RecordingMethod.unknown);
    expect(
        sut.device,
        const Device(
            type: DeviceType.watch,
            manufacturer: 'Google',
            model: 'Pixel Watch'));
    expect(sut.harmonized.series, const [
      HeartRateSeries(timestamp: fixtures.start, beatsPerMinute: 70),
      HeartRateSeries(timestamp: fixtures.mid, beatsPerMinute: 90),
    ]);
  });

  test('heart_rate_built_in_dart_round_trips', () {
    const sut = HeartRate(
      startTimestamp: fixtures.start,
      endTimestamp: fixtures.end,
      harmonized: HeartRateHarmonized(series: [
        HeartRateSeries(timestamp: fixtures.mid, beatsPerMinute: 80),
      ]),
    );
    expect(sut.map['harmonized'], {
      'series': [
        {'timestamp': fixtures.mid, 'beatsPerMinute': 80},
      ],
    });
    expect(HeartRate.fromJson(sut.map), sut);
  });
}
