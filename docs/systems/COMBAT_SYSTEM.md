# Astraea Academy — Combat System Specification
## `COMBAT_SYSTEM.md`

**版本：** v1.0  
**狀態：** Working Specification  
**隸屬文件：** `Life_RPG_Astraea_GDD_v1.1.md`  
**戰鬥定位：** Turn-Based Tactical JRPG + Function Analysis  
**核心差異化：** 戰鬥不是單純交換傷害，而是理解、干涉、重組與反制敵方 Function。

> 文件標記  
> - **Canon**：已由 `WORLD_BIBLE.md`、`CHARACTERS.md`、`STORY_STRUCTURE.md` 確立。  
> - **GDD Proposal**：為玩法實作新增的設計提案，尚未自動成為世界觀 canon。  
> - **TBD**：保留待後續 playtest / narrative / balance 決策。  

---

# 1. Combat Vision

Astraea 的戰鬥核心不是：

```text
Attack
→ Deal Damage
→ Enemy Attack
→ Heal
```

而是：

```text
Observe
↓
Understand
↓
Predict
↓
Interfere
↓
Resolve
```

玩家需要理解敵人的術式如何運作，再選擇：

- 直接承受
- 迴避
- 防禦
- 中斷
- 破解 Weak Node
- Counter-Function
- 改變位置
- 用 Party Synergy 建立解法

戰鬥的理想感受：

> **我不是因為數值比較高而贏，而是因為我理解了這個 Function。**

---

# 2. Combat Pillars

## 2.1 Readability

玩家必須能理解：

- 敵人準備做什麼
- Function 目前進行到哪裡
- 哪些節點可被干涉
- 自己為何命中／失敗
- 哪個決策導致結果

隨機性不能掩蓋戰術因果。

---

## 2.2 Build Expression

不同 Build 應該有不同解法。

例如：

### Analysis Build
```text
Reveal
→ Weak Node
→ Partial Inversion
→ Counter
```

### Burst Build
```text
Break guard
→ High Output Spell
→ Finish before Function completes
```

### Mobility Build
```text
Reposition
→ Avoid targeting condition
→ Punish recovery window
```

### Support Build
```text
Stabilize ally
→ Redirect threat
→ Enable party combo
```

---

## 2.3 Function First

Spell 的本質是 Function / Function Graph。

戰鬥 UI、AI、Boss 設計與 Counter System 都必須以此為核心，而不是把 Function Graph 當 lore 裝飾。

---

## 2.4 Tactical, Not Exhausting

一般戰鬥目標：

```text
3–6 rounds
```

教學戰：

```text
≤ 8 rounds
```

Boss 可以更長，但應透過 Phase 變化而非單純堆 HP。

---

# 3. Canon Combat Foundation

已確立的戰鬥子系統：

- Main Action
- Quick Action
- Movement
- Reaction
- Initiative
- d20 attack resolution
- Nat 1 automatic miss
- Nat 20 critical / enhanced success
- Seeded RNG
- Technique
- Spell
- Weak Node Analysis
- Prepared Deck
- Spell Card
- Full Chant
- Chantless
- Last Spell

Scene 6 教學戰敵人：

- Arcane Sentry Mk-I
- Ashfang Training Construct

---

# 4. Battle State

每場戰鬥維護：

```text
BattleState
├── Round
├── InitiativeOrder
├── Units
├── Positions
├── ActiveFunctions
├── BattlefieldEffects
├── Reactions
├── PreparedDeckState
├── ManaState
└── CombatLog
```

每個 Unit：

```text
Combatant
├── HP / Combat Condition
├── Mana
├── Position
├── Attributes
├── Weapon
├── Techniques
├── PreparedDeck
├── StatusEffects
├── ReactionAvailable
└── FunctionKnowledge
```

具體 HP / Defense / derived-stat 公式：**TBD**。

---

# 5. Turn Structure

每個 Unit 的 Turn 原則上包含：

```text
Turn Start
↓
Status Resolution
↓
Movement
↓
Main Action
↓
Quick Action
↓
Turn End
```

Movement、Main Action、Quick Action 的順序原則上可交換。

例如：

```text
Quick Action
→ Movement
→ Main Action
```

合法。

Reaction 不綁定自己 Turn，而是在觸發條件出現時使用。

---

# 6. Initiative

## Canon

```text
Initiative = d20 + Processing modifier
```

## Design Intent

Processing 高的角色：

- 更容易先行動
- 更能快速處理戰場資訊
- 更適合 Chantless / Reaction-oriented build

## Proposal

同 Initiative 時依序比較：

1. Processing
2. Precision
3. deterministic seeded tiebreaker

避免隱性不穩定 RNG。

---

# 7. Action Economy

## 7.1 Main Action

主要戰術資源。

可用於：

- Weapon Attack
- Technique
- Cast Spell
- Full Chant
- Function Analysis
- Interact with environment
- Major support action
- certain Counter-Function

---

## 7.2 Quick Action

低成本輔助行動。

可能包含：

- Draw / Ready Device
- Minor Analysis
- Switch stance
- Mark Target
- Minor support
- prepare Chant segment
- activate certain preloaded utility Spell

具體清單按 Ability 定義。

---

## 7.3 Movement

用於：

- 改變 Range
- 脫離 Area Function
- 接近 Weak Node interaction zone
- 取得 Cover
- 改變 Line of Sight
- 進入 ally support range

---

## 7.4 Reaction

每 Round 通常：

```text
1 Reaction
```

可能觸發：

- enemy enters range
- Function reaches interruptible node
- ally is targeted
- incoming attack
- enemy leaves threat range
- known Counter condition becomes valid

Reaction 是 Function 戰鬥的重要資源。

---

# 8. Positioning

## Proposal

MVP 不採完整 grid-heavy SRPG。

建議採：

```text
Zone + Relative Range
```

例如：

- Close
- Near
- Far

或 battlefield lane / zone。

原因：

1. Mobile 操作更簡潔
2. 仍保留位置決策
3. Space / Mobility build 有存在感
4. 不讓地圖 pathfinding 吃掉 Function Analysis 的認知預算

最終 grid / free-position / zone 制：**TBD**。

---

# 9. Basic Attack Resolution

## Canon Base

```text
Attack Roll = d20 + Attack Bonus
```

對抗 Defense。

- Nat 1：automatic miss
- Nat 20：critical / enhanced success

## Balance Goal

新手合理命中率：

```text
60–75%
```

避免：

- 玩家理解正確卻連續 miss
- 前期 build 因 RNG 無法表達

---

# 10. Seeded RNG

## Canon

戰鬥採 Seeded RNG。

目的：

- Replay reproducibility
- Test stability
- Bug reproduction
- Balance simulation
- Deterministic tutorial

Seed 不對玩家公開。

---

# 11. Mana System

## Canon

Mana 是施法者可觀察、可管理的施法成本。

相關 Character Attribute：

- Mana Capacity
- Mana Output
- Efficiency
- Ambient Sync

## Proposal

### Mana Capacity
最大 Mana pool。

### Mana Output
單次 Function 能安全輸出的規模。

### Efficiency
同等 Function 的 Mana Cost 折減能力。

### Ambient Sync
與環境魔力條件互動，可能影響 recovery / stability。

具體公式：**TBD**。

---

# 12. Spell Card

## Canon

Spell Card 是 Function / Function Graph 的具現化。

它不是：

```text
抽到卡 → 才能施法
```

而是：

```text
Constructed Function
↓
Encoded / Stored
↓
Spell Card
↓
Prepared
↓
Execute
```

---

# 13. Prepared Deck

## Canon

Scene 5 教學：

```text
Prepared Deck limit = 6
```

## Proposal

Prepared Deck 是：

```text
Loadout
```

而不是：

```text
Random Draw Deck
```

六張 Card 在戰鬥中皆可存取。

限制來源：

- Mana
- Complexity
- Cooldown
- Action Cost
- Casting Method
- Required State
- Interrupt Risk

---

# 14. Why No Random Draw

Random Draw 會破壞：

1. 「Prepared」的世界觀意義
2. 戰術規劃
3. Function-based readability
4. Counter play

因此除非未來某特殊角色／異常狀態明確需要，核心系統不採 draw RNG。

---

# 15. Full Chant

## Canon

Full Chant 負責部分：

- Function sequencing
- target specification
- parameter binding
- stability verification
- request encoding

## Combat Proposal

Full Chant 特性：

### Strength
- 高 Stability
- 可執行高 Complexity Spell
- 較低 Computation burden
- 對新手友善

### Weakness
- Casting time 較長
- 易被 Interrupt
- Intent 較明顯
- 行動成本較高

---

# 16. Chantless

## Canon

Chantless 是把原本外部詠唱處理的 computation / encoding 移到施術者內部。

## Combat Proposal

### Strength
- 快速
- 彈性高
- 不容易被傳統 Silence / Chant Interrupt 克制
- 適合 reactive play

### Weakness
- 高 Processing requirement
- 高 Precision requirement
- 高 error / instability risk
- 複雜 Spell 負擔更大

---

# 17. Function Graph in Combat

每個 Spell 可以表示：

```text
Node A
↓
Node B
↓
Node C
```

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

每個 Node 可具有：

```text
FunctionNode
├── type
├── state
├── visibility
├── interruptible
├── reversible
├── weakness
├── execution_cost
└── dependencies
```

---

# 18. Active Function State

Function 在戰鬥中可處於：

```text
Prepared
Executing
Waiting
Interrupted
Resolved
Failed
PartiallyResolved
Countered
```

Boss 可以同時維持多個 Active Function。

---

# 19. Function Visibility

## 19.1 Transparent

完整 Graph 可見。

適用：

- Tutorial
- familiar enemy
- previously analyzed spell

---

## 19.2 Partial

部分 Node：

```text
???
```

玩家需要：

- Analysis
- previous knowledge
- Rio support
- observed execution

解鎖。

---

## 19.3 Hidden

只顯示 Enemy Intent。

例如：

```text
Mio is altering the casting interface.
```

而不直接顯示 Function Graph。

適用：

- Boss
- unknown magic
- story revelation

---

# 20. Function Knowledge

玩家對 Function 的知識可跨戰鬥保留。

例如：

```text
FireBolt
Knowledge 0:
Unknown

Knowledge 1:
Intent known

Knowledge 2:
Nodes known

Knowledge 3:
Weak Node known

Knowledge 4:
Counter path known
```

## Proposal

這可以形成：

> 戰鬥 → 理解 → 下次更有效率

的長期 RPG progression。

---

# 21. Analysis Action

Analysis 不只是：

```text
Scan enemy weakness.
```

可做：

- Reveal Node
- Reveal dependency
- Detect Weak Node
- Estimate completion timing
- Check invertibility
- Identify parameter
- predict target
- identify false node / decoy

---

# 22. Weak Node

## Canon

Weak Node 是 Function Graph 中可以被有效干涉的節點。

不是：

> 敵人的生理弱點。

例如：

```text
Detect
↓
LockTarget   ← Weak Node
↓
Fire
```

若破壞 LockTarget：

```text
Fire
```

可能無法取得合法 target。

---

# 23. Weak Node Outcomes

干涉成功不一定：

```text
Spell completely disappears
```

可能：

- Cancel
- Delay
- Reduce output
- Force retarget
- Increase Mana cost
- Destabilize
- Expose new weakness
- Convert to partial effect

---

# 24. Interrupt

Interrupt 是最基礎的 Function interference。

可能由：

- Weapon Technique
- Reaction
- Spell
- Movement
- environmental interaction

觸發。

成功率可受：

- Precision
- Processing
- target Stability
- Node Complexity

影響。

公式：**TBD**。

---

# 25. Counter-Function

## Canon

若：

```text
f(A) = B
```

且存在：

```text
f^-1(B) = A
```

則可能反轉結果。

但：

> 不是所有 Function 都存在完整、唯一反函數。

---

# 26. Counter Types

## 26.1 Full Inversion

完整將：

```text
B → A
```

高難度、少見。

---

## 26.2 Partial Inversion

只逆轉部分 state。

---

## 26.3 Local Node Inversion

針對特定 Function Node。

---

## 26.4 Sequence Cancel

讓 downstream dependency 失去成立條件。

---

## 26.5 State Restore

不反轉施法本身，而重新建立較早狀態。

---

# 27. Counter-Function Requirements

一般需要：

1. Function Knowledge
2. Analysis threshold
3. 正確 timing
4. 可用 Counter Spell / Technique
5. 足夠 Mana / Action
6. Function 本身允許 inversion

不能變成：

```text
Analysis 高 → 所有魔法都能 counter
```

---

# 28. Techniques

Technique 與 Spell 分離。

Technique 可以來自：

- Weapon
- Movement
- physical training
- tactical training

例如：

```text
Guard Break
Dash
Cover Ally
Precision Shot
Disengage
Pin
```

即使 Magic Disability 發生，Technique 仍具有價值。

---

# 29. Weapon Roles

## Longsword
- Balanced
- reliable
- close combat
- flexible reaction

## Spear
- Reach
- control space
- interrupt positioning

## Arcane Gun
- Range
- precision
- target pressure

## Staff
- Spell Focus
- complexity handling
- Full Chant synergy

具體 bonus 依 Scene 2 Canon 再平衡。

---

# 30. Party Combat

核心 Party：

- Hero
- Yuma
- Rio
- Hina

隊友不應只是 AI damage dealer。

每個角色提供不同 Function interaction。

---

# 31. Yuma Combat Role

## Canon
- Space
- Mobility
- Support

## Proposal
- Ally reposition
- Enemy displacement
- Cover
- Rescue
- Range manipulation
- Area escape

Yuma 的價值：

> 改變 Function 成立的空間條件。

例如：

```text
Enemy Function requires target inside Area A
```

Yuma 將 Hero 移出 Area A：

```text
condition false
→ Function fails / changes