import 'decorator/extensions.dart';
import 'payload/payload.dart';
import 'type/device_type.dart';

/// Equivalent of [Device]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The device that recorded a sample.
///
/// Supports [map] representation.
///
/// Has a [Device.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class Device with Payload {
  const Device({
    this.type = DeviceType.unknown,
    this.manufacturer,
    this.model,
  });

  /// The kind of device. [DeviceType.unknown] by default
  final DeviceType type;

  /// Manufacturer, e.g. `Google`
  final String? manufacturer;

  /// Model, e.g. `Pixel Watch`
  final String? model;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'type': type.value,
        'manufacturer': manufacturer,
        'model': model,
      };

  /// General constructor from JSON payload
  ///
  Device.fromJson(Map<String, dynamic> json)
      : type = json['type'] == null
            ? DeviceType.unknown
            : DeviceType.from(json['type']),
        manufacturer = json['manufacturer'],
        model = json['model'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Device> collect(List<dynamic> list) =>
      parseObjects(list, Device.fromJson);
}
