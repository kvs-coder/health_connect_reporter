import '../../exceptions.dart';
import '../data_origin.dart';
import '../decorator/extensions.dart';
import '../device.dart';
import '../type/health_type.dart';
import '../type/recording_method.dart';
import 'active_calories_burned.dart';
import 'basal_body_temperature.dart';
import 'basal_metabolic_rate.dart';
import 'blood_glucose.dart';
import 'blood_pressure.dart';
import 'body_fat.dart';
import 'body_temperature.dart';
import 'body_water_mass.dart';
import 'bone_mass.dart';
import 'cervical_mucus.dart';
import 'cycling_pedaling_cadence.dart';
import 'distance.dart';
import 'elevation_gained.dart';
import 'exercise_session.dart';
import 'floors_climbed.dart';
import 'heart_rate.dart';
import 'heart_rate_variability_rmssd.dart';
import 'height.dart';
import 'hydration.dart';
import 'intermenstrual_bleeding.dart';
import 'lean_body_mass.dart';
import 'menstruation_flow.dart';
import 'menstruation_period.dart';
import 'mindfulness_session.dart';
import 'nutrition.dart';
import 'ovulation_test.dart';
import 'oxygen_saturation.dart';
import 'planned_exercise_session.dart';
import 'power.dart';
import 'respiratory_rate.dart';
import 'resting_heart_rate.dart';
import 'sexual_activity.dart';
import 'skin_temperature.dart';
import 'sleep_session.dart';
import 'speed.dart';
import 'steps.dart';
import 'steps_cadence.dart';
import 'total_calories_burned.dart';
import 'vo2_max.dart';
import 'weight.dart';
import 'wheelchair_pushes.dart';
import 'payload.dart';

/// Equivalent of [Sample]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One record stored in Health Connect. In JSON a sample carries
/// a `type` discriminator with its [healthType] identifier, e.g. `heart_rate`.
///
/// [id] names the stored record, [clientRecordId] and [clientRecordVersion]
/// the app's own key and version; update and delete send all three.
///
/// Supports [map] representation.
///
/// Has a [Sample.from] constructor
/// to create instances from JSON payload coming from Android native code
/// and a generic Harmonized object, null for records without values.
///
/// Has a [factory] method for creating a specific instance of types:
/// - [ActiveCaloriesBurned]
/// - [BasalBodyTemperature]
/// - [BasalMetabolicRate]
/// - [BloodGlucose]
/// - [BloodPressure]
/// - [BodyFat]
/// - [BodyTemperature]
/// - [BodyWaterMass]
/// - [BoneMass]
/// - [CervicalMucus]
/// - [CyclingPedalingCadence]
/// - [Distance]
/// - [ElevationGained]
/// - [ExerciseSession]
/// - [FloorsClimbed]
/// - [HeartRate]
/// - [HeartRateVariabilityRmssd]
/// - [Height]
/// - [Hydration]
/// - [IntermenstrualBleeding]
/// - [LeanBodyMass]
/// - [MenstruationFlow]
/// - [MenstruationPeriod]
/// - [MindfulnessSession]
/// - [Nutrition]
/// - [OvulationTest]
/// - [OxygenSaturation]
/// - [PlannedExerciseSession]
/// - [Power]
/// - [RespiratoryRate]
/// - [RestingHeartRate]
/// - [SexualActivity]
/// - [SkinTemperature]
/// - [SleepSession]
/// - [Speed]
/// - [Steps]
/// - [StepsCadence]
/// - [TotalCaloriesBurned]
/// - [Vo2Max]
/// - [Weight]
/// - [WheelchairPushes]
///
abstract class Sample<Harmonized extends Payload?> with Payload {
  const Sample({
    required this.startTimestamp,
    required this.harmonized,
    this.id,
    this.clientRecordId,
    this.clientRecordVersion,
    this.startZoneOffsetSeconds,
    this.endZoneOffsetSeconds,
    this.recordingMethod,
    this.device,
    this.dataOrigin,
    this.lastModifiedTimestamp,
  });

  /// Start time (the measurement time of an instantaneous record),
  /// epoch milliseconds
  final int startTimestamp;

  /// End time, epoch milliseconds; null for instantaneous records
  int? get endTimestamp;

  /// The measured values; null for records without values
  final Harmonized harmonized;

  /// Health Connect id of the stored record; null until it is inserted
  final String? id;

  /// Your own id for the record, kept by Health Connect;
  /// inserting it again updates the record
  final String? clientRecordId;

  /// Your own version of [clientRecordId]; Health Connect keeps the highest
  final int? clientRecordVersion;

  /// Zone offset at [startTimestamp] in seconds; null means unknown
  final int? startZoneOffsetSeconds;

  /// Zone offset at [endTimestamp] in seconds; null means unknown
  final int? endZoneOffsetSeconds;

  /// How the record was recorded; [RecordingMethod.manualEntry]
  /// when written as null
  final RecordingMethod? recordingMethod;

  /// The device that recorded the data
  final Device? device;

  /// The app that wrote the record; set by Health Connect
  final DataOrigin? dataOrigin;

  /// Last modification time, epoch milliseconds; set by Health Connect
  final int? lastModifiedTimestamp;

  /// The data type of this sample
  HealthType get healthType;

  /// General map representation, with the `type` discriminator
  ///
  @override
  Map<String, dynamic> get map => {
        'type': healthType.identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'harmonized': harmonized?.map,
        'id': id,
        'clientRecordId': clientRecordId,
        'clientRecordVersion': clientRecordVersion,
        'startZoneOffsetSeconds': startZoneOffsetSeconds,
        'endZoneOffsetSeconds': endZoneOffsetSeconds,
        'recordingMethod': recordingMethod?.value,
        'device': device?.map,
        'dataOrigin': dataOrigin?.map,
        'lastModifiedTimestamp': lastModifiedTimestamp,
      };

  /// General constructor from JSON payload
  ///
  Sample.from(Map<String, dynamic> json, this.harmonized)
      : startTimestamp = parseInt(json['startTimestamp']),
        id = json['id'],
        clientRecordId = json['clientRecordId'],
        clientRecordVersion = tryParseInt(json['clientRecordVersion']),
        startZoneOffsetSeconds = tryParseInt(json['startZoneOffsetSeconds']),
        endZoneOffsetSeconds = tryParseInt(json['endZoneOffsetSeconds']),
        recordingMethod = json['recordingMethod'] == null
            ? null
            : RecordingMethod.from(json['recordingMethod']),
        device = json['device'] == null
            ? null
            : Device.fromJson(parseObject(json['device'])),
        dataOrigin = json['dataOrigin'] == null
            ? null
            : DataOrigin.fromJson(parseObject(json['dataOrigin'])),
        lastModifiedTimestamp = tryParseInt(json['lastModifiedTimestamp']);

  /// Factory method to create the sample its `type` discriminator names.
  /// Throws an [InvalidValueException] for an unknown type,
  /// so no sample is dropped silently.
  ///
  static Sample factory(Map<String, dynamic> json) {
    final type = json['type'];
    final healthType =
        type is String ? HealthType.tryFromIdentifier(type) : null;
    switch (healthType) {
      case HealthType.activeCaloriesBurned:
        return ActiveCaloriesBurned.fromJson(json);
      case HealthType.basalBodyTemperature:
        return BasalBodyTemperature.fromJson(json);
      case HealthType.basalMetabolicRate:
        return BasalMetabolicRate.fromJson(json);
      case HealthType.bloodGlucose:
        return BloodGlucose.fromJson(json);
      case HealthType.bloodPressure:
        return BloodPressure.fromJson(json);
      case HealthType.bodyFat:
        return BodyFat.fromJson(json);
      case HealthType.bodyTemperature:
        return BodyTemperature.fromJson(json);
      case HealthType.bodyWaterMass:
        return BodyWaterMass.fromJson(json);
      case HealthType.boneMass:
        return BoneMass.fromJson(json);
      case HealthType.cervicalMucus:
        return CervicalMucus.fromJson(json);
      case HealthType.cyclingPedalingCadence:
        return CyclingPedalingCadence.fromJson(json);
      case HealthType.distance:
        return Distance.fromJson(json);
      case HealthType.elevationGained:
        return ElevationGained.fromJson(json);
      case HealthType.exerciseSession:
        return ExerciseSession.fromJson(json);
      case HealthType.floorsClimbed:
        return FloorsClimbed.fromJson(json);
      case HealthType.heartRate:
        return HeartRate.fromJson(json);
      case HealthType.heartRateVariabilityRmssd:
        return HeartRateVariabilityRmssd.fromJson(json);
      case HealthType.height:
        return Height.fromJson(json);
      case HealthType.hydration:
        return Hydration.fromJson(json);
      case HealthType.intermenstrualBleeding:
        return IntermenstrualBleeding.fromJson(json);
      case HealthType.leanBodyMass:
        return LeanBodyMass.fromJson(json);
      case HealthType.menstruationFlow:
        return MenstruationFlow.fromJson(json);
      case HealthType.menstruationPeriod:
        return MenstruationPeriod.fromJson(json);
      case HealthType.mindfulnessSession:
        return MindfulnessSession.fromJson(json);
      case HealthType.nutrition:
        return Nutrition.fromJson(json);
      case HealthType.ovulationTest:
        return OvulationTest.fromJson(json);
      case HealthType.oxygenSaturation:
        return OxygenSaturation.fromJson(json);
      case HealthType.plannedExerciseSession:
        return PlannedExerciseSession.fromJson(json);
      case HealthType.power:
        return Power.fromJson(json);
      case HealthType.respiratoryRate:
        return RespiratoryRate.fromJson(json);
      case HealthType.restingHeartRate:
        return RestingHeartRate.fromJson(json);
      case HealthType.sexualActivity:
        return SexualActivity.fromJson(json);
      case HealthType.skinTemperature:
        return SkinTemperature.fromJson(json);
      case HealthType.sleepSession:
        return SleepSession.fromJson(json);
      case HealthType.speed:
        return Speed.fromJson(json);
      case HealthType.steps:
        return Steps.fromJson(json);
      case HealthType.stepsCadence:
        return StepsCadence.fromJson(json);
      case HealthType.totalCaloriesBurned:
        return TotalCaloriesBurned.fromJson(json);
      case HealthType.vo2Max:
        return Vo2Max.fromJson(json);
      case HealthType.weight:
        return Weight.fromJson(json);
      case HealthType.wheelchairPushes:
        return WheelchairPushes.fromJson(json);
      case null:
        throw InvalidValueException('Unknown sample type: $type');
    }
  }

  /// [factory] for a list of samples, given as maps or JSON strings.
  ///
  static List<Sample> collect(List<dynamic> list) =>
      parseObjects(list, factory);
}

/// Equivalent of [WritableSample]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A sample type apps may insert, update and delete;
/// every Health Connect record is writable.
///
abstract class WritableSample<Harmonized extends Payload?>
    extends Sample<Harmonized> {
  const WritableSample({
    required super.startTimestamp,
    required super.harmonized,
    super.id,
    super.clientRecordId,
    super.clientRecordVersion,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.recordingMethod,
    super.device,
    super.dataOrigin,
    super.lastModifiedTimestamp,
  });

  /// General constructor from JSON payload
  ///
  WritableSample.from(super.json, super.harmonized) : super.from();
}
