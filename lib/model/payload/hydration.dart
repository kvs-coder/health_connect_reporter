import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Hydration]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Water intake, in L.
///
/// Supports [map] representation.
///
/// Has a [Hydration.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.hydration] permissions provided.
///
class Hydration extends WritableSample<HydrationHarmonized> {
  const Hydration({
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
  HealthType get healthType => HealthType.hydration;

  /// General constructor from JSON payload
  ///
  Hydration.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            HydrationHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Hydration> collect(List<dynamic> list) =>
      parseObjects(list, Hydration.fromJson);
}

/// Equivalent of [Hydration.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Hydration.
///
/// Supports [map] representation.
///
/// Has a [HydrationHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HydrationHarmonized with Payload {
  const HydrationHarmonized({
    required this.volume,
  });

  /// Water intake in L (0–100)
  final double volume;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'volume': volume,
      };

  /// General constructor from JSON payload
  ///
  HydrationHarmonized.fromJson(Map<String, dynamic> json)
      : volume = parseDouble(json['volume']);
}
