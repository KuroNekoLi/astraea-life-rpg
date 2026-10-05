# Prototype Implementation Plan
## `PROTOTYPE_IMPLEMENTATION_PLAN.md`

**版本：** v1.0  
**狀態：** Implementation Baseline  
**依據：**
- `SPEC_BASELINE_v1.0.md`
- `WIREFRAME_SPEC.md`
- `TECHNICAL_ARCHITECTURE.md`
- `FIRST_PLAYABLE_PROTOTYPE.md`

---

# 1. Implementation Goal

本階段的目標不是把完整 Astraea 做完，而是建立第一個可測的 end-to-end playable：

```text
Prologue
→ Character Creation
→ Life Quest
→ RewardGrant
→ Growth Potential
→ TrainingConversion
→ Attribute Projection
→ Function Tutorial
→ Prepared Deck
→ Battle
→ Weak Node
→ Post-Battle
```

第一個 playable 必須證明三件事：

1. Life Quest completion 真的會進入 RPG progression。
2. Training choice 真的改變 Character Build。
3. Character Build 真的影響 Function-based Combat。

---

# 2. Technical Baseline

MVP client：

```text
Kotlin Multiplatform
Compose Multiplatform
SQLDelight
Koin
kotlinx.serialization
kotlinx.coroutines
```

Project structure：

```text
astraea-prototype/
├── androidApp/
├── shared/
│   ├── core/
│   ├── feature/
│   └── content/
└── gradle/
```

第一個執行 target：

```text
Android
```

shared module 同時保留：

```text
Android
iOS ARM64
iOS Simulator ARM64
```

---

# 3. Module Boundary

## `androidApp`

責任：

- Android Application entry point
- Activity
- Android manifest
- Android platform integrations
- future Health Connect bridge
- platform lifecycle

不得包含：

- XP 計算
- Story rule
- Combat rule
- Training rule

---

## `shared`

責任：

```text
Domain
Application
Repositories
Compose UI
Content Runtime
Combat Engine
Story Runtime
```

---

# 4. Shared Package Layout

```text
com.linli.astraea

core/
├── domain/
│   ├── life/
│   ├── reward/
│   ├── evidence/
│   ├── progression/
│   ├── character/
│   ├── training/
│   ├── story/
│   ├── spell/
│   └── combat/
├── engine/
├── repository/
└── di/

feature/
├── home/
├── lifequest/
├── training/
├── character/
├── deck/
├── story/
└── combat/

content/
├── story/
├── spell/
├── function/
└── encounter/
```

---

# 5. Architecture Contract

## Canonical reward flow

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
↓
LifeProgressionEngine
↓
RewardGrant
↓
LifeProgress / GrowthPotentialBalance
```

`RewardGrant` 是 immutable transaction。

---

## Canonical character growth flow

```text
GrowthPotentialBalance
↓
TrainingCommand
↓
TrainingConversion
↓
AttributeState Projection
```

永久 Attribute 不允許由 UI / ViewModel 直接 mutate。

---

## Canonical story flow

```text
StoryTransitionCommand
(expectedRevision)
↓
StoryRuntime
↓
StoryState(revision + 1)
```

---

## Canonical combat flow

```text
BattleState
+ CombatCommand
+ Seeded Random
↓
CombatResolution
↓
BattleState'
+ CombatEvents
```

---

# 6. Milestone Overview

```text
M0 — Repository / Build Skeleton
M1 — Domain Foundation
M2 — Life Quest Vertical Path
M3 — Character / Training Path
M4 — Story Runtime + Scene 1–5
M5 — Combat Core
M6 — Function Graph / Weak Node
M7 — End-to-End Vertical Slice
M8 — Test Pilot / Instrumentation
```

---

# 7. M0 — Repository / Build Skeleton

## Goal

專案能在 Android 開啟並顯示 Astraea Home shell。

## Tasks

### Build
- [x] 建立 root Gradle project
- [x] 建立 `shared` KMP module
- [x] 建立 `androidApp`
- [x] 加 Compose Multiplatform
- [x] 加 kotlinx serialization
- [x] 加 coroutines
- [x] 加 SQLDelight plugin
- [x] 加 Koin dependency
- [x] 建立版本 catalog
- [ ] 產生 Gradle wrapper
- [ ] 在 Android Studio sync
- [ ] 驗證 Android debug build
- [ ] 驗證 iOS shared compilation

### UI shell
- [x] `AstraeaApp`
- [x] Home shell
- [x] Simple route state
- [ ] Theme
- [ ] Typography
- [ ] Placeholder assets

## Acceptance

```text
./gradlew :androidApp:assembleDebug
```

成功，且可看到 Home shell。

---

# 8. M1 — Domain Foundation

## Goal

先讓核心規則可以 headless test。

## Tasks

### Life
- [x] `LifeDomain`
- [x] `UserLifeQuest`
- [x] `LifeActivity`

### Evidence
- [x] `EvidenceLevel`
- [x] `EvidenceSummary`

### Reward
- [x] `Reward`
- [x] `RewardGrant`
- [x] `RewardPreview`

### Progression
- [x] `LifeProgressionEngine`
- [x] deterministic MVP formula
- [x] Growth Potential reward

### Character
- [x] 8 `AttributeType`
- [x] `AttributeState`
- [x] `CharacterState`

### Training
- [x] `TrainingDefinition`
- [x] `TrainingConversion`
- [x] `TrainingEngine`

### Story
- [x] `StoryState`
- [x] `StoryTransitionCommand`

### Spell
- [x] Spell / Function Graph basic model

### Combat
- [x] `BattleState`
- [x] `CombatCommand`
- [x] `CombatEvent`

## Acceptance

所有 domain class：
- 不 import Compose
- 不 import Android
- commonTest 可執行

---

# 9. M2 — Life Quest Vertical Path

## Goal

玩家可以真正完成第一個 Life Quest。

## Tasks

### Screens
- [ ] Life Quest list
- [ ] Life Quest detail
- [ ] Timer
- [ ] Quest complete

### State
- [ ] LifeQuestViewModel
- [ ] timer state persistence
- [ ] self-report completion

### Domain integration
- [ ] create `LifeActivity`
- [ ] calculate `RewardPreview`
- [ ] persist `RewardGrant`
- [ ] update LifeProgress
- [ ] update GrowthPotentialBalance

### Persistence
- [x] SQL schema baseline
- [ ] generated DB wiring
- [ ] repository implementation
- [ ] transaction boundary

## Acceptance Scenario

```text
Given:
Read 20 minutes

When:
Complete via Timer

Then:
exactly one LifeActivity
exactly one RewardGrant
Learning XP increases
Cognitive Potential increases
```

Retry 不可 duplicate。

---

# 10. M3 — Character / Training Path

## Goal

完成 Life Quest 後，玩家可以在 Astraea 做 Training。

## Tasks

### Character creation
- [ ] name
- [ ] 8 Attribute allocation
- [ ] 32 points validation
- [ ] cap 15 validation
- [ ] aptitude result
- [ ] Fate Reroll
- [ ] weapon select

### Training
- [ ] Training Hall UI
- [ ] available Potential
- [ ] Training preview
- [ ] Training confirm
- [ ] `TrainingConversion`
- [ ] Attribute projection update

### MVP Training
- [ ] Function Analysis Drill
- [ ] Complexity Exercise
- [ ] Reaction Drill
- [ ] Precision Movement
- [ ] Intent Encoding Drill

## Acceptance

```text
Cognitive Potential = 18

Train Function Analysis Drill cost 10

Then:
Potential = 8
TrainingConversion exists
Analysis projection changes
```

---

# 11. M4 — Story Runtime + Scene 1–5

## Goal

從 Prologue 玩到 Prepared Deck tutorial。

## Tasks

### Story Runtime
- [ ] content JSON schema
- [ ] load chapter / scene
- [ ] dialogue step
- [ ] narration
- [ ] choice
- [ ] story flag
- [ ] revision validation
- [ ] objective trigger

### Scene content
- [ ] Prologue
- [ ] Scene 1 Academy Gate + Yuma
- [ ] Scene 2 Character Creation
- [ ] Scene 3 Function Theory
- [ ] Scene 4 Chant / Chantless
- [ ] Scene 5 Spell Card / Deck

### Function tutorial
- [ ] Function Graph renderer
- [ ] node tap
- [ ] order exercise
- [ ] tutorial completion state

## Acceptance

不能提前 reveal：
- Reality Cost
- The Fading
- Institute Zero
- Mio

---

# 12. M5 — Combat Core

## Goal

先做一個不依賴 UI 的 deterministic combat engine。

## Tasks

### Battle
- [ ] turn order
- [ ] initiative
- [ ] Main Action
- [ ] Movement
- [ ] Quick Action
- [ ] Reaction
- [ ] Mana
- [ ] Basic attack
- [ ] Spell cast
- [ ] defeat
- [ ] victory

### RNG
- [ ] `RandomProvider`
- [ ] seed injection
- [ ] replay deterministic test

### Commands
- [ ] Attack
- [ ] CastSpell
- [ ] Move
- [ ] Analyze
- [ ] React
- [ ] EndTurn

### Battle 1
- [ ] Arcane Sentry Mk-I

## Acceptance

相同：
- initial state
- seed
- command sequence

必須得到完全相同 battle state / events。

---

# 13. M6 — Function Graph / Weak Node

## Goal

做出 Astraea 最重要的差異化戰鬥。

## Tasks

### Runtime
- [ ] Active Function
- [ ] node execution
- [ ] partial visibility
- [ ] Weak Node
- [ ] interrupt
- [ ] downstream cancellation

### UI
- [ ] graph compact mode
- [ ] active node
- [ ] `???`
- [ ] Weak Node highlight
- [ ] Reaction prompt

### Ashfang
- [ ] `Detect`
- [ ] `LockTarget`
- [ ] `Charge`
- [ ] `Pounce`
- [ ] `LockTarget` = Weak Node

## Acceptance

玩家打斷 `LockTarget`：

```text
Pounce loses target
```

必須是真實 domain consequence，不是 UI scripted text。

---

# 14. M7 — End-to-End Vertical Slice

## Goal

Scene 1–6 串起來。

## Tasks

- [ ] onboarding
- [ ] Life Domain select
- [ ] first Life Quest
- [ ] timer
- [ ] reward
- [ ] Training
- [ ] Function theory
- [ ] Chant
- [ ] Deck
- [ ] Arcane Sentry
- [ ] Ashfang
- [ ] Post-Battle Report
- [ ] save / resume
- [ ] error states

## Acceptance

從 fresh install 開始，不用 debug menu：

```text
Start
→ Finish Vertical Slice
```

無 blocker。

---

# 15. M8 — Pilot / Analytics

## Tasks

- [ ] semantic analytics event pipeline
- [ ] activation events
- [ ] Weak Node event
- [ ] prototype completion
- [ ] developer Fast Mode
- [ ] 7-day pilot configuration
- [ ] feedback form / interview checklist

核心 events：

```text
character_created
life_quest_completed
reward_granted
training_converted
deck_confirmed
function_revealed
weak_node_exploited
battle_completed
prototype_completed
```

---

# 16. Task Priority

## P0 — Cannot ship First Playable without it
- Life Quest
- RewardGrant
- Growth Potential
- TrainingConversion
- Story Runtime
- Prepared Deck
- Battle Engine
- Function Graph
- Weak Node
- Persistence
- deterministic tests

## P1 — Strongly preferred
- good dialogue presentation
- animations
- post-battle behavioral feedback
- progress screen
- developer fast mode

## P2 — Defer
- cloud sync
- Health Connect
- social
- party relationship system
- Reality Cost
- Mio
- Research meta system

---

# 17. Suggested Implementation Order

不要依照畫面順序寫。

建議：

```text
1. Domain Models
2. Reward + Training source-of-truth
3. Persistence
4. Headless Combat
5. Story Runtime
6. Feature UI
7. Content
8. Animation / Polish
```

原因：

> UI 可以換，source-of-truth 與 combat semantics 不能後補。

---

# 18. Definition of Done per Task

每個 task 至少包含：

- implementation
- happy-path test
- failure / duplicate test（若涉及 transaction）
- telemetry event（若屬核心 funnel）
- no cross-layer ownership violation

---

# 19. Branch / PR Strategy

建議：

```text
main
feature/domain-foundation
feature/life-loop
feature/training
feature/story-runtime
feature/combat-core
feature/function-graph
feature/vertical-slice
```

PR 不要一次混：
- domain rule
- large UI redesign
- content rewrite

---

# 20. First Coding Sprint

第一個 Sprint 只做：

```text
M0 + M1 + M2 core
```

具體 backlog：

1. Sync project.
2. Build Android app.
3. Add SQLDelight generated DB.
4. Implement `RewardGrant` repository.
5. Implement `CompleteLifeActivityUseCase`.
6. Add Life Quest screens.
7. Add timer.
8. Persist first reward.
9. Add tests for duplicate completion.
10. Show Quest Complete screen.

Sprint 成功時：

> 真實完成一個 Life Quest，可以可靠地留下不可重複的 progression transaction。

---

# 21. Second Coding Sprint

```text
M3 + M4
```

完成：
- character creation
- training
- story runtime
- Scene 1–5
- deck builder

---

# 22. Third Coding Sprint

```text
M5 + M6
```

完成：
- headless battle
- Function Graph
- Weak Node
- Ashfang

---

# 23. Fourth Coding Sprint

```text
M7 + M8
```

完成：
- full slice
- save/resume
- analytics
- usability test

---

# 24. Engineering Quality Gates

每次 merge：

```text
compile
unit test
content validation
deterministic combat test
schema migration test
```

之後加入：
- Android UI test
- screenshot / golden test

---

# 25. First Playable Exit Criteria

只有以下全部成立才叫 First Playable：

- [ ] 真實 Life Quest 可完成
- [ ] Reward 不重複
- [ ] Potential 可 Training
- [ ] Training 影響 Attribute
- [ ] Attribute 影響 Battle
- [ ] Deck 控制可用 Spell
- [ ] Function Graph 真實驅動敵方術式
- [ ] Weak Node 真實改變 downstream Function
- [ ] Story 可保存 / resume
- [ ] 同 seed battle deterministic
- [ ] 從 Prologue 可走到 Post-Battle
- [ ] 核心 analytics 事件完整

---

# 26. Implementation Thesis

第一版不能只「看起來像產品」。

它必須從資料層證明：

```text
我完成現實行動
→ 產生唯一 RewardGrant
→ 轉為 TrainingConversion
→ 改變 Attribute Projection
→ 改變 Combat State Transition
```

只有做到這一點，這個 prototype 才真的驗證 Life RPG 的核心，而不是一段動畫 demo。