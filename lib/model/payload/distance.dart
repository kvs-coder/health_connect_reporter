import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Distance]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Distance moved, in m.
///
/// Supports [map] representation.
///
/// Has a [Distance.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.distance] permissions provided.
///
class Distance extends WritableSample<DistanceHarmonized> {
  const Distance({
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
  HealthType get healthType => HealthType.distance;

  /// General constructor from JSON payload
  ///
  Distance.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json, DistanceHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Distance> collect(List<dynamic> list) =>
      parseObjects(list, Distance.fromJson);
}

/// Equivalent of [Distance.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Distance.
///
/// Supports [map] representation.
///
/// Has a [DistanceHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class DistanceHarmonized with Payload {
  const DistanceHarmonized({
    required this.distance,
  });

  /// Distance in m (0–1 000 000)
  final double distance;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'distance': distance,
      };

  /// General constructor from JSON payload
  ///
  DistanceHarmonized.fromJson(Map<String, dynamic> json)
      : distance = parseDouble(json['distance']);
}
