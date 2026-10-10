import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [OvulationTestResult]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The result of an ovulation test.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [OvulationTestResult.from] and [OvulationTestResult.tryFrom]
/// creating from the [value].
///
enum OvulationTestResult implements ValueEnum {
  inconclusive('INCONCLUSIVE'),
  positive('POSITIVE'),
  high('HIGH'),
  negative('NEGATIVE');

  const OvulationTestResult(this.value);

  /// The Kotlin constant name, e.g. `INCONCLUSIVE`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory OvulationTestResult.from(String value) => valueOf(values, value);

  /// The [OvulationTestResult.from] exception handling
  ///
  static OvulationTestResult? tryFrom(String value) =>
      tryValueOf(values, value);
}
