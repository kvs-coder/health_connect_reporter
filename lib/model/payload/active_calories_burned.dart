import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [ActiveCaloriesBurned]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Calories burned by activity, in kcal.
///
/// Supports [map] representation.
///
/// Has a [ActiveCaloriesBurned.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.activeCaloriesBurned] permissions provided.
///
class ActiveCaloriesBurned
    extends WritableSample<ActiveCaloriesBurnedHarmonized> {
  const ActiveCaloriesBurned({
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
  HealthType get healthType => HealthType.activeCaloriesBurned;

  /// General constructor from JSON payload
  ///
  ActiveCaloriesBurned.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            ActiveCaloriesBurnedHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<ActiveCaloriesBurned> collect(List<dynamic> list) =>
      parseObjects(list, ActiveCaloriesBurned.fromJson);
}

/// Equivalent of [ActiveCaloriesBurned.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of ActiveCaloriesBurned.
///
/// Supports [map] representation.
///
/// Has a [ActiveCaloriesBurnedHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ActiveCaloriesBurnedHarmonized with Payload {
  const ActiveCaloriesBurnedHarmonized({
    required this.energy,
  });

  /// Active calories burned in kcal (0–1 000 000)
  final double energy;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'energy': energy,
      };

  /// General constructor from JSON payload
  ///
  ActiveCaloriesBurnedHarmonized.fromJson(Map<String, dynamic> json)
      : energy = parseDouble(json['energy']);
}
