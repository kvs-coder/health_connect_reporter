import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [TimeGroupUnit]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The calendar unit aggregate results are grouped by, in local time.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [TimeGroupUnit.from] and [TimeGroupUnit.tryFrom]
/// creating from the [value].
///
enum TimeGroupUnit implements ValueEnum {
  daily('DAILY'),
  weekly('WEEKLY'),
  monthly('MONTHLY'),
  yearly('YEARLY');

  const TimeGroupUnit(this.value);

  /// The Kotlin constant name, e.g. `DAILY`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory TimeGroupUnit.from(String value) => valueOf(values, value);

  /// The [TimeGroupUnit.from] exception handling
  ///
  static TimeGroupUnit? tryFrom(String value) => tryValueOf(values, value);
}
