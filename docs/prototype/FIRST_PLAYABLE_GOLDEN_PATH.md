# Astraea First Playable Golden Path

**Status:** Implementation contract  
**Scope:** MVP-only vertical-slice integration  
**Non-goal:** no new systems, currencies, story branches, backend services, or post-MVP mechanics.

## Goal

Connect the already implemented MVP systems into one player-visible payoff chain:

```text
Life Quest
→ RewardGrant
→ Growth Potential
→ Training
→ Character Attribute Growth
→ Ashfang Weak Node payoff
```

The player must be able to understand that a real-life action created Growth Potential, that Training intentionally converted that potential into permanent character growth, and that the resulting Analysis growth materially improves the Ashfang Weak Node interaction.

## Authority

This implementation must preserve:

- `docs/product/SPEC_BASELINE_v1.0.md`
- `docs/product/MVP_VERTICAL_SLICE.md`
- `docs/systems/QUEST_SYSTEM.md`
- `docs/systems/LIFE_PROGRESSION_SYSTEM.md`
- `docs/systems/CHARACTER_PROGRESSION_SYSTEM.md`
- `docs/systems/COMBAT_SYSTEM.md`
- `docs/systems/SPELL_FUNCTION_SYSTEM.md`
- `assets/content/progression/character_growth_mvp_v1.json`
- `assets/content/encounters/ashfang_training_v2.json`

## Scope Contract

### In scope

1. Preserve the existing Life Quest completion and RewardGrant path.
2. Persist an MVP Aptitude profile for newly created characters using the approved `character-growth-mvp-1` policy.
3. Turn the existing read-only Training preview into a minimal executable Training flow.
4. Training must:
   - quote cost from `character-growth-mvp-1`;
   - spend the correct Growth Potential category;
   - commit one idempotent `TrainingConversion`;
   - rebuild permanent Attribute growth from conversion history;
   - never mutate base allocation.
5. Make **Function Analysis Drill → Analysis** the Golden Path training option.
6. Feed the persisted effective Analysis value into Ashfang Function analysis.
7. Show the player why the trained Analysis value changes the Weak Node reveal chance/result.
8. Add focused tests for conversion persistence, projection, idempotency, and Ashfang Analysis payoff.

### Explicitly out of scope

- Fate reroll UI
- balance retuning
- new Training definitions
- new Life Domains
- full character sheet redesign
- full battle integration beyond the existing Ashfang Function tutorial
- new combat formulas
- new story content
- backend sync
- multiplayer/social
- monetization
- analytics expansion beyond existing milestone events

## Player Journey

```text
Complete Learning Life Quest
↓
RewardGrant is committed
↓
Cognitive Growth Potential projection increases
↓
Open Training
↓
Select Function Analysis Drill
↓
See exact versioned cost quote
↓
Confirm Training
↓
Cognitive Potential decreases
↓
Analysis permanent growth increases by +1
↓
Open Ashfang Function Analysis
↓
Analysis modifier reflects trained character value
↓
Weak Node analysis becomes measurably easier
↓
Interrupt LockTarget
↓
Pounce is cancelled
```

## Behavioural Rules

### Reward

The Life Quest completion remains the only source of the RewardGrant.

Training must never fabricate Life XP or Growth Potential.

### Training quote

Use the approved policy:

```text
character-growth-mvp-1
```

For Function Analysis Drill:

```text
potential category = Cognitive
attribute = Analysis
growth/session = +1
```

Cost is:

```text
(basePotentialCost + Aptitude adjustment)
× current Analysis growth tier multiplier
```

No other formula may be invented.

### Training persistence

One committed session writes one immutable `TrainingConversion`.

A retry with the same idempotency key must not double-spend or double-grow the Attribute.

Growth Potential is a projection and must be rebuildable from:

```text
RewardGrants - TrainingConversions
```

### Attribute projection

Effective Analysis is:

```text
base value
+ permanent Training growth
+ existing allowed modifiers
```

Aptitude must not directly modify Analysis.

### Ashfang payoff

Do not change Ashfang's authored difficulty or Function graph.

The existing Function analysis formula remains:

```text
analysisRoll + analysisModifier >= difficulty
```

For the First Playable path, `analysisModifier` must come from the active character's effective Analysis-derived combat modifier.

MVP modifier for this integration is the existing Attribute modifier rule if present. If no centralized modifier helper exists, use a minimal local mapping:

```text
analysisModifier = max(0, effectiveAnalysis - 8)
```

This is an integration adapter only; it must not alter stored Attribute values or the authored encounter difficulty.

## Acceptance Criteria

### AC-01 — Existing Life Quest reward remains authoritative

**Given** a Learning Life Quest is completed and its reward is confirmed  
**When** the completion transaction finishes  
**Then** exactly one RewardGrant exists for the LifeActivity  
**And** Cognitive Growth Potential reflects the grant.

### AC-02 — Character has persisted Aptitude profile

**Given** a new character is saved  
**When** creation completes  
**Then** one rating exists for every canonical Attribute  
**And** the profile records `character-growth-mvp-1`  
**And** the deterministic RNG state/seed needed for replay is persisted  
**And** Aptitude does not change base Attribute values.

### AC-03 — Training shows an exact authored quote

**Given** an active character and available Cognitive Potential  
**When** the player opens Training  
**Then** Function Analysis Drill displays:
- current Cognitive Potential;
- current effective Analysis;
- Analysis Aptitude;
- exact Potential cost;
- resulting Analysis after training;
- policy version.

### AC-04 — Insufficient Potential cannot train

**Given** Cognitive Potential below the quoted cost  
**When** the player views Function Analysis Drill  
**Then** confirmation is disabled  
**And** no TrainingConversion is written.

### AC-05 — Training spends Potential once

**Given** sufficient Cognitive Potential  
**When** Function Analysis Drill is confirmed  
**Then** one TrainingConversion is committed  
**And** Cognitive Potential decreases by exactly the quoted cost  
**And** Analysis permanent growth increases by exactly +1.

### AC-06 — Training retry is idempotent

**Given** a committed TrainingConversion  
**When** the same idempotency key is processed again  
**Then** no additional Potential is spent  
**And** no additional Attribute growth is applied.

### AC-07 — Base allocation is immutable

**Given** a character has a saved base Analysis value  
**When** Training completes  
**Then** the saved base value is unchanged  
**And** growth exists only in the Training projection/history.

### AC-08 — Ashfang uses trained Analysis

**Given** the active character has effective Analysis above base due to Training  
**When** the player analyzes Ashfang's LockTarget  
**Then** the FunctionRuntimeEngine receives an Analysis modifier derived from that effective Analysis  
**And** the UI identifies the modifier as coming from the character's Analysis.

### AC-09 — Weak Node mechanic is unchanged

**Given** LockTarget is revealed  
**When** it is interrupted  
**Then** downstream Pounce is cancelled exactly as before  
**And** no Life Quest directly damages or disables Ashfang.

### AC-10 — Golden Path is understandable

The UI visibly communicates:

```text
Life Quest reward
→ Cognitive Potential
→ Function Analysis Drill
→ Analysis growth
→ better Function analysis
```

without introducing a new tutorial system.

### AC-11 — Save/resume

After app restart:

- committed RewardGrant remains;
- remaining Potential remains;
- TrainingConversion remains;
- Analysis growth remains;
- Ashfang uses the restored value.

### AC-12 — Verification

Required repository gates:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Do not mark the Golden Path DONE if these are not green.

## Implementation Notes

Prefer extending the existing JSON-record persistence rather than adding new database tables during this slice.

Keep domain calculations in pure Dart.

Do not move combat rules into Widgets or Riverpod providers.
