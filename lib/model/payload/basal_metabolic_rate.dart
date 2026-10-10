import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BasalMetabolicRate]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Basal metabolic rate, in W.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [BasalMetabolicRate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.basalMetabolicRate] permissions provided.
///
class BasalMetabolicRate extends WritableSample<BasalMetabolicRateHarmonized> {
  const BasalMetabolicRate({
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
  HealthType get healthType => HealthType.basalMetabolicRate;

  /// General constructor from JSON payload
  ///
  BasalMetabolicRate.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            BasalMetabolicRateHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BasalMetabolicRate> collect(List<dynamic> list) =>
      parseObjects(list, BasalMetabolicRate.fromJson);
}

/// Equivalent of [BasalMetabolicRate.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of BasalMetabolicRate.
///
/// Supports [map] representation.
///
/// Has a [BasalMetabolicRateHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BasalMetabolicRateHarmonized with Payload {
  const BasalMetabolicRateHarmonized({
    required this.basalMetabolicRate,
  });

  /// Basal metabolic rate in W (0–484.25)
  final double basalMetabolicRate;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'basalMetabolicRate': basalMetabolicRate,
      };

  /// General constructor from JSON payload
  ///
  BasalMetabolicRateHarmonized.fromJson(Map<String, dynamic> json)
      : basalMetabolicRate = parseDouble(json['basalMetabolicRate']);
}
