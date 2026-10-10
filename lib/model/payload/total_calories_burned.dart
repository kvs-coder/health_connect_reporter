import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [TotalCaloriesBurned]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Total calories burned (active and basal), in kcal.
///
/// Supports [map] representation.
///
/// Has a [TotalCaloriesBurned.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.totalCaloriesBurned] permissions provided.
///
class TotalCaloriesBurned
    extends WritableSample<TotalCaloriesBurnedHarmonized> {
  const TotalCaloriesBurned({
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
  HealthType get healthType => HealthType.totalCaloriesBurned;

  /// General constructor from JSON payload
  ///
  TotalCaloriesBurned.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            TotalCaloriesBurnedHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<TotalCaloriesBurned> collect(List<dynamic> list) =>
      parseObjects(list, TotalCaloriesBurned.fromJson);
}

/// Equivalent of [TotalCaloriesBurned.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of TotalCaloriesBurned.
///
/// Supports [map] representation.
///
/// Has a [TotalCaloriesBurnedHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class TotalCaloriesBurnedHarmonized with Payload {
  const TotalCaloriesBurnedHarmonized({
    required this.energy,
  });

  /// Total calories burned in kcal (0–1 000 000)
  final double energy;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'energy': energy,
      };

  /// General constructor from JSON payload
  ///
  TotalCaloriesBurnedHarmonized.fromJson(Map<String, dynamic> json)
      : energy = parseDouble(json['energy']);
}
