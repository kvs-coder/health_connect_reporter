import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/sleep_stage_type.dart';
import 'sample.dart';

/// Equivalent of [SleepSession]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A sleep session with its stages.
///
/// Supports [map] representation.
///
/// Has a [SleepSession.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.sleepSession] permissions provided.
///
class SleepSession extends WritableSample<SleepSessionHarmonized> {
  const SleepSession({
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
  HealthType get healthType => HealthType.sleepSession;

  /// General constructor from JSON payload
  ///
  SleepSession.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            SleepSessionHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<SleepSession> collect(List<dynamic> list) =>
      parseObjects(list, SleepSession.fromJson);
}

/// Equivalent of [SleepSession.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of SleepSession.
///
/// Supports [map] representation.
///
/// Has a [SleepSessionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SleepSessionHarmonized with Payload {
  const SleepSessionHarmonized({
    this.title,
    this.notes,
    this.stages = const [],
  });

  /// The title of the session
  final String? title;

  /// Notes on the session
  final String? notes;

  /// The sleep stages, inside the session and not overlapping. Empty by default
  final List<SleepSessionStage> stages;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'title': title,
        'notes': notes,
        'stages': stages.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  SleepSessionHarmonized.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        notes = json['notes'],
        stages = parseObjects(json['stages'], SleepSessionStage.fromJson);
}

/// Equivalent of [SleepSession.Stage]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One sleep stage.
///
/// Supports [map] representation.
///
/// Has a [SleepSessionStage.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SleepSessionStage with Payload {
  const SleepSessionStage({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.stage,
  });

  /// Epoch milliseconds
  final int startTimestamp;

  /// Epoch milliseconds, after [startTimestamp]
  final int endTimestamp;

  /// The stage
  final SleepStageType stage;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'stage': stage.value,
      };

  /// General constructor from JSON payload
  ///
  SleepSessionStage.fromJson(Map<String, dynamic> json)
      : startTimestamp = parseInt(json['startTimestamp']),
        endTimestamp = parseInt(json['endTimestamp']),
        stage = SleepStageType.from(json['stage']);
}
