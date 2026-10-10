import '../../exceptions.dart';
import 'aggregation.dart';
import 'feature.dart';
import 'value_enum.dart';

/// Equivalent of [HealthType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One Health Connect record type.
///
/// Every type can be read, written by the app that holds its write
/// permission, and observed.
///
/// [identifier] is the stable library identifier (`heart_rate`), carried
/// by a sample's `type` discriminator; [value] is the Kotlin constant name
/// (`HEART_RATE`), carried by permissions.
///
/// Has factory methods [HealthType.from] and [HealthType.tryFrom]
/// creating from the [value], and [HealthType.fromIdentifier] and
/// [HealthType.tryFromIdentifier] creating from the [identifier].
///
enum HealthType implements ValueEnum {
  /// calories burned by activity, ActiveCaloriesBurned
  activeCaloriesBurned(
      'active_calories_burned', 'ACTIVE_CALORIES_BURNED', true, null),

  /// basal body temperature, BasalBodyTemperature
  basalBodyTemperature(
      'basal_body_temperature', 'BASAL_BODY_TEMPERATURE', true, null),

  /// basal metabolic rate, BasalMetabolicRate
  basalMetabolicRate(
      'basal_metabolic_rate', 'BASAL_METABOLIC_RATE', true, null),

  /// blood glucose, BloodGlucose
  bloodGlucose('blood_glucose', 'BLOOD_GLUCOSE', true, null),

  /// blood pressure, BloodPressure
  bloodPressure('blood_pressure', 'BLOOD_PRESSURE', true, null),

  /// body fat, BodyFat
  bodyFat('body_fat', 'BODY_FAT', true, null),

  /// body temperature, BodyTemperature
  bodyTemperature('body_temperature', 'BODY_TEMPERATURE', true, null),

  /// body water mass, BodyWaterMass
  bodyWaterMass('body_water_mass', 'BODY_WATER_MASS', true, null),

  /// bone mass, BoneMass
  boneMass('bone_mass', 'BONE_MASS', true, null),

  /// cervical mucus, CervicalMucus
  cervicalMucus('cervical_mucus', 'CERVICAL_MUCUS', true, null),

  /// cycling pedaling cadence, CyclingPedalingCadence
  cyclingPedalingCadence(
      'cycling_pedaling_cadence', 'CYCLING_PEDALING_CADENCE', true, null),

  /// distance, Distance
  distance('distance', 'DISTANCE', true, null),

  /// elevation gained, ElevationGained
  elevationGained('elevation_gained', 'ELEVATION_GAINED', true, null),

  /// exercise sessions, ExerciseSession
  exerciseSession('exercise', 'EXERCISE_SESSION', true, null),

  /// floors climbed, FloorsClimbed
  floorsClimbed('floors_climbed', 'FLOORS_CLIMBED', true, null),

  /// heart rate, HeartRate
  heartRate('heart_rate', 'HEART_RATE', true, null),

  /// heart rate variability (RMSSD), HeartRateVariabilityRmssd
  heartRateVariabilityRmssd('heart_rate_variability_rmssd',
      'HEART_RATE_VARIABILITY_RMSSD', true, null),

  /// height, Height
  height('height', 'HEIGHT', true, null),

  /// water intake, Hydration
  hydration('water_intake', 'HYDRATION', true, null),

  /// intermenstrual bleeding, IntermenstrualBleeding
  intermenstrualBleeding(
      'intermenstrual_bleeding', 'INTERMENSTRUAL_BLEEDING', true, null),

  /// lean body mass, LeanBodyMass
  leanBodyMass('lean_body_mass', 'LEAN_BODY_MASS', true, null),

  /// menstrual flow, MenstruationFlow
  menstruationFlow('menstruation_flow', 'MENSTRUATION_FLOW', true, null),

  /// menstruation periods, MenstruationPeriod
  menstruationPeriod('menstruation_period', 'MENSTRUATION_PERIOD', true, null),

  /// mindfulness sessions, MindfulnessSession (needs
  /// [Feature.MINDFULNESS_SESSION])
  mindfulnessSession('mindfulness_session', 'MINDFULNESS_SESSION', true,
      Feature.mindfulnessSession),

  /// nutrition, Nutrition
  nutrition('nutrition', 'NUTRITION', true, null),

  /// ovulation tests, OvulationTest
  ovulationTest('ovulation_test', 'OVULATION_TEST', true, null),

  /// blood oxygen saturation, OxygenSaturation
  oxygenSaturation('blood_oxygen', 'OXYGEN_SATURATION', true, null),

  /// planned exercise sessions (training plans), PlannedExerciseSession (needs
  /// [Feature.PLANNED_EXERCISE])
  plannedExerciseSession('planned_exercise', 'PLANNED_EXERCISE_SESSION', true,
      Feature.plannedExercise),

  /// power, Power
  power('power', 'POWER', true, null),

  /// respiratory rate, RespiratoryRate
  respiratoryRate('respiratory_rate', 'RESPIRATORY_RATE', true, null),

  /// resting heart rate, RestingHeartRate
  restingHeartRate('resting_heart_rate', 'RESTING_HEART_RATE', true, null),

  /// sexual activity, SexualActivity
  sexualActivity('sexual_activity', 'SEXUAL_ACTIVITY', true, null),

  /// skin temperature, SkinTemperature (needs [Feature.SKIN_TEMPERATURE])
  skinTemperature(
      'skin_temperature', 'SKIN_TEMPERATURE', true, Feature.skinTemperature),

  /// sleep sessions, SleepSession
  sleepSession('sleep', 'SLEEP_SESSION', true, null),

  /// speed, Speed
  speed('speed', 'SPEED', true, null),

  /// steps, Steps
  steps('steps', 'STEPS', true, null),

  /// steps cadence, StepsCadence
  stepsCadence('steps_cadence', 'STEPS_CADENCE', true, null),

  /// total calories burned, TotalCaloriesBurned
  totalCaloriesBurned(
      'total_calories_burned', 'TOTAL_CALORIES_BURNED', true, null),

  /// maximal oxygen uptake (VO2 max), Vo2Max
  vo2Max('vo2_max', 'VO2_MAX', true, null),

  /// weight, Weight
  weight('weight', 'WEIGHT', true, null),

  /// wheelchair pushes, WheelchairPushes
  wheelchairPushes('wheelchair_pushes', 'WHEELCHAIR_PUSHES', true, null);

  const HealthType(this.identifier, this.value, this.isWritable, this.feature);

  /// Stable library identifier, e.g. `heart_rate`, carried by a sample's
  /// `type` discriminator
  final String identifier;

  /// The Kotlin constant name, e.g. `HEART_RATE`, carried by permissions
  @override
  final String value;

  /// Samples can be inserted, updated and deleted
  final bool isWritable;

  /// The Health Connect feature the type needs; null when it needs none
  final Feature? feature;

  /// The aggregations available for this type
  List<Aggregation> get aggregations =>
      Aggregation.values.where((e) => e.healthType == this).toList();

  /// Finds the type by its [value], e.g. `HEART_RATE`.
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory HealthType.from(String value) => valueOf(values, value);

  /// The [HealthType.from] exception handling
  ///
  static HealthType? tryFrom(String value) => tryValueOf(values, value);

  /// Finds the type by its [identifier], e.g. `heart_rate`.
  /// Throws an [InvalidValueException] for an unknown identifier.
  ///
  factory HealthType.fromIdentifier(String identifier) => values.firstWhere(
        (type) => type.identifier == identifier,
        orElse: () =>
            throw InvalidValueException('Invalid HealthType: $identifier'),
      );

  /// The [HealthType.fromIdentifier] exception handling
  ///
  static HealthType? tryFromIdentifier(String identifier) {
    for (final type in values) {
      if (type.identifier == identifier) return type;
    }
    return null;
  }
}
