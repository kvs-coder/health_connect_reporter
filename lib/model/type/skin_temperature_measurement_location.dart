import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [SkinTemperatureMeasurementLocation]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Where skin temperature was measured.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [SkinTemperatureMeasurementLocation.from] and [SkinTemperatureMeasurementLocation.tryFrom]
/// creating from the [value].
///
enum SkinTemperatureMeasurementLocation implements ValueEnum {
  unknown('UNKNOWN'),
  finger('FINGER'),
  toe('TOE'),
  wrist('WRIST');

  const SkinTemperatureMeasurementLocation(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory SkinTemperatureMeasurementLocation.from(String value) =>
      valueOf(values, value);

  /// The [SkinTemperatureMeasurementLocation.from] exception handling
  ///
  static SkinTemperatureMeasurementLocation? tryFrom(String value) =>
      tryValueOf(values, value);
}
