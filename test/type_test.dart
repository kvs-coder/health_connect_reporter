import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/model/type/access_type.dart';
import 'package:health_connect_reporter/model/type/aggregation.dart';
import 'package:health_connect_reporter/model/type/blood_pressure_measurement_location.dart';
import 'package:health_connect_reporter/model/type/body_position.dart';
import 'package:health_connect_reporter/model/type/body_temperature_measurement_location.dart';
import 'package:health_connect_reporter/model/type/cervical_mucus_appearance.dart';
import 'package:health_connect_reporter/model/type/cervical_mucus_sensation.dart';
import 'package:health_connect_reporter/model/type/device_type.dart';
import 'package:health_connect_reporter/model/type/exercise_phase.dart';
import 'package:health_connect_reporter/model/type/exercise_segment_type.dart';
import 'package:health_connect_reporter/model/type/exercise_type.dart';
import 'package:health_connect_reporter/model/type/feature.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter/model/type/meal_type.dart';
import 'package:health_connect_reporter/model/type/menstruation_flow_type.dart';
import 'package:health_connect_reporter/model/type/mindfulness_session_type.dart';
import 'package:health_connect_reporter/model/type/ordering.dart';
import 'package:health_connect_reporter/model/type/ovulation_test_result.dart';
import 'package:health_connect_reporter/model/type/protection_used.dart';
import 'package:health_connect_reporter/model/type/recording_method.dart';
import 'package:health_connect_reporter/model/type/relation_to_meal.dart';
import 'package:health_connect_reporter/model/type/skin_temperature_measurement_location.dart';
import 'package:health_connect_reporter/model/type/sleep_stage_type.dart';
import 'package:health_connect_reporter/model/type/specimen_source.dart';
import 'package:health_connect_reporter/model/type/time_group_unit.dart';
import 'package:health_connect_reporter/model/type/vo2_max_measurement_method.dart';
import 'package:health_connect_reporter/model/type/value_enum.dart';

/// Kotlin constant names of HealthConnectReporter 1.0.0, in declaration order.
const kotlinNames = <String, List<String>>{
  'AccessType': [
    'READ',
    'WRITE',
  ],
  'Aggregation': [
    'ACTIVE_CALORIES_BURNED_ACTIVE_CALORIES_TOTAL',
    'BASAL_METABOLIC_RATE_BASAL_CALORIES_TOTAL',
    'BLOOD_PRESSURE_SYSTOLIC_AVG',
    'BLOOD_PRESSURE_SYSTOLIC_MIN',
    'BLOOD_PRESSURE_SYSTOLIC_MAX',
    'BLOOD_PRESSURE_DIASTOLIC_AVG',
    'BLOOD_PRESSURE_DIASTOLIC_MIN',
    'BLOOD_PRESSURE_DIASTOLIC_MAX',
    'CYCLING_PEDALING_CADENCE_RPM_AVG',
    'CYCLING_PEDALING_CADENCE_RPM_MIN',
    'CYCLING_PEDALING_CADENCE_RPM_MAX',
    'DISTANCE_DISTANCE_TOTAL',
    'ELEVATION_GAINED_ELEVATION_GAINED_TOTAL',
    'EXERCISE_SESSION_EXERCISE_DURATION_TOTAL',
    'FLOORS_CLIMBED_FLOORS_CLIMBED_TOTAL',
    'HEART_RATE_BPM_AVG',
    'HEART_RATE_BPM_MIN',
    'HEART_RATE_BPM_MAX',
    'HEART_RATE_MEASUREMENTS_COUNT',
    'HEIGHT_HEIGHT_AVG',
    'HEIGHT_HEIGHT_MIN',
    'HEIGHT_HEIGHT_MAX',
    'HYDRATION_VOLUME_TOTAL',
    'NUTRITION_BIOTIN_TOTAL',
    'NUTRITION_CAFFEINE_TOTAL',
    'NUTRITION_CALCIUM_TOTAL',
    'NUTRITION_ENERGY_TOTAL',
    'NUTRITION_ENERGY_FROM_FAT_TOTAL',
    'NUTRITION_CHLORIDE_TOTAL',
    'NUTRITION_CHOLESTEROL_TOTAL',
    'NUTRITION_CHROMIUM_TOTAL',
    'NUTRITION_COPPER_TOTAL',
    'NUTRITION_DIETARY_FIBER_TOTAL',
    'NUTRITION_FOLATE_TOTAL',
    'NUTRITION_FOLIC_ACID_TOTAL',
    'NUTRITION_IODINE_TOTAL',
    'NUTRITION_IRON_TOTAL',
    'NUTRITION_MAGNESIUM_TOTAL',
    'NUTRITION_MANGANESE_TOTAL',
    'NUTRITION_MOLYBDENUM_TOTAL',
    'NUTRITION_MONOUNSATURATED_FAT_TOTAL',
    'NUTRITION_NIACIN_TOTAL',
    'NUTRITION_PANTOTHENIC_ACID_TOTAL',
    'NUTRITION_PHOSPHORUS_TOTAL',
    'NUTRITION_POLYUNSATURATED_FAT_TOTAL',
    'NUTRITION_POTASSIUM_TOTAL',
    'NUTRITION_PROTEIN_TOTAL',
    'NUTRITION_RIBOFLAVIN_TOTAL',
    'NUTRITION_SATURATED_FAT_TOTAL',
    'NUTRITION_SELENIUM_TOTAL',
    'NUTRITION_SODIUM_TOTAL',
    'NUTRITION_SUGAR_TOTAL',
    'NUTRITION_THIAMIN_TOTAL',
    'NUTRITION_TOTAL_CARBOHYDRATE_TOTAL',
    'NUTRITION_TOTAL_FAT_TOTAL',
    'NUTRITION_TRANS_FAT_TOTAL',
    'NUTRITION_UNSATURATED_FAT_TOTAL',
    'NUTRITION_VITAMIN_A_TOTAL',
    'NUTRITION_VITAMIN_B12_TOTAL',
    'NUTRITION_VITAMIN_B6_TOTAL',
    'NUTRITION_VITAMIN_C_TOTAL',
    'NUTRITION_VITAMIN_D_TOTAL',
    'NUTRITION_VITAMIN_E_TOTAL',
    'NUTRITION_VITAMIN_K_TOTAL',
    'NUTRITION_ZINC_TOTAL',
    'POWER_POWER_AVG',
    'POWER_POWER_MIN',
    'POWER_POWER_MAX',
    'RESTING_HEART_RATE_BPM_AVG',
    'RESTING_HEART_RATE_BPM_MIN',
    'RESTING_HEART_RATE_BPM_MAX',
    'SKIN_TEMPERATURE_TEMPERATURE_DELTA_AVG',
    'SKIN_TEMPERATURE_TEMPERATURE_DELTA_MIN',
    'SKIN_TEMPERATURE_TEMPERATURE_DELTA_MAX',
    'SLEEP_SESSION_SLEEP_DURATION_TOTAL',
    'SPEED_SPEED_AVG',
    'SPEED_SPEED_MIN',
    'SPEED_SPEED_MAX',
    'STEPS_CADENCE_RATE_AVG',
    'STEPS_CADENCE_RATE_MIN',
    'STEPS_CADENCE_RATE_MAX',
    'STEPS_COUNT_TOTAL',
    'TOTAL_CALORIES_BURNED_ENERGY_TOTAL',
    'WEIGHT_WEIGHT_AVG',
    'WEIGHT_WEIGHT_MIN',
    'WEIGHT_WEIGHT_MAX',
    'WHEELCHAIR_PUSHES_COUNT_TOTAL',
  ],
  'BloodPressureMeasurementLocation': [
    'UNKNOWN',
    'LEFT_WRIST',
    'RIGHT_WRIST',
    'LEFT_UPPER_ARM',
    'RIGHT_UPPER_ARM',
  ],
  'BodyPosition': [
    'UNKNOWN',
    'STANDING_UP',
    'SITTING_DOWN',
    'LYING_DOWN',
    'RECLINING',
  ],
  'BodyTemperatureMeasurementLocation': [
    'UNKNOWN',
    'ARMPIT',
    'FINGER',
    'FOREHEAD',
    'MOUTH',
    'RECTUM',
    'TEMPORAL_ARTERY',
    'TOE',
    'EAR',
    'WRIST',
    'VAGINA',
  ],
  'CervicalMucusAppearance': [
    'UNKNOWN',
    'DRY',
    'STICKY',
    'CREAMY',
    'WATERY',
    'EGG_WHITE',
    'UNUSUAL',
  ],
  'CervicalMucusSensation': [
    'UNKNOWN',
    'LIGHT',
    'MEDIUM',
    'HEAVY',
  ],
  'DeviceType': [
    'UNKNOWN',
    'WATCH',
    'PHONE',
    'SCALE',
    'RING',
    'HEAD_MOUNTED',
    'FITNESS_BAND',
    'CHEST_STRAP',
    'SMART_DISPLAY',
  ],
  'ExercisePhase': [
    'UNKNOWN',
    'WARMUP',
    'REST',
    'ACTIVE',
    'COOLDOWN',
    'RECOVERY',
  ],
  'ExerciseSegmentType': [
    'UNKNOWN',
    'ARM_CURL',
    'BACK_EXTENSION',
    'BALL_SLAM',
    'BARBELL_SHOULDER_PRESS',
    'BENCH_PRESS',
    'BENCH_SIT_UP',
    'BIKING',
    'BIKING_STATIONARY',
    'BURPEE',
    'CRUNCH',
    'DEADLIFT',
    'DOUBLE_ARM_TRICEPS_EXTENSION',
    'DUMBBELL_CURL_LEFT_ARM',
    'DUMBBELL_CURL_RIGHT_ARM',
    'DUMBBELL_FRONT_RAISE',
    'DUMBBELL_LATERAL_RAISE',
    'DUMBBELL_ROW',
    'DUMBBELL_TRICEPS_EXTENSION_LEFT_ARM',
    'DUMBBELL_TRICEPS_EXTENSION_RIGHT_ARM',
    'DUMBBELL_TRICEPS_EXTENSION_TWO_ARM',
    'ELLIPTICAL',
    'FORWARD_TWIST',
    'FRONT_RAISE',
    'HIGH_INTENSITY_INTERVAL_TRAINING',
    'HIP_THRUST',
    'HULA_HOOP',
    'JUMPING_JACK',
    'JUMP_ROPE',
    'KETTLEBELL_SWING',
    'LATERAL_RAISE',
    'LAT_PULL_DOWN',
    'LEG_CURL',
    'LEG_EXTENSION',
    'LEG_PRESS',
    'LEG_RAISE',
    'LUNGE',
    'MOUNTAIN_CLIMBER',
    'OTHER_WORKOUT',
    'PAUSE',
    'PILATES',
    'PLANK',
    'PULL_UP',
    'PUNCH',
    'REST',
    'ROWING_MACHINE',
    'RUNNING',
    'RUNNING_TREADMILL',
    'SHOULDER_PRESS',
    'SINGLE_ARM_TRICEPS_EXTENSION',
    'SIT_UP',
    'SQUAT',
    'STAIR_CLIMBING',
    'STAIR_CLIMBING_MACHINE',
    'STRETCHING',
    'SWIMMING_BACKSTROKE',
    'SWIMMING_BREASTSTROKE',
    'SWIMMING_BUTTERFLY',
    'SWIMMING_FREESTYLE',
    'SWIMMING_MIXED',
    'SWIMMING_OPEN_WATER',
    'SWIMMING_OTHER',
    'SWIMMING_POOL',
    'UPPER_TWIST',
    'WALKING',
    'WEIGHTLIFTING',
    'WHEELCHAIR',
    'YOGA',
  ],
  'ExerciseType': [
    'OTHER_WORKOUT',
    'BADMINTON',
    'BASEBALL',
    'BASKETBALL',
    'BIKING',
    'BIKING_STATIONARY',
    'BOOT_CAMP',
    'BOXING',
    'CALISTHENICS',
    'CRICKET',
    'DANCING',
    'ELLIPTICAL',
    'EXERCISE_CLASS',
    'FENCING',
    'FOOTBALL_AMERICAN',
    'FOOTBALL_AUSTRALIAN',
    'FRISBEE_DISC',
    'GOLF',
    'GUIDED_BREATHING',
    'GYMNASTICS',
    'HANDBALL',
    'HIGH_INTENSITY_INTERVAL_TRAINING',
    'HIKING',
    'ICE_HOCKEY',
    'ICE_SKATING',
    'MARTIAL_ARTS',
    'PADDLING',
    'PARAGLIDING',
    'PILATES',
    'RACQUETBALL',
    'ROCK_CLIMBING',
    'ROLLER_HOCKEY',
    'ROWING',
    'ROWING_MACHINE',
    'RUGBY',
    'RUNNING',
    'RUNNING_TREADMILL',
    'SAILING',
    'SCUBA_DIVING',
    'SKATING',
    'SKIING',
    'SNOWBOARDING',
    'SNOWSHOEING',
    'SOCCER',
    'SOFTBALL',
    'SQUASH',
    'STAIR_CLIMBING',
    'STAIR_CLIMBING_MACHINE',
    'STRENGTH_TRAINING',
    'STRETCHING',
    'SURFING',
    'SWIMMING_OPEN_WATER',
    'SWIMMING_POOL',
    'TABLE_TENNIS',
    'TENNIS',
    'VOLLEYBALL',
    'WALKING',
    'WATER_POLO',
    'WEIGHTLIFTING',
    'WHEELCHAIR',
    'YOGA',
  ],
  'Feature': [
    'READ_HEALTH_DATA_IN_BACKGROUND',
    'SKIN_TEMPERATURE',
    'PLANNED_EXERCISE',
    'READ_HEALTH_DATA_HISTORY',
    'MINDFULNESS_SESSION',
  ],
  'HealthType': [
    'ACTIVE_CALORIES_BURNED',
    'BASAL_BODY_TEMPERATURE',
    'BASAL_METABOLIC_RATE',
    'BLOOD_GLUCOSE',
    'BLOOD_PRESSURE',
    'BODY_FAT',
    'BODY_TEMPERATURE',
    'BODY_WATER_MASS',
    'BONE_MASS',
    'CERVICAL_MUCUS',
    'CYCLING_PEDALING_CADENCE',
    'DISTANCE',
    'ELEVATION_GAINED',
    'EXERCISE_SESSION',
    'FLOORS_CLIMBED',
    'HEART_RATE',
    'HEART_RATE_VARIABILITY_RMSSD',
    'HEIGHT',
    'HYDRATION',
    'INTERMENSTRUAL_BLEEDING',
    'LEAN_BODY_MASS',
    'MENSTRUATION_FLOW',
    'MENSTRUATION_PERIOD',
    'MINDFULNESS_SESSION',
    'NUTRITION',
    'OVULATION_TEST',
    'OXYGEN_SATURATION',
    'PLANNED_EXERCISE_SESSION',
    'POWER',
    'RESPIRATORY_RATE',
    'RESTING_HEART_RATE',
    'SEXUAL_ACTIVITY',
    'SKIN_TEMPERATURE',
    'SLEEP_SESSION',
    'SPEED',
    'STEPS',
    'STEPS_CADENCE',
    'TOTAL_CALORIES_BURNED',
    'VO2_MAX',
    'WEIGHT',
    'WHEELCHAIR_PUSHES',
  ],
  'MealType': [
    'UNKNOWN',
    'BREAKFAST',
    'LUNCH',
    'DINNER',
    'SNACK',
  ],
  'MenstruationFlowType': [
    'UNKNOWN',
    'LIGHT',
    'MEDIUM',
    'HEAVY',
  ],
  'MindfulnessSessionType': [
    'UNKNOWN',
    'MEDITATION',
    'BREATHING',
    'MUSIC',
    'MOVEMENT',
    'UNGUIDED',
  ],
  'Ordering': [
    'ASCENDING',
    'DESCENDING',
  ],
  'OvulationTestResult': [
    'INCONCLUSIVE',
    'POSITIVE',
    'HIGH',
    'NEGATIVE',
  ],
  'ProtectionUsed': [
    'UNKNOWN',
    'PROTECTED',
    'UNPROTECTED',
  ],
  'RecordingMethod': [
    'UNKNOWN',
    'ACTIVELY_RECORDED',
    'AUTOMATICALLY_RECORDED',
    'MANUAL_ENTRY',
  ],
  'RelationToMeal': [
    'UNKNOWN',
    'GENERAL',
    'FASTING',
    'BEFORE_MEAL',
    'AFTER_MEAL',
  ],
  'SkinTemperatureMeasurementLocation': [
    'UNKNOWN',
    'FINGER',
    'TOE',
    'WRIST',
  ],
  'SleepStageType': [
    'UNKNOWN',
    'AWAKE',
    'SLEEPING',
    'OUT_OF_BED',
    'LIGHT',
    'DEEP',
    'REM',
    'AWAKE_IN_BED',
  ],
  'SpecimenSource': [
    'UNKNOWN',
    'INTERSTITIAL_FLUID',
    'CAPILLARY_BLOOD',
    'PLASMA',
    'SERUM',
    'TEARS',
    'WHOLE_BLOOD',
  ],
  'TimeGroupUnit': [
    'DAILY',
    'WEEKLY',
    'MONTHLY',
    'YEARLY',
  ],
  'Vo2MaxMeasurementMethod': [
    'OTHER',
    'METABOLIC_CART',
    'HEART_RATE_RATIO',
    'COOPER_TEST',
    'MULTISTAGE_FITNESS_TEST',
    'ROCKPORT_FITNESS_TEST',
  ],
};

void expectValueEnum<T extends ValueEnum>(
  String name,
  List<T> values,
  T Function(String) from,
  T? Function(String) tryFrom,
) {
  expect(values.map((e) => e.value), kotlinNames[name], reason: name);
  for (final element in values) {
    expect(from(element.value), element, reason: name);
    expect(tryFrom(element.value), element, reason: name);
  }
  expect(
      () => from('NOT_A_CASE'),
      throwsA(isA<InvalidValueException>()
          .having((e) => e.cause, 'cause', 'Invalid $name: NOT_A_CASE')),
      reason: name);
  expect(tryFrom('NOT_A_CASE'), isNull, reason: name);
}

void main() {
  test('every_enum_maps_every_kotlin_name', () {
    expectValueEnum(
        'AccessType', AccessType.values, AccessType.from, AccessType.tryFrom);
    expectValueEnum('Aggregation', Aggregation.values, Aggregation.from,
        Aggregation.tryFrom);
    expectValueEnum(
        'BloodPressureMeasurementLocation',
        BloodPressureMeasurementLocation.values,
        BloodPressureMeasurementLocation.from,
        BloodPressureMeasurementLocation.tryFrom);
    expectValueEnum('BodyPosition', BodyPosition.values, BodyPosition.from,
        BodyPosition.tryFrom);
    expectValueEnum(
        'BodyTemperatureMeasurementLocation',
        BodyTemperatureMeasurementLocation.values,
        BodyTemperatureMeasurementLocation.from,
        BodyTemperatureMeasurementLocation.tryFrom);
    expectValueEnum('CervicalMucusAppearance', CervicalMucusAppearance.values,
        CervicalMucusAppearance.from, CervicalMucusAppearance.tryFrom);
    expectValueEnum('CervicalMucusSensation', CervicalMucusSensation.values,
        CervicalMucusSensation.from, CervicalMucusSensation.tryFrom);
    expectValueEnum(
        'DeviceType', DeviceType.values, DeviceType.from, DeviceType.tryFrom);
    expectValueEnum('ExercisePhase', ExercisePhase.values, ExercisePhase.from,
        ExercisePhase.tryFrom);
    expectValueEnum('ExerciseSegmentType', ExerciseSegmentType.values,
        ExerciseSegmentType.from, ExerciseSegmentType.tryFrom);
    expectValueEnum('ExerciseType', ExerciseType.values, ExerciseType.from,
        ExerciseType.tryFrom);
    expectValueEnum('Feature', Feature.values, Feature.from, Feature.tryFrom);
    expectValueEnum(
        'HealthType', HealthType.values, HealthType.from, HealthType.tryFrom);
    expectValueEnum(
        'MealType', MealType.values, MealType.from, MealType.tryFrom);
    expectValueEnum('MenstruationFlowType', MenstruationFlowType.values,
        MenstruationFlowType.from, MenstruationFlowType.tryFrom);
    expectValueEnum('MindfulnessSessionType', MindfulnessSessionType.values,
        MindfulnessSessionType.from, MindfulnessSessionType.tryFrom);
    expectValueEnum(
        'Ordering', Ordering.values, Ordering.from, Ordering.tryFrom);
    expectValueEnum('OvulationTestResult', OvulationTestResult.values,
        OvulationTestResult.from, OvulationTestResult.tryFrom);
    expectValueEnum('ProtectionUsed', ProtectionUsed.values,
        ProtectionUsed.from, ProtectionUsed.tryFrom);
    expectValueEnum('RecordingMethod', RecordingMethod.values,
        RecordingMethod.from, RecordingMethod.tryFrom);
    expectValueEnum('RelationToMeal', RelationToMeal.values,
        RelationToMeal.from, RelationToMeal.tryFrom);
    expectValueEnum(
        'SkinTemperatureMeasurementLocation',
        SkinTemperatureMeasurementLocation.values,
        SkinTemperatureMeasurementLocation.from,
        SkinTemperatureMeasurementLocation.tryFrom);
    expectValueEnum('SleepStageType', SleepStageType.values,
        SleepStageType.from, SleepStageType.tryFrom);
    expectValueEnum('SpecimenSource', SpecimenSource.values,
        SpecimenSource.from, SpecimenSource.tryFrom);
    expectValueEnum('TimeGroupUnit', TimeGroupUnit.values, TimeGroupUnit.from,
        TimeGroupUnit.tryFrom);
    expectValueEnum('Vo2MaxMeasurementMethod', Vo2MaxMeasurementMethod.values,
        Vo2MaxMeasurementMethod.from, Vo2MaxMeasurementMethod.tryFrom);
  });

  test('health_type_carries_the_library_identifier_writability_and_feature',
      () {
    const expected = <HealthType, (String, bool, Feature?)>{
      HealthType.activeCaloriesBurned: ('active_calories_burned', true, null),
      HealthType.basalBodyTemperature: ('basal_body_temperature', true, null),
      HealthType.basalMetabolicRate: ('basal_metabolic_rate', true, null),
      HealthType.bloodGlucose: ('blood_glucose', true, null),
      HealthType.bloodPressure: ('blood_pressure', true, null),
      HealthType.bodyFat: ('body_fat', true, null),
      HealthType.bodyTemperature: ('body_temperature', true, null),
      HealthType.bodyWaterMass: ('body_water_mass', true, null),
      HealthType.boneMass: ('bone_mass', true, null),
      HealthType.cervicalMucus: ('cervical_mucus', true, null),
      HealthType.cyclingPedalingCadence: (
        'cycling_pedaling_cadence',
        true,
        null
      ),
      HealthType.distance: ('distance', true, null),
      HealthType.elevationGained: ('elevation_gained', true, null),
      HealthType.exerciseSession: ('exercise', true, null),
      HealthType.floorsClimbed: ('floors_climbed', true, null),
      HealthType.heartRate: ('heart_rate', true, null),
      HealthType.heartRateVariabilityRmssd: (
        'heart_rate_variability_rmssd',
        true,
        null
      ),
      HealthType.height: ('height', true, null),
      HealthType.hydration: ('water_intake', true, null),
      HealthType.intermenstrualBleeding: (
        'intermenstrual_bleeding',
        true,
        null
      ),
      HealthType.leanBodyMass: ('lean_body_mass', true, null),
      HealthType.menstruationFlow: ('menstruation_flow', true, null),
      HealthType.menstruationPeriod: ('menstruation_period', true, null),
      HealthType.mindfulnessSession: (
        'mindfulness_session',
        true,
        Feature.mindfulnessSession
      ),
      HealthType.nutrition: ('nutrition', true, null),
      HealthType.ovulationTest: ('ovulation_test', true, null),
      HealthType.oxygenSaturation: ('blood_oxygen', true, null),
      HealthType.plannedExerciseSession: (
        'planned_exercise',
        true,
        Feature.plannedExercise
      ),
      HealthType.power: ('power', true, null),
      HealthType.respiratoryRate: ('respiratory_rate', true, null),
      HealthType.restingHeartRate: ('resting_heart_rate', true, null),
      HealthType.sexualActivity: ('sexual_activity', true, null),
      HealthType.skinTemperature: (
        'skin_temperature',
        true,
        Feature.skinTemperature
      ),
      HealthType.sleepSession: ('sleep', true, null),
      HealthType.speed: ('speed', true, null),
      HealthType.steps: ('steps', true, null),
      HealthType.stepsCadence: ('steps_cadence', true, null),
      HealthType.totalCaloriesBurned: ('total_calories_burned', true, null),
      HealthType.vo2Max: ('vo2_max', true, null),
      HealthType.weight: ('weight', true, null),
      HealthType.wheelchairPushes: ('wheelchair_pushes', true, null),
    };
    expect(expected.keys, HealthType.values);
    for (final entry in expected.entries) {
      final (identifier, isWritable, feature) = entry.value;
      expect(entry.key.identifier, identifier);
      expect(entry.key.isWritable, isWritable);
      expect(entry.key.feature, feature);
      expect(HealthType.fromIdentifier(identifier), entry.key);
      expect(HealthType.tryFromIdentifier(identifier), entry.key);
    }
  });

  test('health_type_from_an_unknown_identifier_throws', () {
    expect(
        () => HealthType.fromIdentifier('STEPS'),
        throwsA(isA<InvalidValueException>()
            .having((e) => e.cause, 'cause', 'Invalid HealthType: STEPS')));
    expect(HealthType.tryFromIdentifier('STEPS'), isNull);
  });

  test('aggregation_carries_the_library_type_and_unit', () {
    const expected = <Aggregation, (HealthType, String)>{
      Aggregation.activeCaloriesBurnedActiveCaloriesTotal: (
        HealthType.activeCaloriesBurned,
        'kcal'
      ),
      Aggregation.basalMetabolicRateBasalCaloriesTotal: (
        HealthType.basalMetabolicRate,
        'kcal'
      ),
      Aggregation.bloodPressureSystolicAvg: (HealthType.bloodPressure, 'mmHg'),
      Aggregation.bloodPressureSystolicMin: (HealthType.bloodPressure, 'mmHg'),
      Aggregation.bloodPressureSystolicMax: (HealthType.bloodPressure, 'mmHg'),
      Aggregation.bloodPressureDiastolicAvg: (HealthType.bloodPressure, 'mmHg'),
      Aggregation.bloodPressureDiastolicMin: (HealthType.bloodPressure, 'mmHg'),
      Aggregation.bloodPressureDiastolicMax: (HealthType.bloodPressure, 'mmHg'),
      Aggregation.cyclingPedalingCadenceRpmAvg: (
        HealthType.cyclingPedalingCadence,
        'rpm'
      ),
      Aggregation.cyclingPedalingCadenceRpmMin: (
        HealthType.cyclingPedalingCadence,
        'rpm'
      ),
      Aggregation.cyclingPedalingCadenceRpmMax: (
        HealthType.cyclingPedalingCadence,
        'rpm'
      ),
      Aggregation.distanceDistanceTotal: (HealthType.distance, 'm'),
      Aggregation.elevationGainedElevationGainedTotal: (
        HealthType.elevationGained,
        'm'
      ),
      Aggregation.exerciseSessionExerciseDurationTotal: (
        HealthType.exerciseSession,
        'ms'
      ),
      Aggregation.floorsClimbedFloorsClimbedTotal: (
        HealthType.floorsClimbed,
        'floors'
      ),
      Aggregation.heartRateBpmAvg: (HealthType.heartRate, 'bpm'),
      Aggregation.heartRateBpmMin: (HealthType.heartRate, 'bpm'),
      Aggregation.heartRateBpmMax: (HealthType.heartRate, 'bpm'),
      Aggregation.heartRateMeasurementsCount: (HealthType.heartRate, 'count'),
      Aggregation.heightHeightAvg: (HealthType.height, 'm'),
      Aggregation.heightHeightMin: (HealthType.height, 'm'),
      Aggregation.heightHeightMax: (HealthType.height, 'm'),
      Aggregation.hydrationVolumeTotal: (HealthType.hydration, 'L'),
      Aggregation.nutritionBiotinTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionCaffeineTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionCalciumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionEnergyTotal: (HealthType.nutrition, 'kcal'),
      Aggregation.nutritionEnergyFromFatTotal: (HealthType.nutrition, 'kcal'),
      Aggregation.nutritionChlorideTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionCholesterolTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionChromiumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionCopperTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionDietaryFiberTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionFolateTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionFolicAcidTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionIodineTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionIronTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionMagnesiumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionManganeseTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionMolybdenumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionMonounsaturatedFatTotal: (
        HealthType.nutrition,
        'kg'
      ),
      Aggregation.nutritionNiacinTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionPantothenicAcidTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionPhosphorusTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionPolyunsaturatedFatTotal: (
        HealthType.nutrition,
        'kg'
      ),
      Aggregation.nutritionPotassiumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionProteinTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionRiboflavinTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionSaturatedFatTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionSeleniumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionSodiumTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionSugarTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionThiaminTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionTotalCarbohydrateTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionTotalFatTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionTransFatTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionUnsaturatedFatTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminATotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminB12Total: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminB6Total: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminCTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminDTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminETotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionVitaminKTotal: (HealthType.nutrition, 'kg'),
      Aggregation.nutritionZincTotal: (HealthType.nutrition, 'kg'),
      Aggregation.powerPowerAvg: (HealthType.power, 'W'),
      Aggregation.powerPowerMin: (HealthType.power, 'W'),
      Aggregation.powerPowerMax: (HealthType.power, 'W'),
      Aggregation.restingHeartRateBpmAvg: (HealthType.restingHeartRate, 'bpm'),
      Aggregation.restingHeartRateBpmMin: (HealthType.restingHeartRate, 'bpm'),
      Aggregation.restingHeartRateBpmMax: (HealthType.restingHeartRate, 'bpm'),
      Aggregation.skinTemperatureTemperatureDeltaAvg: (
        HealthType.skinTemperature,
        '°C'
      ),
      Aggregation.skinTemperatureTemperatureDeltaMin: (
        HealthType.skinTemperature,
        '°C'
      ),
      Aggregation.skinTemperatureTemperatureDeltaMax: (
        HealthType.skinTemperature,
        '°C'
      ),
      Aggregation.sleepSessionSleepDurationTotal: (
        HealthType.sleepSession,
        'ms'
      ),
      Aggregation.speedSpeedAvg: (HealthType.speed, 'm/s'),
      Aggregation.speedSpeedMin: (HealthType.speed, 'm/s'),
      Aggregation.speedSpeedMax: (HealthType.speed, 'm/s'),
      Aggregation.stepsCadenceRateAvg: (HealthType.stepsCadence, 'steps/min'),
      Aggregation.stepsCadenceRateMin: (HealthType.stepsCadence, 'steps/min'),
      Aggregation.stepsCadenceRateMax: (HealthType.stepsCadence, 'steps/min'),
      Aggregation.stepsCountTotal: (HealthType.steps, 'count'),
      Aggregation.totalCaloriesBurnedEnergyTotal: (
        HealthType.totalCaloriesBurned,
        'kcal'
      ),
      Aggregation.weightWeightAvg: (HealthType.weight, 'kg'),
      Aggregation.weightWeightMin: (HealthType.weight, 'kg'),
      Aggregation.weightWeightMax: (HealthType.weight, 'kg'),
      Aggregation.wheelchairPushesCountTotal: (
        HealthType.wheelchairPushes,
        'count'
      ),
    };
    expect(expected.keys, Aggregation.values);
    for (final entry in expected.entries) {
      expect((entry.key.healthType, entry.key.unit), entry.value);
    }
  });

  test('health_type_lists_its_aggregations', () {
    expect(HealthType.heartRate.aggregations, [
      Aggregation.heartRateBpmAvg,
      Aggregation.heartRateBpmMin,
      Aggregation.heartRateBpmMax,
      Aggregation.heartRateMeasurementsCount,
    ]);
    // Health Connect client 1.1.0 can't aggregate mindfulness on Android 14+
    expect(HealthType.mindfulnessSession.aggregations, isEmpty);
  });
}
