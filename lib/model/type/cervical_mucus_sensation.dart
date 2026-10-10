import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [CervicalMucusSensation]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The sensation of cervical mucus.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [CervicalMucusSensation.from] and [CervicalMucusSensation.tryFrom]
/// creating from the [value].
///
enum CervicalMucusSensation implements ValueEnum {
  unknown('UNKNOWN'),
  light('LIGHT'),
  medium('MEDIUM'),
  heavy('HEAVY');

  const CervicalMucusSensation(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory CervicalMucusSensation.from(String value) => valueOf(values, value);

  /// The [CervicalMucusSensation.from] exception handling
  ///
  static CervicalMucusSensation? tryFrom(String value) =>
      tryValueOf(values, value);
}
