# Astraea Life RPG

A real Japanese-style fantasy RPG driven by the player's real-life actions.

## Agent entry point

Every AI/cloud agent should read [AGENTS.md](AGENTS.md) before substantial work.

Default coordinator:

```text
skills/astraea-orchestrator/SKILL.md
```

## Current milestone

M0 — Project Bootstrap implemented. See [verification status](docs/prototype/M0_BOOTSTRAP_STATUS.md).

The M0 execution contract is in:

```text
docs/prototype/M0_PROJECT_BOOTSTRAP.md
```

Flutter engineering baseline:

- [FLUTTER_ARCHITECTURE.md](FLUTTER_ARCHITECTURE.md)
- [FLUTTER_ENGINEERING_STANDARDS.md](FLUTTER_ENGINEERING_STANDARDS.md)

## Required M0 verification

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Do not report M0 complete unless the required gates actually run successfully.

## Flutter bootstrap

Use **Flutter 3.47.6 stable / Dart 3.13.5**, matching CI. The MVP targets Android
and iOS; iOS compilation requires macOS/Xcode. Run from the repository root:

```bash
flutter pub get --enforce-lockfile
dart run build_runner build
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
dart test test/game_engine
flutter run
```

The generated Drift source and application `pubspec.lock` are committed.
Regenerate after changing the database declaration. `freezed` and
`json_serializable` are installed for later immutable state/DTOs; M0 does not
invent models just to exercise generators. Drift schema 1 contains no domain
tables. Its native SQLite connection opens lazily through `databaseProvider`,
uses the application support directory and closes when the provider scope ends.
The shell performs no database writes.

Ownership:

- `lib/app/`: bootstrap, Riverpod composition and go_router lifecycle (`/` → `/home`).
- `lib/core/persistence/`: Drift database and mobile native connection.
- `lib/design_system/theme/`: provisional Material theme entry; not approved final UI.
- `lib/game_engine/rng/`: injected pure Dart RNG; same-seed repeatability on the pinned runtime, without a cross-runtime replay guarantee.
- `lib/features/home/presentation/`: M0 placeholder home.
- `test/`: shell/routing, database reopening and pure RNG behavior.
- `integration_test/README.md`: executable integration deferred until M1/M2.

## Development identifiers — DECISION_REQUIRED before store builds

These are temporary development identifiers, not confirmed store identifiers:

| Target | Temporary identifier | Replacement location |
| --- | --- | --- |
| Android | `dev.astraea.astraea_life_rpg` | `android/app/build.gradle.kts`: applicationId and namespace; `MainActivity.kt` package and directory |
| iOS Runner | `dev.astraea.astraeaLifeRpg` | `ios/Runner.xcodeproj/project.pbxproj`: PRODUCT_BUNDLE_IDENTIFIER in all build configurations |
| iOS tests | `dev.astraea.astraeaLifeRpg.RunnerTests` | Same Xcode project, RunnerTests configurations |

Confirm an owned reverse-domain identifier before any store-facing build.
Android release signing is still the development template configuration and must
be configured for a future store release. M0 does not publish or sign a store build.

Additional baseline packages (`path`, `path_provider`, and `test`) support the
SQLite file location and UI-independent tests. No foundational stack deviation
or product/canon change was introduced. Drift table-manager generation is disabled
while the schema is empty, avoiding unused generated infrastructure.
