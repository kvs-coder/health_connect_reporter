import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [ProtectionUsed]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Whether protection was used during sexual activity.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [ProtectionUsed.from] and [ProtectionUsed.tryFrom]
/// creating from the [value].
///
enum ProtectionUsed implements ValueEnum {
  unknown('UNKNOWN'),
  protected('PROTECTED'),
  unprotected('UNPROTECTED');

  const ProtectionUsed(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory ProtectionUsed.from(String value) => valueOf(values, value);

  /// The [ProtectionUsed.from] exception handling
  ///
  static ProtectionUsed? tryFrom(String value) => tryValueOf(values, value);
}
