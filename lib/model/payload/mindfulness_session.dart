import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/mindfulness_session_type.dart';
import 'sample.dart';

/// Equivalent of [MindfulnessSession]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A mindfulness session.
///
/// Supports [map] representation.
///
/// Has a [MindfulnessSession.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.mindfulnessSession] permissions provided.
///
class MindfulnessSession extends WritableSample<MindfulnessSessionHarmonized> {
  const MindfulnessSession({
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
  HealthType get healthType => HealthType.mindfulnessSession;

  /// General constructor from JSON payload
  ///
  MindfulnessSession.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            MindfulnessSessionHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<MindfulnessSession> collect(List<dynamic> list) =>
      parseObjects(list, MindfulnessSession.fromJson);
}

/// Equivalent of [MindfulnessSession.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of MindfulnessSession.
///
/// Supports [map] representation.
///
/// Has a [MindfulnessSessionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class MindfulnessSessionHarmonized with Payload {
  const MindfulnessSessionHarmonized({
    required this.mindfulnessSessionType,
    this.title,
    this.notes,
  });

  /// The type of session
  final MindfulnessSessionType mindfulnessSessionType;

  /// The title of the session
  final String? title;

  /// Notes on the session
  final String? notes;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'mindfulnessSessionType': mindfulnessSessionType.value,
        'title': title,
        'notes': notes,
      };

  /// General constructor from JSON payload
  ///
  MindfulnessSessionHarmonized.fromJson(Map<String, dynamic> json)
      : mindfulnessSessionType =
            MindfulnessSessionType.from(json['mindfulnessSessionType']),
        title = json['title'],
        notes = json['notes'];
}
