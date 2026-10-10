import '../exceptions.dart';

/// Equivalent of [Availability]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Whether Health Connect can be used on this device.
///
enum Availability {
  /// Health Connect is ready to use.
  available('available'),

  /// The Health Connect app must be installed or updated from Google Play
  /// first (Android 13 and lower).
  updateRequired('update_required'),

  /// Health Connect does not run on this device.
  unavailable('unavailable');

  const Availability(this.value);

  /// The library's JSON value
  final String value;

  /// Finds the case of the library's JSON [value].
  ///
  /// Throws [InvalidValueException] for an unknown value.
  ///
  factory Availability.from(String value) => values.firstWhere(
        (availability) => availability.value == value,
        orElse: () =>
            throw InvalidValueException('Invalid Availability: $value'),
      );
}
