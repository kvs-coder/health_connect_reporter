import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/availability.dart';

import '../bloc/bloc.dart';
import 'catalog_bloc.dart';

/// Prepares the demo when it starts
sealed class SetupEvent {
  const SetupEvent();
}

/// Checks whether Health Connect can be used
final class SetupStarted extends SetupEvent {
  const SetupStarted();
}

enum SetupStatus { checking, unavailable, updateRequired, ready, failed }

class SetupState {
  const SetupState(this.status, this.message);

  final SetupStatus status;
  final String message;
}

/// Health Connect asks for permissions from the Manager rows, so setup only
/// checks its availability.
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc({Future<Availability> Function()? availability})
    : _availability = availability ?? HealthConnectReporter.availability,
      super(const SetupState(SetupStatus.checking, 'Checking Health Connect…'));

  final Future<Availability> Function() _availability;

  @override
  Future<void> onEvent(SetupEvent event) async {
    switch (event) {
      case SetupStarted():
        await _start();
    }
  }

  Future<void> _start() async {
    try {
      emit(switch (await _availability()) {
        Availability.available => const SetupState(
          SetupStatus.ready,
          'Health Connect is available. Grant permissions with requestPermissions',
        ),
        Availability.updateRequired => const SetupState(
          SetupStatus.updateRequired,
          'Install or update Health Connect from Google Play with openInstall',
        ),
        Availability.unavailable => const SetupState(
          SetupStatus.unavailable,
          'Health Connect does not run on this device',
        ),
      });
    } catch (error) {
      emit(SetupState(SetupStatus.failed, CatalogBloc.describe(error)));
    }
  }
}
