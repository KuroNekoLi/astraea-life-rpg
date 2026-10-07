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
```

## Story / Canon

```text
docs/world/WORLD_BIBLE.md
docs/world/CHARACTERS.md
docs/world/STORY_STRUCTURE.md
```

## UX / Prototype

```text
docs/ui/ASTRAEA_UI_UX_FOUNDATION_V1.md
docs/ui/CURRENT_UI_AUDIT_V1.md
skills/astraea-ui-ux-director/SKILL.md
docs/prototype/WIREFRAME_SPEC.md
docs/prototype/FIRST_PLAYABLE_PROTOTYPE.md
docs/product/MVP_VERTICAL_SLICE.md
docs/prototype/PROTOTYPE_IMPLEMENTATION_PLAN.md
docs/systems/ASTRAEA_COMBAT_UX_FLOW_V1.md
```

## Visual Assets

```text
docs/art/ASTRAEA_VISUAL_PROMPT_PLAYBOOK.md
skills/astraea-visual-asset-director/SKILL.md
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
astraea-narrative-director
astraea-real-player-playtester
astraea-ui-ux-director
astraea-visual-asset-director
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

There is currently no required Figma artifact for Astraea implementation.

For current work, visual authority comes from:

```text
approved project specs
+ approved existing assets
+ current Flutter implementation
+ docs/art/ASTRAEA_VISUAL_PROMPT_PLAYBOOK.md
```

If a future task supplies an approved Figma file or high-fidelity reference, use it for that specific UI.

Generated illustration assets are content.

The project owner has approved ChatGPT Images 2.5 for suitable fictional Astraea image assets. Route non-trivial generation through:

```text
skills/astraea-visual-asset-director/SKILL.md
```

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

Use generated art for content such as spell artwork, enemy concepts, backgrounds, cut-ins, magical phenomenon art, or tutorial illustrations. Do not replace precise interactive UI with generated raster screenshots.

### Clean-room Image Generation Protocol

All new Astraea runtime images must be generated or edited in an isolated image context.

Required:

```text
Visual Asset Director
→ one Asset Brief
→ one isolated image worker
→ one asset / one context
→ reference-image edit preferred
→ Visual Asset Director review
→ PASS only
→ runtime integration
```

Do not send long development conversations, CI/QA context, milestone status, or unrelated specs into the image worker.

If generated output contains a presentation sheet, collage, fake HUD, baked text, progress visualization, or multiple variants when one asset was requested, reject it as a runtime asset.

---

# 10. Localization

Astraea must support:

```text
English
Traditional Chinese (zh-TW)
```

Player-facing Flutter strings must come from localization resources or locale-aware authored content.

Do not hardcode user-facing strings in Widgets.

Stable IDs, enum values, routes, persistence keys, analytics keys, and debug-only machine data remain language-neutral.

All new user-facing work must consider both locales before completion.

---

# 11. Verification

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

# 12. Player-Facing Gate

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

# 13. Product Invariants

Do not introduce without explicit product decision:

- Life task directly damages boss
- missed habits deduct XP
- hard streak reset as core mechanic
- productivity hard-gates main story
- purchased XP / Attributes / Spell Power
- global total-XP leaderboard
- Life Level presented as verified mastery

---

# 14. Canon Safety

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

# 15. MVP Priority

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

# 16. If Unsure

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