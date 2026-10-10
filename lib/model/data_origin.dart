import 'decorator/extensions.dart';
import 'payload/payload.dart';

/// Equivalent of [DataOrigin]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The app that wrote a record; also filters reads by app.
///
/// Supports [map] representation.
///
/// Has a [DataOrigin.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class DataOrigin with Payload {
  const DataOrigin({
    required this.packageName,
  });

  /// The app's package name, e.g. `com.google.android.apps.fitness`
  final String packageName;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'packageName': packageName,
      };

  /// General constructor from JSON payload
  ///
  DataOrigin.fromJson(Map<String, dynamic> json)
      : packageName = json['packageName'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<DataOrigin> collect(List<dynamic> list) =>
      parseObjects(list, DataOrigin.fromJson);
}
