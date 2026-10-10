import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [CervicalMucusAppearance]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The appearance of cervical mucus.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [CervicalMucusAppearance.from] and [CervicalMucusAppearance.tryFrom]
/// creating from the [value].
///
enum CervicalMucusAppearance implements ValueEnum {
  unknown('UNKNOWN'),
  dry('DRY'),
  sticky('STICKY'),
  creamy('CREAMY'),
  watery('WATERY'),
  eggWhite('EGG_WHITE'),
  unusual('UNUSUAL');

  const CervicalMucusAppearance(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory CervicalMucusAppearance.from(String value) => valueOf(values, value);

  /// The [CervicalMucusAppearance.from] exception handling
  ///
  static CervicalMucusAppearance? tryFrom(String value) =>
      tryValueOf(values, value);
}
