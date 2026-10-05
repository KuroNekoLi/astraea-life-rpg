# MVP Vertical Slice Specification
## `MVP_VERTICAL_SLICE.md`

**版本：** v1.0  
**狀態：** Working Specification  
**隸屬文件：** `Life_RPG_Astraea_GDD_v1.1.md`  
**相關文件：**
- `COMBAT_SYSTEM.md`
- `LIFE_PROGRESSION_SYSTEM.md`
- `QUEST_SYSTEM.md`
- `EVIDENCE_SYSTEM.md`

**MVP 定位：** 用最小但完整的內容，驗證「真實人生行動 → Astraea 角色成長 → Function-based JRPG 戰鬥 → 劇情推進」是否成立。

> 文件標記  
> - **Canon**：來自現有 `WORLD_BIBLE.md`、`CHARACTERS.md`、`STORY_STRUCTURE.md`。  
> - **GDD Proposal**：為 Life RPG MVP 整合新增。  
> - **TBD**：待 playtest、UX、balance 或 narrative 決策。  

---

# 1. MVP Goal

MVP 不以「做出完整遊戲」為目標。

MVP 必須回答一個核心問題：

> **玩家會不會因為想讓 Astraea 裡的自己變強，而真的願意完成現實世界中的一個行動？**

以及第二個問題：

> **完成真實行動後，角色成長是否真的能讓後續 JRPG 戰鬥變得更有意義，而不是只變成虛假的 XP 動畫？**

---

# 2. Vertical Slice Definition

Vertical Slice 必須完整包含：

```text
Story
+
Life Quest
+
Life Progression
+
Training
+
Character Build
+
Prepared Deck
+
Function Graph Combat
+
Post-Battle Feedback
```

不能只做其中一半。

---


# 2.1 P0 Architecture Baseline — Accepted

Vertical Slice 實作必須遵守：

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
→ LifeProgressionEngine
→ RewardGrant
```

```text
RewardGrant
→ LifeProgress / GrowthPotentialBalance projections
```

```text
TrainingConversion
→ AttributeState projection
```

```text
Story transition
+ expected_story_revision
→ authoritative StoryState
```

離線時 client 顯示 `RewardPreview`；同步後才有正式 `RewardGrant`。

# 3. Core End-to-End Loop

```text
Prologue
↓
Enter Astraea
↓
Meet Yuma
↓
Character Creation
↓
Choose Initial Life Goal
↓
Create / Accept Life Quest
↓
Complete One Real-Life Activity
↓
Gain Life XP
↓
Gain Growth Potential
↓
Return to Astraea
↓
Training Conversion
↓
Character Growth
↓
Learn Magic Theory
↓
Build Prepared Deck
↓
Training Battle
↓
Use Function Graph / Weak Node
↓
Win
↓
Post-Battle Report
↓
Story Continues
```

---

# 4. MVP Scope Summary

MVP 包含五個核心層：

## Layer A — Narrative

Scene 1–6。

## Layer B — Life

Life Quest + Timer + Self-report。

## Layer C — Progression

Life XP + Momentum + Growth Potential + Training Conversion。

## Layer D — RPG Build

Character Attributes + Weapon + Prepared Deck。

## Layer E — Combat

Turn-based tactical battle + Function Graph + Weak Node。

---

# 5. Scene Scope — Canon

保留既有 Vertical Slice：

```text
Scene 1 — Astraea Academy 入學
Scene 2 — 新生適性測試與角色建立
Scene 3 — 第一堂基礎術式理論
Scene 4 — Full Chant vs Chantless
Scene 5 — Spell Card / Prepared Deck Tutorial
Scene 6 — Training Battle
```

Vertical Slice 結束時：

> 玩家應更相信「魔法是一套可以被理解、訓練、最佳化並用來保護人的技術」。

---

# 6. MVP Player Journey

## Step 1 — Start Game

玩家看到 Astraea motto 與 cinematic prologue。

目的：

- 建立世界
- 建立 Hero 核心信念
- 建立 Tachibana 救援事件
- 建立「魔法保護文明」

---

# 7. Prologue

## Canon

內容：

1. Astraea motto
2. Magic becomes civilization infrastructure
3. Public magic systems
4. Aberration threat
5. Magic users protect society
6. Hero childhood disaster
7. Tachibana rescues Hero
8. Hero believes magic can protect people
9. Astraea title card
10. Academy Gate

MVP 不揭露：

- Reality Cost
- The Fading
- Institute Zero
- Mio
- Aberration 真正因果

---

# 8. Scene 1 — Academy Gate

## Canon

玩家進入：

```text
Astraea Academy Gate
```

看到：

```text
星環中央魔導學院。

集魔法教育、研究與異形應對人才培育於一身，
世界上最重要的魔導學府之一。
```

然後取得控制。

---

# 9. Scene 1 Objective

```text
新生報到
前往學院正門與佐伯悠真交談
```

流程：

```text
Walk to Yuma
↓
Interaction prompt
↓
Press E / Tap interact
↓
Dialogue
↓
Choice
```

---

# 10. Dialogue System MVP

MVP 支援：

- Narration
- Inner Monologue
- Character Dialogue
- 2–3 option choice
- portrait expression
- backlog
- dialogue advance

不做：

- voice acting
- cinematic camera editor
- relationship visualization

---

# 11. Scene 1 Completion

Scene 1 結束：

- Hero motivation established
- Yuma relationship initialized
- next objective unlocked

---

# 12. Scene 2 — Character Creation

## Canon

支援：

- Player naming
- 8 Attributes
- 32 Fixed Allocation
- Base = 8
- Allocation cap = 15
- Aptitude Roll
- Fate Reroll
- Initial Weapon
- Rio / Hina introduction

---

# 13. MVP Character Attributes

完整保留：

```text
Mana Capacity
Mana Output
Computation
Processing
Precision
Efficiency
Ambient Sync
Analysis
```

MVP 必須實際影響：

- initiative
- spell requirement
- analysis success
- mana handling
- combat options

不能只是角色卡數字。

---

# 14. Initial Weapons

完整保留四種：

```text
Astraea Longsword
Standard Spear
Training Arcane Gun
Standard Staff
```

MVP 每把武器只需要：

- 1 basic attack profile
- 1 basic Technique
- 1 clear tactical identity

---

# 15. Life Layer Introduction

## GDD Proposal

Scene 2 完成後，首次介紹：

> 現實生活中的投入會透過 Life Progression 影響 Hero 的成長。

MVP 不必在世界觀中完整解釋 Resonance。

可先作為：

> meta progression system。

---

# 16. Initial Life Domains

MVP 僅開三個：

```text
Fitness
Learning
Languages
```

原因：

- 易理解
- Quest template 明確
- 驗證方式簡單
- 避免 scope 爆炸

---

# 17. Initial Life Goal Selection

玩家第一次選：

```text
Which areas do you want to improve?
```

最多選：

```text
2
```

例如：

- Fitness
- Learning
- Languages

---

# 18. Initial Life Quest Templates

每個 Domain 提供 2–3 個。

## Fitness

```text
Walk 10 minutes
Exercise 20 minutes
```

## Learning

```text
Read 20 minutes
Study 20 minutes
```

## Languages

```text
Practice 15 minutes
Speak / Listen 15 minutes
```

---

# 19. First Life Quest

系統必須引導玩家建立或接受：

> 第一個 Life Quest。

例如：

```text
Read 20 minutes
```

---

# 20. First-Life-Action Design

MVP 不強迫玩家立刻離開 20 分鐘才能繼續 Vertical Slice。

提供兩種路徑：

### Real Mode

```text
Do it now
```

玩家真的完成。

### Try System Mode

```text
Demo / Tutorial activity
```

只用於 onboarding。

正式 progression 不應把 Tutorial Demo 當成真實 Life XP。

---

# 21. Evidence MVP

只支援：

```text
E0 Self Report
E1 Timer
```

可選：

```text
E1 Note
```

不做：

- Health Connect
- Apple Health
- GitHub
- GPS
- Photo verification

---

# 22. First Timer Flow

```text
Start Life Quest
↓
Start Timer
↓
Background / Leave App
↓
Return
↓
Stop Timer
↓
Complete
```

Timer 必須支援背景。

---

# 23. Life Quest Completion

完成：

```text
Quest Complete
Read 20 minutes

+ Life XP
+ Cognitive Growth Potential
```

如果使用 Timer：

```text
Timer verified
+ small Evidence bonus
```

---

# 24. Life XP MVP

公式可以先簡化：

```text
Base XP
× Duration Factor
× Evidence Factor
```

不在 MVP 首版加入：

- dynamic challenge
- connected source confidence
- complex diminishing curve

但需保留 architecture hook。

---

# 25. Life Level MVP

玩家至少能看到：

```text
Learning Lv.1
```

與進度條。

Level：

> 代表投入。

UI 需明確避免暗示 Mastery。

---

# 26. Momentum MVP

MVP 簡化：

```text
Inactive
Steady
Strong
```

只需驗證：

> Momentum 是否比 streak 更舒服。

---

# 27. Growth Potential

MVP 支援三類：

```text
Physical Potential
Cognitive Potential
Communication Potential
```

對應：

```text
Fitness
Learning
Languages
```

此 mapping 只作 MVP。

---

# 28. Training Conversion

玩家回到 Astraea 後：

```text
Training Hall
```

看到：

```text
Available Growth Potential
```

例如：

```text
Cognitive Potential: 20
```

---

# 29. Training Choices

MVP 提供少量固定 Training。

例如：

## Cognitive

```text
Function Analysis Drill
→ Analysis tendency

Complexity Exercise
→ Computation tendency
```

## Physical

```text
Reaction Drill
→ Processing tendency

Precision Movement
→ Precision tendency
```

## Communication

```text
Intent Encoding Drill
→ Precision / Ambient Sync tendency
```

具體數值：**TBD**。

---

# 30. Training Rule

MVP 不允許：

```text
20 Potential
→ 自由 +20 Analysis
```

而是：

> 選 Training activity，由系統轉化。

避免 min-max spreadsheet。

---

# 31. Scene 3 — Magic Theory

## Canon

教授介紹：

```text
Magic is not a wish.
Magic is a method of transforming World State A into B.
```

核心：

```text
f(S0)=S1
```

---

# 32. Scene 3 Interaction

MVP 應加入：

> Interactive Function Graph。

例如：

```text
Gather(Energy)
↓
Shape(Bolt)
↓
Move(Target)
```

玩家可點擊 Node 看說明。

---

# 33. Scene 3 Learning Check

不是正式考試。

玩家需要完成：

```text
Arrange 3 Function Nodes
```

或：

```text
Identify what happens first
```

目的：

> 確認玩家理解 Function sequence。

---

# 34. Scene 4 — Full Chant vs Chantless

## Canon

建立：

```text
Full Chant:
Human → Chant → Magic System

Chantless:
Human → Mental Encoding → Magic System
```

---

# 35. Scene 4 Gameplay Tutorial

玩家實際操作：

### Full Chant

- slower
- stable

### Chantless

- faster
- attribute-dependent

不需要複雜 failure system。

---

# 36. Hina Demonstration

Hina 展示：

> 高輸出 Chantless。

Rio 解釋：

> 她不是沒有計算，而是把 encoding 搬到自己腦中。

---

# 37. Scene 5 — Spell Card

## Canon

建立：

```text
Function Graph
↓
Encode
↓
Spell Card
↓
Prepared Deck
↓
Cast
```

---

# 38. MVP Spell Pool

建議：

```text
8–12 cards
```

例如：

## Attack
- Arc Bolt
- Focused Shot
- Energy Burst

## Defense
- Barrier
- Deflect

## Mobility
- Step Shift

## Analysis
- Weak Node Scan

## Support
- Mana Stabilize

## Counter
- Interrupt Pulse

名稱可後續調整。

---

# 39. Prepared Deck Tutorial

玩家從 Spell Pool 選：

```text
6 cards
```

進 Prepared Deck。

MVP 必須明確：

> 不是抽牌。

---

# 40. Prepared Deck Validation

需要記錄：

- 玩家是否修改 Deck
- 選哪些 Card
- 是否理解 role difference

---

# 41. Scene 6 — Training Battle

## Canon

敵人：

```text
Arcane Sentry Mk-I
Ashfang Training Construct
```

---

# 42. Battle 1 — Arcane Sentry

目的：

教：

- Initiative
- Main Action
- Movement
- Basic Attack
- Basic Spell
- Enemy Intent

---

# 43. Battle 1 Scope

只開放：

- Hero
- 1 enemy
- simple battlefield

不一次教 Party control。

---

# 44. Battle 1 Success

玩家：

- 移動至少一次
- 使用 Weapon / Spell
- 理解 Turn Order
- 擊敗 Sentry

---

# 45. Battle 2 — Ashfang Training Construct

目的：

教：

- Party
- Function Graph
- Weak Node
- Reaction
- Interrupt

---

# 46. Battle 2 Party

MVP 可讓：

```text
Hero
Rio
Hina
Yuma
```

全部參與。

若 full party UX 太重，可先縮：

```text
Hero
Rio
Hina
```

最終由 prototype 決定。

---

# 47. Ashfang Function

## GDD Proposal

示例：

```text
Detect(Target)
↓
LockTarget
↓
Charge
↓
Pounce
```

其中：