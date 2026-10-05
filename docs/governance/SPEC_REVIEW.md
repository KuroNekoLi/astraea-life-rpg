# Cross-Spec Consistency Review
## `SPEC_REVIEW.md`

**版本：** v1.1  
**狀態：** Post-Decision Review  
**決策基線：** OD-001～OD-008 Accepted

# 1. Executive Summary

P0 cross-spec consistency review 已完成，原本 8 個 implementation-blocking 決策已全部定案並回寫受影響規格。

目前正式 architecture contract：

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
↓
LifeProgressionEngine
↓
RewardGrant
↓
LifeProgress / GrowthPotentialBalance projections
↓
TrainingConversion
↓
AttributeState projection
↓
Combat
```

Story：

```text
Story transition
+ expected_story_revision
↓
Story Runtime validation
↓
StoryState revision + 1
```

Evidence deletion：

```text
Delete Evidence
→ Evidence payload / coverage changes
→ confirmed personal RewardGrant remains immutable
```

# 2. P0 Review Result

| Previous Issue | Resolution | Status |
|---|---|---|
| Life XP ownership | LifeProgressionEngine | RESOLVED |
| Reward ledger | RewardGrant | RESOLVED |
| Growth Potential provenance | RewardGrant → balance projection | RESOLVED |
| Attribute growth source | TrainingConversion | RESOLVED |
| Quest model overlap | Four-model split | RESOLVED |
| Relationship duplication | CharacterRelationship only | RESOLVED |
| Story merge | revision-based sequencing | RESOLVED |
| Offline reward | RewardPreview → RewardGrant | RESOLVED |
| Evidence deletion | no retroactive personal XP rollback | RESOLVED |

**P0 cross-spec conflict count: 0**

# 3. Canonical Ownership Map

| Concept | Owning System / Record |
|---|---|
| Life Quest configuration | Quest System / UserLifeQuest |
| Life Quest templates | Content Pipeline / QuestTemplate |
| Story Quest content | Content Pipeline / StoryQuestDefinition |
| Story Quest runtime | StoryQuestState |
| Evidence | Evidence System / Evidence |
| Evidence summary | Derived EvidenceSummary |
| Final Life XP | LifeProgressionEngine |
| Reward transaction | RewardGrant |
| Life Level / Momentum | LifeProgress projection |
| Growth Potential balance | GrowthPotentialBalance projection |
| Attribute permanent growth | TrainingConversion |
| Current Attributes | AttributeState projection |
| Relationships | CharacterRelationship |
| Story progression | StoryState |
| Spell semantics | Spell / Function System |
| Battle runtime | Combat System |
| Sync / concurrency | Save & Sync Backend |

# 4. Remaining P1 Decisions

Still open:
- OD-009 Growth Potential taxonomy
- OD-010 Character Level
- OD-011 Spell cooldown
- OD-012 naming normalization
- OD-013 difficulty mapping
- OD-014 Evidence policy ownership
- OD-015 version vocabulary
- OD-016 story content migration
- OD-017 EvidenceSummary projection semantics
- OD-018 Momentum ownership
- OD-019 domain catalog vs MVP domains
- OD-020 Prepared Deck concurrency

Several of these already have baseline recommendations reflected in updated specs where they are architectural hygiene, but remain tracked until formally accepted as product decisions.

# 5. Implementation Readiness

The P0 specs are now safe to use as the MVP architecture baseline provided engineering follows:

1. Never write Life XP directly outside RewardGrant.
2. Never mutate permanent Attribute Growth outside TrainingConversion.
3. Never merge StoryState with LWW or arbitrary flag union.
4. Never treat EvidenceSummary as canonical Evidence.
5. Never make client RewardPreview authoritative.
6. Never store relationship values inside StoryState.
7. Never combine user-created Life Quest and authored Story Quest into one mutable model.
8. Preserve idempotency and version metadata on all progression transactions.

# 6. Remaining Risk

The largest remaining risks are no longer cross-spec contradictions; they are product/balance unknowns:

- Is Training Conversion fun or friction?
- Does Growth Potential feel intuitive?
- Can Function Graph combat remain understandable on mobile?
- Does Life Layer motivate action without making story feel gated?
- Do users return on D7?

These belong to prototype and analytics validation, not schema reconciliation.

# 7. Review Verdict

**P0 cross-spec review: PASS**

The current spec set may be frozen as:

```text
SPEC_BASELINE_v1.0
```

for MVP implementation and prototyping.