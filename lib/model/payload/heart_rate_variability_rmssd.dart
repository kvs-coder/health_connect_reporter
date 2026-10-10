import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [HeartRateVariabilityRmssd]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Heart rate variability (RMSSD), in milliseconds.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [HeartRateVariabilityRmssd.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.heartRateVariabilityRmssd] permissions provided.
///
class HeartRateVariabilityRmssd
    extends WritableSample<HeartRateVariabilityRmssdHarmonized> {
  const HeartRateVariabilityRmssd({
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
  HealthType get healthType => HealthType.heartRateVariabilityRmssd;

  /// General constructor from JSON payload
  ///
  HeartRateVariabilityRmssd.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            HeartRateVariabilityRmssdHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<HeartRateVariabilityRmssd> collect(List<dynamic> list) =>
      parseObjects(list, HeartRateVariabilityRmssd.fromJson);
}

/// Equivalent of [HeartRateVariabilityRmssd.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of HeartRateVariabilityRmssd.
///
/// Supports [map] representation.
///
/// Has a [HeartRateVariabilityRmssdHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HeartRateVariabilityRmssdHarmonized with Payload {
  const HeartRateVariabilityRmssdHarmonized({
    required this.heartRateVariabilityMillis,
  });

  /// Heart rate variability in milliseconds (1–200)
  final double heartRateVariabilityMillis;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'heartRateVariabilityMillis': heartRateVariabilityMillis,
      };

  /// General constructor from JSON payload
  ///
  HeartRateVariabilityRmssdHarmonized.fromJson(Map<String, dynamic> json)
      : heartRateVariabilityMillis =
            parseDouble(json['heartRateVariabilityMillis']);
}
