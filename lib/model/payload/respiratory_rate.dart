import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [RespiratoryRate]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Respiratory rate, in breaths per minute.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [RespiratoryRate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.respiratoryRate] permissions provided.
///
class RespiratoryRate extends WritableSample<RespiratoryRateHarmonized> {
  const RespiratoryRate({
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
  HealthType get healthType => HealthType.respiratoryRate;

  /// General constructor from JSON payload
  ///
  RespiratoryRate.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            RespiratoryRateHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<RespiratoryRate> collect(List<dynamic> list) =>
      parseObjects(list, RespiratoryRate.fromJson);
}

/// Equivalent of [RespiratoryRate.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of RespiratoryRate.
///
/// Supports [map] representation.
///
/// Has a [RespiratoryRateHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class RespiratoryRateHarmonized with Payload {
  const RespiratoryRateHarmonized({
    required this.rate,
  });

  /// Respiratory rate in breaths per minute (0–1000)
  final double rate;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'rate': rate,
      };

  /// General constructor from JSON payload
  ///
  RespiratoryRateHarmonized.fromJson(Map<String, dynamic> json)
      : rate = parseDouble(json['rate']);
}
