# Open Decisions
## `OPEN_DECISIONS.md`

**版本：** v1.0  
**狀態：** Decision Backlog  
**來源：** `SPEC_REVIEW.md`

本文件只記錄需要明確定案的問題。  
每項決策在定案後應：
1. 填入 Decision。
2. 標示 `Accepted`。
3. 回寫受影響規格。
4. 若屬長期 architecture / canon 決策，建立 ADR。

---

# Decision Status

```text
OPEN
PROPOSED
ACCEPTED
REJECTED
DEFERRED
```

---

# P0 — Implementation Blocking

## OD-001 — Life XP Final Calculation Owner

**Status:** ACCEPTED  
**Priority:** P0

### Question

Life XP 最終數值由誰負責計算？

目前：
- Quest 有 difficulty / duration / activity metadata
- Evidence 有 verification
- Life Progression 有公式
- Backend 要 server-authoritative

### Options

A. Quest System calculates XP  
B. Evidence System calculates XP  
C. Client calculates final XP  
D. **Life Progression Engine calculates final XP**

### Recommendation

**D**

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
→ LifeProgressionCalculator
→ RewardGrant
```

Quest / Evidence 只提供 input。

### Impacted Specs
- `LIFE_PROGRESSION_SYSTEM.md`
- `QUEST_SYSTEM.md`
- `EVIDENCE_SYSTEM.md`
- `DATA_MODEL.md`
- `SAVE_SYNC_BACKEND_SPEC.md`

### Decision
Accepted: `LifeProgressionEngine` is the sole final Life XP calculator; Quest and Evidence provide inputs only.

---

## OD-002 — Canonical Reward Ledger

**Status:** ACCEPTED  
**Priority:** P0

### Question

Life XP、Growth Potential、Gold、Battle Reward 是否統一使用 `RewardGrant`？

### Recommendation

Yes.

`RewardGrant` 是唯一不可變 reward transaction envelope。

```text
RewardGrant
source
rewards[]
idempotency_key
formula_version
```

`LifeProgress.total_xp`、`GrowthPotentialBalance` 等是 projection。

### Reason

避免：
- duplicate rewards
- balance 無法 audit
- sync 重複
- formula migration 無來源

### Impacted Specs
- `DATA_MODEL.md`
- `SAVE_SYNC_BACKEND_SPEC.md`
- `LIFE_PROGRESSION_SYSTEM.md`
- `MVP_VERTICAL_SLICE.md`

### Decision
Accepted: immutable `RewardGrant` is the canonical reward ledger for Life XP, Growth Potential, Gold and other grants; balances are projections.

---

## OD-003 — Attribute Growth Source of Truth

**Status:** ACCEPTED  
**Priority:** P0

### Question

永久 Attribute Growth 的 source of truth 是：
- `AttributeState.permanent_growth`
- 還是 `TrainingConversion`？

### Recommendation

```text
TrainingConversion = immutable source of truth
AttributeState = projection
```

TrainingConversion 必須保存：
- Potential consumed
- TrainingDefinition version
- resulting attribute delta
- idempotency key

### Impacted Specs
- `CHARACTER_PROGRESSION_SYSTEM.md`
- `DATA_MODEL.md`
- `SAVE_SYNC_BACKEND_SPEC.md`

### Decision
Accepted: immutable `TrainingConversion` is the source of truth for permanent Attribute Growth; `AttributeState` is a projection.

---

## OD-004 — Quest Domain Model Split

**Status:** ACCEPTED  
**Priority:** P0

### Question

如何統一：
- `LifeQuest`
- `QuestDefinition`
- `QuestState`

### Recommendation

```text
QuestTemplate
= authored reusable Life template

UserLifeQuest
= player-owned configured Life Quest

StoryQuestDefinition
= authored Astraea quest

StoryQuestState
= player's runtime progress
```

避免讓 user-created Life Quest 強迫使用 Story content model。

### Impacted Specs
- `QUEST_SYSTEM.md`
- `DATA_MODEL.md`
- `CONTENT_PIPELINE.md`
- `SAVE_SYNC_BACKEND_SPEC.md`

### Decision
Accepted: split into `QuestTemplate`, `UserLifeQuest`, `StoryQuestDefinition`, `StoryQuestState`.

---

## OD-005 — Relationship State Ownership

**Status:** ACCEPTED  
**Priority:** P0

### Question

Relationship data 應存在：
- `StoryState.relationship_state{}`
- `CharacterRelationship`
- 或兩者？

### Recommendation

Only:

```text
CharacterRelationship
```

StoryState 只保存 story progression 與 choices。

Story conditions 可讀取 Relationship。

### Impacted Specs
- `DATA_MODEL.md`
- `SAVE_SYNC_BACKEND_SPEC.md`
- future `NARRATIVE_DESIGN.md`

### Decision
Accepted: `CharacterRelationship` exclusively owns relationship state; `StoryState` does not duplicate it.

---

## OD-006 — StoryState Concurrency Model

**Status:** ACCEPTED  
**Priority:** P0

### Question

跨裝置 StoryState 如何 merge？

### Reject

- Last-write-wins
- arbitrary union of story flags

### Recommendation

Server-sequenced revision model：

```text
AdvanceStory(
  transition_id,
  expected_story_revision
)
```

成功：
```text
story_revision + 1
```

Conflict：
- reject
- refresh
- resume authoritative state

### Impacted Specs
- `DATA_MODEL.md`
- `SAVE_SYNC_BACKEND_SPEC.md`
- `CONTENT_PIPELINE.md`

### Decision
Accepted: Story progression uses server-sequenced `story_revision` with expected-revision validation; no LWW or arbitrary flag merge.

---

## OD-007 — Offline Reward Semantics

**Status:** ACCEPTED  
**Priority:** P0

### Question

離線完成 Life Quest 時，畫面上的 XP 是 final 還是 provisional？

### Recommendation

Production：

```text
Client RewardPreview
→ Pending Operation
→ Server RewardGrant
→ Confirmed
```

正常 deterministic E0/E1 case 應無感確認。

### Impacted Specs
- `SAVE_SYNC_BACKEND_SPEC.md`
- `LIFE_PROGRESSION_SYSTEM.md`
- `GAME_FLOW_AND_IA.md`
- `MVP_VERTICAL_SLICE.md`

### Decision
Accepted: offline client shows deterministic `RewardPreview`; server confirmation persists authoritative `RewardGrant`.

---

## OD-008 — Evidence Deletion After Reward

**Status:** ACCEPTED  
**Priority:** P0 before connected evidence

### Question

玩家刪掉已提供 XP bonus 的 Evidence 後：

```text
Base 30
E2 bonus +3
Total 33
```

怎麼處理？

### Options

A. XP 回退到 30  
B. 保留 33，但 Evidence Coverage 下降  
C. 刪除整筆 Activity  
D. Depend on Evidence type

### Recommendation

Personal progression：

**B**

Reward transaction 已發生，不 retroactively rewrite personal history。

Evidence payload 可刪除；Evidence Coverage / future competitive eligibility 重新計算。

Competitive finalization 可採更嚴格政策。

### Impacted Specs
- `EVIDENCE_SYSTEM.md`
- `DATA_MODEL.md`
- `SAVE_SYNC_BACKEND_SPEC.md`
- Privacy spec future

### Decision
Accepted: deleting Evidence does not retroactively rollback personal confirmed XP; Evidence Coverage / badges / competitive eligibility may change.

---

# P1 — Resolve Before Closed Beta

## OD-009 — Growth Potential Taxonomy

**Status:** PROPOSED  
**Priority:** P1

### Current

Long-term:
```text
Physical
Cognitive
Communication
Creative
Discipline
```

MVP:
```text
Physical
Cognitive
Communication
```

### Recommendation

Schema 使用 extensible category IDs。

MVP enable 3。

不要 hard-code enum only 3。

### Decision
TBD

---

## OD-010 — Character Level

**Status:** PROPOSED  
**Priority:** P1

### Question

是否需要獨立 Character Level？

目前已有：
- Life Level
- 8 Attributes
- Build

### Options

A. Remove Character Level entirely  
B. Keep as cosmetic / narrative aggregate  
C. Make it combat-power level

### Recommendation

**B 或 MVP 隱藏。**

不建議 C。

### Reason

避免三套 Level 語意混亂。

### Decision
TBD

---

## OD-011 — Spell Cooldown

**Status:** PROPOSED  
**Priority:** P1

### Question

Prepared Deck Spell 是否有 cooldown？

### Recommendation

MVP：

```text
cooldown_rule = optional/null
```

先用：
- Mana
- action economy
- casting method
- conditions

驗證核心戰鬥。

Cooldown 之後再加入特定 Spell。

### Decision
TBD

---

## OD-012 — “Main Quest” Naming

**Status:** PROPOSED  
**Priority:** P1

### Problem

`Main Quest` 同時可能指：
- real-life primary goal
- Astraea main story

### Recommendation

全規格統一：

```text
Life Goal
Main Story
Life Quest
Story Quest
```

### Decision
TBD

---

## OD-013 — Challenge Factor Mapping

**Status:** PROPOSED  
**Priority:** P1

### Recommendation

Quest owns：

```text
difficulty = Easy | Normal | Hard | Epic
```

Life Progression owns：

```text
difficulty → ChallengeFactor
```

Multiplier 跟 `formula_version` 走。

### Decision
TBD

---

## OD-014 — Evidence Policy Ownership

**Status:** PROPOSED  
**Priority:** P1

### Recommendation

Evidence System 定義 enum：

```text
Optional
Recommended
RequiredForCompetitive
RequiredForAchievement
```

Quest 只引用。

### Decision
TBD

---

## OD-015 — Version Vocabulary

**Status:** PROPOSED  
**Priority:** P1

### Standardize

```text
schema_version
content_version
formula_version
verification_version
revision
```

Use:
- `revision` = mutable player object concurrency
- `content_version` = authored content release
- `schema_version` = serialization shape

### Required Patch

`FunctionGraph.version`
→ `content_version` + `schema_version`

`PreparedDeck`
→ add `revision`

### Decision
TBD

---

## OD-016 — Story Content Migration Policy

**Status:** PROPOSED  
**Priority:** P1

### Recommendation

Changes classified:

#### Non-structural
- dialogue text
- typo
- portrait
- camera

No state migration.

#### Structural
- scene ID
- branch
- flag
- objective dependency

Requires migration mapping.

### Decision
TBD

---

## OD-017 — Evidence Summary Persistence

**Status:** PROPOSED  
**Priority:** P1

### Question

Is `EvidenceSummary` source of truth or derived?

### Recommendation

Derived projection/cache.

Canonical:
```text
Evidence[]
```

Derived:
```text
highest_level
bonus_eligibility
competitive_eligible
```

### Decision
TBD

---

## OD-018 — Momentum Owner

**Status:** PROPOSED  
**Priority:** P1

### Recommendation

Life Progression Engine exclusively calculates Momentum.

Quest Recommendation consumes it read-only.

### Decision
TBD

---

## OD-019 — Supported Life Domains vs MVP Domains

**Status:** PROPOSED  
**Priority:** P1

### Recommendation

Separate:

```text
DomainCatalog
```

from:

```text
EnabledDomainsForProductVersion
```

Full catalog may include 8.

MVP enables:
- Fitness
- Learning
- Languages

### Decision
TBD

---

## OD-020 — Prepared Deck Concurrency

**Status:** PROPOSED  
**Priority:** P1

### Recommendation

Add:

```text
revision
```

Deck update uses optimistic concurrency.

### Decision
TBD

---

# P2 — Safe to Defer

## OD-021 — Battle Event Log Storage

**Status:** DEFERRED  
**Priority:** P2

MVP may keep `event_log[]` inside BattleState.

Later:
```text
BattleState snapshot
+
BattleEvent append-only stream
```

---

## OD-022 — Growth Potential Expiry

**Status:** PROPOSED  
**Priority:** P2

Recommendation:
- no hard expiry for MVP
- consider anti-hoarding only after data

---

## OD-023 — Romance

**Status:** OPEN  
**Priority:** P2

No impact on MVP systems.

---

## OD-024 — Season System

**Status:** DEFERRED  
**Priority:** P2

Do not finalize before core D7 loop is validated.

---

## OD-025 — Reality Cost Gameplay Representation

**Status:** OPEN  
**Priority:** P2

Options:
- qualitative Low/Medium/High
- hidden systemic value
- explicit numeric meter

Must respect spoiler timing.

---

# Recommended Decision Order

Resolve in this exact order:

```text
OD-001 XP owner
↓
OD-002 Reward ledger
↓
OD-003 Attribute source of truth
↓
OD-004 Quest model
↓
OD-005 Relationship ownership
↓
OD-006 Story concurrency
↓
OD-007 Offline reward
↓
OD-008 Evidence deletion
```

These eight decisions stabilize the data architecture.

Then:

```text
OD-009 → OD-020
```

stabilize product semantics and MVP implementation.

---

# Suggested ADRs After Approval

Create ADRs for:

```text
ADR-LIFE-001  RewardGrant as canonical reward ledger
ADR-LIFE-002  TrainingConversion as attribute-growth source
ADR-QUEST-001 Life Quest vs Story Quest domain split
ADR-STORY-001 Revision-based StoryState concurrency
ADR-SYNC-001  Offline provisional reward model
ADR-EVID-001  Evidence deletion semantics
```

---

# Definition of “Spec Ready”

P0 specs are implementation-ready when:

- OD-001 through OD-008 are `ACCEPTED`.
- affected specs are patched.
- `DATA_MODEL.md` has one source of truth per progression concept.
- server/client calculation ownership is explicit.
- story concurrency is explicit.
- MVP can run offline without reward duplication.