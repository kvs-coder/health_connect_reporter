import '../exceptions.dart';
import 'decorator/extensions.dart';
import 'payload/payload.dart';
import 'type/access_type.dart';
import 'type/feature.dart';
import 'type/health_type.dart';

/// Equivalent of [Permission]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One Health Connect permission; JSON carries a `type` discriminator. The
/// consuming app declares each permission it requests in its manifest, e.g.
/// `android.permission.health.READ_STEPS`.
///
/// Has a [factory] method creating the case its `type` discriminator names.
///
sealed class Permission with Payload {
  const Permission();

  /// Factory method to create the case its `type` discriminator names.
  /// Throws an [InvalidValueException] for an unknown type.
  ///
  static Permission factory(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'data':
        return PermissionData.fromJson(json);
      case 'read_in_background':
        return const PermissionReadInBackground();
      case 'read_history':
        return const PermissionReadHistory();
      case 'write_exercise_route':
        return const PermissionWriteExerciseRoute();
      default:
        throw InvalidValueException('Invalid Permission: $type');
    }
  }

  /// [factory] for a list of JSON objects.
  ///
  static List<Permission> collect(List<dynamic> list) =>
      parseObjects(list, factory);

  /// The read and write permissions of [types].
  ///
  /// [access] is read and write by default.
  ///
  static Set<Permission> of(Iterable<HealthType> types,
          {Set<AccessType> access = const {
            AccessType.read,
            AccessType.write
          }}) =>
      {
        for (final type in types)
          for (final element in access)
            PermissionData(healthType: type, access: element),
      };
}

/// Equivalent of [Permission.Data]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Access to the records of one type. Some types share their Health Connect
/// permission: [HealthType.steps] and [HealthType.stepsCadence],
/// [HealthType.exerciseSession] and [HealthType.cyclingPedalingCadence],
/// [HealthType.menstruationFlow] and [HealthType.menstruationPeriod]. In JSON
/// the [healthType] is its [HealthType.value], e.g. `STEPS`.
///
/// Supports [map] representation.
///
/// Has a [PermissionData.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class PermissionData extends Permission {
  const PermissionData({
    required this.healthType,
    required this.access,
  });

  /// The data type
  final HealthType healthType;

  /// Read or write
  final AccessType access;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'data',
        'healthType': healthType.value,
        'access': access.value,
      };

  /// General constructor from JSON payload
  ///
  PermissionData.fromJson(Map<String, dynamic> json)
      : healthType = HealthType.from(json['healthType']),
        access = AccessType.from(json['access']);
}

/// Equivalent of [Permission.ReadInBackground]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Read data while the app is in the background; needs
/// [Feature.readHealthDataInBackground].
///
/// Supports [map] representation.
///
class PermissionReadInBackground extends Permission {
  const PermissionReadInBackground();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'read_in_background',
      };
}

/// Equivalent of [Permission.ReadHistory]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Read data older than 30 days before the first grant; needs
/// [Feature.readHealthDataHistory].
///
/// Supports [map] representation.
///
class PermissionReadHistory extends Permission {
  const PermissionReadHistory();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'read_history',
      };
}

/// Equivalent of [Permission.WriteExerciseRoute]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Write exercise routes.
///
/// Supports [map] representation.
///
class PermissionWriteExerciseRoute extends Permission {
  const PermissionWriteExerciseRoute();

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'write_exercise_route',
      };
}
