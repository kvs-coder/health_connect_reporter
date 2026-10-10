import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/type/aggregation.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter_example/demo/catalog.dart';

void main() {
  final rows = Catalog().sections.expand((e) => e.rows).toList();

  test('catalog_has_every_library_area', () {
    expect(Catalog().sections.map((e) => e.title), [
      'Manager',
      'Reader',
      'Aggregates',
      'Writer',
      'Observer',
    ]);
  });

  test('every_health_connect_method_has_a_row', () {
    const methods = [
      'availability',
      'requestPermissions',
      'grantedPermissions',
      'revokeAllPermissions',
      'isFeatureAvailable',
      'openSettings',
      'openInstall',
      'read',
      'readPage',
      'readById',
      'aggregate',
      'aggregateGroups',
      'insert',
      'update',
      'delete',
      'deleteByIds',
      'deleteByRange',
      'anchor',
      'changes',
      'observe',
    ];
    for (final method in methods) {
      expect(
        rows.where((row) => row.title.split(' ').first == method),
        isNotEmpty,
        reason: method,
      );
    }
  });

  test('every_type_and_aggregation_has_a_row', () {
    final titles = rows.map((row) => row.title).toSet();
    for (final type in HealthType.values) {
      expect(titles, contains('read ${type.identifier}'));
      expect(titles, contains('insert ${type.identifier}'));
    }
    for (final aggregation in Aggregation.values) {
      expect(titles, contains('aggregate ${aggregation.value}'));
    }
  });

  test('every_row_runs_or_listens', () {
    for (final row in rows) {
      expect(row.run != null || row.listen != null, isTrue, reason: row.title);
    }
    expect(rows.where((row) => row.isLive).map((row) => row.title), [
      'observe',
    ]);
  });
}
