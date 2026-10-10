import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [RestingHeartRate]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Resting heart rate, in beats per minute.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [RestingHeartRate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.restingHeartRate] permissions provided.
///
class RestingHeartRate extends WritableSample<RestingHeartRateHarmonized> {
  const RestingHeartRate({
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
  HealthType get healthType => HealthType.restingHeartRate;

  /// General constructor from JSON payload
  ///
  RestingHeartRate.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            RestingHeartRateHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<RestingHeartRate> collect(List<dynamic> list) =>
      parseObjects(list, RestingHeartRate.fromJson);
}

/// Equivalent of [RestingHeartRate.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of RestingHeartRate.
///
/// Supports [map] representation.
///
/// Has a [RestingHeartRateHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class RestingHeartRateHarmonized with Payload {
  const RestingHeartRateHarmonized({
    required this.beatsPerMinute,
  });

  /// Resting heart rate in beats per minute (0–300)
  final int beatsPerMinute;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'beatsPerMinute': beatsPerMinute,
      };

  /// General constructor from JSON payload
  ///
  RestingHeartRateHarmonized.fromJson(Map<String, dynamic> json)
      : beatsPerMinute = parseInt(json['beatsPerMinute']);
}
