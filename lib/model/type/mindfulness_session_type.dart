import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [MindfulnessSessionType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The type of a mindfulness session.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [MindfulnessSessionType.from] and [MindfulnessSessionType.tryFrom]
/// creating from the [value].
///
enum MindfulnessSessionType implements ValueEnum {
  unknown('UNKNOWN'),
  meditation('MEDITATION'),
  breathing('BREATHING'),
  music('MUSIC'),
  movement('MOVEMENT'),
  unguided('UNGUIDED');

  const MindfulnessSessionType(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory MindfulnessSessionType.from(String value) => valueOf(values, value);

  /// The [MindfulnessSessionType.from] exception handling
  ///
  static MindfulnessSessionType? tryFrom(String value) =>
      tryValueOf(values, value);
}
