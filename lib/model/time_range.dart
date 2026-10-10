import '../exceptions.dart';
import 'decorator/extensions.dart';
import 'payload/payload.dart';

/// Equivalent of [TimeRange]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A time range in epoch milliseconds, end exclusive.
///
/// Throws an [InvalidValueException] when [endTimestamp] is not after
/// [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [TimeRange.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class TimeRange with Payload {
  TimeRange({
    required this.startTimestamp,
    required this.endTimestamp,
  }) {
    if (endTimestamp <= startTimestamp) {
      throw InvalidValueException('Invalid TimeRange: endTimestamp '
          '$endTimestamp is not after startTimestamp $startTimestamp');
    }
  }

  /// The range from [start] to [end].
  ///
  TimeRange.fromDates(DateTime start, DateTime end)
      : this(
          startTimestamp: start.millisecondsSinceEpoch,
          endTimestamp: end.millisecondsSinceEpoch,
        );

  /// The last [days] calendar days in local time, including the day of [time]
  /// (now by default): from midnight [days] - 1 days before it
  /// to the next midnight.
  ///
  /// Throws an [InvalidValueException] when [days] is less than 1.
  ///
  factory TimeRange.lastDays(int days, {DateTime? time}) {
    if (days < 1) throw InvalidValueException('Invalid days: $days');
    final day = time ?? DateTime.now();
    return TimeRange.fromDates(
      DateTime(day.year, day.month, day.day - (days - 1)),
      DateTime(day.year, day.month, day.day + 1),
    );
  }

  /// Epoch milliseconds, inclusive
  final int startTimestamp;

  /// Epoch milliseconds, exclusive
  final int endTimestamp;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
      };

  /// General constructor from JSON payload
  ///
  TimeRange.fromJson(Map<String, dynamic> json)
      : this(
          startTimestamp: parseInt(json['startTimestamp']),
          endTimestamp: parseInt(json['endTimestamp']),
        );
}
