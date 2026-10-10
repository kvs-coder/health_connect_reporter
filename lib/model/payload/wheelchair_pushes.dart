import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [WheelchairPushes]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Wheelchair pushes.
///
/// Supports [map] representation.
///
/// Has a [WheelchairPushes.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.wheelchairPushes] permissions provided.
///
class WheelchairPushes extends WritableSample<WheelchairPushesHarmonized> {
  const WheelchairPushes({
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
  HealthType get healthType => HealthType.wheelchairPushes;

  /// General constructor from JSON payload
  ///
  WheelchairPushes.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            WheelchairPushesHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<WheelchairPushes> collect(List<dynamic> list) =>
      parseObjects(list, WheelchairPushes.fromJson);
}

/// Equivalent of [WheelchairPushes.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of WheelchairPushes.
///
/// Supports [map] representation.
///
/// Has a [WheelchairPushesHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class WheelchairPushesHarmonized with Payload {
  const WheelchairPushesHarmonized({
    required this.count,
  });

  /// Number of pushes (1–1 000 000)
  final int count;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'count': count,
      };

  /// General constructor from JSON payload
  ///
  WheelchairPushesHarmonized.fromJson(Map<String, dynamic> json)
      : count = parseInt(json['count']);
}
