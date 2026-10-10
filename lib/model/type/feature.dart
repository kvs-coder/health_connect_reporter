import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [Feature]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A Health Connect feature that may be missing on older Health Connect
/// versions.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [Feature.from] and [Feature.tryFrom]
/// creating from the [value].
///
enum Feature implements ValueEnum {
  /// reading health data in the background, Permission.ReadInBackground
  readHealthDataInBackground('READ_HEALTH_DATA_IN_BACKGROUND'),

  /// skin temperature, [HealthType.SKIN_TEMPERATURE]
  skinTemperature('SKIN_TEMPERATURE'),

  /// planned exercise sessions, [HealthType.PLANNED_EXERCISE_SESSION]
  plannedExercise('PLANNED_EXERCISE'),

  /// reading data older than 30 days before the first grant,
  /// Permission.ReadHistory
  readHealthDataHistory('READ_HEALTH_DATA_HISTORY'),

  /// mindfulness sessions, [HealthType.MINDFULNESS_SESSION]
  mindfulnessSession('MINDFULNESS_SESSION');

  const Feature(this.value);

  /// The Kotlin constant name, e.g. `READ_HEALTH_DATA_IN_BACKGROUND`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory Feature.from(String value) => valueOf(values, value);

  /// The [Feature.from] exception handling
  ///
  static Feature? tryFrom(String value) => tryValueOf(values, value);
}
