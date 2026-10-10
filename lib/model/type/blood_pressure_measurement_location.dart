import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [BloodPressureMeasurementLocation]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Where blood pressure was measured.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [BloodPressureMeasurementLocation.from] and [BloodPressureMeasurementLocation.tryFrom]
/// creating from the [value].
///
enum BloodPressureMeasurementLocation implements ValueEnum {
  unknown('UNKNOWN'),
  leftWrist('LEFT_WRIST'),
  rightWrist('RIGHT_WRIST'),
  leftUpperArm('LEFT_UPPER_ARM'),
  rightUpperArm('RIGHT_UPPER_ARM');

  const BloodPressureMeasurementLocation(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory BloodPressureMeasurementLocation.from(String value) =>
      valueOf(values, value);

  /// The [BloodPressureMeasurementLocation.from] exception handling
  ///
  static BloodPressureMeasurementLocation? tryFrom(String value) =>
      tryValueOf(values, value);
}
