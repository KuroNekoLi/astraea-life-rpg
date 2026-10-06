# AGENTS.md — Astraea Academy Life RPG

This is the **entry point for every AI agent working in this repository**.

Do not begin substantial work before reading this file.

---

# 1. Project Identity

Astraea is:

> **A real Japanese-style fantasy RPG driven by the player's real-life actions.**

Core product loop:

```text
Real-Life Action
↓
Life Progress
↓
Growth Potential
↓
Training / Build Growth
↓
Adventure / Story / Combat
↓
RPG Progress
```

This project must not drift into:

> Todo List + RPG skin.

---

# 2. Default Orchestrator

For substantial work, use:

```text
skills/astraea-orchestrator/SKILL.md
```

The Orchestrator decides which roles and docs are necessary.

Do not summon every specialist by default.

---

# 3. Source Map

## Product Baseline

Read first when product behavior changes:

```text
docs/product/SPEC_BASELINE_v1.0.md
docs/product/Life_RPG_Astraea_GDD_v1.1.md
```

## Life / Progression

```text
docs/systems/LIFE_PROGRESSION_SYSTEM.md
docs/systems/QUEST_SYSTEM.md
docs/systems/EVIDENCE_SYSTEM.md
docs/systems/CHARACTER_PROGRESSION_SYSTEM.md
docs/engineering/DATA_MODEL.md
```

## Combat / Magic

```text
docs/systems/COMBAT_SYSTEM.md
docs/systems/SPELL_FUNCTION_SYSTEM.md
docs/systems/COMBAT_IMPLEMENTATION_GAP_MAP.md
docs/prototype/COMBAT_UX_FLOW_SPEC.md
docs/prototype/COMBAT_MOTION_ART_DIRECTION.md
docs/prototype/COMBAT_DEVICE_TEST_PLAN.md
```

## Story / Canon

```text
docs/world/WORLD_BIBLE.md
docs/world/CHARACTERS.md
docs/world/STORY_STRUCTURE.md
```

## UX / Prototype

```text
docs/prototype/WIREFRAME_SPEC.md
docs/prototype/FIRST_PLAYABLE_PROTOTYPE.md
docs/product/MVP_VERTICAL_SLICE.md
docs/prototype/PROTOTYPE_IMPLEMENTATION_PLAN.md
```

## Technical

```text
docs/engineering/TECHNICAL_ARCHITECTURE.md
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
```

## Decisions / Consistency

```text
docs/governance/OPEN_DECISIONS.md
docs/governance/SPEC_REVIEW.md
```

---

# 4. Required Reading by Task

Do not load everything.

## Flutter implementation

Read:

```text
AGENTS.md
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
relevant feature specs
```

## Life Quest

Read:

```text
docs/systems/QUEST_SYSTEM.md
docs/systems/LIFE_PROGRESSION_SYSTEM.md
docs/systems/EVIDENCE_SYSTEM.md
docs/engineering/DATA_MODEL.md
```

## Training / Character Growth

Read:

```text
docs/systems/CHARACTER_PROGRESSION_SYSTEM.md
docs/systems/LIFE_PROGRESSION_SYSTEM.md
docs/engineering/DATA_MODEL.md
```

## Combat

Read:

```text
docs/systems/COMBAT_SYSTEM.md
docs/systems/SPELL_FUNCTION_SYSTEM.md
```

## Narrative

Read:

```text
docs/world/WORLD_BIBLE.md
docs/world/CHARACTERS.md
docs/world/STORY_STRUCTURE.md
```

## MVP scope

Read:

```text
docs/product/SPEC_BASELINE_v1.0.md
docs/product/MVP_VERTICAL_SLICE.md
docs/prototype/FIRST_PLAYABLE_PROTOTYPE.md
```

---

# 5. Project-Specific Skills

Located under:

```text
skills/
```

Available Astraea skills:

```text
astraea-orchestrator
astraea-vision-guardian
astraea-game-director
astraea-combat-designer
astraea-combat-ux-designer
astraea-combat-animation-designer
astraea-combat-technical-architect
astraea-combat-gameplay-engineer
astraea-combat-qa
astraea-narrative-director
astraea-real-player-playtester
```

---

# 6. Role Boundaries

## Engineers may NOT silently change:

- game rules
- Life XP semantics
- Growth Potential semantics
- Quest rewards
- canon
- story reveal timing
- monetization philosophy

Raise:

```text
DECISION_REQUIRED
```

instead.

## Writers may NOT silently change:

- combat rules
- progression rules
- Magic System mechanics
- approved canon

## Designers may NOT silently change:

- reward semantics
- persistence behavior
- combat rules

## Reviewers may NOT redesign unrelated systems.

---

# 7. Flutter Baseline

The MVP client is implemented in Flutter.

Mandatory engineering references:

```text
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
```

Default stack:

```text
Flutter
Dart
Riverpod
go_router
Drift / SQLite
freezed
json_serializable
build_runner
```

Architecture-level deviations require ADR.

---

# 8. Critical Engineering Rule

Game rules must remain testable without Flutter UI.

Especially:

```text
Combat
Function Graph
Weak Node
RewardGrant idempotency
Training conversion
Quest rules
```

Keep these in pure Dart domain/game-engine code.

---

# 9. Design Authority

Figma is the visual source of truth for approved high-fidelity UI.

Generated illustration assets are content.

Flutter UI owns:

- card frame
- text
- Mana cost
- states
- Function Graph
- buttons
- navigation
- progress

Do not bake UI text into spell artwork.

---

# 10. Verification

Minimum completion gate:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

For relevant cross-feature flows:

```bash
flutter test integration_test
```

If not executed, say:

```text
NOT_VERIFIED
```

Do not claim success.

---

# 11. Player-Facing Gate

For meaningful user-facing work, technical success is insufficient.

Relevant features must be reviewed by:

```text
astraea-real-player-playtester
```

Especially:

- onboarding
- Home
- Life Quest
- Timer
- Completion
- Training
- Deck
- Adventure
- Combat
- Function Graph

---

# 12. Product Invariants

Do not introduce without explicit product decision:

- Life task directly damages boss
- missed habits deduct XP
- hard streak reset as core mechanic
- productivity hard-gates main story
- purchased XP / Attributes / Spell Power
- global total-XP leaderboard
- Life Level presented as verified mastery

---

# 13. Canon Safety

Do not reveal too early:

- Reality Cost
- The Fading
- Mio's origin
- Mio's connection-cutting plan
- Institute Zero's full knowledge

Narrative changes must go through:

```text
astraea-narrative-director
```

---

# 14. MVP Priority

The core MVP hypothesis is:

> **Will players do a meaningful real-world action because they want their Astraea self to grow?**

Prefer a coherent vertical slice over system breadth.

P0 flow:

```text
Life Quest
→ Completion
→ RewardGrant
→ Growth Potential
→ Training
→ Character change
→ Adventure
→ Combat
→ Function Graph / Weak Node payoff
```

---

# 15. If Unsure

Do not guess.

Use one of:

```text
DECISION_REQUIRED
CANON_CONFLICT
SPEC_CONFLICT
BLOCKED
NOT_VERIFIED
```

State:

- what is known
- what conflicts
- why the decision matters
- recommended option
- what can continue safely without the decision
