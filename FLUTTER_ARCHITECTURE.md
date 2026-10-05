# Astraea Flutter Architecture

**Status:** MVP Engineering Baseline  
**Scope:** Astraea Life RPG Flutter client  
**Change policy:** Architecture-level deviations require an ADR.

---

# 1. Goals

The architecture must support:

- Life Quest tracking
- deterministic RPG combat
- story runtime
- Prepared Deck / Spell Cards
- Function Graph / Weak Node mechanics
- local persistence
- future account/sync integration
- high-fidelity mobile UI
- testability without requiring a device for core rules

Primary engineering principle:

> **Game and progression rules must remain testable as pure Dart logic, independent of Flutter UI.**

---

# 2. Baseline Technology Choices

Default stack for MVP:

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

These are defaults, not immutable laws.

Adding/replacing a foundational package requires an ADR.

## Responsibilities

### Flutter

Rendering, navigation shell, platform integration.

### Riverpod

- dependency wiring
- application state
- async state
- feature controllers

Do not use Riverpod as the domain model.

### go_router

Declarative app routing and deep-link-ready navigation.

### Drift

Structured local persistence where relational integrity matters.

Good candidates:

- LifeActivity
- RewardGrant
- LifeProgress
- GrowthPotential
- TrainingConversion
- StoryState
- PreparedDeck
- Battle checkpoint / history where needed

### freezed / json_serializable

Use for immutable state / DTOs where code generation materially reduces risk.

Do not generate data classes indiscriminately.

---

# 3. Repository Shape

Recommended MVP structure:

```text
lib/
├── app/
│   ├── app.dart
│   ├── bootstrap.dart
│   ├── router.dart
│   └── app_providers.dart
│
├── design_system/
│   ├── tokens/
│   ├── components/
│   ├── icons/
│   ├── theme/
│   └── assets/
│
├── core/
│   ├── error/
│   ├── logging/
│   ├── persistence/
│   ├── clock/
│   ├── ids/
│   └── result/
│
├── game_engine/
│   ├── combat/
│   ├── function_graph/
│   ├── rng/
│   ├── rules/
│   └── models/
│
├── features/
│   ├── home/
│   ├── life_quest/
│   ├── training/
│   ├── character/
│   ├── deck/
│   ├── adventure/
│   ├── story/
│   └── combat/
│
└── main.dart

assets/
├── images/
│   ├── environments/
│   ├── portraits/
│   ├── enemies/
│   ├── weapons/
│   └── spells/
├── icons/
├── content/
│   ├── story/
│   ├── spells/
│   ├── encounters/
│   └── quests/
└── manifest/
```

Tests mirror production ownership:

```text
test/
├── game_engine/
├── features/
├── core/
└── design_system/

integration_test/
└── vertical_slice_test.dart
```

---

# 4. Feature Internal Structure

Use feature-first organization.

Example:

```text
features/life_quest/
├── domain/
│   ├── life_quest.dart
│   ├── life_activity.dart
│   ├── life_quest_repository.dart
│   └── complete_life_quest.dart
│
├── application/
│   ├── life_quest_controller.dart
│   ├── life_quest_state.dart
│   └── providers.dart
│
├── data/
│   ├── drift_life_quest_repository.dart
│   ├── life_quest_dao.dart
│   └── mappers.dart
│
└── presentation/
    ├── life_quest_screen.dart
    ├── quest_timer_screen.dart
    └── widgets/
```

Not every tiny feature needs all four folders.

Rule:

> Add a layer only when it has a real responsibility.

Avoid ceremony.

---

# 5. Dependency Direction

Preferred dependency flow:

```text
presentation
↓
application
↓
domain
↑
data implementation
```

More precisely:

```text
presentation → application
application → domain
data → domain
app/bootstrap → all composition roots
```

Domain must not depend on:

- Flutter Widgets
- Riverpod
- Drift
- go_router
- platform channels

---

# 6. Game Engine Boundary

`lib/game_engine/` is a special boundary.

It must be:

- pure Dart
- deterministic where possible
- replayable
- serializable where needed
- free from Flutter UI dependencies
- free from Riverpod dependencies
- free from direct database access

Example:

```dart
BattleResolution resolveCommand(
  BattleState state,
  CombatCommand command,
  Rng rng,
)
```

Preferred model:

```text
BattleState
+
CombatCommand
+
RNG
↓
BattleResolution
+
BattleEvents
```

Do not implement rules in:

- Button callbacks
- Widget build methods
- Riverpod providers
- animation controllers

---

# 7. Combat Determinism

Combat must support seeded RNG.

Use cases:

- deterministic tests
- replay/debug
- bug reproduction
- balance simulation

Randomness must be injected.

Bad:

```dart
final roll = Random().nextInt(20) + 1;
```

Better:

```dart
final roll = rng.d20();
```

---

# 8. State Ownership

Every state must have one clear owner.

Examples:

| State | Owner |
|---|---|
| current route | router |
| Life Quest list | Life Quest application layer |
| active timer | Life Quest application layer |
| Growth Potential | progression domain/application |
| prepared deck | Deck feature |
| active battle | Combat feature + game engine |
| story flags | Story feature |
| theme | app/design system |

Avoid:

```text
one giant AppState
```

Avoid duplicate authoritative copies.

---

# 9. Riverpod Rules

Use Riverpod for:

- composition
- async orchestration
- UI-facing state
- dependency injection

Prefer explicit providers.

Do not expose database rows directly to UI.

Do not store business rules inside provider bodies.

Preferred:

```text
Provider
→ Use Case / Service
→ Domain Model
```

For mutable screen state:

```text
Notifier / AsyncNotifier
```

Use family/scoped providers where parameterized ownership is clear.

Avoid deeply chained provider magic that obscures data flow.

---

# 10. Persistence

Drift is the default local persistence layer.

Persistence rules:

- database models are not domain models by default
- map DB rows to domain entities
- migrations are explicit and tested
- RewardGrant must support idempotency
- timestamps use a consistent clock abstraction
- generated IDs use a single project strategy

Do not let Widgets call DAO methods directly.

---

# 11. RewardGrant Idempotency

Life completion and reward creation must be safe against retries.

Conceptual invariant:

```text
one completion event
→ at most one reward grant
```

Use an idempotency key derived from the completion/event identity.

This invariant must be tested.

---

# 12. Navigation

Use `go_router`.

Top-level route groups may include:

```text
/
 /home
 /life
 /training
 /character
 /deck
 /adventure
 /story/:sceneId
 /battle/:encounterId
```

Route names/paths may evolve, but navigation ownership belongs in app routing.

Do not call Navigator imperatively throughout arbitrary domain/application code.

Application layers return outcomes; presentation decides navigation.

---

# 13. Design System

UI must use:

```text
lib/design_system/
```

for shared:

- colors
- typography
- spacing
- radii
- buttons
- cards
- progress
- navigation items
- Function Graph primitives
- Quest controls

Figma Design System is the visual authority.

Do not duplicate magic colors and spacing values across screens.

---

# 14. Assets

Generated art assets are content, not UI chrome.

Separate:

```text
artwork
from
UI frame / text / cost / status
```

Spell card artwork must not contain baked-in:

- title
- Mana cost
- description
- Function Graph
- frame

Flutter composes these at runtime.

---

# 15. Story Runtime

Story content should be data-driven where practical.

Prefer:

```text
StoryScene
StoryBeat
DialogueLine
Choice
StoryCondition
StoryEffect
```

Avoid hardcoding an entire chapter inside Widget trees.

Canon content remains authored/reviewed by narrative roles.

---

# 16. Content Validation

Static content should have validation before runtime.

Examples:

- duplicate IDs
- missing portrait references
- missing Spell ID
- invalid encounter node reference
- unavailable Story target
- Prepared Deck > allowed size
- invalid Function dependency

Fail fast in development.

---

# 17. Error Handling

Use explicit failure types.

Avoid:

```dart
catch (_) {
  return null;
}
```

Prefer domain/application failures with actionable categories.

UI decides presentation:

- retry
- inline error
- blocking error
- fallback

Core gameplay simulation should not depend on UI error strings.

---

# 18. Offline-First MVP

Default MVP assumption:

> local-first, playable without network for core flows.

Network should not be required for:

- Life Quest timer
- local progression
- story content bundled with build
- combat
- deck editing
- training

Future sync should be layered on top of a stable local model.

---

# 19. Testing Architecture

## Domain / Game Engine

Use fast pure Dart unit tests.

High priority:

- combat resolution
- initiative
- attack roll
- Function interruption
- Weak Node
- reward idempotency
- Training conversion
- quest recurrence

## Application

Test:

- controller transitions
- repository interactions
- retry behavior
- error states

## Widget

Test:

- rendering
- user interaction
- loading/error/empty states
- state-specific UI

## Integration

Test the vertical slice:

```text
Life Quest
→ Complete
→ RewardGrant
→ Growth Potential
→ Training
→ Character change
→ Adventure
→ Battle
```

---

# 20. Architecture Rules That Require ADR

Create an ADR before:

- replacing Riverpod
- replacing Drift
- introducing a second persistence system
- introducing a second state-management framework
- moving game rules into a remote backend
- adding a new backend dependency to core gameplay
- introducing micro-packages/modules with public contracts
- changing offline-first assumption
- changing content delivery architecture

---

# 21. MVP Principle

Prefer:

```text
one coherent Flutter application
+
clear boundaries
+
pure game engine
```

over:

```text
many packages
+
abstract interfaces everywhere
+
future-proofing without current value
```

Architecture exists to make the MVP easier to build, test, and change.