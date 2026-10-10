import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [RecordingMethod]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// How a record was recorded.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [RecordingMethod.from] and [RecordingMethod.tryFrom]
/// creating from the [value].
///
enum RecordingMethod implements ValueEnum {
  unknown('UNKNOWN'),
  activelyRecorded('ACTIVELY_RECORDED'),
  automaticallyRecorded('AUTOMATICALLY_RECORDED'),
  manualEntry('MANUAL_ENTRY');

  const RecordingMethod(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory RecordingMethod.from(String value) => valueOf(values, value);

  /// The [RecordingMethod.from] exception handling
  ///
  static RecordingMethod? tryFrom(String value) => tryValueOf(values, value);
}
