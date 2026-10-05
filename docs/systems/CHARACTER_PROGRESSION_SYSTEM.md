# Character Progression System Specification
## `CHARACTER_PROGRESSION_SYSTEM.md`

**版本：** v1.0  
**狀態：** Working Specification  
**隸屬文件：** `Life_RPG_Astraea_GDD_v1.1.md`  
**相關文件：** `LIFE_PROGRESSION_SYSTEM.md`, `COMBAT_SYSTEM.md`, `QUEST_SYSTEM.md`

> 標記規則  
> - **Canon**：來自既有 Astraea 設定。  
> - **GDD Proposal**：為 Life RPG 整合新增。  
> - **TBD**：待 playtest / balance / narrative 決策。  

# 1. System Goal

本系統負責補上完整成長鏈：

```text
Real-Life Action
→ Life XP
→ Growth Potential
→ Training
→ Character Attributes
→ Build
→ Combat Expression
```

核心原則：

> Life Progress 影響角色的「成長方向與彈性」，但不能靠現實 grind 直接碾壓主線。

# 2. Canon Attributes

Hero 使用八項能力：

1. Mana Capacity
2. Mana Output
3. Computation
4. Processing
5. Precision
6. Efficiency
7. Ambient Sync
8. Analysis

初始建立規則：
- Base = 8
- Fixed Allocation = 32
- Fixed Allocation 單項上限 = 15
- Scene 2 Aptitude Roll
- Fate Reroll 一項，必須接受新結果

# 3. Attribute Responsibility

## Mana Capacity
可用 Mana 上限與高消耗 Spell 的持續能力。

## Mana Output
單次 Function 的安全輸出規模、Burst 類 Spell 上限。

## Computation
處理 Function Complexity、複雜術式、Counter 推理。

## Processing
Initiative、Chantless、Reaction、快速戰場處理。

## Precision
Targeting、Interrupt、Chantless 穩定度、精細控制。

## Efficiency
同等術式的 Mana 消耗、資源利用效率。

## Ambient Sync
與環境魔力、場域條件、支援型魔法的互動。

## Analysis
Reveal Function Graph、Weak Node、Invertibility、Counter-Function。

# 4. Derived Stats

**GDD Proposal**

Derived Stats 不新增過多可見數字。初版建議只在需要時推導：

```text
Initiative Bonus
Mana Pool
Spell Stability
Analysis Power
Interrupt Accuracy
Technique Accuracy
```

公式：**TBD**。

原則：Attribute 是核心；Derived Stat 是執行層，不再形成第二套複雜養成。

# 5. Growth Potential

來自 `LIFE_PROGRESSION_SYSTEM.md`。

MVP 類別：

```text
Physical Potential
Cognitive Potential
Communication Potential
```

後續可擴：

```text
Creative Potential
Discipline Potential
```

Growth Potential 不是 Attribute 點數。

# 6. Training Conversion

玩家在 Astraea 透過 Training 將 Potential 轉為 Progress。

例如：

```text
Cognitive Potential
→ Function Analysis Drill
→ Analysis Progress
```

```text
Physical Potential
→ Reaction Drill
→ Processing Progress
```

Training 的作用是讓玩家做 build choice，而不是直接自由點數。

## 6.1 MVP Prototype Balance — Accepted for `character-growth-mvp-1`

These are explicit prototype values for the MVP and are not canon or launch balance. The policy lives in `assets/content/progression/character_growth_mvp_v1.json`; each TrainingConversion records the policy/content version used.

| Training | Potential category | Attribute gained |
| --- | --- | --- |
| Reaction Drill | Physical | Processing |
| Precision Movement | Physical | Precision |
| Function Analysis Drill | Cognitive | Analysis |
| Complexity Exercise | Cognitive | Computation |
| Mana Control Drill | Cognitive | Efficiency |
| Intent Encoding Drill | Communication | Mana Output |

Each completed Training session spends the quoted Potential and grants **+1 permanent growth** to the listed Attribute. The base cost is **18 Potential**. Apply Aptitude adjustment first (`1–2: +2`, `3–4: +0`, `5–6: −2`), then multiply by the growth tier for the same Attribute (`0–4 prior growth: ×1`, `5–9: ×2`, `10+: ×3`). For example, neutral Aptitude costs 18/36/54 Potential across those tiers. Costs remain positive at all configured ratings.

### Aptitude and Fate

- Roll one injected-RNG `1d6` for each of the eight Attributes in canonical attribute order. Store all eight ratings and the policy content version.
- Aptitude affects Training cost only. It does not alter Base Attributes or directly add/subtract effective Attribute value.
- Once per character, after viewing the profile, the player may choose one Attribute and reroll its `1d6`. The replacement is mandatory, even if it is equal or lower. No second reroll is allowed.
- Persist the resulting values, Fate-used flag, RNG state/seed, and policy version so save/resume and replay preserve the result.
- Growth cost tiers are a prototype soft cap; they are not a world/canon hard cap. Revisit all balance values after player testing.

# 7. Attribute Progress

**GDD Proposal**

每個 Attribute 有：

```text
base_value
aptitude_modifier
training_progress
effective_value
```

建議：

```text
effective_value
=
base_value
+ permanent_growth
+ temporary_modifier
```

正式版精確成長曲線仍待 playtest/balance；MVP prototype 暫用第 6.1 節與 `character-growth-mvp-1` 的版本化曲線。

# 8. No Direct Life-to-Stat Mapping

禁止：

```text
Run 5km → Processing +1
Read 30m → Analysis +1
```

原因：
- 會鼓勵 stat farming
- 扭曲真實生活選擇
- 破壞 RPG training decision

正確：

```text
Life Activity
→ Potential
→ Training
→ Attribute Progress
```

# 9. Soft Cap

**GDD Proposal**

Attribute 成長需 diminishing return。

例如：
- 低值：成長容易
- 中值：正常
- 高值：成本上升
- 極高值：需特殊 Training / Story / Aptitude

避免玩家靠大量 Life XP 早期突破主線平衡。

# 10. Hard Cap

是否存在永久硬上限：**TBD**。

建議 MVP：
- 先設 implementation cap
- 不在 UI 宣稱世界觀硬上限

# 11. Aptitude

Scene 2 Aptitude Roll 應影響：
- 某 Attribute 的長期成長效率
- 初始 build identity
- 特定 Training 的成本

但不能讓低 Roll 變成「角色報廢」。MVP prototype 使用第 6.1 節的 `1d6` 成本調整：低 Roll 僅使相應訓練多花 2 Potential，不降低 Attribute，也不封鎖訓練。

# 12. Build

Build 不是固定 Class。

Build 由：

```text
Attributes
+ Weapon
+ Prepared Deck
+ Spell Handling
+ Techniques
+ Player Decisions
```

形成。

# 13. Example Builds

## Function Analyst
偏高：
- Analysis
- Computation
- Efficiency

玩法：
- Reveal
- Weak Node
- Counter

## Chantless Specialist
偏高：
- Processing
- Precision
- Computation

玩法：
- Fast cast
- Reactive magic
- flexible sequencing

## High Output Caster
偏高：
- Mana Capacity
- Mana Output

玩法：
- burst
- area pressure
- high-cost spell

## Support Controller
偏高：
- Efficiency
- Ambient Sync
- Precision

玩法：
- barrier
- stabilization
- spatial / party setup

# 14. Weapon Interaction

武器不綁 Class。

武器可以提供：
- Technique
- Range
- Positioning identity
- Spell synergy

初始四武器：
- Longsword
- Spear
- Arcane Gun
- Staff

# 15. Spell Requirement

Spell 可要求：

```text
minimum_attribute
complexity_tolerance
mana_output
casting_method
```

但不要讓大量 Spell 因 1 點差距完全不可用。

建議：
- 達標：正常
- 未達：較高成本 / 較慢 / 不穩定
- 極度未達：不可使用

# 16. Training Types

MVP：

```text
Function Analysis Drill
Complexity Exercise
Reaction Drill
Precision Movement
Intent Encoding Drill
Mana Control Drill
```

每種 Training：
- 消耗指定 Potential
- 推進 1–2 Attribute
- 有 diminishing return

# 17. Respec

**GDD Proposal**

不允許無成本完全重置人生累積。

但 RPG Build 應允許調整：
- Prepared Deck：自由
- Weapon：可換
- Technique：可換
- Attribute permanent growth：不可完全 reset 或需高成本

理由：角色應保留成長歷史。

# 18. Temporary Modifiers

允許：
- Training buff
- equipment cosmetic-linked utility? **TBD**
- story status
- environment
- injury / disruption

不應讓付費物品提供永久 attribute advantage。

# 19. Character Level

**GDD Proposal**

Character Level 可存在作整體 RPG progression 摘要，但不是主要能力來源。

建議：
- 解鎖 UI / cosmetic / story-safe feature
- 不直接給大量 stat
- 不代表 Life Mastery

# 20. Life Level vs Character Attribute vs Character Level

```text
Life Level
= 真實世界某領域投入

Character Attribute
= RPG 角色能力參數

Character Level
= RPG 整體歷程摘要
```

三者不能混為一談。

# 21. Growth Budget

**GDD Proposal**

為避免無限 grind：
- Potential 取得 sub-linear
- Training 有 soft cap
- 主線有 baseline scaling
- 高階成長需要多樣化與時間

# 22. Baseline Story Progression

即使 Life Progress 很低，玩家也應能：
- 用正確 Deck
- 理解 Function
- 利用 Party
- 降低難度

完成主線。

Life Progress 的價值是：
- 更多容錯
- 更多 build 選擇
- 更高效率
- optional solution

# 23. Power Budget

主線戰鬥中：

```text
Strategy + System Understanding
>
Raw Attribute Advantage
```

Attribute 應影響：
- 成功率
- 資源
- timing
- flexibility

而非單純 HP / damage 膨脹。

# 24. MVP Scope

MVP 實作：
- 8 Attributes
- initial allocation
- aptitude roll
- 3 Growth Potential
- 5–6 Training
- Training Conversion
- Attribute 對 initiative / mana / analysis / precision 的實際影響
- 4 weapons
- Prepared Deck interaction

不做：
- prestige
- class tree
- respec economy
- endgame cap
- gear stat grind

# 25. Data Model

```text
CharacterProgression
├── character_id
├── character_level
├── attributes[]
├── aptitude[]
├── training_history[]
├── temporary_modifiers[]
└── build_snapshot
```

```text
AttributeState
├── attribute_type
├── base_value
├── aptitude
├── permanent_growth
├── temporary_modifier
└── effective_value
```

```text
TrainingDefinition
├── id
├── cost_type
├── cost_amount
├── affected_attributes
├── efficiency_curve
└── unlock_condition
```

# 26. Telemetry

- attribute_allocated
- aptitude_rolled
- fate_reroll_used
- training_selected
- potential_spent
- attribute_increased
- build_snapshot_changed
- weapon_changed
- spell_requirement_failed

# 27. Validation Questions

1. 玩家理解 8 Attributes 差異嗎？
2. Training 是 build decision 還是行政流程？
3. Life Progress 是否真的能影響 combat？
4. 是否出現單一最優 Attribute？
5. 低 Life Progress 玩家是否仍可過主線？
6. 高 Life Progress 是否提供「更多玩法」而非單純壓制？

# 28. Canon Boundary

Canon：
- 8 Attributes
- 初始 allocation / aptitude / reroll
- build 可不同
- Rio/Hina/Yuma specialization

Proposal：
- Growth Potential
- Training Conversion
- derived stat
- soft cap
- character level
- respec rules

# 29. Major TBD

1. Attribute modifier formula
2. final/launch growth curve (MVP prototype curve is versioned in `character-growth-mvp-1`)
3. final/launch soft-cap tuning (MVP prototype thresholds are versioned in `character-growth-mvp-1`)
4. hard cap
5. final/launch aptitude tuning (MVP prototype cost adjustment is versioned in `character-growth-mvp-1`)
6. final/launch training-cost tuning (MVP prototype cost is versioned in `character-growth-mvp-1`)
7. Character Level formula
8. Spell requirement tolerance
9. respec policy
10. temporary modifier policy

# 30. Core Thesis

```text
Real Life
→ Potential
→ Training Choice
→ Attribute Growth
→ Build
→ Combat Expression
```

角色不應因玩家「刷最多 XP」而變強。

> **角色應因玩家長期投入，以及玩家如何選擇把這些投入轉化成能力，而逐漸形成自己的 Build。**
# 7.1 Attribute Growth Source of Truth — Accepted

**Decision OD-003: Accepted**

永久 Attribute Growth 的 canonical source 是：

```text
TrainingConversion
```

而不是直接修改 `AttributeState.permanent_growth`。

流程：

```text
GrowthPotentialBalance
↓
TrainingConversion
↓
Attribute Projection Rebuild
↓
AttributeState.permanent_growth
```

每筆 TrainingConversion 必須保存：
- consumed Potential category
- amount
- TrainingDefinition ID
- TrainingDefinition content version
- resulting attribute deltas
- idempotency key
- created_at

`AttributeState` 是 materialized projection，可重建。
