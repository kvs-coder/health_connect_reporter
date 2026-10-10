import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [HeartRate]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Heart rate over an interval, in beats per minute.
///
/// Supports [map] representation.
///
/// Has a [HeartRate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.heartRate] permissions provided.
///
class HeartRate extends WritableSample<HeartRateHarmonized> {
  const HeartRate({
    required super.startTimestamp,
    required this.endTimestamp,
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

  /// End time, epoch milliseconds, not before [startTimestamp]
  @override
  final int endTimestamp;

  @override
  HealthType get healthType => HealthType.heartRate;

  /// General constructor from JSON payload
  ///
  HeartRate.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            HeartRateHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<HeartRate> collect(List<dynamic> list) =>
      parseObjects(list, HeartRate.fromJson);
}

/// Equivalent of [HeartRate.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of HeartRate.
///
/// Supports [map] representation.
///
/// Has a [HeartRateHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HeartRateHarmonized with Payload {
  const HeartRateHarmonized({
    required this.series,
  });

  /// The measurements, inside the sample's interval
  final List<HeartRateSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  HeartRateHarmonized.fromJson(Map<String, dynamic> json)
      : series = parseObjects(json['series'], HeartRateSeries.fromJson);
}

/// Equivalent of [HeartRate.Series]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One measurement.
///
/// Supports [map] representation.
///
/// Has a [HeartRateSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HeartRateSeries with Payload {
  const HeartRateSeries({
    required this.timestamp,
    required this.beatsPerMinute,
  });

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// Heart rate in beats per minute (1–300)
  final int beatsPerMinute;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'beatsPerMinute': beatsPerMinute,
      };

  /// General constructor from JSON payload
  ///
  HeartRateSeries.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        beatsPerMinute = parseInt(json['beatsPerMinute']);
}
