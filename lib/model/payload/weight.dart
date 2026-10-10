import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Weight]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Weight, in kg.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [Weight.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.weight] permissions provided.
///
class Weight extends WritableSample<WeightHarmonized> {
  const Weight({
    required super.startTimestamp,
    this.endTimestamp,
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

  /// Not used: the record is a single measurement at [startTimestamp]
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.weight;

  /// General constructor from JSON payload
  ///
  Weight.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json, WeightHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Weight> collect(List<dynamic> list) =>
      parseObjects(list, Weight.fromJson);
}

/// Equivalent of [Weight.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Weight.
///
/// Supports [map] representation.
///
/// Has a [WeightHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class WeightHarmonized with Payload {
  const WeightHarmonized({
    required this.weight,
  });

  /// Weight in kg (0–1000)
  final double weight;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'weight': weight,
      };

  /// General constructor from JSON payload
  ///
  WeightHarmonized.fromJson(Map<String, dynamic> json)
      : weight = parseDouble(json['weight']);
}
