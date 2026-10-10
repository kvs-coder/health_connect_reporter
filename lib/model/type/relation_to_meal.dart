import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [RelationToMeal]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// When a blood glucose level was measured relative to a meal.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [RelationToMeal.from] and [RelationToMeal.tryFrom]
/// creating from the [value].
///
enum RelationToMeal implements ValueEnum {
  unknown('UNKNOWN'),
  general('GENERAL'),
  fasting('FASTING'),
  beforeMeal('BEFORE_MEAL'),
  afterMeal('AFTER_MEAL');

  const RelationToMeal(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory RelationToMeal.from(String value) => valueOf(values, value);

  /// The [RelationToMeal.from] exception handling
  ///
  static RelationToMeal? tryFrom(String value) => tryValueOf(values, value);
}
