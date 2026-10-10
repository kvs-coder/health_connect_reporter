import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/vo2_max_measurement_method.dart';
import 'sample.dart';

/// Equivalent of [Vo2Max]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Maximal oxygen uptake (VO2 max), in mL/(min·kg).
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [Vo2Max.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.vo2Max] permissions provided.
///
class Vo2Max extends WritableSample<Vo2MaxHarmonized> {
  const Vo2Max({
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
  HealthType get healthType => HealthType.vo2Max;

  /// General constructor from JSON payload
  ///
  Vo2Max.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json, Vo2MaxHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Vo2Max> collect(List<dynamic> list) =>
      parseObjects(list, Vo2Max.fromJson);
}

/// Equivalent of [Vo2Max.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Vo2Max.
///
/// Supports [map] representation.
///
/// Has a [Vo2MaxHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class Vo2MaxHarmonized with Payload {
  const Vo2MaxHarmonized({
    required this.vo2MillilitersPerMinuteKilogram,
    this.measurementMethod = Vo2MaxMeasurementMethod.other,
  });

  /// VO2 max in mL/(min·kg) (0–100)
  final double vo2MillilitersPerMinuteKilogram;

  /// How VO2 max was measured. [Vo2MaxMeasurementMethod.other] by default
  final Vo2MaxMeasurementMethod measurementMethod;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'vo2MillilitersPerMinuteKilogram': vo2MillilitersPerMinuteKilogram,
        'measurementMethod': measurementMethod.value,
      };

  /// General constructor from JSON payload
  ///
  Vo2MaxHarmonized.fromJson(Map<String, dynamic> json)
      : vo2MillilitersPerMinuteKilogram =
            parseDouble(json['vo2MillilitersPerMinuteKilogram']),
        measurementMethod = json['measurementMethod'] == null
            ? Vo2MaxMeasurementMethod.other
            : Vo2MaxMeasurementMethod.from(json['measurementMethod']);
}
