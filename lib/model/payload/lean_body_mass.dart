import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [LeanBodyMass]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Lean body mass, in kg.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [LeanBodyMass.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.leanBodyMass] permissions provided.
///
class LeanBodyMass extends WritableSample<LeanBodyMassHarmonized> {
  const LeanBodyMass({
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
  HealthType get healthType => HealthType.leanBodyMass;

  /// General constructor from JSON payload
  ///
  LeanBodyMass.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            LeanBodyMassHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<LeanBodyMass> collect(List<dynamic> list) =>
      parseObjects(list, LeanBodyMass.fromJson);
}

/// Equivalent of [LeanBodyMass.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of LeanBodyMass.
///
/// Supports [map] representation.
///
/// Has a [LeanBodyMassHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class LeanBodyMassHarmonized with Payload {
  const LeanBodyMassHarmonized({
    required this.mass,
  });

  /// Lean body mass in kg (0–1000)
  final double mass;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'mass': mass,
      };

  /// General constructor from JSON payload
  ///
  LeanBodyMassHarmonized.fromJson(Map<String, dynamic> json)
      : mass = parseDouble(json['mass']);
}
