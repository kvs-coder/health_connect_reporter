import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/payload/exercise_session.dart';
import 'package:health_connect_reporter/model/type/exercise_segment_type.dart';
import 'package:health_connect_reporter/model/type/exercise_type.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('exercise_session_parses_segments_laps_and_route', () {
    final sut = ExerciseSession.fromJson(fixtures.exerciseSession);
    expect(sut.healthType, HealthType.exerciseSession);
    expect(sut.endTimestamp, fixtures.end);
    final harmonized = sut.harmonized;
    expect(harmonized.exerciseType, ExerciseType.running);
    expect(harmonized.title, 'Morning run');
    expect(harmonized.notes, 'Easy');
    expect(harmonized.segments, const [
      ExerciseSessionSegment(
        startTimestamp: fixtures.start,
        endTimestamp: fixtures.mid,
        segmentType: ExerciseSegmentType.running,
      ),
    ]);
    expect(harmonized.laps, const [
      ExerciseSessionLap(
          startTimestamp: fixtures.start,
          endTimestamp: fixtures.mid,
          length: 400),
    ]);
    expect(
        harmonized.route,
        const ExerciseSessionRoute(locations: [
          ExerciseSessionLocation(
            timestamp: fixtures.mid,
            latitude: 52.52,
            longitude: 13.405,
            horizontalAccuracy: 5,
            verticalAccuracy: 3,
            altitude: 34,
          ),
        ]));
    expect(harmonized.isRouteConsentRequired, isFalse);
    expect(harmonized.plannedExerciseSessionId, 'planned-1');
  });

  test('exercise_session_minimal_json_takes_the_library_defaults', () {
    final sut = ExerciseSession.fromJson(const {
      'type': 'exercise',
      'startTimestamp': fixtures.start,
      'endTimestamp': fixtures.end,
      'harmonized': {
        'exerciseType': 'YOGA',
        'segments': [
          {
            'startTimestamp': fixtures.start,
            'endTimestamp': fixtures.mid,
            'segmentType': 'PLANK',
          },
        ],
      },
    });
    expect(sut.harmonized.segments.single.repetitions, 0);
    expect(sut.harmonized.laps, isEmpty);
    expect(sut.harmonized.route, isNull);
    expect(sut.harmonized.isRouteConsentRequired, isFalse);
    expect(sut.harmonized.title, isNull);
    expect(ExerciseSession.fromJson(sut.map), sut);
  });

  test('exercise_session_needing_route_consent_has_no_route', () {
    final sut = ExerciseSession.fromJson({
      ...fixtures.exerciseSession,
      'harmonized': const {
        'exerciseType': 'RUNNING',
        'isRouteConsentRequired': true,
      },
    });
    expect(sut.harmonized.isRouteConsentRequired, isTrue);
    expect(sut.harmonized.route, isNull);
    expect(sut.harmonized.map['route'], isNull);
  });
}
