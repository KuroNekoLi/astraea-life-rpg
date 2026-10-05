# Technical Architecture Specification
## `TECHNICAL_ARCHITECTURE.md`

**版本：** v1.0  
**狀態：** MVP Architecture Baseline  
**依據：** `SPEC_BASELINE_v1.0.md`, `DATA_MODEL.md`, `SAVE_SYNC_BACKEND_SPEC.md`

---

# 1. Architecture Goal

技術架構必須同時支援：

- mobile-first consumer app
- JRPG exploration / dialogue / combat
- offline Life Quest / Timer
- deterministic battle
- data-driven story / spell content
- future backend sync
- immutable RewardGrant
- revision-based StoryState

核心原則：

> MVP 可以簡化 infrastructure，但不能破壞已 freeze 的 domain ownership。

---

# 2. Recommended Client Direction

使用者已有 Kotlin / Compose Multiplatform 背景，因此 MVP 建議：

```text
Kotlin Multiplatform
+
Compose Multiplatform
```

支援：
- Android
- iOS
- shared domain logic
- shared UI where practical

遊戲並非高強度 3D Action RPG，MVP 的：
- 2D/2.5D scene
- dialogue
- turn-based combat
- Function Graph UI

可由 Compose-based runtime 承擔。

若之後確定需要大型 3D 世界，再重新評估 Unity / Godot。

---

# 3. Architecture Layers

```text
Presentation
↓
Application / Use Cases
↓
Domain
↓
Data
↓
Platform / Infrastructure
```

---

# 4. Module Proposal

```text
app/
core/
  domain/
  data/
  ui/
  analytics/
  sync/

feature/
  home/
  lifequest/
  evidence/
  progression/
  training/
  character/
  deck/
  story/
  exploration/
  combat/

content/
  story/
  spells/
  functions/
  enemies/
  encounters/
```

---

# 5. Domain Ownership

```text
Quest System
→ UserLifeQuest / StoryQuestState

Evidence System
→ Evidence / EvidenceSummary

LifeProgressionEngine
→ Life XP / Momentum / Growth Potential calculation

Reward Service
→ RewardGrant

Character Progression
→ TrainingConversion / Attribute projection

Spell Function
→ FunctionGraph / SpellDefinition

Combat
→ BattleState / Battle events

Story Runtime
→ StoryState / Story transition
```

---

# 6. Immutable Transaction Pattern

正式基線：

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
↓
LifeProgressionEngine
↓
RewardGrant
↓
Projections
```

RewardGrant 不被修改。

Projection 可重建。

---

# 7. Character Progression Pattern

```text
GrowthPotentialBalance
↓
Training Command
↓
TrainingConversion
↓
AttributeState Projection
```

禁止直接 mutate `permanent_growth` 當 source of truth。

---

# 8. Story Concurrency

```text
AdvanceStory(
  transitionId,
  expectedRevision
)
```

成功：

```text
storyRevision + 1
```

衝突：
- refresh authoritative state
- 不做 LWW
- 不做 arbitrary flag union

---

# 9. Local Database

建議：

```text
SQLDelight
```

原因：
- KMP shared
- relational state 適合 Quest / Progress / Story
- migration 可控
- offline-first

---

# 10. Local Tables — MVP

至少：

```text
user_profile
character
attribute_state
life_domain
user_life_quest
life_activity
evidence
reward_grant
life_progress
growth_potential_balance
training_conversion
prepared_deck
story_state
story_quest_state
battle_checkpoint
sync_operation
```

---

# 11. Repository Layer

例如：

```kotlin
interface LifeQuestRepository
interface ProgressionRepository
interface EvidenceRepository
interface CharacterRepository
interface StoryRepository
interface DeckRepository
interface BattleRepository
```

Repository 不做 domain calculation。

---

# 12. Use Cases

例如：

```text
CreateLifeQuest
StartLifeQuestTimer
CompleteLifeActivity
CalculateRewardPreview
ConfirmRewardGrant
ConvertTraining
AdvanceStory
UpdatePreparedDeck
StartBattle
ResolveCombatAction
ResumeBattle
```

---

# 13. Life Completion Transaction

Client MVP：

```text
CompleteLifeActivityUseCase
├── persist LifeActivity
├── build EvidenceSummary
├── LifeProgressionEngine.calculate()
├── persist local RewardGrant
├── update projections
└── emit UI result
```

Production server-sync：

```text
local RewardPreview
→ pending operation
→ backend confirms RewardGrant
```

---

# 14. Reward Service

介面概念：

```kotlin
interface RewardService {
    suspend fun grant(command: RewardGrantCommand): RewardGrant
}
```

要求：
- idempotencyKey
- sourceType
- sourceId
- formulaVersion

---

# 15. Projection Pattern

以下是 projection：
- LifeProgress
- GrowthPotentialBalance
- AttributeState
- EvidenceSummary

可由 canonical event / record 重建。

MVP 可直接更新 projection，但測試要能重新計算比對。

---

# 16. Timer Architecture

Timer 必須使用：
- monotonic elapsed time
- persisted start/pause state

不要只依賴：
- wall clock
- foreground coroutine

---

# 17. Story Runtime

Story content data-driven。

```text
StoryDefinition
→ StoryRuntime
→ StoryState
```

Runtime 負責：
- conditions
- dialogue step
- choices
- objective transition
- battle trigger
- emitted flags

---

# 18. Content Format

MVP 建議 JSON 或 YAML。

若 Kotlin runtime 需強 schema，建議：

```text
JSON
+ kotlinx.serialization
```

優點：
- deterministic
- CI validation
- mobile packaging
- tool friendly

YAML 可作 authoring source，再 build 成 JSON。

---

# 19. Function Graph Runtime

核心結構：

```text
FunctionGraph
├── nodes
├── edges
├── weakNodeRules
└── counterMetadata
```

執行時：

```text
FunctionExecution
├── nodeStates
├── boundParameters
├── stability
└── resolution
```

---

# 20. Combat Engine

Combat Domain 必須：

- UI independent
- deterministic
- seedable
- replayable
- pure state transition 優先

介面：

```text
BattleState + CombatCommand
→ BattleResult
→ New BattleState + Events
```

---

# 21. Combat Command Examples

```text
Attack
CastSpell
Move
UseTechnique
Analyze
React
EndTurn
```

---

# 22. Combat Events

```text
TurnStarted
ActionResolved
FunctionStarted
NodeRevealed
ReactionOpened
InterruptResolved
DamageResolved
StatusApplied
BattleEnded
```

Presentation 只 consume events 做動畫。

---

# 23. Seeded RNG

建立：

```text
RandomProvider(seed)
```

Domain code 不直接呼叫 platform random。

---

# 24. Battle Persistence

MVP checkpoint：
- battle start
- round boundary
- battle end

保存：
- seed
- round
- unit states
- active functions
- event cursor

---

# 25. UI State Management

建議：

```text
ViewModel / Presenter
+ StateFlow
```

Feature state：
- immutable UI state
- explicit intent/action

例如：

```text
LifeQuestUiState
CombatUiState
DeckUiState
```

---

# 26. Dependency Injection

KMP 可用：

```text
Koin
```

保持簡潔。

---

# 27. Networking

MVP local prototype 可不需要 backend。

Production API 建議：

```text
Ktor Client
```

Backend stack可另定，但 API domain 已 freeze。

---

# 28. Backend API Boundaries

未來：

```text
POST /life/activities
POST /rewards/confirm
GET  /progress
POST /training/conversions
GET  /character
PUT  /deck
POST /story/transition
POST /evidence
```

具體 REST / RPC：TBD。

---

# 29. Offline Sync Operation

```text
SyncOperation
├── operationId
├── type
├── payload
├── createdAt
├── state
└── retryCount
```

state：
```text
Pending
Syncing
Confirmed
Failed
```

---

# 30. Idempotency

以下 command 必須具 idempotency：
- complete LifeActivity
- RewardGrant
- TrainingConversion
- Battle reward
- Achievement grant

---

# 31. Content Validation Tool

CI 必須檢查：
- missing ID
- duplicate ID
- invalid scene reference
- invalid Function edge
- missing localization
- invalid spell graph
- missing enemy reference
- story dead-end

---

# 32. Testing Strategy

## Domain Unit Test
- XP calculation
- evidence factor
- diminishing return
- TrainingConversion
- attribute projection
- story revision
- Function Graph validation
- combat resolution

## Integration Test
- LifeActivity → RewardGrant
- RewardGrant → projections
- Training → Attribute
- Story transition
- deck → battle

## UI Test
- first Life Quest
- timer
- Training
- Deck
- Weak Node tutorial

---

# 33. Golden Test — Core Loop

```text
Given:
Learning quest Read 20 min

When:
complete with Timer

Then:
LifeActivity exists
RewardGrant exists
Learning XP increases
Cognitive Potential increases

When:
user runs Function Analysis Training

Then:
TrainingConversion exists
Potential decreases
Analysis projection changes

When:
start Ashfang battle

Then:
updated Analysis affects Function gameplay
```

---

# 34. Analytics Boundary

Domain emits semantic events。

不把 UI click 當核心產品 evidence。

例如：
- LifeQuestCompleted
- TrainingConverted
- WeakNodeExploited

---

# 35. Security Boundary

Production：
- client 不可 self-author authoritative XP
- provider tokens secure storage
- no sensitive Evidence in generic analytics

---

# 36. MVP Technical Scope

Must:
- KMP shared domain
- Compose UI
- SQLDelight local persistence
- data-driven content
- deterministic combat engine
- timer
- story runtime
- RewardGrant
- TrainingConversion
- Prepared Deck

Can defer:
- remote backend
- account sync
- Health integration
- social
- live ops

---

# 37. Recommended Package Boundary

```text
domain.life
domain.reward
domain.training
domain.character
domain.story
domain.spell
domain.combat
domain.quest
domain.evidence
```

避免巨型 `game` package。

---

# 38. ADRs to Create

至少：

```text
ADR-001 KMP + Compose for MVP client
ADR-002 RewardGrant event ledger
ADR-003 TrainingConversion source of truth
ADR-004 Deterministic combat engine
ADR-005 Data-driven content runtime
ADR-006 Story revision concurrency
ADR-007 Local-first progression
```

---

# 39. Architecture Acceptance Criteria

- Domain calculation 不依賴 UI
- Battle 可 headless 執行
- 同 seed + command sequence 得相同結果
- Reward retry 不重複
- app kill 後 Timer 可恢復
- Story transition 可驗 revision
- Projection 可由 canonical records reconstruct
- Content 可新增而不改 core runtime

---

# 40. Architecture Thesis

> **MVP 要快，但不能用「先全部塞在 ViewModel」來換速度。**

真正需要被保護的是：
- progression source of truth
- deterministic combat
- story state
- content/data separation

其餘 infrastructure 可以先簡化。