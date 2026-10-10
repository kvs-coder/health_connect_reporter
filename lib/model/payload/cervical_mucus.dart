import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/cervical_mucus_appearance.dart';
import '../type/cervical_mucus_sensation.dart';
import 'sample.dart';

/// Equivalent of [CervicalMucus]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A cervical mucus observation.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [CervicalMucus.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.cervicalMucus] permissions provided.
///
class CervicalMucus extends WritableSample<CervicalMucusHarmonized> {
  const CervicalMucus({
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
  HealthType get healthType => HealthType.cervicalMucus;

  /// General constructor from JSON payload
  ///
  CervicalMucus.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            CervicalMucusHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<CervicalMucus> collect(List<dynamic> list) =>
      parseObjects(list, CervicalMucus.fromJson);
}

/// Equivalent of [CervicalMucus.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of CervicalMucus.
///
/// Supports [map] representation.
///
/// Has a [CervicalMucusHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CervicalMucusHarmonized with Payload {
  const CervicalMucusHarmonized({
    this.appearance = CervicalMucusAppearance.unknown,
    this.sensation = CervicalMucusSensation.unknown,
  });

  /// The consistency of the mucus. [CervicalMucusAppearance.unknown] by default
  final CervicalMucusAppearance appearance;

  /// The sensation of the mucus. [CervicalMucusSensation.unknown] by default
  final CervicalMucusSensation sensation;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'appearance': appearance.value,
        'sensation': sensation.value,
      };

  /// General constructor from JSON payload
  ///
  CervicalMucusHarmonized.fromJson(Map<String, dynamic> json)
      : appearance = json['appearance'] == null
            ? CervicalMucusAppearance.unknown
            : CervicalMucusAppearance.from(json['appearance']),
        sensation = json['sensation'] == null
            ? CervicalMucusSensation.unknown
            : CervicalMucusSensation.from(json['sensation']);
}
