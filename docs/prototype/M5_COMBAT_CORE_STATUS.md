# Combat M1–M5 — Headless CTB Core Status

**Status:** Implemented and CI-verified  
**Current engine:** `lib/game_engine/combat/v1/`  
**Latest verified master:** `1df164a53fd5917ae58b179e23a89178c9ae588c`  
**Verification run:** GitHub Actions `37573916908` — success  
**Design authority:** `docs/systems/COMBAT_RULES_V1_BASELINE.md`

This document replaces the previous d20 / round-based M5 status description. The older
`lib/game_engine/combat/` prototype remains in the repository for existing feature compatibility,
but new combat work must target the CTB v1 engine unless a migration task explicitly says otherwise.

## Scope delivered

### M1 — Pure Dart Headless Combat Engine

Implemented:

- Continuous CTB-style Timeline.
- Character Turn, Spell Resolve, and generic Battlefield Function timeline events.
- Deterministic event ordering with stable insertion-order tie breaking.
- Main Action resolution and Action Delay rescheduling.
- One free adjacent Normal Move per formal Turn.
- Shared `Near / Mid / Far` Zones.
- Mana payment and recovery.
- Physical / Magic damage with resistance multiplier handling.
- Guard mitigation.
- KO / victory / defeat state.
- Pure Dart state transitions with no Flutter or Riverpod dependency.

Primary files:

- `lib/game_engine/combat/v1/combat_models.dart`
- `lib/game_engine/combat/v1/combat_actions.dart`
- `lib/game_engine/combat/v1/headless_combat_engine.dart`
- `test/game_engine/combat/v1/headless_combat_engine_test.dart`

### M2 — Casting Lifecycle

Implemented:

- Full Chant consumes the initiating Main Action.
- Mana is paid at Cast Start.
- Caster enters Casting State and does not receive normal Turns while construction is pending.
- Spell Resolve becomes a Timeline Event.
- Resolve and post-cast recovery are separate timing concepts.
- Canceling Full Chant refunds 50% of base Mana Cost and applies recovery.
- Target / Zone validity is rechecked at Function resolution.
- Chantless remains an immediate Main Action path.

Primary test:

- `test/game_engine/combat/v1/full_chant_m2_test.dart`

### M3 — Quick / Reaction / Interrupt

Implemented:

- Up to one Quick Action per formal Turn.
- Per-character Reaction Charge.
- Reaction Charge refreshes at the character's next formal Turn.
- Deterministic Interrupt:
  `Interrupt Power >= current Function Stability`.
- Failed disruptive actions can reduce Stability without breaking the Function.
- Same Trigger Window cannot resolve more than one Party Reaction.
- Casting-Compatible Reaction constraint.
- Successful Interrupt removes the pending Function event, refunds 50% base Mana, and schedules caster recovery.
- Main-Action Interrupt and Reaction Interrupt are distinct call paths.

Primary test:

- `test/game_engine/combat/v1/interrupt_m3_test.dart`

### M4 — Analysis / Function Knowledge / Weak Node / Counter

Implemented:

- Function Knowledge is stored separately from active runtime Function state.
- Analysis increases authored knowledge; it does not fabricate a Weak Node.
- Stability can remain unknown until Analysis reveals it.
- Weak Node bonuses cannot be used by guessing an ID; that observer must first reveal the node.
- Known Counter paths can be preloaded as learned knowledge.
- Unknown Counter paths can require Analysis before use.
- Interrupt applies only before Function establishment.
- Counter applies only to an established active Function.
- A Function can become established and remain active independently of its caster.
- If a caster is defeated while the Function is still only Casting, unfinished construction collapses.
- If the caster is defeated after establishment, the active Function remains on the Timeline and can still resolve or be Countered.

Primary test:

- `test/game_engine/combat/v1/function_tactics_m4_test.dart`

Important invariants:

1. `Unknown -> Analysis -> Information -> Decision`, never `Analyze -> guaranteed Weak Node`.
2. Known Spell knowledge can enable immediate Counter without redundant Analysis.
3. Caster defeat is not retroactive cancellation of an already-established Function.

### M5 — Readable Enemy Pattern / Reporting / Deterministic Scenario

Implemented:

- Deterministic `Pattern + Conditions` enemy intent selection.
- Authored priority rules; no global optimal-solver behavior.
- Pattern selection is separated from concrete action execution.
- Combat Report aggregation for core headless metrics.
- Canonical combat-state fingerprint for deterministic replay checks.
- Headless Ashfang scenario proving repeated runs produce the same state fingerprint and report.

Primary files:

- `lib/game_engine/combat/v1/enemy_pattern.dart`
- `lib/game_engine/combat/v1/combat_report.dart`
- `test/game_engine/combat/v1/ashfang_m5_test.dart`

## Verification

The latest verified `master` passed the repository workflow end to end:

- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- `dart test test/domain test/game_engine`

Latest successful run:

- Run ID: `37573916908`
- Commit: `1df164a53fd5917ae58b179e23a89178c9ae588c`

Additional QA fixes made after initial M1–M5 implementation:

- Applied canonical Dart formatting to M1–M5.
- Preserved Function Knowledge across Timeline advances.
- Corrected the M1 generic timeline-event test to use a valid non-spell event.

## Current engine boundary

### Implemented in CTB v1 headless core

- Timeline scheduling
- Main / Quick / Reaction resources
- Normal Move
- Near / Mid / Far
- Mana
- Damage / Resistance / Guard
- Full Chant lifecycle
- Deterministic Interrupt / Stability Damage
- Analysis / Function Knowledge
- Authored Weak Nodes
- Basic Counter path
- Established active Function lifetime
- KO / victory / defeat
- Enemy Pattern + Conditions intent selection
- deterministic replay fingerprint
- combat reporting

### Not yet integrated into the player-facing combat feature

The current Flutter Ashfang feature still uses older prototype combat code and has not been migrated to
`lib/game_engine/combat/v1/`.

Still required for the next integration phase:

1. Feature/domain adapter from player-facing encounter content to CTB v1 commands.
2. Landscape Battle HUD backed by CTB Timeline state.
3. Prepared SC drawer and Casting panel.
4. Analysis workspace and Function Graph presentation.
5. Reaction overlay.
6. Enemy Intent presentation from Pattern + Conditions.
7. Ashfang tutorial scripting on the CTB v1 engine.
8. Checkpoint / resume model for the CTB v1 state if the battle must survive app termination.
9. Balance telemetry and actual playtest pass using `ASHFANG_BALANCE_TEST_SHEET_V0_1.md`.

## Legacy engine note

Files under the older combat engine / feature path may still describe:

- d20 initiative
- round-based ordering
- seeded RNG attack rolls
- legacy checkpoint state

Those behaviors are **not the current Combat Rules v1 design baseline**.

Do not extend those mechanics into new combat work. They remain only until the existing feature is
migrated or explicitly retired.

## Source precedence

For new combat implementation:

1. `docs/product/SPEC_BASELINE_v1.0.md`, including its Combat Baseline Amendment.
2. `docs/systems/COMBAT_RULES_V1_BASELINE.md`.
3. `docs/systems/SPELL_FUNCTION_SYSTEM.md`.
4. `docs/systems/ASTRAEA_COMBAT_UX_FLOW_V1.md`.
5. This implementation-status document.
6. Legacy prototype combat code and historical M5 notes.

If an older document says d20 / rounds / seeded attack RNG where the locked Combat Rules v1 baseline
says CTB / deterministic resolution, the Combat Rules v1 baseline wins.
