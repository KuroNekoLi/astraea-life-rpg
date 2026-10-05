# M0 — Project Bootstrap

## Goal

Create a minimal, buildable Flutter foundation for the Astraea MVP without implementing product features prematurely.

## Required authority

Read in order:

1. `AGENTS.md`
2. `skills/astraea-orchestrator/SKILL.md`
3. `FLUTTER_ARCHITECTURE.md`
4. `FLUTTER_ENGINEERING_STANDARDS.md`
5. `docs/product/SPEC_BASELINE_v1.0.md`
6. `docs/product/MVP_VERTICAL_SLICE.md`

## Before implementation

Resolve only decisions that are truly required for project generation.

### DECISION_REQUIRED — application identifier

The final Android applicationId / iOS bundle identifier must be confirmed before store-facing builds.

Until confirmed, a temporary development identifier may be used only if clearly documented and isolated for replacement.

## Required deliverables

### Flutter project

Create a current stable Flutter project that builds for the intended MVP platforms.

### Dependency baseline

Configure the project around the approved architecture. Expected default stack:

- Riverpod
- go_router
- Drift / SQLite
- freezed
- json_serializable
- build_runner

Use current stable, mutually compatible package versions. Record any deviation and why.

### Source boundaries

Create the baseline ownership structure:

```text
lib/
├── app/
├── core/
├── design_system/
├── game_engine/
└── features/
```

Feature placeholders should exist only when they improve navigation/ownership clarity. Do not create speculative abstractions.

### Pure Dart game-engine boundary

Establish `lib/game_engine/` so combat/domain simulation can remain independent of Flutter widgets and Riverpod.

A minimal deterministic RNG seam should be representable without implementing the full combat system.

### App shell

Provide:

- app bootstrap
- router baseline
- theme/design-system entry
- one placeholder home route proving navigation works

Do not implement the full final UI during M0.

### Persistence baseline

Initialize Drift in a way that supports future domain tables, but do not prematurely create all final tables.

### Testing baseline

Create:

- at least one pure Dart test
- at least one widget/app-shell test
- integration-test directory or documented reason for deferring executable integration setup until M1/M2

### CI

Add GitHub Actions that runs the same minimum gates used locally.

## Mandatory verification

Run:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

If integration tests are executable at M0, also run:

```bash
flutter test integration_test
```

## Acceptance criteria

- AC-01: A clean checkout can resolve dependencies.
- AC-02: Flutter application launches to the M0 app shell.
- AC-03: Project structure follows `FLUTTER_ARCHITECTURE.md`.
- AC-04: Game-engine baseline has no Flutter/Riverpod dependency.
- AC-05: Router baseline is functional.
- AC-06: Persistence baseline compiles.
- AC-07: Required formatting/analyze/test gates are green.
- AC-08: CI runs equivalent gates.
- AC-09: No product/canon rules were invented during bootstrap.
- AC-10: Any unresolved store identifier decision is explicitly documented.

## Out of scope

Do not implement during M0:

- complete Life Quest UX
- real progression formulas beyond existing baseline
- full database schema
- production combat
- story runtime content
- backend sync
- Health integration
- social features
- monetization

## Completion report

The agent must return:

```markdown
# M0 Status

## Verification
- dart format: PASS/FAIL/NOT_VERIFIED
- flutter analyze: PASS/FAIL/NOT_VERIFIED
- flutter test: PASS/FAIL/NOT_VERIFIED
- integration: PASS/FAIL/DEFERRED

## Files / boundaries created
...

## Dependencies added
...

## Deviations
...

## Open decisions
...

## Verdict
DONE | BLOCKED | DECISION_REQUIRED
```
