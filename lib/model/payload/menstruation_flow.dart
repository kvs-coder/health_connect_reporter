import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/menstruation_flow_type.dart';
import 'sample.dart';

/// Equivalent of [MenstruationFlow]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A menstrual flow observation.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [MenstruationFlow.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.menstruationFlow] permissions provided.
///
class MenstruationFlow extends WritableSample<MenstruationFlowHarmonized> {
  const MenstruationFlow({
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
  HealthType get healthType => HealthType.menstruationFlow;

  /// General constructor from JSON payload
  ///
  MenstruationFlow.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            MenstruationFlowHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<MenstruationFlow> collect(List<dynamic> list) =>
      parseObjects(list, MenstruationFlow.fromJson);
}

/// Equivalent of [MenstruationFlow.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of MenstruationFlow.
///
/// Supports [map] representation.
///
/// Has a [MenstruationFlowHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class MenstruationFlowHarmonized with Payload {
  const MenstruationFlowHarmonized({
    this.flow = MenstruationFlowType.unknown,
  });

  /// The menstrual flow. [MenstruationFlowType.unknown] by default
  final MenstruationFlowType flow;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'flow': flow.value,
      };

  /// General constructor from JSON payload
  ///
  MenstruationFlowHarmonized.fromJson(Map<String, dynamic> json)
      : flow = json['flow'] == null
            ? MenstruationFlowType.unknown
            : MenstruationFlowType.from(json['flow']);
}
