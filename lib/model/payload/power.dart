import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Power]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Power over an interval, in W.
///
/// Supports [map] representation.
///
/// Has a [Power.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.power] permissions provided.
///
class Power extends WritableSample<PowerHarmonized> {
  const Power({
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
  HealthType get healthType => HealthType.power;

  /// General constructor from JSON payload
  ///
  Power.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json, PowerHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Power> collect(List<dynamic> list) =>
      parseObjects(list, Power.fromJson);
}

/// Equivalent of [Power.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Power.
///
/// Supports [map] representation.
///
/// Has a [PowerHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PowerHarmonized with Payload {
  const PowerHarmonized({
    required this.series,
  });

  /// The measurements, inside the sample's interval
  final List<PowerSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  PowerHarmonized.fromJson(Map<String, dynamic> json)
      : series = parseObjects(json['series'], PowerSeries.fromJson);
}

/// Equivalent of [Power.Series]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One measurement.
///
/// Supports [map] representation.
///
/// Has a [PowerSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PowerSeries with Payload {
  const PowerSeries({
    required this.timestamp,
    required this.power,
  });

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// Power in W (0–100 000)
  final double power;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'power': power,
      };

  /// General constructor from JSON payload
  ///
  PowerSeries.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        power = parseDouble(json['power']);
}
