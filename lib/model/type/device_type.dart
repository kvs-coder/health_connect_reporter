import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [DeviceType]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The kind of device that recorded a sample.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [DeviceType.from] and [DeviceType.tryFrom]
/// creating from the [value].
///
enum DeviceType implements ValueEnum {
  unknown('UNKNOWN'),
  watch('WATCH'),
  phone('PHONE'),
  scale('SCALE'),
  ring('RING'),
  headMounted('HEAD_MOUNTED'),
  fitnessBand('FITNESS_BAND'),
  chestStrap('CHEST_STRAP'),
  smartDisplay('SMART_DISPLAY');

  const DeviceType(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory DeviceType.from(String value) => valueOf(values, value);

  /// The [DeviceType.from] exception handling
  ///
  static DeviceType? tryFrom(String value) => tryValueOf(values, value);
}
