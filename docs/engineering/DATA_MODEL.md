# Unified Data Model Specification
## `DATA_MODEL.md`

**版本：** v1.1  
**狀態：** Implementation Baseline  
**決策基線：** OD-001～OD-008 Accepted

# 1. Design Principles

- Stable opaque IDs
- Versioned schemas
- Immutable progression transactions
- Materialized projections may be rebuilt
- Idempotent rewards
- Local/offline capable
- Story transitions are revision-controlled
- Evidence provenance preserved
- Canon content and player state separated
- One source of truth per progression concept

# 2. Canonical Ownership

```text
Quest input          → Quest System
Evidence             → Evidence System
Life XP calculation  → LifeProgressionEngine
Reward transaction   → RewardGrant
Training growth      → TrainingConversion
Attribute state      → Attribute projection
Story transition     → Story Runtime
Story authored data  → Content Pipeline
Combat runtime       → Combat System
Sync/concurrency      → Save/Sync Backend
```

# 3. Aggregate Overview

```text
User
├── PlayerProfile
├── Character
├── UserLifeQuest[]
├── LifeActivity[]
├── RewardGrant[]
├── LifeProgress projections
├── GrowthPotentialBalance projections
├── TrainingConversion[]
├── Evidence[]
├── StoryState
├── StoryQuestState[]
├── CharacterRelationship[]
├── PreparedDeck
└── AchievementState[]
```

# 4. User

```text
User
├── id
├── account_type
├── created_at
├── locale
├── timezone
├── schema_version
└── settings
```

# 5. PlayerProfile

```text
PlayerProfile
├── user_id
├── display_name
├── privacy_defaults
├── onboarding_state
└── active_life_domain_ids[]
```

# 6. Character

```text
Character
├── id
├── user_id
├── name
├── character_level?       # optional / may be hidden in MVP
├── weapon_id
├── appearance
├── prepared_deck_id
├── schema_version
└── revision
```

# 7. AttributeState — Projection

`AttributeState` is a materialized projection, not the permanent-growth source of truth.

```text
AttributeState
├── character_id
├── attribute_type
├── base_value
├── aptitude
├── permanent_growth       # derived from TrainingConversion
├── temporary_modifier
├── effective_value
├── projection_version
└── updated_at
```

# 8. LifeDomain

```text
LifeDomainDefinition
├── id
├── parent_id
├── name_key
├── icon
├── schema_version
└── content_version
```

Player activation / privacy:

```text
UserLifeDomain
├── user_id
├── domain_id
├── active
├── privacy
└── revision
```

# 9. Quest Domain Model — Accepted OD-004

## QuestTemplate

Authored reusable Life template.

```text
QuestTemplate
├── id
├── domain_id
├── title_key
├── default_recurrence
├── default_duration
├── default_difficulty
├── verification_policy
├── schema_version
└── content_version
```

## UserLifeQuest

Player-owned configured quest.

```text
UserLifeQuest
├── id
├── user_id
├── template_id?
├── domain_id
├── title
├── type
├── recurrence
├── difficulty
├── estimated_duration
├── activity_group
├── verification_policy
├── status
├── created_at
├── archived_at
└── revision
```

## StoryQuestDefinition

Authored Astraea quest.

```text
StoryQuestDefinition
├── id
├── chapter_id
├── title_key
├── description_key
├── objectives[]
├── rewards[]
├── unlock_conditions[]
├── schema_version
└── content_version
```

## StoryQuestState

```text
StoryQuestState
├── user_id
├── quest_id
├── status
├── objective_states[]
├── started_at
├── completed_at
└── revision
```

# 10. LifeActivity

```text
LifeActivity
├── id
├── user_id
├── life_quest_id
├── domain_id
├── start_at
├── end_at
├── raw_duration
├── normalized_duration
├── difficulty_snapshot
├── activity_group
├── evidence_summary_id?
├── created_offline
├── schema_version
└── created_at
```

LifeActivity does **not** own the final XP number.

# 11. Evidence

```text
Evidence
├── id
├── activity_id
├── type
├── level
├── source_provider
├── source_record_id?
├── captured_at
├── verified_at?
├── confidence?
├── privacy
├── metadata
├── verification_version
└── schema_version
```

# 12. EvidenceSummary — Projection

```text
EvidenceSummary
├── activity_id
├── highest_level
├── evidence_bonus_eligibility
├── competitive_eligible
├── verification_status
├── projection_version
└── updated_at
```

Canonical source is `Evidence[]`, not EvidenceSummary.

# 13. RewardGrant — Canonical Reward Ledger

**Decision OD-002: Accepted**

All progression/economy rewards use an immutable transaction envelope.

```text
RewardGrant
├── id
├── user_id
├── source_type
├── source_id
├── rewards[]
├── idempotency_key
├── formula_version
├── created_at
└── schema_version
```

Example:

```text
rewards:
- LIFE_XP(domain=Learning, amount=25)
- GROWTH_POTENTIAL(type=Cognitive, amount=18)
```

RewardGrant is append-only except administrative repair with audit trail.

# 14. LifeProgress — Projection

```text
LifeProgress
├── user_id
├── domain_id
├── total_xp              # derived from RewardGrant
├── level
├── momentum_7d
├── momentum_28d
├── evidence_coverage
├── projection_version
└── updated_at
```

# 15. GrowthPotentialBalance — Projection

```text
GrowthPotentialBalance
├── user_id
├── category
├── available_amount
├── lifetime_earned
├── lifetime_spent
├── projection_version
└── updated_at
```

Earned values derive from RewardGrant. Spent values derive from TrainingConversion.

# 16. TrainingConversion — Canonical Attribute Growth Event

**Decision OD-003: Accepted**

```text
TrainingConversion
├── id
├── user_id
├── character_id
├── training_definition_id
├── training_content_version
├── potential_category
├── amount_spent
├── attribute_deltas[]
├── idempotency_key
├── created_at
└── schema_version
```

`AttributeState.permanent_growth` is projected from these events.

# 17. TrainingDefinition

```text
TrainingDefinition
├── id
├── potential_cost_type
├── base_cost
├── affected_attributes[]
├── efficiency_curve_id
├── unlock_condition
├── schema_version
└── content_version
```

# 18. StoryState — Revision Controlled

**Decisions OD-005 / OD-006: Accepted**

StoryState does **not** contain relationship state.

```text
StoryState
├── user_id
├── chapter_id
├── scene_id
├── step_id?
├── flags{}
├── choices[]
├── story_revision
├── schema_version
└── content_version
```

Story transitions must provide expected previous revision.

# 19. CharacterRelationship

```text
CharacterRelationship
├── user_id
├── character_id
├── trust
├── affinity
├── shared_history_flags[]
├── tactical_synergy
├── revision
└── schema_version
```

This is the sole owner of relationship state.

# 20. SpellDefinition

```text
SpellDefinition
├── id
├── name_key
├── graph_id
├── category
├── casting_methods[]
├── base_mana_cost
├── complexity
├── requirements[]
├── cooldown_rule?
├── tags[]
├── schema_version
└── content_version
```

# 21. FunctionGraph

```text
FunctionGraph
├── id
├── nodes[]
├── edges[]
├── entry_nodes[]
├── output_nodes[]
├── weak_node_rules[]
├── counter_metadata
├── schema_version
└── content_version
```

# 22. FunctionNode

```text
FunctionNode
├── id
├── type
├── parameters
├── complexity
├── interruptible
├── reversible
└── tags[]
```

# 23. PreparedDeck

```text
PreparedDeck
├── id
├── character_id
├── slot_limit
├── spell_ids[]
├── revision
├── schema_version
└── updated_at
```

# 24. BattleDefinition

```text
BattleDefinition
├── id
├── encounter_id
├── battlefield_id
├── enemies[]
├── party_rules
├── seed_policy
├── victory_conditions[]
├── tutorial_flags[]
├── schema_version
└── content_version
```

# 25. BattleState

```text
BattleState
├── id
├── user_id
├── definition_id
├── seed
├── round
├── initiative_order[]
├── unit_states[]
├── active_functions[]
├── battlefield_state
├── event_log[]
├── status
├── revision
└── schema_version
```

# 26. Achievement

```text
AchievementDefinition
├── id
├── type
├── title_key
├── criteria
├── verification_requirement
├── visibility
├── schema_version
└── content_version
```

```text
AchievementState
├── user_id
├── achievement_id
├── status
├── evidence_level
├── completed_at
└── revision
```

# 27. Season

```text
SeasonDefinition
├── id
├── start_at
├── end_at
├── theme
├── rewards[]
├── schema_version
└── content_version
```

# 28. Reward Preview

Client may calculate an ephemeral deterministic:

```text
RewardPreview
```

It is never persisted as canonical reward truth.

Final persisted result is `RewardGrant`.

# 29. Source of Truth Table

| Concept | Source of truth |
|---|---|
| Life Activity | `LifeActivity` |
| Evidence | `Evidence` |
| Life XP / Growth reward | `RewardGrant` |
| Life total / Level / Momentum | `LifeProgress` projection |
| Growth Potential balance | `GrowthPotentialBalance` projection |
| Attribute permanent growth | `TrainingConversion` |
| Current Attribute values | `AttributeState` projection |
| Story progression | `StoryState` |
| Relationships | `CharacterRelationship` |
| Story Quest runtime | `StoryQuestState` |
| Deck | `PreparedDeck` |
| Combat runtime | `BattleState` |

# 30. Version Vocabulary — Baseline

```text
schema_version
content_version
formula_version
verification_version
revision
projection_version
```

Definitions:
- `schema_version`: serialization shape
- `content_version`: authored content release
- `formula_version`: reward/progression calculation
- `verification_version`: Evidence verification logic
- `revision`: mutable player-object concurrency
- `projection_version`: materialized view implementation version

# 31. Idempotency

Mandatory for:
- RewardGrant
- TrainingConversion
- Battle reward
- Achievement grant
- imported provider Activity

# 32. MVP Minimum Entities

P0:
- User
- PlayerProfile
- Character
- AttributeState
- LifeDomainDefinition
- UserLifeDomain
- QuestTemplate
- UserLifeQuest
- LifeActivity
- Evidence
- EvidenceSummary
- RewardGrant
- LifeProgress
- GrowthPotentialBalance
- TrainingConversion
- StoryState
- StoryQuestDefinition
- StoryQuestState
- CharacterRelationship
- SpellDefinition
- FunctionGraph
- PreparedDeck
- BattleState

# 33. Core Thesis

> Immutable events / grants preserve history; projections make the product fast to read.

```text
RewardGrant
→ LifeProgress
→ GrowthPotentialBalance

TrainingConversion
→ AttributeState

Ordered Story Transition
→ StoryState
```