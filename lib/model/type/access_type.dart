import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [AccessType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// What a data permission allows.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [AccessType.from] and [AccessType.tryFrom]
/// creating from the [value].
///
enum AccessType implements ValueEnum {
  /// read, aggregate and read changes
  read('READ'),

  /// insert, update and delete
  write('WRITE');

  const AccessType(this.value);

  /// The Kotlin constant name, e.g. `READ`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory AccessType.from(String value) => valueOf(values, value);

  /// The [AccessType.from] exception handling
  ///
  static AccessType? tryFrom(String value) => tryValueOf(values, value);
}
