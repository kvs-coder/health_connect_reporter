import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter_example/demo/catalog.dart';
import 'package:integration_test/integration_test.dart';

/// Runs every row of the Health Connect demo on an Android 14+ phone.
/// Grant the permissions once first (run the app, tap requestPermissions
/// and allow all), since Health Connect's permission screen can't be driven
/// from a test; `--no-uninstall` keeps them between runs.
///
/// Rows of a type whose feature the device lacks fail with `NotAvailable`,
/// which is reported, not failed.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final catalog = Catalog();

  // These rows leave the app for a Health Connect or Google Play screen,
  // or revoke the permissions the other rows need
  const skipped = {
    'requestPermissions',
    'openSettings',
    'openInstall',
    'revokeAllPermissions',
  };

  for (final section in catalog.sections) {
    for (final row in section.rows) {
      test(
        '${section.title} / ${row.title}',
        skip: skipped.contains(row.title),
        () async {
          if (row.isLive) {
            final updates = <String>[];
            final subscription = row.listen!(updates.add);
            await Future<void>.delayed(const Duration(seconds: 4));
            await subscription.cancel();
            // ignore: avoid_print
            print(
              'LIVE ${row.title}: ${updates.length} updates, '
              'last: ${updates.lastOrNull}',
            );
            return;
          }
          try {
            final result = await row.run!().timeout(
              const Duration(seconds: 90),
            );
            // ignore: avoid_print
            print('OK ${row.title}: ${result.split('\n').first}');
          } on PlatformException catch (error) {
            // ignore: avoid_print
            print(
              'ERR ${row.title}: ${error.code}: ${error.message} '
              '(${error.details})',
            );
            if (error.details != 'NotAvailable') rethrow;
          }
        },
        timeout: const Timeout(Duration(minutes: 3)),
      );
    }
  }
}
