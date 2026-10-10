import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/exercise_segment_type.dart';
import '../type/exercise_type.dart';
import 'sample.dart';

/// Equivalent of [ExerciseSession]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// An exercise session with its segments, laps and route.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSession.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.exerciseSession] permissions provided.
///
class ExerciseSession extends WritableSample<ExerciseSessionHarmonized> {
  const ExerciseSession({
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
  HealthType get healthType => HealthType.exerciseSession;

  /// General constructor from JSON payload
  ///
  ExerciseSession.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            ExerciseSessionHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<ExerciseSession> collect(List<dynamic> list) =>
      parseObjects(list, ExerciseSession.fromJson);
}

/// Equivalent of [ExerciseSession.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of ExerciseSession.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSessionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseSessionHarmonized with Payload {
  const ExerciseSessionHarmonized({
    required this.exerciseType,
    this.title,
    this.notes,
    this.segments = const [],
    this.laps = const [],
    this.route,
    this.isRouteConsentRequired = false,
    this.plannedExerciseSessionId,
  });

  /// The type of exercise
  final ExerciseType exerciseType;

  /// The title of the session
  final String? title;

  /// Notes on the session
  final String? notes;

  /// The segments, inside the session and compatible with [exerciseType]. Empty
  /// by default
  final List<ExerciseSessionSegment> segments;

  /// The laps, inside the session. Empty by default
  final List<ExerciseSessionLap> laps;

  /// The route; null when there is none or reading it needs the user's consent
  final ExerciseSessionRoute? route;

  /// A route exists, but reading it needs the user's consent; set by Health
  /// Connect. `false` by default
  final bool isRouteConsentRequired;

  /// Id of the [PlannedExerciseSession] this session completes
  final String? plannedExerciseSessionId;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'exerciseType': exerciseType.value,
        'title': title,
        'notes': notes,
        'segments': segments.map((e) => e.map).toList(),
        'laps': laps.map((e) => e.map).toList(),
        'route': route?.map,
        'isRouteConsentRequired': isRouteConsentRequired,
        'plannedExerciseSessionId': plannedExerciseSessionId,
      };

  /// General constructor from JSON payload
  ///
  ExerciseSessionHarmonized.fromJson(Map<String, dynamic> json)
      : exerciseType = ExerciseType.from(json['exerciseType']),
        title = json['title'],
        notes = json['notes'],
        segments =
            parseObjects(json['segments'], ExerciseSessionSegment.fromJson),
        laps = parseObjects(json['laps'], ExerciseSessionLap.fromJson),
        route = json['route'] == null
            ? null
            : ExerciseSessionRoute.fromJson(parseObject(json['route'])),
        isRouteConsentRequired = json['isRouteConsentRequired'] ?? false,
        plannedExerciseSessionId = json['plannedExerciseSessionId'];
}

/// Equivalent of [ExerciseSession.Segment]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One segment of the session, e.g. a set of an exercise.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSessionSegment.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseSessionSegment with Payload {
  const ExerciseSessionSegment({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.segmentType,
    this.repetitions = 0,
  });

  /// Epoch milliseconds
  final int startTimestamp;

  /// Epoch milliseconds, after [startTimestamp]
  final int endTimestamp;

  /// The type of segment
  final ExerciseSegmentType segmentType;

  /// Number of repetitions, not negative. `0` by default
  final int repetitions;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'segmentType': segmentType.value,
        'repetitions': repetitions,
      };

  /// General constructor from JSON payload
  ///
  ExerciseSessionSegment.fromJson(Map<String, dynamic> json)
      : startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']),
        segmentType = ExerciseSegmentType.from(json['segmentType']),
        repetitions = tryParseInt(json['repetitions']) ?? 0;
}

/// Equivalent of [ExerciseSession.Lap]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One lap of the session.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSessionLap.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseSessionLap with Payload {
  const ExerciseSessionLap({
    required this.startTimestamp,
    required this.endTimestamp,
    this.length,
  });

  /// Epoch milliseconds
  final int startTimestamp;

  /// Epoch milliseconds, after [startTimestamp]
  final int endTimestamp;

  /// Length of the lap in m (0–1 000 000)
  final double? length;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'length': length,
      };

  /// General constructor from JSON payload
  ///
  ExerciseSessionLap.fromJson(Map<String, dynamic> json)
      : startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']),
        length = tryParseDouble(json['length']);
}

/// Equivalent of [ExerciseSession.Route]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The route of the session.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSessionRoute.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseSessionRoute with Payload {
  const ExerciseSessionRoute({
    required this.locations,
  });

  /// The locations, inside the session
  final List<ExerciseSessionLocation> locations;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'locations': locations.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  ExerciseSessionRoute.fromJson(Map<String, dynamic> json)
      : locations =
            parseObjects(json['locations'], ExerciseSessionLocation.fromJson);
}

/// Equivalent of [ExerciseSession.Location]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One point of a route.
///
/// Supports [map] representation.
///
/// Has a [ExerciseSessionLocation.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ExerciseSessionLocation with Payload {
  const ExerciseSessionLocation({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.horizontalAccuracy,
    this.verticalAccuracy,
    this.altitude,
  });

  /// Epoch milliseconds
  final int timestamp;

  /// Latitude in degrees (-90–90)
  final double latitude;

  /// Longitude in degrees (-180–180)
  final double longitude;

  /// Horizontal accuracy in m
  final double? horizontalAccuracy;

  /// Vertical accuracy in m
  final double? verticalAccuracy;

  /// Altitude in m
  final double? altitude;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'latitude': latitude,
        'longitude': longitude,
        'horizontalAccuracy': horizontalAccuracy,
        'verticalAccuracy': verticalAccuracy,
        'altitude': altitude,
      };

  /// General constructor from JSON payload
  ///
  ExerciseSessionLocation.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        latitude = parseDouble(json['latitude']),
        longitude = parseDouble(json['longitude']),
        horizontalAccuracy = tryParseDouble(json['horizontalAccuracy']),
        verticalAccuracy = tryParseDouble(json['verticalAccuracy']),
        altitude = tryParseDouble(json['altitude']);
}
