import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/blood_pressure_measurement_location.dart';
import '../type/body_position.dart';
import 'sample.dart';

/// Equivalent of [BloodPressure]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A blood pressure measurement, in mmHg.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [BloodPressure.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bloodPressure] permissions provided.
///
class BloodPressure extends WritableSample<BloodPressureHarmonized> {
  const BloodPressure({
    required super.startTimestamp,
    this.endTimestamp,
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

  /// Not used: the record is a single measurement at [startTimestamp]
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.bloodPressure;

  /// General constructor from JSON payload
  ///
  BloodPressure.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            BloodPressureHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BloodPressure> collect(List<dynamic> list) =>
      parseObjects(list, BloodPressure.fromJson);
}

/// Equivalent of [BloodPressure.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of BloodPressure.
///
/// Supports [map] representation.
///
/// Has a [BloodPressureHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodPressureHarmonized with Payload {
  const BloodPressureHarmonized({
    required this.systolic,
    required this.diastolic,
    this.bodyPosition = BodyPosition.unknown,
    this.measurementLocation = BloodPressureMeasurementLocation.unknown,
  });

  /// Systolic pressure in mmHg (20–200)
  final double systolic;

  /// Diastolic pressure in mmHg (10–180)
  final double diastolic;

  /// The body position during the measurement. [BodyPosition.unknown] by
  /// default
  final BodyPosition bodyPosition;

  /// The arm and part of the arm measured.
  /// [BloodPressureMeasurementLocation.unknown] by default
  final BloodPressureMeasurementLocation measurementLocation;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'systolic': systolic,
        'diastolic': diastolic,
        'bodyPosition': bodyPosition.value,
        'measurementLocation': measurementLocation.value,
      };

  /// General constructor from JSON payload
  ///
  BloodPressureHarmonized.fromJson(Map<String, dynamic> json)
      : systolic = parseDouble(json['systolic']),
        diastolic = parseDouble(json['diastolic']),
        bodyPosition = json['bodyPosition'] == null
            ? BodyPosition.unknown
            : BodyPosition.from(json['bodyPosition']),
        measurementLocation = json['measurementLocation'] == null
            ? BloodPressureMeasurementLocation.unknown
            : BloodPressureMeasurementLocation.from(
                json['measurementLocation']);
}
