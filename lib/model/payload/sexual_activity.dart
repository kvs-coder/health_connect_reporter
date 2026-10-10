import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/protection_used.dart';
import 'sample.dart';

/// Equivalent of [SexualActivity]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// An occurrence of sexual activity.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [SexualActivity.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.sexualActivity] permissions provided.
///
class SexualActivity extends WritableSample<SexualActivityHarmonized> {
  const SexualActivity({
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
  HealthType get healthType => HealthType.sexualActivity;

  /// General constructor from JSON payload
  ///
  SexualActivity.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            SexualActivityHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<SexualActivity> collect(List<dynamic> list) =>
      parseObjects(list, SexualActivity.fromJson);
}

/// Equivalent of [SexualActivity.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of SexualActivity.
///
/// Supports [map] representation.
///
/// Has a [SexualActivityHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SexualActivityHarmonized with Payload {
  const SexualActivityHarmonized({
    this.protectionUsed = ProtectionUsed.unknown,
  });

  /// Whether protection was used. [ProtectionUsed.unknown] by default
  final ProtectionUsed protectionUsed;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'protectionUsed': protectionUsed.value,
      };

  /// General constructor from JSON payload
  ///
  SexualActivityHarmonized.fromJson(Map<String, dynamic> json)
      : protectionUsed = json['protectionUsed'] == null
            ? ProtectionUsed.unknown
            : ProtectionUsed.from(json['protectionUsed']);
}
