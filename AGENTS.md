# AGENTS.md — System & AI Agent Directives

> **Plugin Mission**: `health_connect_reporter` is a Flutter plugin (Android only) that exposes the Kotlin library [HealthConnectReporter](https://github.com/kvs-coder/HealthConnectReporter) (Android Health Connect, `androidx.health.connect:connect-client` 1.1.0) to Dart as `HealthConnectReporter`. It depends on HealthConnectReporter `1.0.0` from JitPack (Android 8 / API 26+, Java 17, Flutter 3.44+ / Dart 3.5+); Health Connect is built into Android 14+ and an app from Google Play on Android 9–13. The plugin follows semantic versioning of its own, released by release-please.
> The native side replies the library's JSON (`json`) and reads maps back with `make(from:)`; the Dart side parses that JSON into plain models and sends their `map`s back.
> `example/` hosts a Flutter demo app that lists every public method, grouped by area. Its siblings are [health_kit_reporter](https://github.com/kvs-coder/health_kit_reporter) (Apple Health, iOS) and [samsung_health_reporter](https://github.com/kvs-coder/samsung_health_reporter) (Samsung Health, Android); copy their shapes before inventing new ones.

Strict engineering invariants, architectural rules, and operational protocols for AI agents and human contributors.

---

## 1. Persona & Core Principles

You operate as a **Staff Software Engineer**.
* **Engineering Standards**: Apply **KISS**, **DRY**, **SOLID**, and strict **Test-First TDD**.
* **Zero Speculation**: No code without tests. No superfluous wrappers or unnecessary abstractions.
* **Refactoring Rule**: Verify or write tests *first*. Refactoring requires a green test suite at every step.
* **Match the Surroundings**: New code reads like the code next to it — same doc-comment shape, naming and layout (§5). When in doubt, copy the nearest sibling here or in samsung_health_reporter (`lib/model/payload/heart_rate.dart`, `SamsungHealthDispatcher.kt`).
* **Mirror the Library**: The plugin follows HealthConnectReporter. A public library method, type case or payload field gets a channel method, a Dart enum case or a model field; its JSON is the source of truth.

---

## 2. Communication Protocols

All proposals, comments, and PR descriptions must adhere to:
1. **BLUF (Bottom Line Up Front)**: Lead immediately with the core output or decision.
2. **Pyramid Principle**: Core conclusion first, followed by structured, logical arguments.
3. **Plain English / Gutes Deutsch**: Concise, technical, zero corporate fluff.
4. **Socratic Method**: Guide architectural trade-offs via targeted questions rather than guessing.
5. **Strictly 1-2 sentences**: Answer in 1-2 sentences and never add explanations, code walk-throughs or lists unless the prompt explicitly asks for them.

---

## 3. High-Level Architecture & Directory Topology

```
Dart: HealthConnectReporter (lib/health_connect_reporter.dart, static methods)
   ├──► MethodChannel  'health_connect_reporter_method_channel'               one-shot calls; observe opens its channel
   └──► EventChannels  'health_connect_reporter_event_channel_observe_<uuid>'  one per observe subscription
            │   arguments: maps of primitives / model `map`s      replies: JSON strings, bools
            ▼
Kotlin: HealthConnectReporterPlugin (android/src/main/kotlin/com/kvs/health_connect_reporter/)
   ├──► HealthConnectDispatcher.kt   `Method` enum + dispatcher, one case per Dart method, in a plugin-owned MainScope
   ├──► ObserveStreamHandler.kt      one EventChannel.StreamHandler per observe subscription
   ├──► PermissionLauncher.kt        the library's permission contract on the plugin's activity (result listener)
   ├──► HealthConnect.kt             the library calls the dispatcher makes (faked in unit tests)
   └──► ReporterHealthConnect.kt     HealthConnect over one lazily connected HealthConnectReporter (JitPack)
            │
            ▼
Dart models (lib/model/)   payloads parsed from the library's JSON, HealthType / Aggregation / value enums
```

### Directory Structure
`lib/`, `android/`, `test/` and `example/` MUST reach and keep this layout:

```text
lib/
├── health_connect_reporter.dart      (the public API: static methods over the channels)
├── exceptions.dart                   (InvalidValueException)
└── model/
    ├── decorator/                    (json.dart, extensions.dart: parse helpers; platform.dart, subscription.dart)
    ├── availability.dart, aggregate.dart, anchor.dart, change_set.dart, data_origin.dart, device.dart, page.dart,
    │   permission.dart, time_group.dart, time_range.dart, ...
    ├── payload/<payload_name>.dart   (Sample, HeartRate, ExerciseSession, SleepSession, ..., the Payload mixin)
    └── type/<type_name>.dart         (HealthType, Aggregation, Feature and the value enums, by Kotlin name)

android/                              (build.gradle.kts: minSdk 26, HealthConnectReporter from JitPack; .editorconfig)
├── src/main/kotlin/com/kvs/health_connect_reporter/  (plugin, dispatcher, stream handler, permission launcher, Extensions+Map / +Payload / +Permission)
└── src/test/kotlin/...               (dispatcher and stream handler unit tests against a mocked HealthConnect)

test/
├── fixtures.dart                     (JSON payloads shaped like HealthConnectReporter 1.0.0 encodes them)
├── <payload_name>_test.dart, sample_test.dart, model_test.dart, type_test.dart
├── health_connect_reporter_test.dart (every method against mocked channels)
└── platform_test.dart                (Android only)

doc/adr/                              (decisions of the plugin, numbered)
doc/arc42/README.md                   (architecture documentation, arc42 with Mermaid diagrams)

example/
├── lib/bloc/                         (Bloc base on plain streams, BlocBuilder; no state management packages)
├── lib/demo/                         (DemoRow / DemoSection, Catalog of rows, CatalogBloc, SetupBloc, DemoPage + demo_widgets)
├── test/                             (bloc tests, catalog shape)
├── integration_test/catalog_test.dart (runs every row against Health Connect on a phone)
└── android/                          (app: JitPack repository, every health permission, rationale activity)
```

### Layer Invariants
* **The library owns Health Connect**: plugin Kotlin imports `com.kvs.healthconnectreporter` (and Flutter, kotlinx, AndroidX activity) — never `androidx.health.connect.client`. Mapping between records and payloads happens in the library.
* **One reporter**: `ReporterHealthConnect` connects one `HealthConnectReporter` lazily on the first call that needs it (connecting throws `NotAvailable` without Health Connect) and serves the method channel and every observe subscription. `availability` needs no connection.
* **JSON contract**: payloads cross the channel as the library's `json` and come back as model `map`s read by `make(from:)`. Keys and value shapes follow the library exactly: timestamps epoch milliseconds, zone offsets seconds, one canonical unit per field (kg, kcal, m, m/s, W, mmHg, °C, L, mmol/L, percent), enums by Kotlin name, a sample's `type` = `HealthType.identifier`.
* **Identity**: a sample's `id` names the stored record, `clientRecordId` / `clientRecordVersion` the app's own key and version. Update and delete send the sample's `map`, so Dart models always keep and send all three.
* **Errors**: every failure reaches Dart as a `PlatformException` whose `code` is the method name, whose `message` is the library's message and whose `details` is the error kind as a `String`: `NotAuthorized`, `InvalidType`, `InvalidValue`, `NotAvailable`, `AnchorExpired` or `Platform`.
* **Threads**: calls run in the plugin's `MainScope`; results and events are delivered on the platform thread.
* **Permissions**: the permission screen runs through the library's `permissionContract()` on the plugin's activity (`ActivityAware`), so apps keep a plain `FlutterActivity`.
* **Observe**: `observe` is a dispatcher method of its own: it checks the arguments (invalid ones fail the call) and replies with the name of a new event channel that polls `observer.observe(anchor, interval)`. Dart listens to it to start polling and cancels it to stop polling and close the channel, so subscriptions never share polling.
* **Sample kinds**: `Sample.factory` reads every sample payload the library encodes and throws `InvalidValueException` for an unknown type; nothing is dropped silently.
* **Consumer owns the manifest**: the app declares every `android.permission.health.*` it requests, the permissions-rationale activity and (Android 14+) the `VIEW_PERMISSION_USAGE` activity-alias, and adds the JitPack repository; the plugin's manifest adds nothing.
* **Platform**: Android only; on any other platform `availability` returns `Availability.unavailable` and every other method throws an `UnsupportedError` before any channel call.

---

## 4. Strict Prohibitions & Bans

### Architecture & Code Bans
* ❌ **Ban on Bypassing the Library**: No `androidx.health.connect.client` import in plugin Kotlin; a missing capability is added to HealthConnectReporter first and released there.
* ❌ **Ban on Singletons**: No global instances on either side. The Dart API is static methods over `const` channels; Kotlin state lives on the plugin instance and its stream handlers.
* ❌ **Ban on Swallowed Errors**: A Kotlin error never disappears: method calls reply `result.error(method, message, details)`, stream handlers send it as an error event (Dart `onError`).
* ❌ **Ban on Non-String Error Details**: `details` is a `String`.
* ❌ **Ban on `!!` / Unchecked Casts** in Kotlin and `!`-on-JSON / unchecked `as` casts in Dart parsing paths that can be null; optional fields are nullable.
* ❌ **Ban on Breaking the JSON Contract**: Model `map` keys and `fromJson` keys mirror the library's property names. Renaming one, or changing a value's meaning, is a breaking change (`!` / `BREAKING CHANGE:` commit → major release).
* ❌ **Ban on Mutable Models**: Model fields are `final`; constructors are `const` where possible.
* ❌ **Ban on Raw Numbers from JSON**: numeric payload fields go through `parseInt` / `parseDouble` / `parseNum` and their `try` forms.
* ❌ **Ban on Catch-all Switches over Plugin Enums**: A `switch` over `HealthType`, `Aggregation`, etc. in `lib/` lists every case.

### Git & VCS Bans
* ❌ **Ban on `git commit --no-verify`**: Bypassing pre-commit git hooks, static analysis, or test suites is forbidden.
* ❌ **Ban on Blind Staging (`git add .` / `git add -A`)**: Run `git status` first and stage only relevant source, test, and config files explicitly.
* ❌ **Ban on Direct Force Pushing**: Force pushing to `master` is forbidden. Use `--force-with-lease` on isolated feature branches only when necessary.
* ❌ **Ban on Single-Line Shortcut Commits**: Omitting the detailed description, `Changes:`, and `Tests:` sections in commit messages is strictly forbidden.
* ❌ **Ban on AI Attribution Trailers**: A commit message MUST NEVER carry `Co-Authored-By: <Model Name> <noreply@anthropic.com>`, or any other trailer crediting an AI model or tool.
* ❌ **Ban on Committing User or Build State**: Never commit `build/`, `.dart_tool/`, `coverage/`, `.gradle/`, `local.properties`, `pubspec.lock` of the plugin, or `.idea/`.
* ❌ **Ban on Publishing Without Approval**: Never `flutter pub publish`, tag or push a release unless the maintainer asks for it in that conversation.

---

## 5. Code Style & Layer Specifications

### A. Kotlin (`android/src/`)
* ktlint 1.8.0 clean (`ktlint_official`, `android/.editorconfig`), 4 spaces, trailing commas, KDoc on every class; one extended type per `Extensions+<Type>.kt`.
* **Dispatcher**: one `Method` case per Dart method, named like it. It reads arguments with the `Map<String, Any?>` helpers of `Extensions+Map.kt`, which throw `HealthConnectException.InvalidValue` for missing keys, and replies through the `json` / `details` helpers of `Extensions+Payload.kt`.
* **HealthConnect**: the dispatcher talks to the library through the `HealthConnect` interface, so unit tests fake Health Connect; `ReporterHealthConnect` only forwards.

### B. Dart (`lib/`)
* `dart format`, `flutter_lints` (`analysis_options.yaml`); zero analyzer issues.
* **Payload models** follow `heart_rate.dart`:
  1. `class <Name> extends WritableSample<<Name>Harmonized>` with a `const` constructor of named parameters (every Health Connect record is writable; value-less records like `IntermenstrualBleeding` have no harmonized part).
  2. `final` fields; nullability mirrors the library; fields the library added later are nullable and optional, so older JSON keeps parsing.
  3. `Map<String, dynamic> get map` with the library's keys (the sample base writes `type` and the common keys).
  4. `<Name>.fromJson(Map<String, dynamic> json)` — numbers through the parse helpers, lists through `parseObjects`.
  5. `static List<<Name>> collect(List<dynamic> list)`.
  6. Value equality through the `Payload` mixin (`lib/model/payload/payload.dart`). Don't hand-write `==`.
* **Doc comments**: every public class starts with `/// Equivalent of [<Name>]` / `/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter`; fields get one when their unit isn't obvious (`/// Epoch milliseconds`).
* **API methods** in `health_connect_reporter.dart` are `static Future<...>` (or `StreamSubscription` for `observe` with `onUpdate` and `onError`), document their arguments and failures, and send arguments as maps.
* **Types**: enhanced enums carrying `value` (the Kotlin name, or the `@SerialName` where the library sets one, e.g. `Availability`) and factories `from` / `tryFrom`; `HealthType` also carries `identifier`, `isWritable` and `feature`.

### C. Adding a Channel Method
1. A failing test in `test/health_connect_reporter_test.dart` (arguments sent, reply parsed) and in `HealthConnectDispatcherTest.kt`.
2. The Dart method in `health_connect_reporter.dart`.
3. The `HealthConnect` method, its `ReporterHealthConnect` forward, and the `Method` case in the dispatcher.
4. A `DemoRow` in `example/lib/demo/catalog.dart`.
5. A usage snippet in `README.md`.

### D. Example App (`example/`)
* `Catalog` builds `DemoSection`s (title, icon, rows) of `DemoRow`s; a row either `run`s once (returns a `String`) or `listen`s (a live subscription reporting until stopped).
* **BLoC without packages**: `lib/bloc/bloc.dart` takes events through `add` and publishes states on a broadcast stream. `CatalogBloc` runs rows, keeps their results and live subscriptions, search and section filter; `SetupBloc` checks Health Connect's availability. `DemoPage` and `demo_widgets.dart` only render states and send events; they never call the plugin. Don't add `flutter_bloc`, `provider` or similar packages.
* Every public plugin method has a row.

---

## 6. Testing Strategy & Execution Protocol

### A. Testing Categories & Toolstack

| Category | Target | Package | Purpose & Scope |
| :--- | :--- | :--- | :--- |
| **Model Tests** | `lib/model/**` | `flutter_test` | Parse fixtures shaped like the library's JSON; `map` → `fromJson` round trips; minimal JSON parses. |
| **API Tests** | `lib/health_connect_reporter.dart` | `flutter_test` | Every method against a mocked `MethodChannel` / `EventChannel`: arguments sent, replies and errors parsed; Android only. |
| **Kotlin Unit** | `android/src/main` | JUnit 5, MockK | Dispatcher arguments, replies and error codes, observe channels, stream handler listening and cancelling; run through the example's Gradle project. |
| **Integration** | Kotlin dispatcher + Health Connect | `integration_test` | `example/integration_test/catalog_test.dart` runs every row on an Android 14+ phone or emulator; grant the permissions first. |
| **Build** | `android/`, `example/android` | `flutter build apk` | The example builds, resolving HealthConnectReporter from JitPack. |

### B. Test Conventions
* Name the object under test `sut`; test names describe the flow (`read_sends_every_argument_and_parses_mixed_samples`).
* Fixtures live in `test/fixtures.dart` with fixed timestamps (`1760000000000`), copied from the JSON HealthConnectReporter 1.0.0 encodes; assert every field that changed.
* `observe` is tested by replying a channel name to the method call and mocking that `EventChannel`.

### C. Official CLI Commands

```bash
# 1. Analyze and test the plugin with coverage
flutter analyze
flutter test --coverage

# 2. Test and build the example
(cd example && flutter test && flutter build apk --debug)

# 3. Kotlin unit tests and ktlint 1.8.0
(cd example/android && ./gradlew :health_connect_reporter:testDebugUnitTest)
(cd android && ktlint "src/**/*.kt" "*.kts")

# 4. Run every row on an Android 14+ phone or emulator with Health Connect (grant the permissions
#    once from the app's requestPermissions row; --no-uninstall keeps them)
(cd example && flutter test integration_test --no-uninstall -d <device-id>)
```

`.github/workflows/ci.yml` runs 1, 2 and 3 on every PR and push to `master`; a phone with Health Connect can't run in CI, so 4 stays manual.

### D. Quality Gate Requirements
Before any commit or PR creation, the codebase must pass all gates:
1. `flutter analyze` — **zero issues** in the plugin and the example.
2. `flutter test` — **all tests green**; quote the passed/failed counts.
3. Example build — `flutter build apk --debug` passes.
4. Coverage — line coverage of `lib/` is **≥ `COVERAGE_THRESHOLD`** (90 %) in `.github/workflows/ci.yml`; quote the measured percentage.
5. Kotlin — ktlint clean and the Kotlin unit tests green (quote the count) whenever Kotlin changes.
6. Integration — for changes to the Kotlin dispatcher, run the catalog integration test on a phone and quote which rows failed and why.

---

## 7. Release & Versioning

* **Semantic versioning of the plugin's own**: new methods/fields → minor, fixes → patch, a breaking Dart API or JSON change → major. The plugin's major is independent of HealthConnectReporter's.
* **release-please** (`.github/workflows/release.yml`, `release-please-config.json`, `.release-please-manifest.json`) derives the next version from the Conventional Commits on `master` and keeps a release PR open that bumps `pubspec.yaml`, the example's `pubspec.yaml`, the README's dependency line and `CHANGELOG.md` (headers reformatted to `## [X.Y.Z] - dd.MM.yyyy`). Never bump versions or write release changelog entries by hand.
* Merging the release PR tags `vX.Y.Z`; `release.yml` then starts `.github/workflows/publish.yml` on that tag, which publishes to pub.dev through GitHub's OIDC token (pub.dev admin › Automated publishing: GitHub Actions, repository `kvs-coder/health_connect_reporter`, tag pattern `v{{version}}`, push and `workflow_dispatch` events). Merging the release PR happens only on the maintainer's request.
* `pubspec.yaml` `version` and the top `CHANGELOG.md` entry always agree (CI's release guard checks it).
* **Starting point**: the manifest and `pubspec.yaml` are at `0.0.0` and nothing is released (CI's release guard accepts that until the first entry). The first complete release (every library service exposed) ships as `1.0.0` through a `Release-As: 1.0.0` footer. The package name `health_connect_reporter` is free on pub.dev (checked 10.10.2026); the maintainer creates it on the first publish.

---

## 8. Git & GitHub CLI (`gh`) Operational Protocols

### Branch Naming Convention
All branches MUST follow the strict user initials and issue structure:

```text
<initials>/issue-<XXX>
```

### Mandatory Git Execution Sequence
Before committing or creating a PR, run this exact sequence:

```bash
flutter analyze
flutter test --coverage
(cd example && flutter build apk --debug)
git status
git add lib/model/payload/<name>.dart test/<name>_test.dart
git commit -m "<type>(<scope>)[!]: <short summary>" \
  -m "<longer description / context>" \
  -m "Changes:
- <file_path>: <details>" \
  -m "Tests: <summary>" \
  -m "Refs: #<issue>"
```

### Commit Format Specification
```text
<type>(<scope>)[!]: <short summary>

<longer description / context>

Changes:
- <file path>: <details>

Tests: <summary>

[BREAKING CHANGE: <what breaks and how to migrate>]
Refs: #<issue>
```

* The header is a [Conventional Commit](https://www.conventionalcommits.org).
* `<type>`: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `build`, `chore`. `!` after the scope or a `BREAKING CHANGE:` footer marks a major change.
* `Refs: #<issue>` is required whenever an issue exists.

---

## 9. AI Verification Checklist

Before outputting code or submitting PRs, explicitly verify:
* [ ] Does the change mirror HealthConnectReporter's API and JSON, including new library methods, type cases and fields?
* [ ] Is plugin Kotlin free of `androidx.health.connect.client` imports, and does the example manifest declare every permission it requests?
* [ ] Does every error reach Dart with the method as code, the library's message and a `String` kind as details, and every result/event on the platform thread?
* [ ] Do Dart models keep `final` fields, the library's JSON keys, the parse helpers for numbers, nullable new fields, `id`, `clientRecordId` and `clientRecordVersion`?
* [ ] Are timestamps epoch milliseconds everywhere?
* [ ] Does every new channel method have a Dart API test, a Kotlin dispatcher test, a `DemoRow` and a README snippet?
* [ ] Are `flutter analyze` and `flutter test` green, coverage ≥ `COVERAGE_THRESHOLD`, the example building, ktlint clean and the Kotlin tests green?
* [ ] Is the version left to release-please, with `pubspec.yaml` and `CHANGELOG.md` agreeing?
* [ ] Is the branch named strictly `<initials>/issue-<XXX>`, are commits made without `--no-verify`, staged without blind `git add .`, in the §8 format with no AI trailer?
