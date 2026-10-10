import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [SpecimenSource]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The specimen a blood glucose level was measured in.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [SpecimenSource.from] and [SpecimenSource.tryFrom]
/// creating from the [value].
///
enum SpecimenSource implements ValueEnum {
  unknown('UNKNOWN'),
  interstitialFluid('INTERSTITIAL_FLUID'),
  capillaryBlood('CAPILLARY_BLOOD'),
  plasma('PLASMA'),
  serum('SERUM'),
  tears('TEARS'),
  wholeBlood('WHOLE_BLOOD');

  const SpecimenSource(this.value);

  /// The Kotlin constant name, e.g. `UNKNOWN`
  @override
  final String value;

  /// Finds the case by its [value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  factory SpecimenSource.from(String value) => valueOf(values, value);

  /// The [SpecimenSource.from] exception handling
  ///
  static SpecimenSource? tryFrom(String value) => tryValueOf(values, value);
}
