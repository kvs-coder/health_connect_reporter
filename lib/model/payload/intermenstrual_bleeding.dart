import '../decorator/extensions.dart';
import '../type/health_type.dart';
import 'sample.dart';

/// Equivalent of [IntermenstrualBleeding]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// An occurrence of intermenstrual bleeding (spotting).
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [IntermenstrualBleeding.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.intermenstrualBleeding] permissions provided.
///
class IntermenstrualBleeding extends WritableSample<Null> {
  const IntermenstrualBleeding({
    required super.startTimestamp,
    this.endTimestamp,
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

  /// Not used: the record is a single measurement at [startTimestamp]
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.intermenstrualBleeding;

  /// General constructor from JSON payload
  ///
  IntermenstrualBleeding.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json, null);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<IntermenstrualBleeding> collect(List<dynamic> list) =>
      parseObjects(list, IntermenstrualBleeding.fromJson);
}
