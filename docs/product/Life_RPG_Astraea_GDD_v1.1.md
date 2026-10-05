# Life RPG × Astraea Academy
## Game Design Document v1.1 — Narrative / Combat Integration

**版本：** v1.1  
**文件狀態：** Working Specification  
**類型：** Real-Life Driven JRPG  
**核心舞台：** Astraea Academy  
**主要平台：** iOS / Android  
**輔助平台：** Web Companion  

> 文件標記規則  
> - **Canon**：來自既有 `WORLD_BIBLE.md`、`CHARACTERS.md`、`STORY_STRUCTURE.md`，已確立設定。  
> - **GDD Proposal**：為 Life RPG 玩法整合新增的提案，尚未自動成為世界觀 canon。  
> - **TBD**：刻意保留，待後續設計決策。

---

# 1. High Concept

Life RPG × Astraea Academy 是一款由玩家真實生活行動驅動的日系魔法學院 RPG。

玩家在現實中的：

- 運動
- 閱讀
- 學習
- 工作
- 語言練習
- 創作
- 理財
- 社交
- 個人習慣

會成為遊戲角色成長的來源。

核心循環：

```text
Real-Life Action
↓
Life Quest Progress
↓
Character Growth / Resources
↓
Astraea Exploration
↓
Spell Construction / Prepared Deck
↓
Combat
↓
Boss / Story Progress
↓
New Knowledge / New Functions / New Regions
↓
Back to Real Life
```

產品目標不是讓玩家待在遊戲中更久，而是：

> **讓玩家願意為了遊戲中的冒險，真的去生活。**

---

# 2. Product Identity

本作不是：

```text
Habit Tracker
+
RPG Skin
```

也不是：

```text
Todo List
+
XP
```

產品定義：

> **一款由現實生活行動驅動的日系魔法學院 RPG。**

玩家真正會玩的內容包含：

- 主線劇情
- 世界探索
- NPC 關係
- JRPG 戰鬥
- Spell Card
- Prepared Deck
- Function Analysis
- Character Build
- Party
- Boss
- Character Customization

現實生活負責：

> 提供角色成長與冒險資源。

---

# 3. Core Fantasy

玩家感受到的不是：

> 「今天完成三個 Todo。」

而是：

> 「我今天在現實裡做的事，讓 Astraea 裡的自己真的變強了。」

例如：

```text
今天跑步 30 分鐘
↓
角色 Growth Potential 增加
↓
Training Session 轉化為角色成長
↓
更適合 Mobility / Processing 型 Build
↓
晚上進入戰鬥
↓
成功避開敵方 Area Function
```

或：

```text
今天閱讀 40 分鐘
↓
Cognitive Growth Potential 增加
↓
Analysis / Computation 發展
↓
戰鬥中更容易辨識敵方 Function Graph
↓
發現 Weak Node
↓
以 Counter-Function 解除敵方效果
```

核心原則：

> **現實活動不直接打 Boss；現實活動塑造角色，而玩家再用角色真正遊玩 RPG。**

---

# 4. World Setting

## 4.1 Astraea — Canon

Astraea 是一個把魔法視為文明基礎技術的世界。

Astraea Central Academy of Arcana 同時具備：

- 魔法教育
- 高等研究
- 魔法工程
- 異形應對人才培育
- 公共文明防衛

世界表面相信：

> 魔法保護文明。

但真正的後期衝突是：

> 人類越依賴魔法，世界越接近無法逆轉的 Entropy 累積與 The Fading。

---

# 5. Magic Model

## 5.1 Magic as Function — Canon

魔法不是無條件的奇蹟，而是：

> 將世界從狀態 A 轉換為狀態 B 的方法。

```text
f(S0) = S1
```

其中：

- `S0`：施法前世界狀態
- `f`：Spell / Function
- `S1`：施法後世界狀態

---

## 5.2 Human → Magic System — Canon

人類不是直接改寫 Reality。

施法流程：

```text
Human Intent
↓
Medium / Encoding
↓
Magic System
↓
Function Execution
↓
World State A → B
```

常見媒介：

- Chant
- Mental Calculation
- Magic Circle
- Spell Card
- Magical Device

Magic System 的最終本體仍為 **TBD**。

---

# 6. Function Graph

## 6.1 Core Model — Canon

複雜 Spell 可以拆成多個 Function Node。

例如：

```text
Detect(Target)
↓
LockTarget
↓
Gather(Energy)
↓
Shape(Bolt)
↓
Move(Target)
```

Function Graph 同時用於：

1. 教學
2. 魔法工程
3. 戰鬥分析
4. Weak Node
5. Counter-Function

Function Graph 是 Astraea 的核心差異化系統，應由遊戲本體實作，不依賴通用卡牌插件取代。

---

# 7. Real Life ↔ Astraea Link

## 7.1 Resonance — GDD Proposal

現實玩家的行動不應直接解釋為「跨世界施法」。

建議新增：

# Resonance

```text
Real Intent
↓
Sustained Real-Life Action
↓
Resonance
↓
Hero Growth Potential
```

Resonance 可影響：

- Hero aptitude growth
- Training Potential
- training efficiency
- Function familiarity
- specialization tendency
- recovery / preparation resources

---

## 7.2 Separation from Magic System — GDD Proposal

Resonance 與 Magic System 應分離。

Magic：

```text
Hero Intent
→ Encoding
→ Magic System
→ Function
```

Resonance：

```text
Real Player Action
→ Hero Growth Input
```

現實玩家不直接取得施法權。

---

# 8. Player Character

## 8.1 Hero — Canon

Hero：

- 姓名由玩家決定
- 幼年曾遭遇 Aberration 災害
- 曾被魔法師救下
- 救命恩人後來成為 Astraea 教授
- 因此形成核心信念：

> **「魔法可以保護人。」**

玩家可影響：

- 對話語氣
- NPC 關係
- Build
- 武器
- Prepared Deck
- 戰術風格

但不否定上述核心背景。

---

## 8.2 Character Arc — Canon

```text
被魔法救下
↓
相信魔法可以保護人
↓
進入 Astraea
↓
學會理解與使用魔法
↓
魔法失能事件
↓
調查 Institute Zero / Mio
↓
得知 Magic → Entropy → The Fading
↓
決定是否阻止 Mio
```

Hero 的成長不能簡化成「發現魔法是壞的」。

真正問題是：

> 知道魔法有長期代價後，是否仍能找到比 Mio 更好的答案。

---

# 9. Character Attributes

## 9.1 Base Attributes — Canon

八項能力：

1. Mana Capacity
2. Mana Output
3. Computation
4. Processing
5. Precision
6. Efficiency
7. Ambient Sync
8. Analysis

原始 Character Creation 規則：

- Base = 8
- Fixed Allocation = 32
- Fixed Allocation 上限 = 15
- Scene 2 進行 Aptitude Roll
- 最後可 Fate Reroll 一項

---

# 10. Life Domain → Character Growth

## 10.1 Life Domains — GDD Proposal

初期 Life Domain：

- Fitness
- Learning
- Languages
- Career
- Finance
- Creativity
- Social
- Lifestyle

---

## 10.2 Growth Flow — GDD Proposal

```text
Life Domain Activity
↓
Life XP
↓
Growth Potential
↓
Training Session
↓
Character Attribute / Build Growth
```

不採：

```text
Running = Processing +1
Reading = Analysis +1
```

避免玩家針對 RPG Stat 刻意扭曲真實生活。

---

## 10.3 Suggested Tendencies — GDD Proposal

僅作為系統估值方向，不是固定 mapping。

### Fitness
較可能影響：

- Processing
- Precision
- Mana Output

### Reading / Study
較可能影響：

- Computation
- Analysis
- Efficiency

### Language / Communication
較可能影響：

- Processing
- Precision
- Ambient Sync

### Career / Building
較可能影響：

- Computation
- Efficiency
- Analysis

---

# 11. Progression Layers

## 11.1 Life Level

例如：

```text
Fitness Lv.12
English Lv.15
Reading Lv.20
Finance Lv.8
Career Lv.22
```

定義：

> **Life Level 表示投入程度，不代表真實能力證照。**

---

## 11.2 Character Attributes

例如：

```text
Analysis 14
Processing 12
Precision 11
```

直接影響 RPG gameplay。

---

## 11.3 Build

Build 由 Attribute、Weapon、Spell、Prepared Deck、玩家戰術共同形成。

可能 Build：

- Function Analyst
- Chantless Specialist
- High Output Caster
- Support Controller
- Counter-Function Engineer

---

# 12. Weapon System

## 12.1 Initial Weapons — Canon

Scene 2 初始武器：

1. Astraea Longsword
2. Standard Spear
3. Training Arcane Gun
4. Standard Staff

武器影響：

- Technique Pool
- Range
- Positioning
- Action Economy
- Spell Interaction

---

# 13. Spell Card

## 13.1 Definition — Canon

Spell Card 是：

> **Function / Function Graph 的具現化。**

用途：

- 保存
- 攜帶
- 載入
- 重複提交
- 預先準備戰鬥術式

Spell Card 不是 collectible gacha card。

---

# 14. Prepared Deck

## 14.1 Core Rule — Canon

戰鬥前玩家將已學會的 Spell Card 放入 Prepared Deck。

Scene 5 教學上限：

```text
6 cards
```

Prepared Deck 的世界觀意義：

> 預先載入這場戰鬥可以快速呼叫的術式。

---

## 14.2 No Random Draw — GDD Recommendation

建議：

```text
Prepared Deck
≠
Random Draw Deck
```

戰鬥中六張 Spell Card 全部可存取。

限制來自：

- Mana
- Cooldown
- Action Cost
- Condition
- Function Complexity
- Interrupt risk

---

# 15. Spell Categories

## Attack
- FireBolt
- Arc Pulse
- Piercing Function

## Defense
- Barrier
- Deflection
- Damage Conversion

## Mobility
- Step Shift
- Space Fold
- Acceleration

## Analysis
- Weak Node Scan
- Function Trace
- Invertibility Check

## Support
- Target Link
- Mana Stabilization
- Precision Field

## Counter
- Interrupt
- Partial Inversion
- Counter-Function

具體 Spell List：**TBD**。

---

# 16. Combat System

## 16.1 Combat Structure — Canon Base

戰鬥包含：

- Main Action
- Quick Action
- Movement
- Reaction
- Initiative
- Attack Roll
- Technique
- Spell
- Weak Node
- Seeded RNG

---

## 16.2 Combat Direction — GDD Proposal

定位：

> **Turn-based Tactical JRPG + Function Analysis**

不是：

- Action RPG
- Auto Battle
- Gacha Card Battler

---

## 16.3 Core Combat Loop

```text
Enemy Intent
↓
Function Graph Visible / Partially Hidden
↓
Player Analysis
↓
Choose Action
├─ Attack
├─ Defend
├─ Spell
├─ Technique
├─ Interrupt
├─ Reposition
├─ Counter
└─ Support
↓
Function Resolution
↓
World State Changes
↓
Next Tactical State
```

---

# 17. Function Visibility

## Transparent Function
完整顯示，適合教學與低難度。

## Partial Function
部分 Node 未知，需要 Analysis。

## Hidden Function
只顯示 Intent / Telegraph，用於 Boss 或高階敵人。

---

# 18. Weak Node

Weak Node 是：

> Function Graph 中最適合干涉的節點。

例如：

```text
Gather
↓
Compress
↓
Launch
```

若 `Compress` 為 Weak Node：

```text
Interrupt(Compress)
→ downstream Function fails
```

Weak Node 不等同於一般 RPG 的「發光弱點部位」。

---

# 19. Counter-Function

## 19.1 Canon

若：

```text
f(A) = B
```

且存在：

```text
f⁻¹(B) = A
```

則可能透過 Counter-Function 逆轉或解除效果。

不是所有 Function 都存在完整反函數。

Gameplay 可包含：

- Full Inversion
- Partial Inversion
- Weak Node Break
- Sequence Cancel
- State Restore

---

## 19.2 Progression

```text
Weak Node Analysis
↓
Function Trace
↓
Invertibility
↓
Counter-Function
```

---

# 20. Full Chant

## 20.1 Canon

Full Chant 可承擔：

- Function sequencing
- target specification
- parameter binding
- stability verification
- request encoding

## Gameplay Tendency — Proposal

優點：

- Stable
- Good complexity handling
- Lower execution requirement

缺點：

- Slow
- Interruptible
- Predictable

---

# 21. Chantless

## 21.1 Canon

Chantless 並非「沒有計算」。

而是：

> 將原本由 Chant 承擔的 computation / request encoding 移到施法者自身。

## Gameplay Tendency — Proposal

優點：

- Fast
- Flexible
- Harder to interrupt

缺點：

- Higher Processing requirement
- Higher Precision requirement
- Higher execution risk

---

# 22. Last Spell

## 22.1 Canon Rules

- 一場戰鬥只能使用一次
- 發動後施術者無法繼續戰鬥
- 輸出或效果遠高於一般 Spell
- 不同角色可擁有不同 Last Spell

後期還具有：

> 高戰術價值 vs 高 Reality Cost

的倫理重量。

具體角色專屬 Last Spell：**TBD**。

---

# 23. Party System

## 23.1 Core Party — Canon

核心角色：

- Hero
- Saeki Yuma
- Kamiya Rio
- Asakura Hina

---

## 23.2 Yuma

### Canon Identity
- Space
- Mobility
- Support

### Gameplay Role — Proposal
- reposition
- teleport
- cover
- rescue
- spatial control
- party mobility

---

## 23.3 Rio

### Canon Identity
- Analysis
- Information
- Optimization
- Function Graph
- Counter-Function

### Gameplay Role — Proposal
- Reveal Node
- Reduce Function Complexity
- Identify Weak Node
- Analyze invertibility
- Optimize allied Spell
- Pattern recognition

---

## 23.4 Hina

### Canon Identity
- High Mana Capacity
- High Mana Output
- Energy Magic
- Chantless

### Gameplay Role — Proposal
- Burst
- Area Pressure
- Fast Casting
- High resource consumption
- Aggressive tempo

---

## 23.5 Tachibana

### Canon Narrative Position
- Hero 的救命恩人
- 真心相信魔法能救人
- 不應被寫成虛偽反派

核心倫理：

```text
Tachibana:
優先拯救眼前的人

Mio:
優先避免未來整個世界毀滅
```

是否成為常駐 Party：**TBD**。

---

# 24. Relationship System

## GDD Proposal

角色關係資料：

- Trust
- Affinity
- Shared History
- Tactical Synergy

是否存在 Romance：**TBD**。

---

# 25. Exploration Mode

## 25.1 Canon Presentation

遊戲模式：

```text
Exploration Mode
Dialogue Mode
Combat Mode
```

規則：

- NPC 實際存在於世界
- Dialogue 時保留背景
- JRPG 式 Choice List
- 角色 portrait / expression 由 presentation data 解析
- Combat 使用獨立戰術畫面

---

# 26. Academy Structure

## GDD Proposal

前期可探索區域：

- Academy Gate
- Central Hall
- Classrooms
- Training Hall
- Spell Engineering Lab
- Library
- Student Dorm
- Cafeteria
- Research Wing
- Aberration Response Wing
- Restricted Sector

Institute Zero 區域後期才開放。

---
