import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [StepsCadence]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Steps cadence over an interval, in steps per minute.
///
/// Supports [map] representation.
///
/// Has a [StepsCadence.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.stepsCadence] permissions provided.
///
class StepsCadence extends WritableSample<StepsCadenceHarmonized> {
  const StepsCadence({
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
  HealthType get healthType => HealthType.stepsCadence;

  /// General constructor from JSON payload
  ///
  StepsCadence.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            StepsCadenceHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<StepsCadence> collect(List<dynamic> list) =>
      parseObjects(list, StepsCadence.fromJson);
}

/// Equivalent of [StepsCadence.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of StepsCadence.
///
/// Supports [map] representation.
///
/// Has a [StepsCadenceHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class StepsCadenceHarmonized with Payload {
  const StepsCadenceHarmonized({
    required this.series,
  });

  /// The measurements, inside the sample's interval
  final List<StepsCadenceSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  StepsCadenceHarmonized.fromJson(Map<String, dynamic> json)
      : series = parseObjects(json['series'], StepsCadenceSeries.fromJson);
}

/// Equivalent of [StepsCadence.Series]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One measurement.
///
/// Supports [map] representation.
///
/// Has a [StepsCadenceSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class StepsCadenceSeries with Payload {
  const StepsCadenceSeries({
    required this.timestamp,
    required this.rate,
  });

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// Steps cadence in steps per minute (0–10 000)
  final double rate;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'rate': rate,
      };

  /// General constructor from JSON payload
  ///
  StepsCadenceSeries.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        rate = parseDouble(json['rate']);
}
