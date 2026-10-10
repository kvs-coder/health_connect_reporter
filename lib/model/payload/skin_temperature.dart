import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/skin_temperature_measurement_location.dart';
import 'sample.dart';

/// Equivalent of [SkinTemperature]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Skin temperature as deltas from a baseline, in °C.
///
/// Supports [map] representation.
///
/// Has a [SkinTemperature.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.skinTemperature] permissions provided.
///
class SkinTemperature extends WritableSample<SkinTemperatureHarmonized> {
  const SkinTemperature({
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
  HealthType get healthType => HealthType.skinTemperature;

  /// General constructor from JSON payload
  ///
  SkinTemperature.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(
            json,
            SkinTemperatureHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<SkinTemperature> collect(List<dynamic> list) =>
      parseObjects(list, SkinTemperature.fromJson);
}

/// Equivalent of [SkinTemperature.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of SkinTemperature.
///
/// Supports [map] representation.
///
/// Has a [SkinTemperatureHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SkinTemperatureHarmonized with Payload {
  const SkinTemperatureHarmonized({
    required this.deltas,
    this.baseline,
    this.measurementLocation = SkinTemperatureMeasurementLocation.unknown,
  });

  /// The measured deltas, inside the sample's interval
  final List<SkinTemperatureDelta> deltas;

  /// The baseline skin temperature in °C (0–100)
  final double? baseline;

  /// Where the temperature was measured.
  /// [SkinTemperatureMeasurementLocation.unknown] by default
  final SkinTemperatureMeasurementLocation measurementLocation;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'deltas': deltas.map((e) => e.map).toList(),
        'baseline': baseline,
        'measurementLocation': measurementLocation.value,
      };

  /// General constructor from JSON payload
  ///
  SkinTemperatureHarmonized.fromJson(Map<String, dynamic> json)
      : deltas = parseObjects(json['deltas'], SkinTemperatureDelta.fromJson),
        baseline = tryParseDouble(json['baseline']),
        measurementLocation = json['measurementLocation'] == null
            ? SkinTemperatureMeasurementLocation.unknown
            : SkinTemperatureMeasurementLocation.from(
                json['measurementLocation']);
}

/// Equivalent of [SkinTemperature.Delta]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// One skin temperature measurement relative to the baseline.
///
/// Supports [map] representation.
///
/// Has a [SkinTemperatureDelta.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class SkinTemperatureDelta with Payload {
  const SkinTemperatureDelta({
    required this.timestamp,
    required this.delta,
  });

  /// Measurement time, epoch milliseconds
  final int timestamp;

  /// Difference from the baseline in °C (-30–30)
  final double delta;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'timestamp': timestamp,
        'delta': delta,
      };

  /// General constructor from JSON payload
  ///
  SkinTemperatureDelta.fromJson(Map<String, dynamic> json)
      : timestamp = parseInt(json['timestamp']),
        delta = parseDouble(json['delta']);
}
