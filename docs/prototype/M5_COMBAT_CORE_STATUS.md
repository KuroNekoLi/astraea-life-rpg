# M5 — Deterministic Combat Core

## Engine delivered

- Pure Dart combat reducer supports d20 initiative with Processing modifier and seeded tie-breaks, weapon/spell resolution, natural 1/20 rules, Main Action use, movement, optional Guard Reaction damage reduction, turn/round advancement, Mana, defeat and victory state.
- Attack damage, critical damage, Defense and Mana cost are supplied by encounter/content inputs; no balance formula is hidden in the engine.
- Serializable 32-bit seeded RNG state is stored in CombatState and in checkpoint payloads for deterministic continuation.
- Combat checkpoint persistence round-trips units, resources, turn, revision, event log and RNG state.

## Scope limits

- No player-facing training-battle screen or fully authored Arcane Sentry/Ashfang encounter UI is included yet.
- Combat balance and derived-stat formulas are TBD in COMBAT_SYSTEM.md. Encounter number tuning awaits authored inputs and playtest.
- The M6 Ashfang Function lab is a focused behavior scenario and marks its illustrative content values as awaiting playtest.

## Verification

- Pure engine tests cover deterministic replay, natural 1/20, Mana, defeat, Reaction reduction, initiative and serializable RNG progression.
- Checkpoint round-trip test: PASS.
- dart format, flutter analyze, flutter test, and pure Dart engine suite are rerun at final integration.
