import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/body_temperature_measurement_location.dart';
import 'sample.dart';

/// Equivalent of [BasalBodyTemperature]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Basal body temperature, in °C.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [BasalBodyTemperature.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.basalBodyTemperature] permissions provided.
///
class BasalBodyTemperature
    extends WritableSample<BasalBodyTemperatureHarmonized> {
  const BasalBodyTemperature({
    required super.startTimestamp,
    this.endTimestamp,
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

  /// Not used: the record is a single measurement at [startTimestamp]
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.basalBodyTemperature;

  /// General constructor from JSON payload
  ///
  BasalBodyTemperature.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(
            json,
            BasalBodyTemperatureHarmonized.fromJson(
                parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BasalBodyTemperature> collect(List<dynamic> list) =>
      parseObjects(list, BasalBodyTemperature.fromJson);
}

/// Equivalent of [BasalBodyTemperature.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of BasalBodyTemperature.
///
/// Supports [map] representation.
///
/// Has a [BasalBodyTemperatureHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BasalBodyTemperatureHarmonized with Payload {
  const BasalBodyTemperatureHarmonized({
    required this.temperature,
    this.measurementLocation = BodyTemperatureMeasurementLocation.unknown,
  });

  /// Basal body temperature in °C (0–100)
  final double temperature;

  /// Where the temperature was measured.
  /// [BodyTemperatureMeasurementLocation.unknown] by default
  final BodyTemperatureMeasurementLocation measurementLocation;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'temperature': temperature,
        'measurementLocation': measurementLocation.value,
      };

  /// General constructor from JSON payload
  ///
  BasalBodyTemperatureHarmonized.fromJson(Map<String, dynamic> json)
      : temperature = parseDouble(json['temperature']),
        measurementLocation = json['measurementLocation'] == null
            ? BodyTemperatureMeasurementLocation.unknown
            : BodyTemperatureMeasurementLocation.from(
                json['measurementLocation']);
}
