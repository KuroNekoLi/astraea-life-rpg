# Astraea Life RPG

A real Japanese-style fantasy RPG driven by the player's real-life actions.

## Agent entry point

Every AI/cloud agent should read [AGENTS.md](AGENTS.md) before substantial work.

Default coordinator:

```text
skills/astraea-orchestrator/SKILL.md
```

## Current milestone

```text
M0 — Project Bootstrap
```

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
