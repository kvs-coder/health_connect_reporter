# health_connect_reporter

[![CI](https://github.com/kvs-coder/health_connect_reporter/actions/workflows/ci.yml/badge.svg)](https://github.com/kvs-coder/health_connect_reporter/actions/workflows/ci.yml)

## About

A Flutter plugin that reads, writes and observes [Android Health Connect](https://developer.android.com/health-and-fitness/guides/health-connect) data. It wraps the Kotlin library [HealthConnectReporter](https://github.com/kvs-coder/HealthConnectReporter) and hands you its payloads as plain Dart models.

Its siblings are [health_kit_reporter](https://pub.dev/packages/health_kit_reporter) for Apple Health and [samsung_health_reporter](https://pub.dev/packages/samsung_health_reporter) for Samsung Health.

> **Status**: every HealthConnectReporter call exists; nothing is released yet.

## Requirements

- Android 8 (API 26) or later. Health Connect is part of Android 14+; on Android 9–13 the user installs the Health Connect app from Google Play.
- Flutter 3.44+, Java 17.

## Installation

```yaml
dependencies:
  health_connect_reporter: ^1.0.0 # x-release-please-version
```

The plugin resolves HealthConnectReporter from JitPack, so add the repository to `android/build.gradle.kts`:

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        maven("https://jitpack.io")
    }
}
```

### Manifest

Your app declares every health permission it requests, for example:

```xml
<uses-permission android:name="android.permission.health.READ_STEPS" />
<uses-permission android:name="android.permission.health.WRITE_STEPS" />
```

It also needs an activity that shows your privacy policy for the `androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE` intent and, on Android 14+, an activity-alias for `android.intent.action.VIEW_PERMISSION_USAGE` with the `android.intent.category.HEALTH_PERMISSIONS` category. Google Play requires a [Health Connect permissions declaration](https://support.google.com/googleplay/android-developer/answer/12991134) before you publish.

## Usage

```dart
switch (await HealthConnectReporter.availability()) {
  case Availability.available:
    // read, write and observe
    break;
  case Availability.updateRequired:
    await HealthConnectReporter.openInstall();
    break;
  case Availability.unavailable:
    // Health Connect does not run on this device
    break;
}
```

### Permissions

The permission screen runs on your app's activity, so a plain `FlutterActivity` works. Request only permissions your manifest declares: anything else fails with `InvalidValue`, and so does an empty set.

```dart
final granted = await HealthConnectReporter.requestPermissions({
  ...Permission.of([HealthType.steps, HealthType.heartRate]), // read and write
  const PermissionData(healthType: HealthType.weight, access: AccessType.read),
  const PermissionReadInBackground(), // needs Feature.readHealthDataInBackground
});
final current = await HealthConnectReporter.grantedPermissions();
await HealthConnectReporter.revokeAllPermissions();
```

A permission that needs a feature the device lacks fails with `NotAvailable`; check features first:

```dart
if (await HealthConnectReporter.isFeatureAvailable(Feature.skinTemperature)) {
  // read and write HealthType.skinTemperature
}
```

`openSettings()` opens Health Connect's data management screen, and `openInstall()` opens Health Connect on Google Play when `availability()` is `Availability.updateRequired`.

### Read and aggregate

```dart
final range = TimeRange.lastDays(7);
final samples = await HealthConnectReporter.read(HealthType.heartRate, range,
    ordering: Ordering.ascending, limit: 500);
for (final sample in samples.whereType<HeartRate>()) {
  print(sample.harmonized.series.map((e) => e.beatsPerMinute));
}

// one page at a time
var page = await HealthConnectReporter.readPage(HealthType.steps, range, pageSize: 100);
while (page.nextPageToken != null) {
  page = await HealthConnectReporter.readPage(HealthType.steps, range,
      pageSize: 100, pageToken: page.nextPageToken);
}

final weight = await HealthConnectReporter.readById(HealthType.weight, 'record-id');

final steps = await HealthConnectReporter.aggregate(Aggregation.stepsCountTotal, range,
    origins: {const DataOrigin(packageName: 'com.google.android.apps.fitness')});
final daily = await HealthConnectReporter.aggregateGroups(
    {Aggregation.stepsCountTotal, Aggregation.heartRateBpmAvg},
    range,
    TimeGroupPeriod(unit: TimeGroupUnit.daily, zoneId: 'Europe/Berlin'));
```

Values come in the library's canonical units (kg, kcal, m, m/s, W, mmHg, °C, L, mmol/L, percent; durations in milliseconds). Without `PermissionReadHistory()` Health Connect returns data from 30 days before the first grant onwards, and a type that needs a missing feature fails with `NotAvailable`.

### Write

Every Health Connect record is writable by the app that holds its write permission. A sample without a `clientRecordId` gets a random one on insert, so you can update and delete it later without reading it back.

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final inserted = await HealthConnectReporter.insert([
  Steps(
    startTimestamp: now - 3600000,
    endTimestamp: now,
    harmonized: const StepsHarmonized(count: 1200),
    clientRecordId: 'steps-2026-10-10-09',
    clientRecordVersion: 1,
  ),
  Weight(startTimestamp: now, harmonized: const WeightHarmonized(weight: 72.5)),
]);
print(inserted.map((e) => e.id)); // Health Connect ids, in input order

// a higher clientRecordVersion replaces the record with that clientRecordId
await HealthConnectReporter.update([
  Steps(
    startTimestamp: now - 3600000,
    endTimestamp: now,
    harmonized: const StepsHarmonized(count: 1300),
    clientRecordId: 'steps-2026-10-10-09',
    clientRecordVersion: 2,
  ),
]);

await HealthConnectReporter.delete(inserted.last); // by id, else by clientRecordId
await HealthConnectReporter.deleteByIds(HealthType.steps, clientRecordIds: ['steps-2026-10-10-09']);
await HealthConnectReporter.deleteByRange(HealthType.weight, TimeRange.lastDays(1));
```

### Observe changes

An anchor is a position in Health Connect's change history. Store it, and read only what changed since:

```dart
var anchor = await HealthConnectReporter.anchor({HealthType.steps, HealthType.heartRate});
// later
final changeSet = await HealthConnectReporter.changes(anchor);
print('${changeSet.upserted.length} upserted, ${changeSet.deletedIds.length} deleted');
anchor = changeSet.anchor; // store it for the next call
```

While the app runs, `observe` polls on an event channel of its own, first right away, and reports every non-empty change set:

```dart
final subscription = HealthConnectReporter.observe(
  anchor,
  interval: const Duration(minutes: 1),
  onUpdate: (changeSet) => anchor = changeSet.anchor,
  onError: (error) => print(error), // polling stops, e.g. on AnchorExpired
);
// cancel to stop polling
await subscription.cancel();
```

Health Connect keeps changes for 30 days: an older anchor fails with `AnchorExpired`, so read the data again in full and take a new anchor.

#### Background sync

`observe` polls only while the Flutter engine runs. To sync in the background, schedule a periodic task with [workmanager](https://pub.dev/packages/workmanager) and read the changes of your stored anchor there; reading in the background needs `PermissionReadInBackground()` (check `Feature.readHealthDataInBackground` first) and its manifest entry `android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND`.

```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    final anchor = Anchor(token: await loadToken()); // your storage
    final changeSet = await HealthConnectReporter.changes(anchor);
    await upload(changeSet); // your sync
    await saveToken(changeSet.anchor.token);
    return true;
  });
}

// once, after the user granted the permissions
await Workmanager().initialize(callbackDispatcher);
await Workmanager().registerPeriodicTask('health-sync', 'health-sync',
    frequency: const Duration(minutes: 15));
```

Errors arrive as `PlatformException`s whose `code` is the method name and whose `details` name the error: `NotAuthorized`, `InvalidType`, `InvalidValue`, `NotAvailable`, `AnchorExpired` or `Platform`.

## Example

`example/` lists every plugin method, grouped like the library (Manager, Reader, Aggregates, Writer, Observer); tap a row to run it. Its manifest declares every health permission, the permissions-rationale activity and the `VIEW_PERMISSION_USAGE` alias, so it doubles as a setup reference.

`example/integration_test/catalog_test.dart` runs every row on an Android 14+ phone. Grant the permissions once from the app's `requestPermissions` row, then:

```bash
cd example
flutter test integration_test --no-uninstall -d <device-id>
```

## License

[MIT](LICENSE)
