# Spell & Function System Specification
## `SPELL_FUNCTION_SYSTEM.md`

**版本：** v1.0  
**狀態：** Working Specification  
**相關文件：** `COMBAT_SYSTEM.md`, `CHARACTER_PROGRESSION_SYSTEM.md`

# 1. Purpose

本系統定義 Astraea 的核心魔法 domain model：

```text
Intent
→ Encoding
→ Function Graph
→ Spell
→ Spell Card
→ Prepared Deck
→ Execution
```

它同時服務：
- 世界觀
- 戰鬥
- Research
- Teaching
- Weak Node
- Counter-Function

# 2. Magic — Canon

魔法：

```text
f(S0) = S1
```

代表把世界從 State A 轉為 State B。

人類不直接改寫 Reality：

```text
Human Intent
→ Medium / Encoding
→ Magic System
→ Function Execution
```

# 3. Function

**Canon**

Function 是最小可理解的魔法操作單元之一。

例如：

```text
Gather(Energy)
Lock(Target)
Move(Object)
Shape(Bolt)
```

# 4. Function Node

**GDD Proposal**

```text
FunctionNode
├── id
├── type
├── parameters
├── inputs
├── outputs
├── requirements
├── complexity
├── stability
├── interruptible
├── reversible
└── tags
```

# 5. Function Graph

**Canon**

複雜 Spell 由多個 Node 串接。

例如：

```text
Detect(Target)
↓
LockTarget
↓
Gather(Energy)
↓
Fire(Bolt)
```

# 6. Graph Edge

**GDD Proposal**

Edge 表示：
- execution dependency
- data dependency
- target dependency
- state dependency

例如：

```text
LockTarget
--target_ref-->
Fire
```

# 7. Spell

**Canon**

Spell 是已具有明確效果、可被執行的 Function / Function Graph。

```text
Spell
├── graph
├── parameters
├── mana_cost
├── casting_method
└── resulting_state_change
```

# 8. Spell Card

**Canon**

Spell Card 是已構築完成 Function / Function Graph 的可保存、攜帶、載入與重複提交形式。

不是 collectible-gacha card。

**Accepted design decision**

Spell Card（SC）是戰鬥前準備好的 **combat-ready Function template**。角色理論上可使用所有已學會的基礎魔法；SC／Prepared Deck 的容量代表戰鬥中可快速呼叫、並能維持的 Prepared Functions 數量，不是角色學習或擁有魔法的上限。MVP Prepared SC 上限為 6。

### Spell Family、Signature 與 Tier

每個 Spell Family 有完整 Signature。Tier 對該 Signature 開放更多可控 parameters；其他細節由模板處理。Tier 越高通常 Mana Cost、Complexity 與 Chantless burden 越高，但不同 Spell Family 的 Tier 不可直接橫向比較。例如 Fireball III 可能只在某些面向約等於 Flame Lance I。

解鎖高 Tier 後，既有低 Tier 仍保留且可獨立 Prepared。角色能同時準備不同 Tier；高熟練者的 Fireball I 可以比一般人的 Fireball III 更強。Tier 表示可控術式層級，不保證跨 Family 的絕對強度。

SC 可使用 Full Chant 或 Chantless。是否能對特定 SC／Tier Chantless，取決於施術者對該術式的理解與角色能力。Fireball I 等基礎術式多數學生可詠唱破棄；高階 Spell／Tier 通常只有更強或更熟練的施術者能做到。

### 八大系統與代表 SC — 初版設計目錄

八大系統分類已確定；下列 Spell Family 是代表性初版目錄，用途清晰並展示 Function-based magic。此目錄不表示所有 SC 都屬 MVP，也不鎖定最終平衡值。各 Signature、具體 Tier 開放的參數、Mana Cost、Complexity、要求與稀有度仍需逐張定義。

| 系統 | 主要操作對象 | 代表性 Spell Family |
| --- | --- | --- |
| Elemental（元素） | 熱、冷、電、流體等自然現象 | Fireball、Flame Lance、Ice Lance、Lightning Bolt / Chain Lightning |
| Kinetic（動力） | 力、速度、動量、向量 | Force Bolt、Vector Shift、Repulsion Field、Gravity Crush |
| Spatial（空間） | 距離、位置、空間連接 | Blink、Position Swap、Space Fold、Spatial Severance |
| Temporal（時間） | 局部時間速度、順序、延遲 | Slow、Haste、Delay、Temporal Anchor；Time Stop 為極高階代表 |
| Life（生命） | 生物狀態、組織、恢復、強化 | Heal、Detox、Reinforce、Regeneration |
| Mind / Information（精神／情報） | 感知、資訊、認知、記憶 | Detect、Illusion、Mind Link、Predictive Read |
| Causality（因果） | 條件、觸發、結果機率、因果關係 | Trigger Mark、Misfortune Shift、Deferred Consequence、Outcome Lock |
| Structural / Arcane（術式構造／奧術） | 魔法 Function 與 Function Graph | Analysis、Weak Node Scan、Stabilize、Dispel、Parameter Rewrite、Reverse Operation |

目前每系約 3–4 個常規起始 Family 已足以形成第一版內容方向；此為內容規劃，不代表 MVP 必須一次實作全部 Family。最能展現 Astraea 身份的候選招牌術式為 **Vector Shift、Position Swap、Delay、Trigger Mark、Weak Node Scan、Parameter Rewrite、Reverse Operation**。Fireball、Heal、Slow 等熟悉術式可作為容易理解的入口。

### Signature 與 Tier 示例

完整 Signature 可包含比某 Tier 暴露給施術者更多的參數。未開放參數由術式模板處理，而不是從 Signature 中刪除：

```text
Fireball(
  target,
  power,
  temperature,
  radius,
  velocity,
  trajectory,
  stability,
  detonation
)
```

初步控制範圍示例：

```text
Fireball I    → target, power
Fireball II   → + velocity, radius
Fireball III  → + trajectory, stability
Fireball IV   → + detonation, advanced trajectory
```

這是單一 Family 的示例，不構成所有 SC 共用的 Tier 數或參數開放順序。Flame Lance 可有不同且較早複雜的 Signature：

```text
FlameLance(target, penetration, temperature, velocity, shape)
```

因此 Fireball III 和 Flame Lance I 可能在部分面向相近，但前者偏範圍與泛用，後者偏穿透與單體；不能僅憑 Tier 數字比較。

其他代表 Signature 範例：

```text
ForceBolt(target, force, direction)
VectorShift(object, old_vector, new_vector)
RepulsionField(center, radius, force)
GravityCrush(area, gravity_multiplier, duration)

Blink(caster, destination)
PositionSwap(targetA, targetB)
SpaceFold(pointA, pointB, duration)
SpatialSeverance(regionA, regionB)

Slow(target, rate, duration)
Haste(target, rate, duration)
Delay(function, delay_time)
TemporalAnchor(target, state_reference)

Heal(target, recovery_amount)
Detox(target, toxin_type)
Reinforce(target, muscle_output, durability, duration)
Regeneration(target, rate, duration)

Detect(target_type, radius)
Illusion(target, sensory_channel, content)
MindLink(caster, ally, bandwidth)
PredictiveRead(target, observed_behavior, horizon)

TriggerMark(condition, execute)
MisfortuneShift(event, probability_delta)
DeferredConsequence(event, duration)
OutcomeLock(event, permitted_result)

Analyze(target_function)
WeakNodeScan(function_graph)
Stabilize(function, node)
Dispel(active_function)
ParameterRewrite(target_spell, parameter, new_value)
ReverseOperation(active_function)
```

### 範圍與高階門檻

- `PredictiveRead` 是根據已觀察資訊推測目標行動，不是預知未來。
- Temporal 的 Slow、Haste、Delay 可作一般課程方向；Time Stop、Temporal Reversal、Return to Past 是大魔法或極高階術式。
- Causality 的低階術式只能在有限條件、事件與機率範圍內運作。機率微調、Outcome Lock 與因果／歷史改寫的尺度須逐級受限；不得把全系統設定成禁術。
- Structural / Arcane 的 Analysis 與 Weak Node Scan 是可由 SC 實現的術式方向。它們不等於每場戰鬥固定執行的免費開場掃描；熟悉 Signature 可直接使用既有知識，未知或改造術式才需要進一步分析。Analysis 類 SC 也不會保證找到 Weak Node。
- `Dispel` 表示解除或終止 active Function，不代表完整反運算。`Reverse Operation` 是高階、受限的反運算術式方向，不保證任何 Function 都有可用反函數；仍受 Function 可逆性與 Counter-Function requirements 限制。
- Resurrection／復活不納入目前目錄或規則；生命系是否存在此類效果維持未定，不以它推導世界規則。

# 9. Prepared Deck

**Canon**

戰鬥前載入可快速執行的 Spell Card。

Scene 5：
```text
Deck Limit = 6
```

MVP 中，6 是角色可維持的 Prepared Functions 數量上限。Prepared Deck 是戰鬥快速呼叫的術式配置；未放入 Deck 不代表角色沒有學會該魔法。

**Proposal：**
- 全部 6 張可直接存取
- 不採 random draw
- 限制由 Mana / action economy / condition / complexity 決定；cooldown 為 optional rule，MVP 預設可為 null

# 10. Casting Method

```text
Full Chant
Chantless
Magic Circle
Spell Card
Magical Device
```

MVP 主要：
- Full Chant
- Chantless
- Spell Card

# 11. Full Chant — Canon

負責：
- sequencing
- targeting
- parameter binding
- stability verification
- request encoding

# 12. Chantless — Canon

不是沒有 encoding，而是將 encoding 內化至施術者。

# 13. Complexity

**Proposal**

每個 Function / Spell 有 Complexity。

影響：
- Computation requirement
- Full Chant 時間
- Chantless difficulty
- Analysis difficulty
- Counter difficulty

Scale：**TBD**

# 14. Stability

**Proposal**

狀態：
```text
Stable
Strained
Unstable
Critical
```

影響：
- execution accuracy
- interrupt susceptibility
- partial failure

# 15. Weak Node

**Canon**

Weak Node 是 Function Graph 中最適合干涉的節點。

不是敵人生理弱點。

# 16. Weak Node Types

**Proposal**
- Structural Weak Node
- Timing Weak Node
- Parameter Weak Node
- Dependency Weak Node

# 17. Interrupt

Interrupt 是在施法完成前，打斷施術者或正在進行的 casting。依干涉點與時機，可能：
- cancel
- delay
- destabilize
- force retarget
- increase cost
- expose downstream node

施法完成、Spell 已形成或 Function 已 active 後，處理方式屬於迴避、防禦、Counter 或 Reverse Operation，不稱為 Interrupt。

# 18. Reversibility

**Canon**

若：
```text
f(A)=B
```

且存在：
```text
f^-1(B)=A
```

則可考慮 Counter-Function。

不是所有 Function 都可逆。

# 19. Counter-Function

類型：
- Full Inversion
- Partial Inversion
- Local Node Inversion
- Sequence Cancel
- State Restore

# 20. Counter Requirements

- Function Knowledge
- Analysis threshold
- timing
- compatible Counter
- sufficient Mana
- reversibility

# 21. Function Knowledge

**Proposal**

```text
K0 Unknown
K1 Intent Known
K2 Nodes Known
K3 Weak Node Known
K4 Counter Path Known
```

可跨戰鬥保存。

常用 Spell Signature 的學生本來就知道其基本運作，可依已知術式直接預判、打斷或防禦。Analysis 不是固定的開場「找 Weak Node」動作；主要用於未知、改造、複合或高階術式，以揭露尚未知的結構、Weak Node 或 Counter path。已知資訊不需要每場重新分析。

# 22. Spell Acquisition

來源：
- class / lesson
- NPC
- story
- research
- boss
- exploration
- Function Construction

禁止：
- paid gacha
- premium-only power spell

# 23. Function Construction

**Proposal**

後期允許受限制組合：

```text
Node
+ Node
+ Node
→ Spell Variant
```

不是完全自由 programming。

# 24. Parameter Binding

Spell Card 可在施放時綁定：
- target
- power
- range
- duration

哪些 parameter 可變由 Card 定義。

# 25. Spell Data Model

```text
SpellDefinition
├── id
├── name_key
├── graph_id
├── category
├── casting_methods
├── base_mana_cost
├── complexity
├── requirements
├── cooldown_rule?      # optional/null in MVP
├── tags
└── unlock_condition
```

# 26. Function Graph Data Model

```text
FunctionGraph
├── id
├── nodes[]
├── edges[]
├── entry_nodes[]
├── output_nodes[]
├── weak_node_rules[]
└── counter_metadata
```

# 27. Execution Runtime

```text
FunctionExecution
├── execution_id
├── caster
├── graph
├── node_states
├── bound_parameters
├── stability
├── target
├── started_at
└── resolution
```

# 28. Active Node State

```text
Pending
Active
Resolved
Interrupted
Failed
Countered
```

# 29. Error Semantics

Function 失敗必須有明確原因：
- invalid target
- insufficient Mana
- connection failure
- interrupted node
- parameter failure
- stability failure

這對後期 Magic Disability 劇情尤其重要。

# 30. Magic Disability Compatibility — Canon

Mio 切斷：

```text
Connection(Human, Magic System)
```

因此：
- Spell Card 存在
- Chant 正確
- Graph 正確
- Mana 仍有

但 request 無法真正執行。

系統模型必須能表達這種 failure。

# 31. Last Spell — Canon

Last Spell 是角色專屬的特殊 Spell Card，不是一般高 Tier Spell Family，也不屬於一般 `I → II → III` SC Tier progression。

規則：
- 每個角色每場戰鬥最多使用自己的 Last Spell 一次；不同角色各有自己的使用次數。
- 效果遠超一般 SC，可提供極高輸出、特殊效果或改變戰場規則。
- 使用後立刻施加 `LastSpellExhaustion`，該角色直到本場戰鬥結束都不能再行動。
- 解鎖來自角色劇情、重大成長或特殊條件；確切解鎖方式由角色設計決定。
- Last Spell 是否占用一般 Prepared Deck 位置：**TBD**。

```text
LastSpellExhaustion
├── duration: until battle end
├── removable: false during this battle
└── cannot:
    ├── take Main Action or Quick Action
    ├── move or use Reaction
    ├── cast Spell / use Last Spell
    └── use Technique
```

這是獨立的本場戰鬥終止行動狀態，不等同於 HP 歸零、昏迷或受傷；治療、恢復 Mana 或其他一般狀態移除不能解除它。Mana 可以同時耗盡，但不是 Exhaustion 的唯一原因。角色表現出的代價可依個人不同，不預設必然昏迷或瀕死。

隊伍內每位角色都可各自使用一次，因此四名角色理論上各有一次機會。每次使用都會永久拿走該角色本場剩餘回合與支援能力，構成即時戰術收益與後續隊伍行動力之間的取捨。

例如，`Starfall: Final Equation` 可作為某角色的超規模攻擊；`Absolute Domain Separation` 可暫時隔離一片戰場、改變 Boss Function 與召喚物的生效條件；`Perfect Deconstruction` 可分析並破解大型 active Function。這些是效果方向示例，不指定為現有角色的正式 Last Spell。

後期可能具有高 Reality Cost。

# 32. Reality Cost — Canon

```text
Mana Cost = caster pays
Reality Cost = world pays
```

前期 UI 不顯示 Reality Cost。

# 33. Research

**Proposal**

Research 可：
- reveal node
- optimize node
- lower complexity
- unlock variant
- discover counter path

# 34. MVP Scope

MVP：
- 8–12 Spell Cards
- 6-card Prepared Deck
- Function Graph
- partial visibility
- one Weak Node tutorial
- one simple Counter
- Full Chant
- Chantless
- Mana
- connection-failure capable domain model

不做：
- free-form construction
- Reality Cost UI
- Last Spell
- advanced inverse solver

# 35. Validation

1. 玩家理解 Spell Card ≠ 抽卡嗎？
2. Function Graph 看得懂嗎？
3. Weak Node 是否有成就感？
4. Counter 是否能產生不同於 damage 的玩法？
5. Data model 是否能支援 Mio 失能事件？

# 36. Major TBD

1. Complexity scale
2. stability formula
3. cooldown rules
4. parameter system
5. research economy
6. construction constraints
7. Counter formula
8. Function Knowledge persistence
9. Reality Cost representation
10. Last Spell schemas

# 37. Core Thesis

> **Astraea 的 Spell 不是動畫名稱，而是可以被理解、拆解、干涉與反轉的 Function。**
