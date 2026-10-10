import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/ovulation_test_result.dart';
import 'sample.dart';

/// Equivalent of [OvulationTest]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// An ovulation test result.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [OvulationTest.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.ovulationTest] permissions provided.
///
class OvulationTest extends WritableSample<OvulationTestHarmonized> {
  const OvulationTest({
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
  HealthType get healthType => HealthType.ovulationTest;

  /// General constructor from JSON payload
  ///
  OvulationTest.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            OvulationTestHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<OvulationTest> collect(List<dynamic> list) =>
      parseObjects(list, OvulationTest.fromJson);
}

/// Equivalent of [OvulationTest.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of OvulationTest.
///
/// Supports [map] representation.
///
/// Has a [OvulationTestHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class OvulationTestHarmonized with Payload {
  const OvulationTestHarmonized({
    required this.result,
  });

  /// The test result
  final OvulationTestResult result;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'result': result.value,
      };

  /// General constructor from JSON payload
  ///
  OvulationTestHarmonized.fromJson(Map<String, dynamic> json)
      : result = OvulationTestResult.from(json['result']);
}
