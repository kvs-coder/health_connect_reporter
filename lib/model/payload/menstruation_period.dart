import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [MenstruationPeriod]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A menstruation period.
///
/// Supports [map] representation.
///
/// Has a [MenstruationPeriod.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.menstruationPeriod] permissions provided.
///
class MenstruationPeriod extends WritableSample<Null> {
  const MenstruationPeriod({
    required super.startTimestamp,
    required this.endTimestamp,
    super.id,
    super.clientRecordId,
    super.clientRecordVersion,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.recordingMethod,
    super.device,
    super.dataOrigin,
    super.lastModifiedTimestamp,
  }) : super(harmonized: null);

  /// End time, epoch milliseconds, not before [startTimestamp]
  @override
  final int endTimestamp;

  @override
  HealthType get healthType => HealthType.menstruationPeriod;

  /// General constructor from JSON payload
  ///
  MenstruationPeriod.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json, null);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<MenstruationPeriod> collect(List<dynamic> list) =>
      parseObjects(list, MenstruationPeriod.fromJson);
}
