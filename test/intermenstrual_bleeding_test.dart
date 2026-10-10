import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/payload/intermenstrual_bleeding.dart';
import 'package:health_connect_reporter/model/payload/menstruation_period.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('records_without_values_have_no_harmonized_part', () {
    final bleeding =
        IntermenstrualBleeding.fromJson(fixtures.intermenstrualBleeding);
    final period = MenstruationPeriod.fromJson(fixtures.menstruationPeriod);
    expect(bleeding.harmonized, isNull);
    expect(period.harmonized, isNull);
    expect(bleeding.map['harmonized'], isNull);
    expect(period.endTimestamp, fixtures.end);
  });

  test('a_record_without_values_built_in_dart_round_trips', () {
    const sut = IntermenstrualBleeding(
        startTimestamp: fixtures.start, clientRecordId: 'client-1');
    expect(fixtures.withoutNulls(sut.map), {
      'type': 'intermenstrual_bleeding',
      'startTimestamp': fixtures.start,
      'clientRecordId': 'client-1',
    });
    expect(IntermenstrualBleeding.fromJson(sut.map), sut);
  });
}
