import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BodyFat]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Body fat, in percent.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [BodyFat.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bodyFat] permissions provided.
///
class BodyFat extends WritableSample<BodyFatHarmonized> {
  const BodyFat({
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
  HealthType get healthType => HealthType.bodyFat;

  /// General constructor from JSON payload
  ///
  BodyFat.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json, BodyFatHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BodyFat> collect(List<dynamic> list) =>
      parseObjects(list, BodyFat.fromJson);
}

/// Equivalent of [BodyFat.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of BodyFat.
///
/// Supports [map] representation.
///
/// Has a [BodyFatHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BodyFatHarmonized with Payload {
  const BodyFatHarmonized({
    required this.percentage,
  });

  /// Body fat in percent (0–100)
  final double percentage;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'percentage': percentage,
      };

  /// General constructor from JSON payload
  ///
  BodyFatHarmonized.fromJson(Map<String, dynamic> json)
      : percentage = parseDouble(json['percentage']);
}
