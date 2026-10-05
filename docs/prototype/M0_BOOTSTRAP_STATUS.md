# M0 Status

## Scope / authority

Engineering bootstrap under `AGENTS.md`, `skills/astraea-orchestrator/SKILL.md`,
Flutter architecture/standards, SPEC_BASELINE and MVP_VERTICAL_SLICE.
No product, progression, combat or canon behavior added.

## Verification

- dart format: PASS — 14 files, 0 changed.
- flutter analyze: PASS — No issues found.
- flutter test: PASS — 4 tests (shell redirect, RNG replay/range, invalid RNG bounds, SQLite schema reopen).
- pure Dart: PASS — `dart test test/game_engine`, 2 tests.
- integration: DEFERRED — see `integration_test/README.md`; no cross-feature journey in M0.
- clean-source dependency resolution: PASS — copied repository files without caches/build outputs, `flutter pub get --enforce-lockfile` and `dart run build_runner build`; generated database matches original byte-for-byte.
- independent code review: PASS — separate reviewer context; no blocking findings after identifier documentation.
- visual: PASS — reviewed [mobile shell rendering](evidence/m0-shell.png), captured at 390 × 844 by Flutter's widget renderer with Roboto; this is not device execution or approved final UI.
- Android debug APK: PASS — `flutter build apk --debug`; output `build/app/outputs/flutter-apk/app-debug.apk`. No emulator/device launch was performed.
- iOS build/device launch: NOT_VERIFIED — requires macOS/Xcode; platform project generated from stable Flutter template.
- CI: equivalent format/analyze/test gates configured in `.github/workflows/flutter.yml`; remote Actions run not observed.

## Files / boundaries created

- Android/iOS platform projects and Flutter root configuration.
- `lib/app/`: ProviderScope bootstrap, app, router (`/` redirects to `/home`), lazy database composition.
- `lib/core/persistence/`: native SQLite opener, empty Drift schema 1, generated source.
- `lib/design_system/theme/`: provisional theme entry.
- `lib/game_engine/rng/`: pure Dart injectable seeded RNG, no Flutter/Riverpod imports.
- `lib/features/home/presentation/`: single placeholder home screen.
- Mirrored unit/widget test ownership, integration deferral, CI and setup README.

## Dependencies added

Resolved using Flutter 3.47.6 stable / Dart 3.13.5; exact transitive versions in
`pubspec.lock`:

- flutter_riverpod 3.4.3; go_router 18.0.2; drift/drift_dev 2.35.1.
- freezed 4.0.1 / freezed_annotation 3.1.0.
- json_serializable 6.14.1 / json_annotation 4.12.0; build_runner 2.16.1.
- path 1.9.1 / path_provider 2.1.6 for the application-support database location.
- test 1.31.1; Flutter SDK widget tests; flutter_lints 6.0.0.

## Deviations

No architecture deviation. No speculative feature directories or domain tables.
Drift table-manager generation disabled for the empty schema to avoid an unused
generated field. Freezed/JSON generators configured without invented DTOs.
Native SQLite targets the intended mobile platforms; web is not an M0 target.
Seeded RNG is repeatable on the pinned runtime, not a cross-SDK replay contract.
Tool caches and Android/JDK setup are environment-only, outside the repository.

## Open decisions

Final store identifiers require confirmation before store-facing builds. M0 uses
explicit temporary development identifiers documented in README, with replacement
locations. This does not block development bootstrap. Store signing is deferred.

## Roles used

Orchestrator, Architect/Flutter Engineer, independent Code Reviewer, QA.
Player validation is deferred until meaningful player-facing journeys exist;
this placeholder contains no onboarding, gameplay or major navigation flow.

## Verdict

DONE — M0 source foundation, mandatory local gates, Android debug build and independent review pass. iOS/device execution remains explicitly NOT_VERIFIED.
