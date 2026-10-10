import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Steps]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Steps taken.
///
/// Supports [map] representation.
///
/// Has a [Steps.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.steps] permissions provided.
///
class Steps extends WritableSample<StepsHarmonized> {
  const Steps({
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
  HealthType get healthType => HealthType.steps;

  /// General constructor from JSON payload
  ///
  Steps.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json, StepsHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Steps> collect(List<dynamic> list) =>
      parseObjects(list, Steps.fromJson);
}

/// Equivalent of [Steps.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Steps.
///
/// Supports [map] representation.
///
/// Has a [StepsHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class StepsHarmonized with Payload {
  const StepsHarmonized({
    required this.count,
  });

  /// Number of steps (1–1 000 000)
  final int count;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'count': count,
      };

  /// General constructor from JSON payload
  ///
  StepsHarmonized.fromJson(Map<String, dynamic> json)
      : count = parseInt(json['count']);
}
