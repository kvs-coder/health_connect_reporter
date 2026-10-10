import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [BoneMass]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Bone mass, in kg.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [BoneMass.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.boneMass] permissions provided.
///
class BoneMass extends WritableSample<BoneMassHarmonized> {
  const BoneMass({
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
  HealthType get healthType => HealthType.boneMass;

  /// General constructor from JSON payload
  ///
  BoneMass.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json, BoneMassHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BoneMass> collect(List<dynamic> list) =>
      parseObjects(list, BoneMass.fromJson);
}

/// Equivalent of [BoneMass.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of BoneMass.
///
/// Supports [map] representation.
///
/// Has a [BoneMassHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BoneMassHarmonized with Payload {
  const BoneMassHarmonized({
    required this.mass,
  });

  /// Bone mass in kg (0–1000)
  final double mass;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'mass': mass,
      };

  /// General constructor from JSON payload
  ///
  BoneMassHarmonized.fromJson(Map<String, dynamic> json)
      : mass = parseDouble(json['mass']);
}
