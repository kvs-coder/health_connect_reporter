# 2. The permission screen runs on the plugin's activity

Date: 10.10.2026

## Status

Accepted. Ships with 1.0.0.

## Context

HealthConnectReporter offers two ways to show Health Connect's permission screen: `manager.requestPermissions(activity, permissions)`, which needs a `ComponentActivity` and registers on its activity result registry, and `manager.permissionContract()`, an `ActivityResultContract` for the app to launch. A Flutter app's activity is usually a plain `FlutterActivity`, which is no `ComponentActivity`; asking every app to switch to `FlutterFragmentActivity` would make the plugin's setup harder than its siblings'.

## Decision

- The plugin is `ActivityAware` and registers a `PermissionLauncher` as the activity binding's result listener.
- `PermissionLauncher` launches the library's `permissionContract()` by hand: `getSynchronousResult`, then `createIntent` (which rejects empty or undeclared permissions with `InvalidValue`), `startActivityForResult` with a request code of the plugin, and `parseResult` when the result arrives.
- Before launching, `ReporterHealthConnect` checks each permission's feature the way `HealthConnectManager.requestPermissions` does and fails with `NotAvailable`.
- `openInstall` builds the Google Play intent of `HealthConnectManager.installIntent` itself, since the manager needs a connection, which fails exactly when Health Connect must be installed or updated.

## Consequences

- Apps keep a plain `FlutterActivity` and add nothing for permissions but their manifest entries.
- The feature check and the install intent duplicate small parts of the library; a connection-free `installIntent(context)` in HealthConnectReporter would remove the latter.
- Requesting permissions needs an attached activity; without one it fails with `Platform`.
