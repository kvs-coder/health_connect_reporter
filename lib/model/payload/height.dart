import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [Height]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Height, in m.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [Height.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.height] permissions provided.
///
class Height extends WritableSample<HeightHarmonized> {
  const Height({
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
  HealthType get healthType => HealthType.height;

  /// General constructor from JSON payload
  ///
  Height.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json, HeightHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Height> collect(List<dynamic> list) =>
      parseObjects(list, Height.fromJson);
}

/// Equivalent of [Height.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Height.
///
/// Supports [map] representation.
///
/// Has a [HeightHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class HeightHarmonized with Payload {
  const HeightHarmonized({
    required this.height,
  });

  /// Height in m (0–3)
  final double height;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'height': height,
      };

  /// General constructor from JSON payload
  ///
  HeightHarmonized.fromJson(Map<String, dynamic> json)
      : height = parseDouble(json['height']);
}
