import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [ElevationGained]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Elevation gained, in m.
///
/// Supports [map] representation.
///
/// Has a [ElevationGained.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.elevationGained] permissions provided.
///
class ElevationGained extends WritableSample<ElevationGainedHarmonized> {
  const ElevationGained({
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
  HealthType get healthType => HealthType.elevationGained;

  /// General constructor from JSON payload
  ///
  ElevationGained.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            ElevationGainedHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<ElevationGained> collect(List<dynamic> list) =>
      parseObjects(list, ElevationGained.fromJson);
}

/// Equivalent of [ElevationGained.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of ElevationGained.
///
/// Supports [map] representation.
///
/// Has a [ElevationGainedHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ElevationGainedHarmonized with Payload {
  const ElevationGainedHarmonized({
    required this.elevation,
  });

  /// Elevation gained in m (-1 000 000–1 000 000)
  final double elevation;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'elevation': elevation,
      };

  /// General constructor from JSON payload
  ///
  ElevationGainedHarmonized.fromJson(Map<String, dynamic> json)
      : elevation = parseDouble(json['elevation']);
}
