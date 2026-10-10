import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/payload/sleep_session.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter/model/type/sleep_stage_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('sleep_session_parses_its_stages', () {
    final sut = SleepSession.fromJson(fixtures.sleepSession);
    expect(sut.healthType, HealthType.sleepSession);
    expect(sut.harmonized.title, 'Night');
    expect(sut.harmonized.notes, 'Restful');
    expect(sut.harmonized.stages, const [
      SleepSessionStage(
          startTimestamp: fixtures.start,
          endTimestamp: fixtures.mid,
          stage: SleepStageType.light),
      SleepSessionStage(
          startTimestamp: fixtures.mid,
          endTimestamp: fixtures.end,
          stage: SleepStageType.deep),
    ]);
  });

  test('sleep_session_without_stages_parses', () {
    final sut = SleepSessionHarmonized.fromJson(const {});
    expect(sut, const SleepSessionHarmonized());
    expect(sut.map, {'title': null, 'notes': null, 'stages': []});
  });
}
