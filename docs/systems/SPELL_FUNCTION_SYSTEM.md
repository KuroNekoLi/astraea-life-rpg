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

# 9. Prepared Deck

**Canon**

戰鬥前載入可快速執行的 Spell Card。

Scene 5：
```text
Deck Limit = 6
```

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

Interrupt 會：
- cancel
- delay
- destabilize
- force retarget
- increase cost
- expose downstream node

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

特殊 Spell Card：
- 每戰一次
- 高輸出
- 使用後 caster 退出戰鬥

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