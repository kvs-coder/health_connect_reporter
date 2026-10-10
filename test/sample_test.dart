import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/model/data_origin.dart';
import 'package:health_connect_reporter/model/device.dart';
import 'package:health_connect_reporter/model/payload/active_calories_burned.dart';
import 'package:health_connect_reporter/model/payload/basal_body_temperature.dart';
import 'package:health_connect_reporter/model/payload/basal_metabolic_rate.dart';
import 'package:health_connect_reporter/model/payload/blood_glucose.dart';
import 'package:health_connect_reporter/model/payload/blood_pressure.dart';
import 'package:health_connect_reporter/model/payload/body_fat.dart';
import 'package:health_connect_reporter/model/payload/body_temperature.dart';
import 'package:health_connect_reporter/model/payload/body_water_mass.dart';
import 'package:health_connect_reporter/model/payload/bone_mass.dart';
import 'package:health_connect_reporter/model/payload/cervical_mucus.dart';
import 'package:health_connect_reporter/model/payload/cycling_pedaling_cadence.dart';
import 'package:health_connect_reporter/model/payload/distance.dart';
import 'package:health_connect_reporter/model/payload/elevation_gained.dart';
import 'package:health_connect_reporter/model/payload/exercise_session.dart';
import 'package:health_connect_reporter/model/payload/floors_climbed.dart';
import 'package:health_connect_reporter/model/payload/heart_rate.dart';
import 'package:health_connect_reporter/model/payload/heart_rate_variability_rmssd.dart';
import 'package:health_connect_reporter/model/payload/height.dart';
import 'package:health_connect_reporter/model/payload/hydration.dart';
import 'package:health_connect_reporter/model/payload/intermenstrual_bleeding.dart';
import 'package:health_connect_reporter/model/payload/lean_body_mass.dart';
import 'package:health_connect_reporter/model/payload/menstruation_flow.dart';
import 'package:health_connect_reporter/model/payload/menstruation_period.dart';
import 'package:health_connect_reporter/model/payload/mindfulness_session.dart';
import 'package:health_connect_reporter/model/payload/nutrition.dart';
import 'package:health_connect_reporter/model/payload/ovulation_test.dart';
import 'package:health_connect_reporter/model/payload/oxygen_saturation.dart';
import 'package:health_connect_reporter/model/payload/planned_exercise_session.dart';
import 'package:health_connect_reporter/model/payload/power.dart';
import 'package:health_connect_reporter/model/payload/respiratory_rate.dart';
import 'package:health_connect_reporter/model/payload/resting_heart_rate.dart';
import 'package:health_connect_reporter/model/payload/sexual_activity.dart';
import 'package:health_connect_reporter/model/payload/skin_temperature.dart';
import 'package:health_connect_reporter/model/payload/sleep_session.dart';
import 'package:health_connect_reporter/model/payload/speed.dart';
import 'package:health_connect_reporter/model/payload/steps.dart';
import 'package:health_connect_reporter/model/payload/steps_cadence.dart';
import 'package:health_connect_reporter/model/payload/total_calories_burned.dart';
import 'package:health_connect_reporter/model/payload/vo2_max.dart';
import 'package:health_connect_reporter/model/payload/weight.dart';
import 'package:health_connect_reporter/model/payload/wheelchair_pushes.dart';
import 'package:health_connect_reporter/model/payload/sample.dart';
import 'package:health_connect_reporter/model/type/device_type.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter/model/type/recording_method.dart';

import 'fixtures.dart' as fixtures;

/// Keys every sample may leave out
const metadata = [
  'id',
  'clientRecordId',
  'clientRecordVersion',
  'startZoneOffsetSeconds',
  'endZoneOffsetSeconds',
  'recordingMethod',
  'device',
  'dataOrigin',
  'lastModifiedTimestamp',
];

void main() {
  final expected = <String, (Type, List<Sample> Function(List<dynamic>))>{
    'active_calories_burned': (
      ActiveCaloriesBurned,
      ActiveCaloriesBurned.collect
    ),
    'basal_body_temperature': (
      BasalBodyTemperature,
      BasalBodyTemperature.collect
    ),
    'basal_metabolic_rate': (BasalMetabolicRate, BasalMetabolicRate.collect),
    'blood_glucose': (BloodGlucose, BloodGlucose.collect),
    'blood_pressure': (BloodPressure, BloodPressure.collect),
    'body_fat': (BodyFat, BodyFat.collect),
    'body_temperature': (BodyTemperature, BodyTemperature.collect),
    'body_water_mass': (BodyWaterMass, BodyWaterMass.collect),
    'bone_mass': (BoneMass, BoneMass.collect),
    'cervical_mucus': (CervicalMucus, CervicalMucus.collect),
    'cycling_pedaling_cadence': (
      CyclingPedalingCadence,
      CyclingPedalingCadence.collect
    ),
    'distance': (Distance, Distance.collect),
    'elevation_gained': (ElevationGained, ElevationGained.collect),
    'exercise': (ExerciseSession, ExerciseSession.collect),
    'floors_climbed': (FloorsClimbed, FloorsClimbed.collect),
    'heart_rate': (HeartRate, HeartRate.collect),
    'heart_rate_variability_rmssd': (
      HeartRateVariabilityRmssd,
      HeartRateVariabilityRmssd.collect
    ),
    'height': (Height, Height.collect),
    'water_intake': (Hydration, Hydration.collect),
    'intermenstrual_bleeding': (
      IntermenstrualBleeding,
      IntermenstrualBleeding.collect
    ),
    'lean_body_mass': (LeanBodyMass, LeanBodyMass.collect),
    'menstruation_flow': (MenstruationFlow, MenstruationFlow.collect),
    'menstruation_period': (MenstruationPeriod, MenstruationPeriod.collect),
    'mindfulness_session': (MindfulnessSession, MindfulnessSession.collect),
    'nutrition': (Nutrition, Nutrition.collect),
    'ovulation_test': (OvulationTest, OvulationTest.collect),
    'blood_oxygen': (OxygenSaturation, OxygenSaturation.collect),
    'planned_exercise': (
      PlannedExerciseSession,
      PlannedExerciseSession.collect
    ),
    'power': (Power, Power.collect),
    'respiratory_rate': (RespiratoryRate, RespiratoryRate.collect),
    'resting_heart_rate': (RestingHeartRate, RestingHeartRate.collect),
    'sexual_activity': (SexualActivity, SexualActivity.collect),
    'skin_temperature': (SkinTemperature, SkinTemperature.collect),
    'sleep': (SleepSession, SleepSession.collect),
    'speed': (Speed, Speed.collect),
    'steps': (Steps, Steps.collect),
    'steps_cadence': (StepsCadence, StepsCadence.collect),
    'total_calories_burned': (TotalCaloriesBurned, TotalCaloriesBurned.collect),
    'vo2_max': (Vo2Max, Vo2Max.collect),
    'weight': (Weight, Weight.collect),
    'wheelchair_pushes': (WheelchairPushes, WheelchairPushes.collect),
  };

  test('every_health_type_has_a_sample_and_a_fixture', () {
    final identifiers = HealthType.values.map((e) => e.identifier).toSet();
    expect(fixtures.samples.keys.toSet(), identifiers);
    expect(expected.keys.toSet(), identifiers);
  });

  for (final entry in fixtures.samples.entries) {
    test('factory_creates_${entry.key}_and_round_trips', () {
      final (type, collect) = expected[entry.key]!;
      final sut = Sample.factory(entry.value);
      expect(sut.runtimeType, type);
      expect(sut, isA<WritableSample>());
      expect(sut.healthType.identifier, entry.key);
      expect(fixtures.withoutNulls(sut.map), entry.value);
      expect(Sample.factory(sut.map), sut);
      expect(Sample.factory(jsonDecode(jsonEncode(sut.map))), sut);
      expect(collect([entry.value, jsonEncode(entry.value)]), [sut, sut]);
    });

    test('${entry.key}_parses_without_metadata', () {
      final json = Map<String, dynamic>.from(entry.value)
        ..removeWhere((key, _) => metadata.contains(key));
      final sut = Sample.factory(json);
      expect(sut.id, isNull);
      expect(sut.clientRecordId, isNull);
      expect(sut.clientRecordVersion, isNull);
      expect(sut.startZoneOffsetSeconds, isNull);
      expect(sut.endZoneOffsetSeconds, isNull);
      expect(sut.recordingMethod, isNull);
      expect(sut.device, isNull);
      expect(sut.dataOrigin, isNull);
      expect(sut.lastModifiedTimestamp, isNull);
      expect(fixtures.withoutNulls(sut.map), json);
    });
  }

  test('sample_parses_every_metadata_field', () {
    final sut = Sample.factory(fixtures.stepsMetadata);
    expect(sut.startTimestamp, fixtures.start);
    expect(sut.endTimestamp, fixtures.end);
    expect(sut.id, 'id-1');
    expect(sut.clientRecordId, 'client-1');
    expect(sut.clientRecordVersion, 2);
    expect(sut.startZoneOffsetSeconds, fixtures.offset);
    expect(sut.endZoneOffsetSeconds, fixtures.offset);
    expect(sut.recordingMethod, RecordingMethod.activelyRecorded);
    expect(
        sut.device,
        const Device(
            type: DeviceType.watch,
            manufacturer: 'Google',
            model: 'Pixel Watch'));
    expect(sut.dataOrigin, const DataOrigin(packageName: 'com.example'));
    expect(sut.lastModifiedTimestamp, fixtures.end);
    expect(fixtures.withoutNulls(sut.map), fixtures.stepsMetadata);
  });

  test('instantaneous_samples_have_no_end', () {
    final sut = Weight.fromJson(fixtures.weight);
    expect(sut.endTimestamp, isNull);
    expect(sut.map.containsKey('endTimestamp'), isTrue);
  });

  test('factory_throws_for_an_unknown_type', () {
    expect(
      () => Sample.factory({...fixtures.steps, 'type': 'steps_per_hour'}),
      throwsA(isA<InvalidValueException>().having(
          (e) => e.cause, 'cause', 'Unknown sample type: steps_per_hour')),
    );
  });

  test('factory_throws_without_a_type', () {
    final json = Map<String, dynamic>.from(fixtures.steps)..remove('type');
    expect(() => Sample.factory(json), throwsA(isA<InvalidValueException>()));
  });

  test('factory_does_not_accept_the_kotlin_name_as_type', () {
    expect(
      () => Sample.factory({...fixtures.steps, 'type': 'STEPS'}),
      throwsA(isA<InvalidValueException>()),
    );
  });

  test('factory_throws_for_an_unknown_recording_method', () {
    expect(
      () => Sample.factory({...fixtures.steps, 'recordingMethod': 'GUESSED'}),
      throwsA(isA<InvalidValueException>()),
    );
  });

  test('samples_with_different_identity_are_not_equal', () {
    final sut = Steps.fromJson(fixtures.steps);
    for (final change in [
      {'id': 'other'},
      {'clientRecordId': 'other'},
      {'clientRecordVersion': 2},
    ]) {
      expect(sut, isNot(Steps.fromJson({...fixtures.steps, ...change})),
          reason: '$change');
    }
    expect(sut.hashCode, Steps.fromJson(fixtures.steps).hashCode);
  });

  test('sample_built_in_dart_sends_every_key', () {
    const sut = Steps(
      startTimestamp: fixtures.start,
      endTimestamp: fixtures.end,
      harmonized: StepsHarmonized(count: 1200),
      clientRecordId: 'client-1',
    );
    expect(sut.map, {
      'type': 'steps',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {'count': 1200},
      'id': null,
      'clientRecordId': 'client-1',
      'clientRecordVersion': null,
      'startZoneOffsetSeconds': null,
      'endZoneOffsetSeconds': null,
      'recordingMethod': null,
      'device': null,
      'dataOrigin': null,
      'lastModifiedTimestamp': null,
    });
    expect(Steps.fromJson(sut.map), sut);
  });
}
