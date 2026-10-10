import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [Vo2MaxMeasurementMethod]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// How VO2 max was measured.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [Vo2MaxMeasurementMethod.from] and [Vo2MaxMeasurementMethod.tryFrom]
/// creating from the [value].
///
enum Vo2MaxMeasurementMethod implements ValueEnum {
  other('OTHER'),
  metabolicCart('METABOLIC_CART'),
  heartRateRatio('HEART_RATE_RATIO'),
  cooperTest('COOPER_TEST'),
  multistageFitnessTest('MULTISTAGE_FITNESS_TEST'),
  rockportFitnessTest('ROCKPORT_FITNESS_TEST');

  const Vo2MaxMeasurementMethod(this.value);

  /// The Kotlin constant name, e.g. `OTHER`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory Vo2MaxMeasurementMethod.from(String value) => valueOf(values, value);

  /// The [Vo2MaxMeasurementMethod.from] exception handling
  ///
  static Vo2MaxMeasurementMethod? tryFrom(String value) =>
      tryValueOf(values, value);
}
