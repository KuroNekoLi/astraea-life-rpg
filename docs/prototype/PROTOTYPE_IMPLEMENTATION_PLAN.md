# Flutter MVP Implementation Plan

**Version:** 2.0
**Status:** Active Flutter implementation roadmap
**Authority:** `AGENTS.md`, `FLUTTER_ARCHITECTURE.md`, `FLUTTER_ENGINEERING_STANDARDS.md`, product SPEC baseline, domain specifications and accepted decisions OD-001–OD-008.

This plan replaces the earlier Kotlin Multiplatform / Compose / SQLDelight implementation plan. The MVP client is Flutter/Dart with Riverpod, go_router and Drift/SQLite. Domain and game rules remain pure Dart. Do not treat checkboxes from the superseded plan as evidence of completed implementation.

## Product exit goal

The first playable must demonstrate this complete chain:

```text
Life Quest completion
→ one canonical RewardGrant
→ Growth Potential projection
→ deliberate TrainingConversion
→ changed Character Attribute projection
→ Prepared Deck choice
→ deterministic Function-based battle
→ Weak Node decision changes combat outcome
→ saved story / battle state can resume
```

Real-life activity does not directly damage enemies or directly assign Attributes. Life progression never hard-gates the main story. Offline previews are not canonical grants.

## Architecture contracts

```text
presentation → application → domain
infrastructure → domain contracts
app/bootstrap → composition root
```

- `RewardGrant` is the immutable reward ledger. LifeProgress and GrowthPotential are projections.
- `TrainingConversion` is the immutable source of permanent attribute growth. AttributeState is a projection.
- Story transitions check the expected story revision. StoryState does not own relationship values.
- RNG is injected into game rules. Game simulation never imports Flutter, Riverpod, or Drift.
- Persist only necessary life/evidence data. Never include raw private activity content in analytics.
- TBD formula, balance and content values must be injected/configured; engineers must not silently invent them.

## Milestones

### M0 — Flutter project bootstrap — DONE

Android/iOS Flutter projects, Riverpod/go_router shell, provisional theme, lazy empty Drift schema, pure Dart RNG seam, widget/unit tests and GitHub Actions. Temporary store identifiers are recorded in the repository README. Android debug APK builds. iOS build/device execution has not been verified in the managed Linux environment.

### M1 — Domain foundation — DONE

Pure Dart immutable models and rules for MVP life domains/quests/activities, evidence projections, RewardPreview/RewardGrant and idempotency, authored progression policy, GrowthPotential projection, character attributes/initial allocation, authored TrainingConversion, revision-controlled StoryState, spell/function graph/deck content and battle state envelopes. These are headless contracts; feature persistence and gameplay screens remain in later milestones.

Acceptance:

- Domain/game engine imports no Flutter, Riverpod or Drift.
- MVP entity boundaries preserve canonical source-of-truth ownership.
- Same idempotency key cannot grant or convert twice; conflicting payloads fail explicitly.
- Initial attributes validate Base 8, 32 allocated points and per-attribute cap 15.
- Stale story revisions return conflict without changing state.
- Every unresolved formula/content rate is an explicit input, not a guessed default.
- Pure Dart unit tests exercise happy paths, invalid data, retries and projections.

### M2 — Life Quest vertical path — DONE (prototype scope)

Screens: list, detail, timer, completion. Application state handles active timer lifecycle and restoration; repositories persist quest/activity/evidence and transactionally record the reward ledger and projections.

Acceptance:

```text
Complete a configured quest through timer or self-report
→ one LifeActivity
→ one RewardPreview
→ one local RewardGrant after confirmation
→ updated LifeProgress and GrowthPotential projections
```

Retrying completion must not duplicate activity or grant. Timer duration survives pause/resume and process restoration according to mobile lifecycle support. Evidence level communicates what the timer can verify. Test crash/retry and SQLite transaction boundaries. No connected health integrations in this milestone.

### M3 — Character and Training path — IN PROGRESS

Character creation validates eight attributes, 32 allocation points, Base 8 and allocation cap 15. Fate reroll uses injected deterministic randomness, and the player accepts the replacement result. Authored weapon choices remain content data.

Training reads available potential, previews an authored TrainingDefinition, and commits a single idempotent TrainingConversion. Rebuild AttributeState from its base values and conversion history. Training costs, aptitude modifiers, efficiency curves and growth values require approved content/policy inputs where source specifications still say TBD.

### M4 — Story runtime, Scene 1–5 and Prepared Deck — IMPLEMENTED PROTOTYPE EXCERPT

Load versioned story/content data separately from player state. Implement dialogue/narration/choice steps, revision-checked transitions, objective flags, Function Theory interaction, Chant/Chantless teaching, Spell Card explanation and six-slot Prepared Deck selection. Do not reveal restricted canon. Narrative copy and reveal timing follow the narrative source documents and narrative review; no engineering-authored canon.

### M5 — Deterministic combat core — ENGINE COMPLETE; PLAYER ENCOUNTER PENDING BALANCE

Implement headless commands/resolution for turn order, initiative, actions, movement, reactions, Mana, weapon/spell use, defeat and victory. Inject seeded RNG; the same initial state, seed and command sequence must produce identical state and events. Implement one training encounter only after combat mechanics match the approved combat spec. Numerical balance formulas marked TBD remain content/policy inputs.

### M6 — Function Graph / Weak Node — IMPLEMENTED TUTORIAL SCENARIO

Implement active Function execution, visibility state, analysis, interrupt outcomes and downstream cancellation. Add one Ashfang training pattern with a real Weak Node outcome: interrupting LockTarget changes or cancels Pounce. Add pure Dart scenario tests and accessible UI state distinctions that are not color-only.

### M7 — End-to-end first playable — PARTIAL; ACCEPTANCE PENDING

From fresh install, complete onboarding, Life Quest, reward, Training, scenes/tutorial, Deck setup, training encounters and post-battle feedback without debug menus. Save/resume across app restart. Add integration coverage for the full chain and error/retry paths. Validate that character build changes combat decisions and Life completion is meaningful without coercion.

### M8 — Pilot and measurement — IMPLEMENTATION IN PROGRESS; HUMAN PILOT PENDING

After privacy-safe event contracts are approved, instrument semantic milestones: character created, life quest completed, reward granted, training converted, deck confirmed, Function revealed, Weak Node exploited, battle completed and prototype completed. Run a seven-day pilot with feedback/interviews. Do not upload raw notes, evidence or health data. Decide next scope from observed activation and player understanding.

## Delivery and verification

For each milestone, make a small reviewable commit and push to `master` after its quality gates pass. Preserve useful partial progress if a later product decision blocks a downstream milestone. Never mark blocked/untested work complete.

Required Flutter gates:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

For pure Dart engine/domain suites:

```bash
dart test test/domain test/game_engine
```

For cross-feature journeys, run the relevant integration suite. Player-facing milestones also require visual evidence and real-player review before acceptance. CI must run the same applicable gates.

## Current next action

M2 is implemented with versioned quest/reward content, a Drift-backed Life Quest flow, timer restoration, self-report/timer evidence, idempotent completion, reward confirmation and projection rebuilds. Flutter format/analyze/test gates pass. M3 is next; Training balance values remain explicit authored inputs.
