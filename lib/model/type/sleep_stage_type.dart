import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [SleepStageType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The stage of a sleep session.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [SleepStageType.from] and [SleepStageType.tryFrom]
/// creating from the [value].
///
enum SleepStageType implements ValueEnum {
  unknown('UNKNOWN'),
  awake('AWAKE'),
  sleeping('SLEEPING'),
  outOfBed('OUT_OF_BED'),
  light('LIGHT'),
  deep('DEEP'),
  rem('REM'),
  awakeInBed('AWAKE_IN_BED');

  const SleepStageType(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory SleepStageType.from(String value) => valueOf(values, value);

  /// The [SleepStageType.from] exception handling
  ///
  static SleepStageType? tryFrom(String value) => tryValueOf(values, value);
}
