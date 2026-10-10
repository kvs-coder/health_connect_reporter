# health_connect_reporter

[![CI](https://github.com/kvs-coder/health_connect_reporter/actions/workflows/ci.yml/badge.svg)](https://github.com/kvs-coder/health_connect_reporter/actions/workflows/ci.yml)

## About

A Flutter plugin that reads, writes and observes [Android Health Connect](https://developer.android.com/health-and-fitness/guides/health-connect) data. It wraps the Kotlin library [HealthConnectReporter](https://github.com/kvs-coder/HealthConnectReporter) and hands you its payloads as plain Dart models.

Its siblings are [health_kit_reporter](https://pub.dev/packages/health_kit_reporter) for Apple Health and [samsung_health_reporter](https://pub.dev/packages/samsung_health_reporter) for Samsung Health.

> **Status**: under construction. Only `availability` exists; the manager, reader, writer and observer follow (see `AGENTS.md`). Nothing is released yet.

## Requirements

- Android 8 (API 26) or later. Health Connect is part of Android 14+; on Android 9–13 the user installs the Health Connect app from Google Play.
- Flutter 3.44+, Java 17.

## Installation

```yaml
dependencies:
  health_connect_reporter: ^0.0.0 # x-release-please-version
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
    // send the user to Health Connect on Google Play
    break;
  case Availability.unavailable:
    // Health Connect does not run on this device
    break;
}
```

Errors arrive as `PlatformException`s whose `code` is the method name and whose `details` name the error: `NotAuthorized`, `InvalidType`, `InvalidValue`, `NotAvailable`, `AnchorExpired` or `Platform`.

## License

[MIT](LICENSE)
