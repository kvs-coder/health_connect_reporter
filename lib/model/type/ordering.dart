import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [Ordering]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Ordering of read results by start time.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [Ordering.from] and [Ordering.tryFrom]
/// creating from the [value].
///
enum Ordering implements ValueEnum {
  /// oldest first
  ascending('ASCENDING'),

  /// newest first
  descending('DESCENDING');

  const Ordering(this.value);

  /// The Kotlin constant name, e.g. `ASCENDING`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory Ordering.from(String value) => valueOf(values, value);

  /// The [Ordering.from] exception handling
  ///
  static Ordering? tryFrom(String value) => tryValueOf(values, value);
}
