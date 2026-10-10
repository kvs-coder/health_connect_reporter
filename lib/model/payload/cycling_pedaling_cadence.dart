import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [CyclingPedalingCadence]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Cycling pedaling cadence over an interval, in revolutions per minute.
///
/// Supports [map] representation.
///
/// Has a [CyclingPedalingCadence.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.cyclingPedalingCadence] permissions provided.
///
class CyclingPedalingCadence
    extends WritableSample<CyclingPedalingCadenceHarmonized> {
  const CyclingPedalingCadence({
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
  HealthType get healthType => HealthType.cyclingPedalingCadence;

  /// General constructor from JSON payload
  ///
  CyclingPedalingCadence.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            CyclingPedalingCadenceHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<CyclingPedalingCadence> collect(List<dynamic> list) =>
      parseObjects(list, CyclingPedalingCadence.fromJson);
}

/// Equivalent of [CyclingPedalingCadence.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of CyclingPedalingCadence.
///
/// Supports [map] representation.
///
/// Has a [CyclingPedalingCadenceHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CyclingPedalingCadenceHarmonized with Payload {
  const CyclingPedalingCadenceHarmonized({
    required this.series,
  });

  /// The measurements, inside the sample's interval
  final List<CyclingPedalingCadenceSeries> series;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'series': series.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  CyclingPedalingCadenceHarmonized.fromJson(Map<String, dynamic> json)
      : series =
            parseObjects(json['series'], CyclingPedalingCadenceSeries.fromJson);
}

/// Equivalent of [CyclingPedalingCadence.Series]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One measurement.
///
/// Supports [map] representation.
///
/// Has a [CyclingPedalingCadenceSeries.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CyclingPedalingCadenceSeries with Payload {
  const CyclingPedalingCadenceSeries({
    required this.timestamp,
    required this.revolutionsPerMinute,
  });

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// Pedaling cadence in revolutions per minute (0–10 000)
  final double revolutionsPerMinute;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'revolutionsPerMinute': revolutionsPerMinute,
      };

  /// General constructor from JSON payload
  ///
  CyclingPedalingCadenceSeries.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        revolutionsPerMinute = parseDouble(json['revolutionsPerMinute']);
}
