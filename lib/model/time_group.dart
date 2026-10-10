import '../exceptions.dart';
import 'decorator/extensions.dart';
import 'payload/payload.dart';
import 'type/time_group_unit.dart';

/// Equivalent of [TimeGroup]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// How aggregate results are grouped into buckets; JSON carries a `type`
/// discriminator.
///
/// Has a [factory] method creating the case its `type` discriminator names.
///
sealed class TimeGroup with Payload {
  const TimeGroup();

  /// Factory method to create the case its `type` discriminator names.
  /// Throws an [InvalidValueException] for an unknown type.
  ///
  static TimeGroup factory(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'duration':
        return TimeGroupDuration.fromJson(json);
      case 'period':
        return TimeGroupPeriod.fromJson(json);
      default:
        throw InvalidValueException('Invalid TimeGroup: $type');
    }
  }

  /// [factory] for a list of JSON objects.
  ///
  static List<TimeGroup> collect(List<dynamic> list) =>
      parseObjects(list, factory);
}

/// Equivalent of [TimeGroup.Duration]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Buckets of a fixed physical duration, e.g. every 15 minutes. Throws an
/// [InvalidValueException] when [durationMillis] is less than 1.
///
/// Supports [map] representation.
///
/// Has a [TimeGroupDuration.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class TimeGroupDuration extends TimeGroup {
  TimeGroupDuration({
    required this.durationMillis,
  }) {
    if (durationMillis < 1) {
      throw InvalidValueException(
          'Invalid TimeGroup duration: $durationMillis');
    }
  }

  /// Bucket length in milliseconds, at least 1
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
  TimeGroupDuration.fromJson(Map<String, dynamic> json)
      : this(durationMillis: parseInt(json['durationMillis']));
}

/// Equivalent of [TimeGroup.Period]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Buckets of calendar periods in a time zone, e.g. days or months. Throws an
/// [InvalidValueException] when [count] is less than 1.
///
/// Supports [map] representation.
///
/// Has a [TimeGroupPeriod.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class TimeGroupPeriod extends TimeGroup {
  TimeGroupPeriod({
    required this.unit,
    this.count = 1,
    this.zoneId,
  }) {
    if (count < 1) {
      throw InvalidValueException('Invalid TimeGroup count: $count');
    }
  }

  /// The calendar unit
  final TimeGroupUnit unit;

  /// Units per bucket, at least 1. `1` by default
  final int count;

  /// The zone of the calendar, e.g. `Europe/Berlin`; null means the device's
  /// zone
  final String? zoneId;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': 'period',
        'unit': unit.value,
        'count': count,
        'zoneId': zoneId,
      };

  /// General constructor from JSON payload
  ///
  TimeGroupPeriod.fromJson(Map<String, dynamic> json)
      : this(
          unit: TimeGroupUnit.from(json['unit']),
          count: tryParseInt(json['count']) ?? 1,
          zoneId: json['zoneId'],
        );
}
