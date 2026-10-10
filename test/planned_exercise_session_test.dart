import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/model/payload/planned_exercise_session.dart';
import 'package:health_connect_reporter/model/type/exercise_phase.dart';
import 'package:health_connect_reporter/model/type/exercise_segment_type.dart';
import 'package:health_connect_reporter/model/type/exercise_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('planned_exercise_session_parses_blocks_and_steps', () {
    final sut =
        PlannedExerciseSession.fromJson(fixtures.plannedExerciseSession);
    final harmonized = sut.harmonized;
    expect(harmonized.exerciseType, ExerciseType.running);
    expect(harmonized.title, 'Intervals');
    expect(harmonized.notes, 'Twice');
    expect(harmonized.hasExplicitTime, isTrue);
    expect(harmonized.completedExerciseSessionId, isNull);
    final block = harmonized.blocks.single;
    expect(block.repetitions, 2);
    expect(block.description, 'Intervals');
    expect(block.steps, [
      PlannedExerciseSessionStep(
        exerciseType: ExerciseSegmentType.running,
        exercisePhase: ExercisePhase.warmup,
        completionGoal: CompletionGoalDuration(durationMillis: 600000),
        performanceTargets: [
          PerformanceTargetHeartRate(minHeartRate: 100, maxHeartRate: 120),
        ],
        description: 'Warm up',
      ),
      PlannedExerciseSessionStep(
        exerciseType: ExerciseSegmentType.running,
        exercisePhase: ExercisePhase.active,
        completionGoal: CompletionGoalDistance(distance: 1000),
      ),
    ]);
  });

  test('planned_exercise_session_is_timed_explicitly_by_default', () {
    final sut = PlannedExerciseSessionHarmonized.fromJson(const {
      'exerciseType': 'BIKING',
      'blocks': [],
    });
    expect(sut.hasExplicitTime, isTrue);
    expect(sut.blocks, isEmpty);
  });

  test('every_completion_goal_round_trips', () {
    final sut = CompletionGoal.collect(fixtures.completionGoals);
    expect(sut, const [
      CompletionGoalDistance(distance: 1),
      CompletionGoalDistanceAndDuration(distance: 1, durationMillis: 1),
      CompletionGoalSteps(steps: 1),
      CompletionGoalDuration(durationMillis: 1),
      CompletionGoalRepetitions(repetitions: 1),
      CompletionGoalTotalCaloriesBurned(totalCalories: 1),
      CompletionGoalActiveCaloriesBurned(activeCalories: 1),
      CompletionGoalManualCompletion(),
      CompletionGoalUnknown(),
    ]);
    expect(sut.map((e) => e.map), fixtures.completionGoals);
  });

  test('every_performance_target_round_trips', () {
    final sut = PerformanceTarget.collect(fixtures.performanceTargets);
    expect(sut, const [
      PerformanceTargetPower(minPower: 1, maxPower: 2),
      PerformanceTargetSpeed(minSpeed: 1, maxSpeed: 2),
      PerformanceTargetCadence(minCadence: 1, maxCadence: 2),
      PerformanceTargetHeartRate(minHeartRate: 1, maxHeartRate: 2),
      PerformanceTargetWeight(mass: 1),
      PerformanceTargetRateOfPerceivedExertion(rpe: 1),
      PerformanceTargetAmrap(),
      PerformanceTargetUnknown(),
    ]);
    expect(sut.map((e) => e.map), fixtures.performanceTargets);
  });

  test('unknown_goal_and_target_types_throw', () {
    expect(
        () => CompletionGoal.factory(const {'type': 'laps'}),
        throwsA(isA<InvalidValueException>()
            .having((e) => e.cause, 'cause', 'Invalid CompletionGoal: laps')));
    expect(() => PerformanceTarget.factory(const {}),
        throwsA(isA<InvalidValueException>()));
  });
}
