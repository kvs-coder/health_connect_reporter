# health_connect_reporter — Architecture (arc42)

The architecture of the Flutter plugin `health_connect_reporter`, following the [arc42](https://arc42.org) template. Conventions and rules live in [AGENTS.md](../../AGENTS.md); decisions in [doc/adr/](../adr/).

## 1. Introduction and Goals

`health_connect_reporter` gives Flutter apps on Android access to Health Connect. It exposes the Kotlin library [HealthConnectReporter](https://github.com/kvs-coder/HealthConnectReporter) 1.0.0 to Dart as the static API `HealthConnectReporter`.

**Requirements**

| Area | Dart methods | State |
| :--- | :--- | :--- |
| Facade | `availability` | done |
| Manager | `requestPermissions`, `grantedPermissions`, `revokeAllPermissions`, `isFeatureAvailable`, `openSettings`, `openInstall` | done |
| Reader | `read`, `readPage`, `readById`, `aggregate`, `aggregateGroups` | done |
| Writer | `insert`, `update`, `delete`, `deleteByIds`, `deleteByRange` | done |
| Observer | `anchor`, `changes`, `observe` (live subscription) | done |

**Quality goals**

1. **Fidelity**: the plugin mirrors the library 1:1 — methods, types, JSON and errors.
2. **Testability**: every Dart method is tested against mocked channels, every Kotlin path against a mocked `HealthConnect`.
3. **Parity**: shapes and names match samsung_health_reporter wherever Health Connect allows it.

**Stakeholders**

| Stakeholder | Expectation |
| :--- | :--- |
| Flutter app developers | Typed Dart models and one call per library method; setup no harder than a manifest |
| Maintainer | Changes in HealthConnectReporter map 1:1 onto the plugin; green gates before every release |
| Google Play review | Declared permissions, a privacy policy screen and the permission-usage alias |

## 2. Architecture Constraints

| Constraint | Consequence |
| :--- | :--- |
| Health Connect is Android only | The plugin is Android only; elsewhere `availability` is `unavailable` and every other method throws `UnsupportedError` |
| connect-client 1.1.0 needs Android 8 | `minSdk = 26`; Health Connect is built into Android 14+ and an app from Google Play on Android 9–13 |
| HealthConnectReporter 1.0.0 from JitPack | The app adds `maven("https://jitpack.io")`; Java/JVM 17 |
| Flutter 3.44+ / Dart 3.5+ | SDK constraints in `pubspec.yaml` |
| Health Connect ignores undeclared permissions | The app declares every `android.permission.health.*` it requests, the rationale activity and the `VIEW_PERMISSION_USAGE` alias; the plugin's manifest adds nothing |
| `FlutterActivity` has no activity result registry | The permission screen starts with `startActivityForResult` ([ADR 0002](../adr/0002-permission-screen-on-the-plugin-activity.md)) |

## 3. System Scope and Context

```mermaid
flowchart LR
    app["Flutter app (Dart)"]
    plugin["health_connect_reporter<br/>(Dart API + Kotlin bridge)"]
    lib["HealthConnectReporter 1.0.0<br/>(Kotlin, JitPack)"]
    client["connect-client 1.1.0"]
    hc["Health Connect"]
    pub["pub.dev"]

    app -- "static methods,<br/>models" --> plugin
    plugin -- "library calls" --> lib
    lib -- "client calls" --> client
    client -- "IPC" --> hc
    plugin -. "published to" .-> pub
```

| Neighbour | Interface |
| :--- | :--- |
| Flutter app | `HealthConnectReporter` static methods, models in `lib/model/`, `PlatformException` errors |
| HealthConnectReporter | Kotlin API (`manager`, `reader`, `writer`, `observer`), payloads with `json` and `make(from:)` |
| Health Connect / connect-client | Owned by the library; plugin Kotlin never imports `androidx.health.connect.client` |

## 4. Solution Strategy

- **Thin bridge over one library**: mapping records to payloads happens in HealthConnectReporter; the plugin only moves arguments and replies across the channel.
- **JSON as contract**: payloads cross as the library's `json`; Dart parses them into immutable models and sends their `map`s back, which Kotlin reads with `make(from:)` (sealed non-payloads like `Permission` and `TimeGroup` through kotlinx.serialization). Dart's nulls mean absent ([ADR 0003](../adr/0003-dart-nulls-mean-absent.md)).
- **One method channel, one event channel per subscription**: one-shot calls share `health_connect_reporter_method_channel`; each `observe` gets its own channel, so subscriptions never share polling.
- **Testing seam**: the dispatcher talks to the `HealthConnect` interface, which unit tests mock.

## 5. Building Block View

### Level 1

```mermaid
flowchart TB
    subgraph Dart["Dart (lib/)"]
        api["HealthConnectReporter<br/>static API"]
        models["Models<br/>payloads, types, sealed models"]
        deco["decorator/<br/>platform, parse helpers, subscribe"]
        api --> models
        api --> deco
    end
    subgraph Kotlin["Kotlin (android/src/main/kotlin)"]
        plugin["HealthConnectReporterPlugin"]
        disp["HealthConnectDispatcher"]
        hc["HealthConnect<br/>(interface)"]
        rep["ReporterHealthConnect"]
        plugin --> disp
        disp --> hc
        rep -. implements .-> hc
    end
    lib["HealthConnectReporter 1.0.0"]
    api -- "MethodChannel" --> plugin
    deco -- "EventChannel per observe" --> plugin
    rep --> lib
```

### Level 2: Kotlin bridge

```mermaid
flowchart LR
    plugin["HealthConnectReporterPlugin<br/>FlutterPlugin + ActivityAware"]
    disp["HealthConnectDispatcher<br/>Method enum, MainScope"]
    maps["Extensions+Map<br/>argument readers, make(from:)"]
    json["Extensions+Payload<br/>JSON replies, error kinds"]
    perm["Extensions+Permission<br/>permission features"]
    launcher["PermissionLauncher<br/>ActivityResultListener"]
    handler["ObserveStreamHandler<br/>per subscription"]
    rep["ReporterHealthConnect<br/>lazy HealthConnectReporter"]

    plugin -- "method channel handler" --> disp
    plugin -- "result listener on the activity binding" --> launcher
    plugin -- "opens / closes event channels" --> handler
    disp --> maps
    disp --> json
    disp -- "observe" --> handler
    disp --> rep
    rep --> launcher
    rep --> perm
```

### Level 2: Dart models

```mermaid
classDiagram
    class Payload {
        <<mixin>>
        map
        ==()
        hashCode
    }
    class Sample~Harmonized~ {
        <<abstract>>
        startTimestamp
        endTimestamp
        harmonized
        id
        clientRecordId
        clientRecordVersion
        healthType
        factory(json)$
    }
    class WritableSample~Harmonized~ {
        <<abstract>>
    }
    class HeartRate
    class HeartRateHarmonized
    class IntermenstrualBleeding
    class Permission {
        <<sealed>>
        factory(json)$
        of(types, access)$
    }
    class TimeGroup {
        <<sealed>>
    }
    class ChangeSet
    class Anchor
    class Page

    Payload <|.. Sample
    Sample <|-- WritableSample
    WritableSample <|-- HeartRate : 41 payloads
    WritableSample <|-- IntermenstrualBleeding : harmonized Null
    HeartRate *-- HeartRateHarmonized
    Payload <|.. Permission
    Payload <|.. TimeGroup
    Payload <|.. ChangeSet
    Payload <|.. Page
    ChangeSet *-- Anchor
    ChangeSet o-- Sample : upserted
    Page o-- Sample : items
```

`Sample.factory` picks the payload by the `type` discriminator (`HealthType.identifier`); `Permission`, `TimeGroup`, `CompletionGoal` and `PerformanceTarget` do the same by their own `type`. Enums implement `ValueEnum` with the Kotlin name as `value`.

### Blocks

| Block | Where | Responsibility |
| :--- | :--- | :--- |
| `HealthConnectReporter` | `lib/health_connect_reporter.dart` | Static Dart API; Android check before any channel call. |
| Models | `lib/model/` | Plain Dart models parsed from the library's JSON: 41 payloads, 25 enums, sealed permissions, time groups, goals and targets. |
| `subscribe` | `lib/model/decorator/subscription.dart` | One event channel per `observe` subscription. |
| `HealthConnectReporterPlugin` | `android/src/main/kotlin/…` | Channel setup, plugin-owned `MainScope`, event channels, activity binding. |
| `HealthConnectDispatcher` | same | One `Method` case per Dart method; replies JSON, errors as `PlatformException`. |
| `HealthConnect` / `ReporterHealthConnect` | same | Library calls behind an interface, faked in unit tests, over one lazily connected `HealthConnectReporter`. |
| `PermissionLauncher` | same | The library's permission contract on the attached activity, resumed by the activity result listener. |
| `ObserveStreamHandler` | same | Collects one subscription's change sets while Dart listens. |
| `Extensions+Map` / `+Payload` / `+Permission` | same | Argument readers, JSON replies and error kinds, permission features. |

### Example app (`example/`)

A catalog of every method (BLoC on plain streams, no packages) and `integration_test/catalog_test.dart`, which runs every row on a phone. Its manifest is the reference setup: every health permission, the rationale activity and the usage alias.

## 6. Runtime View

### One-shot call: `read`

```mermaid
sequenceDiagram
    autonumber
    participant App as Flutter app
    participant Api as HealthConnectReporter (Dart)
    participant Disp as HealthConnectDispatcher
    participant Rep as ReporterHealthConnect
    participant Lib as HealthConnectReporter (library)

    App->>Api: read(type, range, ordering, limit, origins)
    Api->>Api: requirePlatform(android)
    Api->>Disp: invokeMethod('read', {type, range: map, ordering, limit, origins: [map]})
    Disp->>Disp: launch in MainScope, read arguments (TimeRange.make, DataOrigin.make)
    Disp->>Rep: read(...)
    Rep->>Lib: reporter.reader.read(...) (connects on first use)
    Lib-->>Rep: List<Sample>
    Rep-->>Disp: List<Sample>
    Disp-->>Api: result.success(JSON array)
    Api->>Api: Sample.collect(jsonDecode(json))
    Api-->>App: List<Sample>
```

### Write: `insert`, then `update`

```mermaid
sequenceDiagram
    autonumber
    participant App as Flutter app
    participant Api as HealthConnectReporter (Dart)
    participant Disp as HealthConnectDispatcher
    participant Lib as HealthConnectWriter (library)

    App->>Api: insert([Steps(clientRecordId: null, ...)])
    Api->>Disp: invokeMethod('insert', {samples: [sample.map]})
    Disp->>Disp: drop nulls, Steps.make(map) per type
    Disp->>Lib: insert(samples)
    Lib->>Lib: random clientRecordId where missing
    Lib-->>Disp: samples with id and clientRecordId
    Disp-->>Api: JSON array
    Api-->>App: List<WritableSample>
    App->>Api: update([Steps(clientRecordId, clientRecordVersion + 1, ...)])
    Api->>Disp: invokeMethod('update', {samples: [map]})
    Disp->>Lib: update(samples)
    Lib->>Lib: upsert by clientRecordId, else update by id
    Lib-->>Disp: Unit
    Disp-->>Api: true
```

### Permission screen: `requestPermissions`

```mermaid
sequenceDiagram
    autonumber
    participant App as Flutter app
    participant Api as HealthConnectReporter (Dart)
    participant Disp as HealthConnectDispatcher
    participant Rep as ReporterHealthConnect
    participant L as PermissionLauncher
    participant Act as FlutterActivity

    App->>Api: requestPermissions(permissions)
    Api->>Disp: invokeMethod('requestPermissions', {permissions: [map]})
    Disp->>Rep: requestPermissions(Set<Permission>)
    Rep->>Rep: check each permission's feature (NotAvailable)
    Rep->>L: launch(manager.permissionContract(), permissions)
    L->>L: contract.createIntent (InvalidValue when undeclared)
    L->>Act: startActivityForResult(intent, code)
    Act-->>L: onActivityResult(code, result) via the binding's listener
    L-->>Rep: contract.parseResult → granted
    Rep-->>Disp: Set<Permission>
    Disp-->>Api: JSON array
    Api-->>App: Set<Permission>
```

### Live subscription: `observe` and cancel

```mermaid
sequenceDiagram
    autonumber
    participant App as Flutter app
    participant Sub as subscribe (Dart)
    participant Disp as HealthConnectDispatcher
    participant Plugin as HealthConnectReporterPlugin
    participant H as ObserveStreamHandler
    participant Rep as ReporterHealthConnect

    App->>Sub: observe(anchor, interval, onUpdate, onError)
    Sub->>Disp: invokeMethod('observe', {anchor, interval})
    Disp->>Rep: observe(anchor, interval) → Flow (InvalidValue when not positive)
    Disp->>Plugin: open(name, ObserveStreamHandler)
    Disp-->>Sub: "health_connect_reporter_event_channel_observe_<uuid>"
    Sub->>H: EventChannel(name).listen → onListen
    loop every interval, first right away
        Rep-->>H: non-empty ChangeSet
        H-->>Sub: events.success(json)
        Sub-->>App: onUpdate(ChangeSet)
    end
    App->>Sub: subscription.cancel()
    Sub->>H: onCancel → cancel job
    H->>Plugin: close(name)
    Note over H,Sub: A polling error (e.g. AnchorExpired) ends polling: events.error('observe', message, kind) → onError
```

## 7. Deployment View

```mermaid
flowchart TB
    subgraph Phone["Android phone (Android 8+)"]
        subgraph AppProc["Flutter app (APK)"]
            dart["Dart: app + health_connect_reporter"]
            kotlin["Kotlin: plugin + HealthConnectReporter + connect-client"]
            dart <-- "platform channels" --> kotlin
        end
        hc["Health Connect (system on 14+, Play app on 9–13)"]
        kotlin <-- "IPC" --> hc
    end
    jitpack["JitPack"] -. "build: HealthConnectReporter 1.0.0" .-> kotlin
    pubdev["pub.dev"] -. "build: health_connect_reporter" .-> dart
```

**Delivery pipeline** (`.github/workflows/`):

```mermaid
flowchart LR
    push["push / PR to master"] --> ci["ci.yml<br/>Version / Changelog · Analyze / Test (coverage ≥ 90 %)<br/>· Android (Gradle build, Kotlin tests, ktlint)"]
    push --> rel["release.yml<br/>release-please keeps a release PR open"]
    rel -- "merge release PR → tag vX.Y.Z" --> pub["publish.yml<br/>OIDC → pub.dev"]
    phone["Pixel / Android 14+ phone"] -. "manual: integration_test/catalog_test.dart" .-> ci
```

master is protected: pull requests, all three CI jobs, linear history, no force pushes.

## 8. Crosscutting Concepts

- **JSON contract**: keys and value shapes follow the library exactly — timestamps epoch milliseconds, zone offsets seconds, one canonical unit per field, enums by Kotlin name or `@SerialName`, a sample's `type` = `HealthType.identifier`. Lists reply as JSON arrays; `readPage` replies `{"items":[...],"nextPageToken":"..."}`.
- **Identity**: `id` names the stored record, `clientRecordId` / `clientRecordVersion` the app's own key and version; update upserts by client record id first, else by id; update and delete send the sample's `map` with all three.
- **Errors**: every failure is a `PlatformException` — `code` the method name, `message` the library's message, `details` the kind as a `String`: `NotAuthorized`, `InvalidType`, `InvalidValue`, `NotAvailable`, `AnchorExpired` or `Platform`. Observe errors arrive on `onError` with code `observe`.
```mermaid
flowchart LR
    ex["HealthConnectException"] --> k{"kind"}
    k --> na["NotAuthorized"]
    k --> it["InvalidType"]
    k --> iv["InvalidValue"]
    k --> nv["NotAvailable"]
    k --> ae["AnchorExpired"]
    k --> pl["Platform"]
    other["any other Exception"] --> cls["its class name"]
    na & it & iv & nv & ae & pl & cls --> pe["PlatformException<br/>code = method · message · details = kind"]
    pe --> call["Future error"]
    pe --> ev["observe: onError"]
```

- **Threads**: calls run in the plugin's `MainScope`; results and events are delivered on the platform thread.
- **Connection**: `ReporterHealthConnect` creates the `HealthConnectReporter` on the first call that needs it and retries after a failure; `availability` and `openInstall` need none.
- **Platform guard**: `availability` is `unavailable` outside Android; every other method throws `UnsupportedError` before any channel call.
- **Parsing**: numbers through `parseInt` / `parseDouble` / `parseNum`; optional and later-added fields are nullable; unknown sample, permission, group, goal or target types throw `InvalidValueException`.
- **Testing**: fixtures are the JSON the library encodes for its own test fixtures (`test/fixtures.dart`, `android/src/test/.../Fixtures.kt`); Dart API tests against mocked channels; Kotlin dispatcher, launcher and stream handler tests against mocks (JUnit 5, MockK).

## 9. Architecture Decisions

| ADR | Decision |
| :--- | :--- |
| [0001](../adr/0001-health-connect-reporter-for-flutter.md) | A Flutter plugin of its own for Health Connect |
| [0002](../adr/0002-permission-screen-on-the-plugin-activity.md) | The permission screen runs on the plugin's activity through the activity result listener |
| [0003](../adr/0003-dart-nulls-mean-absent.md) | Dart's nulls in argument maps mean absent |

## 10. Quality Requirements

| Quality | Scenario | Measure |
| :--- | :--- | :--- |
| Fidelity | A library payload is read, sent back for update and deleted | Every fixture round-trips to the library's exact JSON in Dart, and every type's map is read back by `make(from:)` to the same JSON in Kotlin |
| Correctness | Every Dart method sends its arguments and parses its reply or error | API tests per method; Kotlin dispatcher tests per `Method` |
| Coverage | A change lowers test coverage of `lib/` | CI fails below 90 % line coverage |
| Isolation | Two subscriptions; one is cancelled | Separate event channels and coroutine jobs; the other keeps polling |
| Robustness | Health Connect is missing or lacks a feature | `availability` reports it; calls fail with `NotAvailable`, no crash |
| Style | Kotlin or Dart change | ktlint 1.8.0 and `flutter analyze` clean in CI |

## 11. Risks and Technical Debt

| Risk / debt | Impact | Mitigation |
| :--- | :--- | :--- |
| `openInstall` builds HealthConnectManager's Google Play intent itself, since the manager needs a connection that fails exactly when Health Connect must be installed | The intent can drift from the library's | Add a connection-free `installIntent(context)` to HealthConnectReporter and forward it |
| The permission screen can't be driven from a test | `requestPermissions` on a device is checked by hand; `PermissionLauncher` is unit-tested | Run the example's `requestPermissions` row before a release |
| Integration tests need a phone with Health Connect | `integration_test/catalog_test.dart` runs manually, not in CI | Run it before dispatcher changes (AGENTS.md §6D) |
| Dependency on a single library version from JitPack | JitPack outage or library changes break builds and the JSON contract | Pinned to 1.0.0; library changes are mirrored deliberately |

## 12. Glossary

| Term | Meaning |
| :--- | :--- |
| Health Connect | Android's on-device store for health and fitness data |
| HealthConnectReporter | The Kotlin library wrapping connect-client; the plugin's only native dependency |
| `HealthType` | A Health Connect record type, e.g. `HEART_RATE`; carries its `identifier`, `isWritable` and `feature` |
| `Feature` | A Health Connect capability older versions may lack, e.g. skin temperature or reading in the background |
| Sample / `WritableSample` | A stored record; every Health Connect record is writable |
| `id` / `clientRecordId` | Health Connect's id of a record / the app's own key for it, with `clientRecordVersion` |
| Aggregation | A summary Health Connect computes, e.g. `STEPS_COUNT_TOTAL`, optionally grouped by `TimeGroup` |
| `Anchor` / `ChangeSet` | A position in the change history / the upserts, deletions and next anchor since one |
| Observe subscription | A polled stream of `ChangeSet`s on its own event channel |
| Epoch milliseconds | The timestamp format of every time field |
