import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/availability.dart';
import 'package:health_connect_reporter_example/demo/catalog_bloc.dart';
import 'package:health_connect_reporter_example/demo/demo_row.dart';
import 'package:health_connect_reporter_example/demo/setup_bloc.dart';

void main() {
  final ok = DemoRow('ok', 'succeeds', run: () async => 'done');
  final failing = DemoRow(
    'failing',
    'fails',
    run: () async => throw PlatformException(code: 'save', message: 'denied'),
  );
  final updates = StreamController<String>.broadcast();
  final live = DemoRow(
    'live',
    'reports',
    listen: (report) => updates.stream.listen(report),
  );
  final sections = [
    DemoSection('Reader', [ok, failing]),
    DemoSection('Live', [live]),
  ];

  late CatalogBloc sut;
  setUp(() => sut = CatalogBloc(sections));
  tearDown(() => sut.close());

  test('a_row_reports_running_then_its_result', () async {
    final states = sut.states
        .map((e) => e.results[ok]?.status)
        .take(2)
        .toList();
    sut.add(RowTapped(ok));
    expect(await states, [RowStatus.running, RowStatus.success]);
    expect(sut.state.results[ok]?.text, 'done');
  });

  test('a_failing_row_reports_the_platform_error', () async {
    sut.add(RowTapped(failing));
    await sut.states.firstWhere(
      (e) => e.results[failing]?.status == RowStatus.failure,
    );
    expect(sut.state.results[failing]?.text, 'save: denied');
  });

  test('a_live_row_reports_updates_until_tapped_again', () async {
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.contains(live));
    updates.add('1 update');
    await sut.states.firstWhere((e) => e.results[live]?.text == '1 update');
    expect(sut.state.results[live]?.status, RowStatus.listening);
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.isEmpty);
    updates.add('ignored');
    await pumpEventQueue();
    expect(sut.state.results[live]?.text, 'stopped');
    expect(updates.hasListener, isFalse);
  });

  test('stopping_all_live_queries_clears_their_results', () async {
    sut.add(RowTapped(live));
    await sut.states.firstWhere((e) => e.live.contains(live));
    sut.add(const LiveQueriesStopped());
    await sut.states.firstWhere((e) => e.live.isEmpty);
    expect(sut.state.results.containsKey(live), isFalse);
  });

  test('search_and_section_filter_the_rows', () async {
    sut.add(const SearchChanged('FAIL'));
    await sut.states.first;
    expect(sut.state.visibleSections.single.rows, [failing]);
    sut
      ..add(const SearchChanged(''))
      ..add(const SectionSelected('Live'));
    await sut.states.firstWhere((e) => e.section == 'Live');
    expect(sut.state.visibleSections.single.title, 'Live');
    sut.add(const SectionSelected(null));
    await sut.states.first;
    expect(sut.state.visibleSections, hasLength(2));
  });

  group('setup', () {
    Future<SetupState> setUpWith(
      Future<Availability> Function() availability,
    ) async {
      final bloc = SetupBloc(availability: availability);
      bloc.add(const SetupStarted());
      final state = await bloc.states.first;
      await bloc.close();
      return state;
    }

    test('available_health_connect_is_ready', () async {
      expect(
        (await setUpWith(() async => Availability.available)).status,
        SetupStatus.ready,
      );
    });

    test('health_connect_to_install_or_update_needs_an_update', () async {
      expect(
        (await setUpWith(() async => Availability.updateRequired)).status,
        SetupStatus.updateRequired,
      );
    });

    test('device_without_health_connect_is_unavailable', () async {
      expect(
        (await setUpWith(() async => Availability.unavailable)).status,
        SetupStatus.unavailable,
      );
    });

    test('a_failing_check_is_reported', () async {
      final failed = await setUpWith(
        () async => throw PlatformException(
          code: 'availability',
          message: 'No package manager',
        ),
      );
      expect(failed.status, SetupStatus.failed);
      expect(failed.message, 'availability: No package manager');
    });
  });
}
