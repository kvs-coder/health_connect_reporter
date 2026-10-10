import '../../exceptions.dart';
import '../aggregate.dart';
import 'health_type.dart';
import 'value_enum.dart';

/// Equivalent of [Aggregation]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One aggregate Health Connect computes over a [healthType], named after its
/// `AggregateMetric`.
///
/// Health Connect client 1.1.0 can't aggregate mindfulness sessions on
/// Android 14+, so they have no aggregation.
///
/// Values are reported in the canonical units: durations in milliseconds,
/// masses in kg, energy in kcal.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [Aggregation.from] and [Aggregation.tryFrom]
/// creating from the [value].
///
enum Aggregation implements ValueEnum {
  /// total active calories burned
  activeCaloriesBurnedActiveCaloriesTotal(
      'ACTIVE_CALORIES_BURNED_ACTIVE_CALORIES_TOTAL',
      HealthType.activeCaloriesBurned,
      'kcal'),

  /// total basal calories burned
  basalMetabolicRateBasalCaloriesTotal(
      'BASAL_METABOLIC_RATE_BASAL_CALORIES_TOTAL',
      HealthType.basalMetabolicRate,
      'kcal'),

  /// average systolic pressure
  bloodPressureSystolicAvg(
      'BLOOD_PRESSURE_SYSTOLIC_AVG', HealthType.bloodPressure, 'mmHg'),

  /// minimum systolic pressure
  bloodPressureSystolicMin(
      'BLOOD_PRESSURE_SYSTOLIC_MIN', HealthType.bloodPressure, 'mmHg'),

  /// maximum systolic pressure
  bloodPressureSystolicMax(
      'BLOOD_PRESSURE_SYSTOLIC_MAX', HealthType.bloodPressure, 'mmHg'),

  /// average diastolic pressure
  bloodPressureDiastolicAvg(
      'BLOOD_PRESSURE_DIASTOLIC_AVG', HealthType.bloodPressure, 'mmHg'),

  /// minimum diastolic pressure
  bloodPressureDiastolicMin(
      'BLOOD_PRESSURE_DIASTOLIC_MIN', HealthType.bloodPressure, 'mmHg'),

  /// maximum diastolic pressure
  bloodPressureDiastolicMax(
      'BLOOD_PRESSURE_DIASTOLIC_MAX', HealthType.bloodPressure, 'mmHg'),

  /// average pedaling cadence
  cyclingPedalingCadenceRpmAvg('CYCLING_PEDALING_CADENCE_RPM_AVG',
      HealthType.cyclingPedalingCadence, 'rpm'),

  /// minimum pedaling cadence
  cyclingPedalingCadenceRpmMin('CYCLING_PEDALING_CADENCE_RPM_MIN',
      HealthType.cyclingPedalingCadence, 'rpm'),

  /// maximum pedaling cadence
  cyclingPedalingCadenceRpmMax('CYCLING_PEDALING_CADENCE_RPM_MAX',
      HealthType.cyclingPedalingCadence, 'rpm'),

  /// total distance
  distanceDistanceTotal('DISTANCE_DISTANCE_TOTAL', HealthType.distance, 'm'),

  /// total elevation gained
  elevationGainedElevationGainedTotal('ELEVATION_GAINED_ELEVATION_GAINED_TOTAL',
      HealthType.elevationGained, 'm'),

  /// total exercise duration
  exerciseSessionExerciseDurationTotal(
      'EXERCISE_SESSION_EXERCISE_DURATION_TOTAL',
      HealthType.exerciseSession,
      'ms'),

  /// total floors climbed
  floorsClimbedFloorsClimbedTotal('FLOORS_CLIMBED_FLOORS_CLIMBED_TOTAL',
      HealthType.floorsClimbed, 'floors'),

  /// average heart rate
  heartRateBpmAvg('HEART_RATE_BPM_AVG', HealthType.heartRate, 'bpm'),

  /// minimum heart rate
  heartRateBpmMin('HEART_RATE_BPM_MIN', HealthType.heartRate, 'bpm'),

  /// maximum heart rate
  heartRateBpmMax('HEART_RATE_BPM_MAX', HealthType.heartRate, 'bpm'),

  /// number of heart rate measurements
  heartRateMeasurementsCount(
      'HEART_RATE_MEASUREMENTS_COUNT', HealthType.heartRate, 'count'),

  /// average height
  heightHeightAvg('HEIGHT_HEIGHT_AVG', HealthType.height, 'm'),

  /// minimum height
  heightHeightMin('HEIGHT_HEIGHT_MIN', HealthType.height, 'm'),

  /// maximum height
  heightHeightMax('HEIGHT_HEIGHT_MAX', HealthType.height, 'm'),

  /// total water intake
  hydrationVolumeTotal('HYDRATION_VOLUME_TOTAL', HealthType.hydration, 'L'),

  /// total biotin
  nutritionBiotinTotal('NUTRITION_BIOTIN_TOTAL', HealthType.nutrition, 'kg'),

  /// total caffeine
  nutritionCaffeineTotal(
      'NUTRITION_CAFFEINE_TOTAL', HealthType.nutrition, 'kg'),

  /// total calcium
  nutritionCalciumTotal('NUTRITION_CALCIUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total energy
  nutritionEnergyTotal('NUTRITION_ENERGY_TOTAL', HealthType.nutrition, 'kcal'),

  /// total energy from fat
  nutritionEnergyFromFatTotal(
      'NUTRITION_ENERGY_FROM_FAT_TOTAL', HealthType.nutrition, 'kcal'),

  /// total chloride
  nutritionChlorideTotal(
      'NUTRITION_CHLORIDE_TOTAL', HealthType.nutrition, 'kg'),

  /// total cholesterol
  nutritionCholesterolTotal(
      'NUTRITION_CHOLESTEROL_TOTAL', HealthType.nutrition, 'kg'),

  /// total chromium
  nutritionChromiumTotal(
      'NUTRITION_CHROMIUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total copper
  nutritionCopperTotal('NUTRITION_COPPER_TOTAL', HealthType.nutrition, 'kg'),

  /// total dietary fiber
  nutritionDietaryFiberTotal(
      'NUTRITION_DIETARY_FIBER_TOTAL', HealthType.nutrition, 'kg'),

  /// total folate
  nutritionFolateTotal('NUTRITION_FOLATE_TOTAL', HealthType.nutrition, 'kg'),

  /// total folic acid
  nutritionFolicAcidTotal(
      'NUTRITION_FOLIC_ACID_TOTAL', HealthType.nutrition, 'kg'),

  /// total iodine
  nutritionIodineTotal('NUTRITION_IODINE_TOTAL', HealthType.nutrition, 'kg'),

  /// total iron
  nutritionIronTotal('NUTRITION_IRON_TOTAL', HealthType.nutrition, 'kg'),

  /// total magnesium
  nutritionMagnesiumTotal(
      'NUTRITION_MAGNESIUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total manganese
  nutritionManganeseTotal(
      'NUTRITION_MANGANESE_TOTAL', HealthType.nutrition, 'kg'),

  /// total molybdenum
  nutritionMolybdenumTotal(
      'NUTRITION_MOLYBDENUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total monounsaturated fat
  nutritionMonounsaturatedFatTotal(
      'NUTRITION_MONOUNSATURATED_FAT_TOTAL', HealthType.nutrition, 'kg'),

  /// total niacin
  nutritionNiacinTotal('NUTRITION_NIACIN_TOTAL', HealthType.nutrition, 'kg'),

  /// total pantothenic acid
  nutritionPantothenicAcidTotal(
      'NUTRITION_PANTOTHENIC_ACID_TOTAL', HealthType.nutrition, 'kg'),

  /// total phosphorus
  nutritionPhosphorusTotal(
      'NUTRITION_PHOSPHORUS_TOTAL', HealthType.nutrition, 'kg'),

  /// total polyunsaturated fat
  nutritionPolyunsaturatedFatTotal(
      'NUTRITION_POLYUNSATURATED_FAT_TOTAL', HealthType.nutrition, 'kg'),

  /// total potassium
  nutritionPotassiumTotal(
      'NUTRITION_POTASSIUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total protein
  nutritionProteinTotal('NUTRITION_PROTEIN_TOTAL', HealthType.nutrition, 'kg'),

  /// total riboflavin
  nutritionRiboflavinTotal(
      'NUTRITION_RIBOFLAVIN_TOTAL', HealthType.nutrition, 'kg'),

  /// total saturated fat
  nutritionSaturatedFatTotal(
      'NUTRITION_SATURATED_FAT_TOTAL', HealthType.nutrition, 'kg'),

  /// total selenium
  nutritionSeleniumTotal(
      'NUTRITION_SELENIUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total sodium
  nutritionSodiumTotal('NUTRITION_SODIUM_TOTAL', HealthType.nutrition, 'kg'),

  /// total sugar
  nutritionSugarTotal('NUTRITION_SUGAR_TOTAL', HealthType.nutrition, 'kg'),

  /// total thiamin
  nutritionThiaminTotal('NUTRITION_THIAMIN_TOTAL', HealthType.nutrition, 'kg'),

  /// total total carbohydrate
  nutritionTotalCarbohydrateTotal(
      'NUTRITION_TOTAL_CARBOHYDRATE_TOTAL', HealthType.nutrition, 'kg'),

  /// total total fat
  nutritionTotalFatTotal(
      'NUTRITION_TOTAL_FAT_TOTAL', HealthType.nutrition, 'kg'),

  /// total trans fat
  nutritionTransFatTotal(
      'NUTRITION_TRANS_FAT_TOTAL', HealthType.nutrition, 'kg'),

  /// total unsaturated fat
  nutritionUnsaturatedFatTotal(
      'NUTRITION_UNSATURATED_FAT_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin a
  nutritionVitaminATotal(
      'NUTRITION_VITAMIN_A_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin b12
  nutritionVitaminB12Total(
      'NUTRITION_VITAMIN_B12_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin b6
  nutritionVitaminB6Total(
      'NUTRITION_VITAMIN_B6_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin c
  nutritionVitaminCTotal(
      'NUTRITION_VITAMIN_C_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin d
  nutritionVitaminDTotal(
      'NUTRITION_VITAMIN_D_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin e
  nutritionVitaminETotal(
      'NUTRITION_VITAMIN_E_TOTAL', HealthType.nutrition, 'kg'),

  /// total vitamin k
  nutritionVitaminKTotal(
      'NUTRITION_VITAMIN_K_TOTAL', HealthType.nutrition, 'kg'),

  /// total zinc
  nutritionZincTotal('NUTRITION_ZINC_TOTAL', HealthType.nutrition, 'kg'),

  /// average power
  powerPowerAvg('POWER_POWER_AVG', HealthType.power, 'W'),

  /// minimum power
  powerPowerMin('POWER_POWER_MIN', HealthType.power, 'W'),

  /// maximum power
  powerPowerMax('POWER_POWER_MAX', HealthType.power, 'W'),

  /// average resting heart rate
  restingHeartRateBpmAvg(
      'RESTING_HEART_RATE_BPM_AVG', HealthType.restingHeartRate, 'bpm'),

  /// minimum resting heart rate
  restingHeartRateBpmMin(
      'RESTING_HEART_RATE_BPM_MIN', HealthType.restingHeartRate, 'bpm'),

  /// maximum resting heart rate
  restingHeartRateBpmMax(
      'RESTING_HEART_RATE_BPM_MAX', HealthType.restingHeartRate, 'bpm'),

  /// average skin temperature delta from the baseline
  skinTemperatureTemperatureDeltaAvg('SKIN_TEMPERATURE_TEMPERATURE_DELTA_AVG',
      HealthType.skinTemperature, '°C'),

  /// minimum skin temperature delta from the baseline
  skinTemperatureTemperatureDeltaMin('SKIN_TEMPERATURE_TEMPERATURE_DELTA_MIN',
      HealthType.skinTemperature, '°C'),

  /// maximum skin temperature delta from the baseline
  skinTemperatureTemperatureDeltaMax('SKIN_TEMPERATURE_TEMPERATURE_DELTA_MAX',
      HealthType.skinTemperature, '°C'),

  /// total sleep duration
  sleepSessionSleepDurationTotal(
      'SLEEP_SESSION_SLEEP_DURATION_TOTAL', HealthType.sleepSession, 'ms'),

  /// average speed
  speedSpeedAvg('SPEED_SPEED_AVG', HealthType.speed, 'm/s'),

  /// minimum speed
  speedSpeedMin('SPEED_SPEED_MIN', HealthType.speed, 'm/s'),

  /// maximum speed
  speedSpeedMax('SPEED_SPEED_MAX', HealthType.speed, 'm/s'),

  /// average steps cadence
  stepsCadenceRateAvg(
      'STEPS_CADENCE_RATE_AVG', HealthType.stepsCadence, 'steps/min'),

  /// minimum steps cadence
  stepsCadenceRateMin(
      'STEPS_CADENCE_RATE_MIN', HealthType.stepsCadence, 'steps/min'),

  /// maximum steps cadence
  stepsCadenceRateMax(
      'STEPS_CADENCE_RATE_MAX', HealthType.stepsCadence, 'steps/min'),

  /// total steps
  stepsCountTotal('STEPS_COUNT_TOTAL', HealthType.steps, 'count'),

  /// total calories burned
  totalCaloriesBurnedEnergyTotal('TOTAL_CALORIES_BURNED_ENERGY_TOTAL',
      HealthType.totalCaloriesBurned, 'kcal'),

  /// average weight
  weightWeightAvg('WEIGHT_WEIGHT_AVG', HealthType.weight, 'kg'),

  /// minimum weight
  weightWeightMin('WEIGHT_WEIGHT_MIN', HealthType.weight, 'kg'),

  /// maximum weight
  weightWeightMax('WEIGHT_WEIGHT_MAX', HealthType.weight, 'kg'),

  /// total wheelchair pushes
  wheelchairPushesCountTotal(
      'WHEELCHAIR_PUSHES_COUNT_TOTAL', HealthType.wheelchairPushes, 'count');

  const Aggregation(this.value, this.healthType, this.unit);

  /// The Kotlin constant name, e.g. `STEPS_COUNT_TOTAL`
  @override
  final String value;

  /// The aggregated type
  final HealthType healthType;

  /// Unit of [Aggregate.value]
  final String unit;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory Aggregation.from(String value) => valueOf(values, value);

  /// The [Aggregation.from] exception handling
  ///
  static Aggregation? tryFrom(String value) => tryValueOf(values, value);
}
