# 1. A Flutter plugin of its own for Health Connect

Date: 10.10.2026

## Status

Accepted.

## Context

Flutter apps on Android need Health Connect, which the Kotlin library [HealthConnectReporter](https://github.com/kvs-coder/HealthConnectReporter) 1.0.0 wraps over `androidx.health.connect:connect-client` 1.1.0. Its siblings already exist as separate plugins: [health_kit_reporter](https://github.com/kvs-coder/health_kit_reporter) (Apple Health) and [samsung_health_reporter](https://github.com/kvs-coder/samsung_health_reporter) (Samsung Health); samsung_health_reporter's ADR 0001 rejected merging providers into one package.

## Decision

- `health_connect_reporter` is an Android-only plugin, `HealthConnectReporter`, mirroring the library 1:1: its methods, types, JSON (epoch milliseconds, one canonical unit per field, enums by Kotlin name) and errors (`PlatformException` coded with the method name, the library's message, the error kind as `details`).
- It copies samsung_health_reporter's architecture: a static Dart API over one method channel, a Kotlin dispatcher behind a `HealthConnect` interface (faked in unit tests), one event channel per `observe` subscription, a BLoC example on plain streams, release-please and pub.dev publishing through OIDC.
- The plugin depends on HealthConnectReporter from JitPack; the app adds the JitPack repository and declares its health permissions, rationale activity and permission-usage alias.
- The permission screen runs through the library's `permissionContract()` on the plugin's activity, so apps keep a plain `FlutterActivity`.
- On any other platform `availability` returns `unavailable` and every other method throws an `UnsupportedError`.

## Consequences

- Apps that support several providers depend on each plugin and map the data they need themselves; identifiers equal samsung_health_reporter's where the concept matches.
- The first complete release is 1.0.0.
