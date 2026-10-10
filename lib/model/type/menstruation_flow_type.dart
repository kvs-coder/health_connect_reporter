import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [MenstruationFlowType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The menstrual flow.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [MenstruationFlowType.from] and [MenstruationFlowType.tryFrom]
/// creating from the [value].
///
enum MenstruationFlowType implements ValueEnum {
  unknown('UNKNOWN'),
  light('LIGHT'),
  medium('MEDIUM'),
  heavy('HEAVY');

  const MenstruationFlowType(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory MenstruationFlowType.from(String value) => valueOf(values, value);

  /// The [MenstruationFlowType.from] exception handling
  ///
  static MenstruationFlowType? tryFrom(String value) =>
      tryValueOf(values, value);
}
