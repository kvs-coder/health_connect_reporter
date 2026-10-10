import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Speed]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Speed over an interval, in m/s.
///
/// Supports [map] representation.
///
/// Has a [Speed.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.speed] permissions provided.
///
class Speed extends WritableSample<SpeedHarmonized> {
  const Speed({
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
  HealthType get healthType => HealthType.speed;

  /// General constructor from JSON payload
  ///
  Speed.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json, SpeedHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Speed> collect(List<dynamic> list) =>
      parseObjects(list, Speed.fromJson);
}

/// Equivalent of [Speed.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Speed.
///
/// Supports [map] representation.
///
/// Has a [SpeedHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SpeedHarmonized with Payload {
  const SpeedHarmonized({
    required this.series,
  });

  /// The measurements, inside the sample's interval
  final List<SpeedSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  SpeedHarmonized.fromJson(Map<String, dynamic> json)
      : series = parseObjects(json['series'], SpeedSeries.fromJson);
}

/// Equivalent of [Speed.Series]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One measurement.
///
/// Supports [map] representation.
///
/// Has a [SpeedSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SpeedSeries with Payload {
  const SpeedSeries({
    required this.timestamp,
    required this.speed,
  });

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// Speed in m/s (0–1 000 000)
  final double speed;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'speed': speed,
      };

  /// General constructor from JSON payload
  ///
  SpeedSeries.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        speed = parseDouble(json['speed']);
}
