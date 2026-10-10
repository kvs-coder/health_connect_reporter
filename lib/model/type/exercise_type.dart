import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [ExerciseType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The type of an exercise session.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [ExerciseType.from] and [ExerciseType.tryFrom]
/// creating from the [value].
///
enum ExerciseType implements ValueEnum {
  otherWorkout('OTHER_WORKOUT'),
  badminton('BADMINTON'),
  baseball('BASEBALL'),
  basketball('BASKETBALL'),
  biking('BIKING'),
  bikingStationary('BIKING_STATIONARY'),
  bootCamp('BOOT_CAMP'),
  boxing('BOXING'),
  calisthenics('CALISTHENICS'),
  cricket('CRICKET'),
  dancing('DANCING'),
  elliptical('ELLIPTICAL'),
  exerciseClass('EXERCISE_CLASS'),
  fencing('FENCING'),
  footballAmerican('FOOTBALL_AMERICAN'),
  footballAustralian('FOOTBALL_AUSTRALIAN'),
  frisbeeDisc('FRISBEE_DISC'),
  golf('GOLF'),
  guidedBreathing('GUIDED_BREATHING'),
  gymnastics('GYMNASTICS'),
  handball('HANDBALL'),
  highIntensityIntervalTraining('HIGH_INTENSITY_INTERVAL_TRAINING'),
  hiking('HIKING'),
  iceHockey('ICE_HOCKEY'),
  iceSkating('ICE_SKATING'),
  martialArts('MARTIAL_ARTS'),
  paddling('PADDLING'),
  paragliding('PARAGLIDING'),
  pilates('PILATES'),
  racquetball('RACQUETBALL'),
  rockClimbing('ROCK_CLIMBING'),
  rollerHockey('ROLLER_HOCKEY'),
  rowing('ROWING'),
  rowingMachine('ROWING_MACHINE'),
  rugby('RUGBY'),
  running('RUNNING'),
  runningTreadmill('RUNNING_TREADMILL'),
  sailing('SAILING'),
  scubaDiving('SCUBA_DIVING'),
  skating('SKATING'),
  skiing('SKIING'),
  snowboarding('SNOWBOARDING'),
  snowshoeing('SNOWSHOEING'),
  soccer('SOCCER'),
  softball('SOFTBALL'),
  squash('SQUASH'),
  stairClimbing('STAIR_CLIMBING'),
  stairClimbingMachine('STAIR_CLIMBING_MACHINE'),
  strengthTraining('STRENGTH_TRAINING'),
  stretching('STRETCHING'),
  surfing('SURFING'),
  swimmingOpenWater('SWIMMING_OPEN_WATER'),
  swimmingPool('SWIMMING_POOL'),
  tableTennis('TABLE_TENNIS'),
  tennis('TENNIS'),
  volleyball('VOLLEYBALL'),
  walking('WALKING'),
  waterPolo('WATER_POLO'),
  weightlifting('WEIGHTLIFTING'),
  wheelchair('WHEELCHAIR'),
  yoga('YOGA');

  const ExerciseType(this.value);

  /// The Kotlin constant name, e.g. `OTHER_WORKOUT`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory ExerciseType.from(String value) => valueOf(values, value);

  /// The [ExerciseType.from] exception handling
  ///
  static ExerciseType? tryFrom(String value) => tryValueOf(values, value);
}
