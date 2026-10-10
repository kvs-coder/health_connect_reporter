import 'payload/payload.dart';

/// Equivalent of [Anchor]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A position in Health Connect's change history; store it to read only
/// later changes. Health Connect keeps changes for 30 days; reading changes
/// of an older anchor fails with `AnchorExpired`.
///
/// Supports [map] representation.
///
/// Has a [Anchor.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class Anchor with Payload {
  const Anchor({
    required this.token,
  });

  /// The Health Connect changes token
  final String token;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'token': token,
      };

  /// General constructor from JSON payload
  ///
  Anchor.fromJson(Map<String, dynamic> json) : token = json['token'];
}
