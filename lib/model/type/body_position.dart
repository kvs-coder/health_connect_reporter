import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [BodyPosition]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The body position during a blood pressure measurement.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [BodyPosition.from] and [BodyPosition.tryFrom]
/// creating from the [value].
///
enum BodyPosition implements ValueEnum {
  unknown('UNKNOWN'),
  standingUp('STANDING_UP'),
  sittingDown('SITTING_DOWN'),
  lyingDown('LYING_DOWN'),
  reclining('RECLINING');

  const BodyPosition(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory BodyPosition.from(String value) => valueOf(values, value);

  /// The [BodyPosition.from] exception handling
  ///
  static BodyPosition? tryFrom(String value) => tryValueOf(values, value);
}
