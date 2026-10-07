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

# 7.1 Spell Signature — Canon

常用 Spell 具有標準 Signature，用來描述術式接受的參數與基本結構。

例如：

```text
Fireball(
    power,
    direction,
    velocity,
    radius,
    temperature,
    stability,
    ...
)
```

Astraea 學院學生會在基礎教育中學習常用術式的 Signature、典型 Graph、詠唱特徵與基本應對方式。

因此對標準、已知術式：

```text
recognized signature
→ known spell
→ immediate tactical response
```

不需要先花費 Analysis action 才知道術式名稱與基本性質。

但 Signature 與 runtime parameters 必須分開：

```text
Signature:
Fireball(power, direction, radius, ...)

Runtime:
Fireball(
  power = 900,
  direction = target_A,
  radius = 3.5,
  ...
)
```

已知 Signature 不代表已知本次施法的實際威力、穩定性或是否被修改。

## 7.2 Spell Family 與 Tier — Canon

同一個 Spell Family 具有一個完整 Signature；不同 Tier 不代表完全不同的魔法，而是對同一完整 Signature 開放不同程度的控制權。

例如完整 Fireball Signature：

```text
Fireball(
    power,
    direction,
    velocity,
    radius,
    temperature,
    stability,
    trajectory,
    detonation,
    ...
)
```

### Tier I

只開放少數核心 parameters，其餘由標準模板提供。

```text
Fireball I
controllable:
- target
- basic power

templated:
- velocity
- radius
- temperature
- stability
- trajectory
- detonation
```

### Higher Tier

Tier 越高：
- 可控制／覆寫的 parameters 越多；
- Function Graph / runtime control burden 通常越複雜；
- Mana Cost 通常更高；
- Chantless difficulty 通常更高；
- 對 caster 的 Processing / Precision / Efficiency / Output 要求可能提高。

因此 Tier 代表的是 **同一 Spell Family 中術式控制與結構能力的深化**，不是單純的 damage rank。

同時，Tier **不是跨 Spell Family 的全球戰力刻度**。

例如：

```text
Fireball III
≈
Flame Lance I
```

可能在某些輸出或複雜度面向接近，但不代表兩者必須具有相同傷害、Mana Cost、Graph 或戰術角色。

不同 Spell Family 可以有完全不同的基礎難度與起始強度。

## 7.3 Tier 與 Caster Strength — Canon

低 Tier 不會因高 Tier 解鎖而在世界觀上自動失去價值。

同一個低階 Spell 可以因 caster 的：
- Mana Output
- Efficiency
- Precision
- mastery / understanding

而產生遠高於普通人的效果。

因此以下情況合法：

```text
Expert Fireball I
>
Ordinary Fireball III
```

Spell Tier 描述術式本身的控制層級；caster strength 描述誰在執行它。兩者不可混為單一戰力數字。

# 8. Spell Card

**Canon**

Spell Card（SC）是某個已學會 Spell / Tier 的 **combat-ready prepared function template**。

它保存或承載：
- Spell Family / Tier
- 對應 Function Graph
- Signature 與該 Tier 可控制 parameters
- locked / templated parameters
- execution / encoding 結構
- 本場戰鬥可快速呼叫所需的 prepared state

SC 不是「擁有這張卡才學會這個魔法」。

角色理論上可以理解、學會並在非戰鬥情境使用大量基礎 Spell；SC 的存在是為了把有限數量的術式預先構築成戰鬥中可以快速、安全調用的 Prepared Function。

因此：

```text
Learned Spell Knowledge
≠
Prepared SC Loadout
```

不是 collectible-gacha card。

# 9. Prepared Deck

**Canon**

魔法師在戰鬥前只能維持有限數量的 Prepared Functions，因此必須選擇有限數量的 SC 作為本場戰鬥 Loadout。

限制不是「角色只會這幾個魔法」，而是：

```text
Learned spell library
→ prepare finite set of Functions
→ battle-ready SC loadout
```

Scene 5：
```text
Deck Limit = 6
```

MVP 固定為 6 張。未來是否讓角色能力改變 Prepared Function capacity：**TBD**。

**Proposal：**
- 全部 6 張可直接存取
- 不採 random draw
- 戰鬥中只能使用 Prepared SC
- 限制由 Mana / action economy / condition / complexity / casting method 決定；cooldown 為 optional rule，MVP 預設可為 null

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

Full Chant 的功能不是增加一個獨立「Buff」，而是把部分 Function construction / encoding 工作外部化並結構化。

在相同施術者、相同 Spell 與近似資源投入下，Full Chant 通常提供：
- 較高 Stability
- 較完整 Parameter Binding
- 較低 internal computation burden
- 較高有效輸出／較少 execution loss

代價：
- casting time 較長
- intent 較容易被辨識
- 提供明確 Interrupt window


# 12. Chantless — Canon

不是沒有 encoding，而是將原本由外部詠唱完成的 computation / encoding 內化至施術者。

```text
Full Chant:
Human
→ Chant-assisted construction / encoding
→ Magic System

Chantless:
Human
→ Internal construction / mental encoding
→ Magic System
```

對多數施術者而言，Chantless 是以速度換取較高的個人處理負擔，因此可能造成：
- lower effective output
- lower Efficiency
- lower Precision
- lower Stability
- higher failure / deviation risk

但這些不是固定倍率。

若施術者具有極高 Processing、Precision、Efficiency，或極高 Mana Capacity / Output，則：

```text
talented caster Chantless output
>
ordinary caster Full Chant output
```

是合法且符合世界觀的結果。

魔法天才至少存在兩種典型：
1. Precision / Efficiency 型：低浪費、高控制，能自行承擔大量 construction / encoding。
2. Capacity / Output 型：控制未必最精密，但巨量 Mana 讓最終輸出仍遠高於一般人。


# 12.1 Chantless Eligibility by SC Tier

詠唱或詠唱破棄是 **執行 SC 的方式**，不是另一張卡。

角色能否對某張 SC 使用 Chantless，取決於：
- 對該 Spell / Tier 的理解與熟練程度；
- Tier / Complexity；
- Processing；
- Precision；
- 其他 Spell-specific requirements。

基礎術式可以非常容易進入 Chantless。

例如：

```text
Fireball I
→ 幾乎所有完成基礎訓練的學生都可詠唱破棄
```

高 Tier 或高階 Spell Family 則可能只有優秀施術者能安全詠唱破棄。

```text
Fireball III
→ ordinary student: Full Chant
→ skilled caster: Chantless possible

High-complexity Spell I
→ Chantless may already require exceptional ability
```

因此不能用「所有 Tier N 都要求同一 Mastery」的全球規則；每個 Spell Tier 應定義自己的 Chantless requirement。

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

# 15. Analysis — Canon

Analysis 的核心不是固定產生 Weak Node，而是將未知資訊轉換成可採取行動的戰鬥資訊。

對已知、標準術式：
- spell identity / basic signature 可直接由受過教育的角色辨識；
- 不要求先進行 Analysis 才能 Guard、Dodge、Interrupt 或使用已知 Counter。

Analysis 的主要使用情境：
- unknown signature
- modified spell
- composite spell
- self-authored / high-level spell
- runtime parameter estimation
- Function Graph reconstruction
- reversibility check
- Counter path discovery
- Weak Node discovery

Analysis 可以揭露：
- intent
- runtime parameters
- node / dependency
- stability
- casting progress
- target condition
- reversible node
- possible Weak Node
- possible Counter path

Weak Node 是 Analysis 可能產生的高價值結果之一，不是所有 Spell 都一定存在。

# 16. Weak Node

**Canon**

Weak Node 是 Function Graph 中最適合干涉的節點。

不是敵人生理弱點。

# 17. Weak Node Types

**Proposal**
- Structural Weak Node
- Timing Weak Node
- Parameter Weak Node
- Dependency Weak Node

# 18. Interrupt

Interrupt 處理的是 **Spell 尚未完成／Function 尚未成立** 的施法過程。

典型流程：

```text
Caster
→ Chant / Encoding
→ Function construction
→ [Interrupt window]
→ Execution
```

可由：
- weapon hit
- knockback
- stun
- silence
- displacement
- dedicated interference spell
- timing-based reaction

造成：
- cancel casting
- delay completion
- destabilize construction
- force restart / retarget
- increase cost

對學生已知的標準 Fireball，常見正解就是在詠唱完成前直接 Interrupt；不需要先進行 Function Analysis。

Interrupt 與 Counter-Function 必須區分：
- **Interrupt**：阻止術式完成。
- **Counter / Reverse Operation**：處理已成立、已 active execution 或已無法藉由打斷施術者停止的術式。


# 19. Reversibility

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

# 20. Counter-Function

類型：
- Full Inversion
- Partial Inversion
- Local Node Inversion
- Sequence Cancel
- State Restore

# 21. Counter Requirements

- Function Knowledge
- Analysis threshold
- timing
- compatible Counter
- sufficient Mana
- reversibility

# 22. Function Knowledge

**Proposal**

Function Knowledge 不應從「所有東西都 Unknown」開始。

學院教育提供 common spell baseline knowledge。對常用標準術式，角色可預設具備：
- identity known
- signature known
- basic graph known
- common interrupt timing known

Knowledge progression 主要針對未知、改造、複合或高階術式：

```text
K0 Unknown
K1 Intent / Signature partially known
K2 Runtime parameters / Nodes known
K3 Dependencies / Weak Node known
K4 Counter / Reverse path known
```

可跨戰鬥保存。


# 23. Spell Acquisition

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

# 23.1 Magic System Classification and SC Progression

**Canon direction**

Spell 會被歸入若干魔法系統（Magic Systems / Schools；正式分類名稱與清單 **TBD**）。

角色取得／分配某一魔法系統的成長點數後，可以將其投入該系統內的 SC，增加該 SC 的經驗。

概念流程：

```text
Magic System growth points
↓
allocate to compatible SC
↓
SC Tier XP
↓
Tier XP full
↓
unlock next Tier
```

例如：

```text
Fire-system points
↓
Fireball I XP
↓
Fireball I mastered
↓
Fireball II unlocked
```

Tier 升級代表：
- 開放更多 controllable parameters；
- 增加術式能力上限；
- 通常提高 Mana Cost；
- 通常提高 Complexity / Chantless burden。

**尚未決定：**
- 系統分類的正式名稱與數量；
- 戰鬥實際使用是否也直接提供 SC XP；
- 升到 Tier II 後 Tier I 是否仍可作為獨立 Prepared SC 使用；
- Tier XP 曲線與點數成本。

# 24. Function Construction

**Proposal**

後期允許受限制組合：

```text
Node
+ Node
+ Node
→ Spell Variant
```

不是完全自由 programming。

# 25. Parameter Binding

每個 Spell Family 先定義完整 Signature；各 Tier 再定義其中哪些 parameters 對 caster 開放。

Parameter 必須區分：
- **Signature parameters**：完整術式可接受哪些參數。
- **Tier-exposed parameters**：此 Tier 允許 caster 控制哪些參數。
- **Templated parameters**：此 Tier 尚未開放，使用 SC 內建模板／標準值。
- **Runtime values**：本次 execution 實際綁定的值。

例如：

```text
Fireball I
exposed:
- target
- power

templated:
- velocity
- radius
- stability
- trajectory
```

```text
Fireball II
exposed:
- target
- power
- velocity
- radius

templated:
- advanced trajectory
- detonation behavior
```

Analysis 可用來估算或揭露敵方 runtime values，但角色可能早已知道該 Spell 的完整 Signature 與標準 Tier template。

# 26. Spell Data Model

```text
SpellDefinition
├── id
├── family_id
├── name_key
├── magic_system_id
├── full_signature
├── tiers[]
├── graph_id
├── category
├── casting_methods
├── tags
└── unlock_condition

SpellTierDefinition
├── tier
├── exposed_parameters[]
├── templated_parameters{}
├── base_mana_cost
├── complexity
├── chantless_requirements
├── graph_variant?
└── tier_unlock_requirement
```

# 27. Function Graph Data Model

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

# 28. Execution Runtime

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

# 29. Active Node State

```text
Pending
Active
Resolved
Interrupted
Failed
Countered
```

# 30. Error Semantics

Function 失敗必須有明確原因：
- invalid target
- insufficient Mana
- connection failure
- interrupted node
- parameter failure
- stability failure

這對後期 Magic Disability 劇情尤其重要。

# 31. Magic Disability Compatibility — Canon

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

# 32. Last Spell — Canon

特殊 Spell Card：
- 每戰一次
- 高輸出
- 使用後 caster 退出戰鬥

後期可能具有高 Reality Cost。

# 33. Reality Cost — Canon

```text
Mana Cost = caster pays
Reality Cost = world pays
```

前期 UI 不顯示 Reality Cost。

# 34. Research

**Proposal**

Research 可：
- reveal node
- optimize node
- lower complexity
- unlock variant
- discover counter path

# 35. MVP Scope

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

# 36. Validation

1. 玩家理解 Spell Card ≠ 抽卡嗎？
2. Function Graph 看得懂嗎？
3. Weak Node 是否有成就感？
4. Counter 是否能產生不同於 damage 的玩法？
5. Data model 是否能支援 Mio 失能事件？

# 37. Major TBD

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

# 38. Core Thesis

> **Astraea 的 Spell 不是動畫名稱，而是可以被理解、拆解、干涉與反轉的 Function。**