import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [ExercisePhase]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The phase of a planned exercise step.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [ExercisePhase.from] and [ExercisePhase.tryFrom]
/// creating from the [value].
///
enum ExercisePhase implements ValueEnum {
  unknown('UNKNOWN'),
  warmup('WARMUP'),
  rest('REST'),
  active('ACTIVE'),
  cooldown('COOLDOWN'),
  recovery('RECOVERY');

  const ExercisePhase(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory ExercisePhase.from(String value) => valueOf(values, value);

  /// The [ExercisePhase.from] exception handling
  ///
  static ExercisePhase? tryFrom(String value) => tryValueOf(values, value);
}
