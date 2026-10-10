import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [OxygenSaturation]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Blood oxygen saturation (SpO2), in percent.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [OxygenSaturation.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.oxygenSaturation] permissions provided.
///
class OxygenSaturation extends WritableSample<OxygenSaturationHarmonized> {
  const OxygenSaturation({
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
  HealthType get healthType => HealthType.oxygenSaturation;

  /// General constructor from JSON payload
  ///
  OxygenSaturation.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            OxygenSaturationHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<OxygenSaturation> collect(List<dynamic> list) =>
      parseObjects(list, OxygenSaturation.fromJson);
}

/// Equivalent of [OxygenSaturation.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of OxygenSaturation.
///
/// Supports [map] representation.
///
/// Has a [OxygenSaturationHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class OxygenSaturationHarmonized with Payload {
  const OxygenSaturationHarmonized({
    required this.percentage,
  });

  /// Oxygen saturation in percent (0–100)
  final double percentage;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'percentage': percentage,
      };

  /// General constructor from JSON payload
  ///
  OxygenSaturationHarmonized.fromJson(Map<String, dynamic> json)
      : percentage = parseDouble(json['percentage']);
}
