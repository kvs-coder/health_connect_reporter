import 'anchor.dart';
import 'decorator/extensions.dart';
import 'payload/payload.dart';
import 'payload/sample.dart';

/// Equivalent of [ChangeSet]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The changes since an anchor. Persist [anchor] and pass it
/// to the next changes read.
///
/// Supports [map] representation.
///
/// Has a [ChangeSet.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class ChangeSet with Payload {
  const ChangeSet({
    required this.upserted,
    required this.deletedIds,
    required this.anchor,
  });

  /// Inserted or updated samples, oldest change first
  final List<Sample> upserted;

  /// Health Connect ids of deleted records
  final List<String> deletedIds;

  /// The anchor after these changes; pass it to the next call
  final Anchor anchor;

  /// True when nothing changed
  bool get isEmpty => upserted.isEmpty && deletedIds.isEmpty;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'upserted': upserted.map((e) => e.map).toList(),
        'deletedIds': deletedIds,
        'anchor': anchor.map,
      };

  /// General constructor from JSON payload.
  /// Throws an [InvalidValueException] for a sample of an unknown type.
  ///
  ChangeSet.fromJson(Map<String, dynamic> json)
      : upserted = Sample.collect(json['upserted'] ?? const []),
        deletedIds = parseStrings(json['deletedIds']),
        anchor = Anchor.fromJson(parseObject(json['anchor']));
}
