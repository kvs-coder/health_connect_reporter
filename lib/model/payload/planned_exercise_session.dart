import '../../exceptions.dart';
import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/exercise_phase.dart';
import '../type/exercise_segment_type.dart';
import '../type/exercise_type.dart';
import 'sample.dart';

/// Equivalent of [PlannedExerciseSession]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A planned exercise session (training plan) of blocks of steps.
///
/// Supports [map] representation.
///
/// Has a [PlannedExerciseSession.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.plannedExerciseSession] permissions provided.
///
class PlannedExerciseSession
    extends WritableSample<PlannedExerciseSessionHarmonized> {
  const PlannedExerciseSession({
    required super.startTimestamp,
    required this.endTimestamp,
    required super.harmonized,
    super.id,
    super.clientRecordId,
    super.clientRecordVersion,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.recordingMethod,
    super.device,
    super.dataOrigin,
    super.lastModifiedTimestamp,
  });

  /// End time, epoch milliseconds, not before [startTimestamp]
  @override
  final int endTimestamp;

  @override
  HealthType get healthType => HealthType.plannedExerciseSession;

  /// General constructor from JSON payload
  ///
  PlannedExerciseSession.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            PlannedExerciseSessionHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<PlannedExerciseSession> collect(List<dynamic> list) =>
      parseObjects(list, PlannedExerciseSession.fromJson);
}

/// Equivalent of [PlannedExerciseSession.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of PlannedExerciseSession.
///
/// Supports [map] representation.
///
/// Has a [PlannedExerciseSessionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PlannedExerciseSessionHarmonized with Payload {
  const PlannedExerciseSessionHarmonized({
    required this.exerciseType,
    required this.blocks,
    this.title,
    this.notes,
    this.hasExplicitTime = true,
    this.completedExerciseSessionId,
  });

  /// The type of exercise
  final ExerciseType exerciseType;

  /// The blocks of the plan, in order
  final List<PlannedExerciseSessionBlock> blocks;

  /// The title of the plan
  final String? title;

  /// Notes on the plan
  final String? notes;

  /// The plan has a start and end time; when false it is planned for the day of
  /// the start (stored by Health Connect at noon, lasting until the end).
  /// `true` by default
  final bool hasExplicitTime;

  /// Id of the [ExerciseSession] that completed the plan; set by Health Connect
  final String? completedExerciseSessionId;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'exerciseType': exerciseType.value,
        'blocks': blocks.map((e) => e.map).toList(),
        'title': title,
        'notes': notes,
        'hasExplicitTime': hasExplicitTime,
        'completedExerciseSessionId': completedExerciseSessionId,
      };

  /// General constructor from JSON payload
  ///
  PlannedExerciseSessionHarmonized.fromJson(Map<String, dynamic> json)
      : exerciseType = ExerciseType.from(json['exerciseType']),
        blocks =
            parseObjects(json['blocks'], PlannedExerciseSessionBlock.fromJson),
        title = json['title'],
        notes = json['notes'],
        hasExplicitTime = json['hasExplicitTime'] ?? true,
        completedExerciseSessionId = json['completedExerciseSessionId'];
}

/// Equivalent of [PlannedExerciseSession.Block]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Steps repeated a number of times.
///
/// Supports [map] representation.
///
/// Has a [PlannedExerciseSessionBlock.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PlannedExerciseSessionBlock with Payload {
  const PlannedExerciseSessionBlock({
    required this.repetitions,
    required this.steps,
    this.description,
  });

  /// How often the steps are repeated, at least 1
  final int repetitions;

  /// The steps, in order
  final List<PlannedExerciseSessionStep> steps;

  /// A description of the block
  final String? description;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'repetitions': repetitions,
        'steps': steps.map((e) => e.map).toList(),
        'description': description,
      };

  /// General constructor from JSON payload
  ///
  PlannedExerciseSessionBlock.fromJson(Map<String, dynamic> json)
      : repetitions = parseInt(json['repetitions']),
        steps =
            parseObjects(json['steps'], PlannedExerciseSessionStep.fromJson),
        description = json['description'];
}

/// Equivalent of [PlannedExerciseSession.Step]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One planned step, e.g. a warm-up or an interval.
///
/// Supports [map] representation.
///
/// Has a [PlannedExerciseSessionStep.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PlannedExerciseSessionStep with Payload {
  const PlannedExerciseSessionStep({
    required this.exerciseType,
    required this.exercisePhase,
    required this.completionGoal,
    this.performanceTargets = const [],
    this.description,
  });

  /// The exercise of the step
  final ExerciseSegmentType exerciseType;

  /// The phase of the step
  final ExercisePhase exercisePhase;

  /// When the step is complete
  final CompletionGoal completionGoal;

  /// Targets to hold during the step. Empty by default
  final List<PerformanceTarget> performanceTargets;

  /// A description of the step
  final String? description;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'exerciseType': exerciseType.value,
        'exercisePhase': exercisePhase.value,
        'completionGoal': completionGoal.map,
        'performanceTargets': performanceTargets.map((e) => e.map).toList(),
        'description': description,
      };

  /// General constructor from JSON payload
  ///
  PlannedExerciseSessionStep.fromJson(Map<String, dynamic> json)
      : exerciseType = ExerciseSegmentType.from(json['exerciseType']),
        exercisePhase = ExercisePhase.from(json['exercisePhase']),
        completionGoal =
            CompletionGoal.factory(parseObject(json['completionGoal'])),
        performanceTargets =
            parseObjects(json['performanceTargets'], PerformanceTarget.factory),
        description = json['description'];
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// When a planned step is complete; JSON carries a `type` discriminator.
///
/// Has a [factory] method creating the case its `type` discriminator names.
///
sealed class CompletionGoal with Payload {
  const CompletionGoal();

  /// Factory method to create the case its `type` discriminator names.
  /// Throws an [InvalidValueException] for an unknown type.
  ///
  static CompletionGoal factory(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'distance':
        return CompletionGoalDistance.fromJson(json);
      case 'distance_and_duration':
        return CompletionGoalDistanceAndDuration.fromJson(json);
      case 'steps':
        return CompletionGoalSteps.fromJson(json);
      case 'duration':
        return CompletionGoalDuration.fromJson(json);
      case 'repetitions':
        return CompletionGoalRepetitions.fromJson(json);
      case 'total_calories_burned':
        return CompletionGoalTotalCaloriesBurned.fromJson(json);
      case 'active_calories_burned':
        return CompletionGoalActiveCaloriesBurned.fromJson(json);
      case 'manual_completion':
        return const CompletionGoalManualCompletion();
      case 'unknown':
        return const CompletionGoalUnknown();
      default:
        throw InvalidValueException('Invalid CompletionGoal: $type');
    }
  }

  /// [factory] for a list of JSON objects.
  ///
  static List<CompletionGoal> collect(List<dynamic> list) =>
      parseObjects(list, factory);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.Distance]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after a distance.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalDistance.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalDistance extends CompletionGoal {
  const CompletionGoalDistance({
    required this.distance,
  });

  /// Distance in m
  final double distance;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'distance',
        'distance': distance,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalDistance.fromJson(Map<String, dynamic> json)
      : distance = parseDouble(json['distance']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.DistanceAndDuration]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after a distance, in a duration.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalDistanceAndDuration.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalDistanceAndDuration extends CompletionGoal {
  const CompletionGoalDistanceAndDuration({
    required this.distance,
    required this.durationMillis,
  });

  /// Distance in m
  final double distance;

  /// Duration in milliseconds
  final int durationMillis;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'distance_and_duration',
        'distance': distance,
        'durationMillis': durationMillis,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalDistanceAndDuration.fromJson(Map<String, dynamic> json)
      : distance = parseDouble(json['distance']),
        durationMillis = parseInt(json['durationMillis']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.Steps]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after a number of steps.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalSteps.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalSteps extends CompletionGoal {
  const CompletionGoalSteps({
    required this.steps,
  });

  /// Number of steps
  final int steps;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'steps',
        'steps': steps,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalSteps.fromJson(Map<String, dynamic> json)
      : steps = parseInt(json['steps']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.Duration]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after a duration.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalDuration.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalDuration extends CompletionGoal {
  const CompletionGoalDuration({
    required this.durationMillis,
  });

  /// Duration in milliseconds
  final int durationMillis;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'duration',
        'durationMillis': durationMillis,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalDuration.fromJson(Map<String, dynamic> json)
      : durationMillis = parseInt(json['durationMillis']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.Repetitions]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after a number of repetitions.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalRepetitions.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalRepetitions extends CompletionGoal {
  const CompletionGoalRepetitions({
    required this.repetitions,
  });

  /// Number of repetitions
  final int repetitions;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'repetitions',
        'repetitions': repetitions,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalRepetitions.fromJson(Map<String, dynamic> json)
      : repetitions = parseInt(json['repetitions']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.TotalCaloriesBurned]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after burning calories.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalTotalCaloriesBurned.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalTotalCaloriesBurned extends CompletionGoal {
  const CompletionGoalTotalCaloriesBurned({
    required this.totalCalories,
  });

  /// Total calories in kcal
  final double totalCalories;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'total_calories_burned',
        'totalCalories': totalCalories,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalTotalCaloriesBurned.fromJson(Map<String, dynamic> json)
      : totalCalories = parseDouble(json['totalCalories']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.ActiveCaloriesBurned]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Complete after burning active calories.
///
/// Supports [map] representation.
///
/// Has a [CompletionGoalActiveCaloriesBurned.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class CompletionGoalActiveCaloriesBurned extends CompletionGoal {
  const CompletionGoalActiveCaloriesBurned({
    required this.activeCalories,
  });

  /// Active calories in kcal
  final double activeCalories;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'active_calories_burned',
        'activeCalories': activeCalories,
      };

  /// General constructor from JSON payload
  ///
  CompletionGoalActiveCaloriesBurned.fromJson(Map<String, dynamic> json)
      : activeCalories = parseDouble(json['activeCalories']);
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.ManualCompletion]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The user completes the step.
///
/// Supports [map] representation.
///
class CompletionGoalManualCompletion extends CompletionGoal {
  const CompletionGoalManualCompletion();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'manual_completion',
      };
}

/// Equivalent of [PlannedExerciseSession.CompletionGoal.Unknown]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A goal this library version does not know.
///
/// Supports [map] representation.
///
class CompletionGoalUnknown extends CompletionGoal {
  const CompletionGoalUnknown();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'unknown',
      };
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A target to hold during a planned step; JSON carries a `type` discriminator.
///
/// Has a [factory] method creating the case its `type` discriminator names.
///
sealed class PerformanceTarget with Payload {
  const PerformanceTarget();

  /// Factory method to create the case its `type` discriminator names.
  /// Throws an [InvalidValueException] for an unknown type.
  ///
  static PerformanceTarget factory(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'power':
        return PerformanceTargetPower.fromJson(json);
      case 'speed':
        return PerformanceTargetSpeed.fromJson(json);
      case 'cadence':
        return PerformanceTargetCadence.fromJson(json);
      case 'heart_rate':
        return PerformanceTargetHeartRate.fromJson(json);
      case 'weight':
        return PerformanceTargetWeight.fromJson(json);
      case 'rate_of_perceived_exertion':
        return PerformanceTargetRateOfPerceivedExertion.fromJson(json);
      case 'amrap':
        return const PerformanceTargetAmrap();
      case 'unknown':
        return const PerformanceTargetUnknown();
      default:
        throw InvalidValueException('Invalid PerformanceTarget: $type');
    }
  }

  /// [factory] for a list of JSON objects.
  ///
  static List<PerformanceTarget> collect(List<dynamic> list) =>
      parseObjects(list, factory);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.Power]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A power range.
///
/// Supports [map] representation.
///
/// Has a [PerformanceTargetPower.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PerformanceTargetPower extends PerformanceTarget {
  const PerformanceTargetPower({
    required this.minPower,
    required this.maxPower,
  });

  /// Minimum power in W
  final double minPower;

  /// Maximum power in W
  final double maxPower;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'power',
        'minPower': minPower,
        'maxPower': maxPower,
      };

  /// General constructor from JSON payload
  ///
  PerformanceTargetPower.fromJson(Map<String, dynamic> json)
      : minPower = parseDouble(json['minPower']),
        maxPower = parseDouble(json['maxPower']);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.Speed]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A speed range.
///
/// Supports [map] representation.
///
/// Has a [PerformanceTargetSpeed.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PerformanceTargetSpeed extends PerformanceTarget {
  const PerformanceTargetSpeed({
    required this.minSpeed,
    required this.maxSpeed,
  });

  /// Minimum speed in m/s
  final double minSpeed;

  /// Maximum speed in m/s
  final double maxSpeed;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'speed',
        'minSpeed': minSpeed,
        'maxSpeed': maxSpeed,
      };

  /// General constructor from JSON payload
  ///
  PerformanceTargetSpeed.fromJson(Map<String, dynamic> json)
      : minSpeed = parseDouble(json['minSpeed']),
        maxSpeed = parseDouble(json['maxSpeed']);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.Cadence]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A cadence range.
///
/// Supports [map] representation.
///
/// Has a [PerformanceTargetCadence.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PerformanceTargetCadence extends PerformanceTarget {
  const PerformanceTargetCadence({
    required this.minCadence,
    required this.maxCadence,
  });

  /// Minimum cadence in steps or revolutions per minute
  final double minCadence;

  /// Maximum cadence in steps or revolutions per minute
  final double maxCadence;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'cadence',
        'minCadence': minCadence,
        'maxCadence': maxCadence,
      };

  /// General constructor from JSON payload
  ///
  PerformanceTargetCadence.fromJson(Map<String, dynamic> json)
      : minCadence = parseDouble(json['minCadence']),
        maxCadence = parseDouble(json['maxCadence']);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.HeartRate]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A heart rate range.
///
/// Supports [map] representation.
///
/// Has a [PerformanceTargetHeartRate.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PerformanceTargetHeartRate extends PerformanceTarget {
  const PerformanceTargetHeartRate({
    required this.minHeartRate,
    required this.maxHeartRate,
  });

  /// Minimum heart rate in beats per minute
  final double minHeartRate;

  /// Maximum heart rate in beats per minute
  final double maxHeartRate;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'heart_rate',
        'minHeartRate': minHeartRate,
        'maxHeartRate': maxHeartRate,
      };

  /// General constructor from JSON payload
  ///
  PerformanceTargetHeartRate.fromJson(Map<String, dynamic> json)
      : minHeartRate = parseDouble(json['minHeartRate']),
        maxHeartRate = parseDouble(json['maxHeartRate']);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.Weight]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A weight to lift.
///
/// Supports [map] representation.
///
/// Has a [PerformanceTargetWeight.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PerformanceTargetWeight extends PerformanceTarget {
  const PerformanceTargetWeight({
    required this.mass,
  });

  /// Weight in kg
  final double mass;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'weight',
        'mass': mass,
      };

  /// General constructor from JSON payload
  ///
  PerformanceTargetWeight.fromJson(Map<String, dynamic> json)
      : mass = parseDouble(json['mass']);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.RateOfPerceivedExertion]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A perceived exertion.
///
/// Supports [map] representation.
///
/// Has a [PerformanceTargetRateOfPerceivedExertion.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PerformanceTargetRateOfPerceivedExertion extends PerformanceTarget {
  const PerformanceTargetRateOfPerceivedExertion({
    required this.rpe,
  });

  /// Rate of perceived exertion (0–10)
  final int rpe;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'rate_of_perceived_exertion',
        'rpe': rpe,
      };

  /// General constructor from JSON payload
  ///
  PerformanceTargetRateOfPerceivedExertion.fromJson(Map<String, dynamic> json)
      : rpe = parseInt(json['rpe']);
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.Amrap]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// As many repetitions as possible.
///
/// Supports [map] representation.
///
class PerformanceTargetAmrap extends PerformanceTarget {
  const PerformanceTargetAmrap();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'amrap',
      };
}

/// Equivalent of [PlannedExerciseSession.PerformanceTarget.Unknown]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A target this library version does not know.
///
/// Supports [map] representation.
///
class PerformanceTargetUnknown extends PerformanceTarget {
  const PerformanceTargetUnknown();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'unknown',
      };
}
