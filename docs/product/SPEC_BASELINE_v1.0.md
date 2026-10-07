# Life RPG × Astraea Academy
## `SPEC_BASELINE_v1.0.md`

**Baseline Version:** v1.0  
**Status:** FROZEN FOR MVP IMPLEMENTATION  
**Decision Freeze:** OD-001 through OD-008 accepted  
**Purpose:** Establish the authoritative P0 specification set for the first playable MVP / Vertical Slice.

---

# 1. Product Thesis

Life RPG × Astraea Academy is:

> **A real-life-driven Japanese-style magic academy RPG in which real-world investment shapes the player's character build, and that build is used in genuine Function-based tactical RPG combat and narrative progression.**

Core loop:

```text
Live
↓
Complete Meaningful Real-Life Action
↓
Life Progress
↓
Growth Potential
↓
Training
↓
Character Build
↓
Function-Based Combat
↓
Story / Discovery
↓
Return to Real Life
```

---

# 2. Authoritative Specification Set

## Canon / Narrative Sources

- `WORLD_BIBLE.md`
- `CHARACTERS.md`
- `STORY_STRUCTURE.md`

These remain the source of truth for Astraea canon.

## Product / Game Design

- `Life_RPG_Astraea_GDD_v1.1.md`
- `MVP_VERTICAL_SLICE.md`

## Core Systems

- `COMBAT_SYSTEM.md`
- `LIFE_PROGRESSION_SYSTEM.md`
- `QUEST_SYSTEM.md`
- `EVIDENCE_SYSTEM.md`
- `CHARACTER_PROGRESSION_SYSTEM.md`
- `SPELL_FUNCTION_SYSTEM.md`

## Implementation / Production

- `DATA_MODEL.md`
- `GAME_FLOW_AND_IA.md`
- `CONTENT_PIPELINE.md`
- `SAVE_SYNC_BACKEND_SPEC.md`
- `ANALYTICS_EXPERIMENT_SPEC.md`

## Governance

- `OPEN_DECISIONS.md`
- `SPEC_REVIEW.md`
- `SPEC_BASELINE_v1.0.md`

---

# 3. Frozen P0 Decisions

## OD-001 — Life XP Owner

Accepted:

```text
LifeProgressionEngine
```

is the sole final Life XP calculator.

Input:

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
```

Output:

```text
RewardGrant
```

---

## OD-002 — Reward Ledger

Accepted:

```text
RewardGrant
```

is the immutable canonical reward transaction for:
- Life XP
- Growth Potential
- Gold
- battle reward
- other progression grants

Balances are projections.

---

## OD-003 — Attribute Growth

Accepted:

```text
TrainingConversion
```

is the immutable source of truth for permanent Attribute Growth.

```text
AttributeState
```

is a materialized projection.

---

## OD-004 — Quest Model

Accepted split:

```text
QuestTemplate
UserLifeQuest
StoryQuestDefinition
StoryQuestState
```

Life and Story quest domains are intentionally separated.

---

## OD-005 — Relationship Ownership

Accepted:

```text
CharacterRelationship
```

is the sole relationship state owner.

`StoryState` does not duplicate trust / affinity / tactical synergy.

---

## OD-006 — Story Concurrency

Accepted:

```text
expected_story_revision
→ validate
→ StoryState revision + 1
```

No Last-Write-Wins.  
No arbitrary union of story flags.

---

## OD-007 — Offline Reward

Accepted:

```text
Local completion
→ RewardPreview
→ Pending Operation
→ Server calculation
→ RewardGrant
```

`RewardPreview` is UX only, never canonical state.

---

## OD-008 — Evidence Deletion

Accepted for personal progression:

```text
Delete Evidence
→ remove/minimize evidence payload
→ recalculate Evidence Coverage
→ possibly remove verified badge / competitive eligibility
→ keep already confirmed RewardGrant
```

No retroactive personal XP punishment.

---

# 4. Canonical Progression Pipeline

```text
UserLifeQuest
↓
LifeActivity
↓
Evidence[]
↓
EvidenceSummary projection
↓
LifeProgressionEngine
↓
RewardGrant
├── LIFE_XP
└── GROWTH_POTENTIAL
↓
LifeProgress projection
GrowthPotentialBalance projection
↓
TrainingConversion
↓
AttributeState projection
↓
Character Build
↓
Combat
```

---

# 5. Canonical Story Pipeline

```text
StoryQuestDefinition
↓
StoryQuestState
↓
Player reaches transition
↓
AdvanceStory(transition_id, expected_story_revision)
↓
Story Runtime validates
↓
StoryState revision + 1
↓
Story flags / unlocks projected
```

Relationship data is read from:

```text
CharacterRelationship
```

not StoryState.

---

# 6. Canonical Evidence Pipeline

```text
LifeActivity
↓
Evidence[]
↓
Verification
↓
EvidenceSummary projection
↓
LifeProgressionEngine
```

Evidence System does not directly grant XP.

---

# 7. Canonical Character Growth Pipeline

```text
GrowthPotentialBalance
↓
Select TrainingDefinition
↓
TrainingConversion
↓
AttributeState rebuilt/projected
↓
Effective Attributes
↓
Combat
```

No direct:

```text
Life Activity → Attribute +1
```

---

# 8. Core Product Semantics

## Life Level

```text
Accumulated real-life investment
```

Not mastery.

## Momentum

```text
Recent engagement / consistency
```

Does not erase Level.

## Attribute

```text
RPG character capability
```

## Build

```text
Attributes
+ Weapon
+ Prepared Deck
+ Spell handling
+ player decisions
```

## Evidence

```text
Credibility / provenance of real-world activity
```

Not moral trust.

---

# 9. Quest Semantics

Use only:

```text
Life Goal
Life Quest
Main Story
Story Quest
```

Conceptual boundary:

```text
Life Quest
→ grow the character

Story Quest
→ play the RPG
```

Life Progress may create flexibility, optional paths and stronger builds, but must not hard-gate the Main Story.

---

# 10. Combat Baseline

Combat identity:

```text
Turn-Based Tactical JRPG
+
Function Analysis
```

### Combat Baseline Amendment — 2026-10-07

The original frozen v1.0 list below used the terms **Initiative** and **Seeded RNG** from the first combat prototype. Subsequent locked combat design decisions supersede those two implementation assumptions for the current Combat v1 engine.

Current P0 combat timing / resolution baseline:

```text
Continuous / CTB-like Action Timeline
+ Action Delay
+ deterministic rule resolution
```

Therefore:

- Do not implement d20 initiative for new Combat v1 work.
- Do not use seeded attack-roll RNG as the default hit / Interrupt resolution model.
- Reaction Charge refreshes on the character's formal Turn, not a global Round reset.
- Spell Resolve and important Battlefield Functions may be Timeline Events.
- The normative combat-rule source is `docs/systems/COMBAT_RULES_V1_BASELINE.md`.
- Legacy d20 / seeded-RNG code remains transitional until the player-facing combat feature is migrated.

Current P0 mechanics:
- Continuous Action Timeline
- Action Delay
- Main Action
- Quick Action
- Movement
- Reaction
- Mana
- Weapon Technique
- Spell Card
- 6-slot Prepared Deck
- Function Graph
- Weak Node
- deterministic Interrupt / Stability
- basic Counter pattern
- deterministic enemy Pattern + Conditions
- Post-Battle Report

Prepared Deck is loadout, not random draw.

---

# 11. Magic Baseline

Canon:

```text
f(S0) = S1
```

```text
Human Intent
→ Medium / Encoding
→ Magic System
→ Function Execution
```

Spell Card:

> executable / reusable representation of a constructed Function / Function Graph.

Function Graph is first-class content and runtime data.

---

# 12. MVP Narrative Baseline

Vertical Slice:

```text
Scene 1 — Academy Entrance
Scene 2 — Character Creation / Aptitude
Scene 3 — Function Theory
Scene 4 — Full Chant vs Chantless
Scene 5 — Spell Card / Prepared Deck
Scene 6 — Training Battle
```

Do not reveal in Scene 1–6:
- Reality Cost
- The Fading
- Institute Zero
- Mio identity
- Aberration true origin
- Connection severing

---

# 13. MVP Life Scope

Enabled Domains:

```text
Fitness
Learning
Languages
```

MVP Evidence:

```text
E0 Self Report
E1 Timer
```

MVP progression:
- Life XP
- Life Level
- Momentum
- Growth Potential
- Training Conversion

---

# 14. MVP Character Scope

- 8 canonical Attributes
- 32 Fixed Allocation
- Aptitude Roll
- Fate Reroll
- 4 initial weapons
- Training Conversion
- build-relevant combat effects

---

# 15. MVP Spell Scope

Target:

```text
8–12 Spell Cards
```

Prepared Deck:

```text
6 slots
```

MVP Function features:
- visible graph
- partial graph
- one Weak Node tutorial
- one simple Counter example

No:
- Last Spell
- Reality Cost gameplay
- free-form Function Construction

---

# 16. MVP Data Integrity Rules

Mandatory:

1. `RewardGrant` idempotent.
2. `TrainingConversion` idempotent.
3. Story transition revision checked.
4. PreparedDeck saved with revision.
5. LifeActivity survives app kill.
6. Timer survives background / restart where supported.
7. Battle reward cannot duplicate after crash.
8. Evidence provenance preserved.
9. Materialized projections can be rebuilt from canonical records.

---

# 17. Version Vocabulary

Use exactly:

```text
schema_version
content_version
formula_version
verification_version
revision
projection_version
```

Do not introduce generic ambiguous `version` fields in new P0 schemas.

---

# 18. MVP UX Architecture

Primary mobile areas:

```text
Home
├── Adventure
├── Life Quest
├── Character
├── Deck
└── Progress
```

Home should surface:
- current Story objective
- today's meaningful Life Quests
- available Growth Potential
- Continue Adventure

---

# 19. Content Architecture

Authoring data:
- StoryChapter
- StoryScene
- Dialogue
- Choice
- QuestTemplate
- StoryQuestDefinition
- SpellDefinition
- FunctionGraph
- EnemyDefinition
- EncounterDefinition
- TrainingDefinition

Runtime state must remain separate.

---

# 20. Validation Baseline

Primary hypothesis:

> Players will complete a real-world action because they want their Astraea character to grow.

Primary activation:

```text
First Life Quest Completed
AND
First Training Conversion Completed
```

Combat aha moment:

```text
First Weak Node Exploited
```

---

# 21. P0 Cross-Spec Status

After OD-001～OD-008 freeze:

```text
P0 source-of-truth conflicts: 0
```

Remaining unknowns are predominantly:
- balance
- UX
- product validation
- P1 design decisions

not blocking schema ownership.

---

# 22. Change Control

Any change that modifies one of the following requires updating this baseline or creating an ADR:

- reward source of truth
- attribute source of truth
- Quest domain split
- story concurrency
- evidence deletion semantics
- Life XP ownership
- canonical progression pipeline
- canon/world rules

---

# 23. Next Phase

The project may now enter:

```text
Wireframe
→ Interactive Prototype
→ Technical Architecture
→ MVP Implementation
→ 7-Day Pilot
```

Do not expand major P2 systems before core MVP validation.

---

# 24. Baseline Thesis

This baseline freezes the product around one complete contract:

```text
Real Life
→ Credible Progress
→ Deliberate Training
→ Character Build
→ Understandable Magic System
→ Tactical Combat
→ Narrative Payoff
```

The implementation should preserve that chain.

> **The game is not a reward screen attached to a habit tracker.  
> The player's life shapes a real RPG character, and the RPG gives that progress emotional meaning.**