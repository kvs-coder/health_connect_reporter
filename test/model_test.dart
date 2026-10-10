import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/exceptions.dart';
import 'package:health_connect_reporter/model/aggregate.dart';
import 'package:health_connect_reporter/model/anchor.dart';
import 'package:health_connect_reporter/model/change_set.dart';
import 'package:health_connect_reporter/model/data_origin.dart';
import 'package:health_connect_reporter/model/decorator/extensions.dart';
import 'package:health_connect_reporter/model/device.dart';
import 'package:health_connect_reporter/model/page.dart';
import 'package:health_connect_reporter/model/payload/steps.dart';
import 'package:health_connect_reporter/model/permission.dart';
import 'package:health_connect_reporter/model/time_group.dart';
import 'package:health_connect_reporter/model/time_range.dart';
import 'package:health_connect_reporter/model/type/access_type.dart';
import 'package:health_connect_reporter/model/type/aggregation.dart';
import 'package:health_connect_reporter/model/type/device_type.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter/model/type/time_group_unit.dart';

import 'fixtures.dart' as fixtures;

void main() {
  group('device', () {
    test('device_parses_every_field_and_round_trips', () {
      final sut = Device.fromJson(fixtures.device);
      expect(sut.type, DeviceType.watch);
      expect(sut.manufacturer, 'Google');
      expect(sut.model, 'Pixel Watch');
      expect(sut.map, fixtures.device);
      expect(Device.collect([fixtures.device]), [sut]);
    });

    test('device_type_is_unknown_by_default', () {
      expect(Device.fromJson(const {}), const Device());
      expect(const Device().map,
          {'type': 'UNKNOWN', 'manufacturer': null, 'model': null});
    });
  });

  test('data_origin_round_trips', () {
    final sut = DataOrigin.fromJson(fixtures.dataOrigin);
    expect(sut.packageName, 'com.example');
    expect(sut.map, fixtures.dataOrigin);
    expect(DataOrigin.collect([fixtures.dataOrigin]), [sut]);
  });

  group('time_range', () {
    test('time_range_round_trips', () {
      final sut = TimeRange.fromJson(fixtures.timeRange);
      expect(sut.startTimestamp, fixtures.start);
      expect(sut.endTimestamp, fixtures.end);
      expect(sut.map, fixtures.timeRange);
    });

    test('time_range_from_dates_uses_epoch_milliseconds', () {
      final sut = TimeRange.fromDates(
        DateTime.fromMillisecondsSinceEpoch(fixtures.start),
        DateTime.fromMillisecondsSinceEpoch(fixtures.end),
      );
      expect(sut, TimeRange.fromJson(fixtures.timeRange));
    });

    test('time_range_last_days_spans_whole_local_days', () {
      final sut = TimeRange.lastDays(2, time: DateTime(2026, 3, 1, 15, 30));
      expect(sut.startTimestamp, DateTime(2026, 2, 28).millisecondsSinceEpoch);
      expect(sut.endTimestamp, DateTime(2026, 3, 2).millisecondsSinceEpoch);
      expect(TimeRange.lastDays(1).endTimestamp,
          greaterThan(DateTime.now().millisecondsSinceEpoch));
    });

    test('time_range_rejects_an_end_not_after_its_start', () {
      expect(
          () => TimeRange(
              startTimestamp: fixtures.end, endTimestamp: fixtures.end),
          throwsA(isA<InvalidValueException>()));
      expect(
          () => TimeRange.lastDays(0), throwsA(isA<InvalidValueException>()));
    });
  });

  group('time_group', () {
    test('time_groups_round_trip', () {
      final sut = TimeGroup.collect(fixtures.timeGroups);
      expect(sut, [
        TimeGroupDuration(durationMillis: 900000),
        TimeGroupPeriod(
            unit: TimeGroupUnit.daily, count: 2, zoneId: 'Europe/Berlin'),
      ]);
      expect(sut.map((e) => e.map), fixtures.timeGroups);
    });

    test('time_group_period_counts_one_unit_in_the_device_zone_by_default', () {
      final sut = TimeGroup.factory(const {'type': 'period', 'unit': 'WEEKLY'});
      expect(sut, TimeGroupPeriod(unit: TimeGroupUnit.weekly));
      expect(sut.map,
          {'type': 'period', 'unit': 'WEEKLY', 'count': 1, 'zoneId': null});
    });

    test('time_group_rejects_empty_buckets_and_unknown_types', () {
      expect(() => TimeGroupDuration(durationMillis: 0),
          throwsA(isA<InvalidValueException>()));
      expect(() => TimeGroupPeriod(unit: TimeGroupUnit.daily, count: 0),
          throwsA(isA<InvalidValueException>()));
      expect(
          () => TimeGroup.factory(const {'type': 'hourly'}),
          throwsA(isA<InvalidValueException>()
              .having((e) => e.cause, 'cause', 'Invalid TimeGroup: hourly')));
    });
  });

  test('page_parses_its_samples_and_token', () {
    final sut = Page.fromJson(fixtures.page);
    expect(sut.items, [Steps.fromJson(fixtures.steps)]);
    expect(sut.nextPageToken, 'next');
    expect(fixtures.withoutNulls(sut.map), fixtures.page);
    expect(Page.fromJson(const {}).items, isEmpty);
  });

  group('aggregate', () {
    test('aggregate_round_trips', () {
      final sut = Aggregate.fromJson(fixtures.aggregate);
      expect(sut.aggregation, Aggregation.stepsCountTotal);
      expect(sut.startTimestamp, fixtures.start);
      expect(sut.endTimestamp, fixtures.end);
      expect(sut.value, 1.0);
      expect(sut.unit, 'count');
      expect(sut.map, fixtures.aggregate);
      expect(Aggregate.collect([fixtures.aggregate]), [sut]);
    });

    test('aggregate_without_data_has_no_value_and_the_default_unit', () {
      final sut = Aggregate.fromJson(fixtures.aggregateEmpty);
      expect(sut.value, isNull);
      expect(fixtures.withoutNulls(sut.map), fixtures.aggregateEmpty);
      expect(
          Aggregate(
                  aggregation: Aggregation.weightWeightAvg,
                  startTimestamp: fixtures.start,
                  endTimestamp: fixtures.end,
                  value: null)
              .unit,
          'kg');
    });
  });

  test('change_set_parses_upserts_deletions_and_anchor', () {
    final sut = ChangeSet.fromJson(fixtures.changeSet);
    expect(sut.upserted, [Steps.fromJson(fixtures.steps)]);
    expect(sut.deletedIds, ['id-2']);
    expect(sut.anchor, const Anchor(token: 'token'));
    expect(sut.isEmpty, isFalse);
    expect(fixtures.withoutNulls(sut.map), fixtures.changeSet);
    expect(
        ChangeSet.fromJson(const {
          'anchor': {'token': 'next'}
        }).isEmpty,
        isTrue);
  });

  test('anchor_round_trips', () {
    final sut = Anchor.fromJson(fixtures.anchor);
    expect(sut.token, 'token');
    expect(sut.map, fixtures.anchor);
  });

  group('permission', () {
    test('permissions_round_trip', () {
      final sut = Permission.collect(fixtures.permissions);
      expect(sut, const [
        PermissionData(healthType: HealthType.steps, access: AccessType.read),
        PermissionReadInBackground(),
        PermissionReadHistory(),
        PermissionWriteExerciseRoute(),
      ]);
      expect(sut.map((e) => e.map), fixtures.permissions);
    });

    test('permission_of_reads_and_writes_every_type', () {
      expect(Permission.of([HealthType.steps, HealthType.weight]), {
        const PermissionData(
            healthType: HealthType.steps, access: AccessType.read),
        const PermissionData(
            healthType: HealthType.steps, access: AccessType.write),
        const PermissionData(
            healthType: HealthType.weight, access: AccessType.read),
        const PermissionData(
            healthType: HealthType.weight, access: AccessType.write),
      });
      expect(Permission.of([HealthType.steps], access: {AccessType.read}), {
        const PermissionData(
            healthType: HealthType.steps, access: AccessType.read),
      });
    });

    test('permission_of_an_unknown_type_throws', () {
      expect(
          () => Permission.factory(const {'type': 'read_everything'}),
          throwsA(isA<InvalidValueException>().having(
              (e) => e.cause, 'cause', 'Invalid Permission: read_everything')));
      expect(
          () => Permission.factory(
              const {'type': 'data', 'healthType': 'steps', 'access': 'READ'}),
          throwsA(isA<InvalidValueException>()));
    });
  });

  group('parse helpers', () {
    test('numbers_parse_from_numbers_and_strings', () {
      expect(parseInt(7), 7);
      expect(parseInt('7'), 7);
      expect(parseDouble(7), 7.0);
      expect(parseDouble('7.5'), 7.5);
      expect(tryParseInt(null), isNull);
      expect(tryParseDouble(null), isNull);
    });

    test('anything_else_is_not_a_number', () {
      expect(() => parseInt(true), throwsFormatException);
      expect(() => parseObject(7), throwsA(isA<InvalidValueException>()));
    });

    test('payloads_print_their_map', () {
      expect(const Anchor(token: 'token').toString(), 'Anchor({token: token})');
    });
  });
}
