import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [ExerciseSegmentType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The type of an exercise segment or planned exercise step.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [ExerciseSegmentType.from] and [ExerciseSegmentType.tryFrom]
/// creating from the [value].
///
enum ExerciseSegmentType implements ValueEnum {
  unknown('UNKNOWN'),
  armCurl('ARM_CURL'),
  backExtension('BACK_EXTENSION'),
  ballSlam('BALL_SLAM'),
  barbellShoulderPress('BARBELL_SHOULDER_PRESS'),
  benchPress('BENCH_PRESS'),
  benchSitUp('BENCH_SIT_UP'),
  biking('BIKING'),
  bikingStationary('BIKING_STATIONARY'),
  burpee('BURPEE'),
  crunch('CRUNCH'),
  deadlift('DEADLIFT'),
  doubleArmTricepsExtension('DOUBLE_ARM_TRICEPS_EXTENSION'),
  dumbbellCurlLeftArm('DUMBBELL_CURL_LEFT_ARM'),
  dumbbellCurlRightArm('DUMBBELL_CURL_RIGHT_ARM'),
  dumbbellFrontRaise('DUMBBELL_FRONT_RAISE'),
  dumbbellLateralRaise('DUMBBELL_LATERAL_RAISE'),
  dumbbellRow('DUMBBELL_ROW'),
  dumbbellTricepsExtensionLeftArm('DUMBBELL_TRICEPS_EXTENSION_LEFT_ARM'),
  dumbbellTricepsExtensionRightArm('DUMBBELL_TRICEPS_EXTENSION_RIGHT_ARM'),
  dumbbellTricepsExtensionTwoArm('DUMBBELL_TRICEPS_EXTENSION_TWO_ARM'),
  elliptical('ELLIPTICAL'),
  forwardTwist('FORWARD_TWIST'),
  frontRaise('FRONT_RAISE'),
  highIntensityIntervalTraining('HIGH_INTENSITY_INTERVAL_TRAINING'),
  hipThrust('HIP_THRUST'),
  hulaHoop('HULA_HOOP'),
  jumpingJack('JUMPING_JACK'),
  jumpRope('JUMP_ROPE'),
  kettlebellSwing('KETTLEBELL_SWING'),
  lateralRaise('LATERAL_RAISE'),
  latPullDown('LAT_PULL_DOWN'),
  legCurl('LEG_CURL'),
  legExtension('LEG_EXTENSION'),
  legPress('LEG_PRESS'),
  legRaise('LEG_RAISE'),
  lunge('LUNGE'),
  mountainClimber('MOUNTAIN_CLIMBER'),
  otherWorkout('OTHER_WORKOUT'),
  pause('PAUSE'),
  pilates('PILATES'),
  plank('PLANK'),
  pullUp('PULL_UP'),
  punch('PUNCH'),
  rest('REST'),
  rowingMachine('ROWING_MACHINE'),
  running('RUNNING'),
  runningTreadmill('RUNNING_TREADMILL'),
  shoulderPress('SHOULDER_PRESS'),
  singleArmTricepsExtension('SINGLE_ARM_TRICEPS_EXTENSION'),
  sitUp('SIT_UP'),
  squat('SQUAT'),
  stairClimbing('STAIR_CLIMBING'),
  stairClimbingMachine('STAIR_CLIMBING_MACHINE'),
  stretching('STRETCHING'),
  swimmingBackstroke('SWIMMING_BACKSTROKE'),
  swimmingBreaststroke('SWIMMING_BREASTSTROKE'),
  swimmingButterfly('SWIMMING_BUTTERFLY'),
  swimmingFreestyle('SWIMMING_FREESTYLE'),
  swimmingMixed('SWIMMING_MIXED'),
  swimmingOpenWater('SWIMMING_OPEN_WATER'),
  swimmingOther('SWIMMING_OTHER'),
  swimmingPool('SWIMMING_POOL'),
  upperTwist('UPPER_TWIST'),
  walking('WALKING'),
  weightlifting('WEIGHTLIFTING'),
  wheelchair('WHEELCHAIR'),
  yoga('YOGA');

  const ExerciseSegmentType(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory ExerciseSegmentType.from(String value) => valueOf(values, value);

  /// The [ExerciseSegmentType.from] exception handling
  ///
  static ExerciseSegmentType? tryFrom(String value) =>
      tryValueOf(values, value);
}
