import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [BodyTemperatureMeasurementLocation]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Where a body temperature was measured.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [BodyTemperatureMeasurementLocation.from] and [BodyTemperatureMeasurementLocation.tryFrom]
/// creating from the [value].
///
enum BodyTemperatureMeasurementLocation implements ValueEnum {
  unknown('UNKNOWN'),
  armpit('ARMPIT'),
  finger('FINGER'),
  forehead('FOREHEAD'),
  mouth('MOUTH'),
  rectum('RECTUM'),
  temporalArtery('TEMPORAL_ARTERY'),
  toe('TOE'),
  ear('EAR'),
  wrist('WRIST'),
  vagina('VAGINA');

  const BodyTemperatureMeasurementLocation(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory BodyTemperatureMeasurementLocation.from(String value) =>
      valueOf(values, value);

  /// The [BodyTemperatureMeasurementLocation.from] exception handling
  ///
  static BodyTemperatureMeasurementLocation? tryFrom(String value) =>
      tryValueOf(values, value);
}
