import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [FloorsClimbed]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Floors climbed.
///
/// Supports [map] representation.
///
/// Has a [FloorsClimbed.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.floorsClimbed] permissions provided.
///
class FloorsClimbed extends WritableSample<FloorsClimbedHarmonized> {
  const FloorsClimbed({
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
  HealthType get healthType => HealthType.floorsClimbed;

  /// General constructor from JSON payload
  ///
  FloorsClimbed.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            FloorsClimbedHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<FloorsClimbed> collect(List<dynamic> list) =>
      parseObjects(list, FloorsClimbed.fromJson);
}

/// Equivalent of [FloorsClimbed.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of FloorsClimbed.
///
/// Supports [map] representation.
///
/// Has a [FloorsClimbedHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class FloorsClimbedHarmonized with Payload {
  const FloorsClimbedHarmonized({
    required this.floors,
  });

  /// Number of floors (0–1 000 000)
  final double floors;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'floors': floors,
      };

  /// General constructor from JSON payload
  ///
  FloorsClimbedHarmonized.fromJson(Map<String, dynamic> json)
      : floors = parseDouble(json['floors']);
}
