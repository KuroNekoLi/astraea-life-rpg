# Wireframe Specification
## `WIREFRAME_SPEC.md`

**版本：** v1.0  
**狀態：** MVP Wireframe Baseline  
**依據：**
- `SPEC_BASELINE_v1.0.md`
- `GAME_FLOW_AND_IA.md`
- `MVP_VERTICAL_SLICE.md`
- `QUEST_SYSTEM.md`
- `LIFE_PROGRESSION_SYSTEM.md`
- `COMBAT_SYSTEM.md`

---

# 1. Purpose

本文件定義 Life RPG × Astraea Academy MVP 的主要畫面、資訊層級、導覽與互動 wireframe。

目標不是做視覺稿，而是回答：

- 每個畫面要顯示什麼？
- 玩家下一步可以做什麼？
- Life Layer 與 RPG Layer 如何切換？
- 哪些資訊必須第一眼看到？
- 哪些資訊應 progressive disclosure？

---

# 2. UX Principle

核心原則：

```text
Life Layer
≠
Story Layer
```

但兩者必須在 Home 匯合。

Home 要同時回答：

```text
今天現實世界要做什麼？
Astraea 現在進展到哪裡？
我的角色因現實投入成長了什麼？
```

---

# 3. Primary Navigation

MVP Bottom Navigation：

```text
[Home] [Life] [Adventure] [Deck] [Character]
```

`Progress` 放在 Character / Home secondary entry。

理由：

- MVP 主要 loop 是 Home → Life → Training → Adventure
- `Deck` 是戰鬥核心，需要一級入口
- `Progress` 尚未重要到獨立 tab

---

# 4. Home Wireframe

```text
┌──────────────────────────────┐
│ Astraea Academy              │
│ [Hero live scene / portrait] │
│                              │
│ Main Story                   │
│ 新生報到                     │
│ 前往訓練場                   │
│ [Continue Adventure]         │
│                              │
│ Today                        │
│ □ Read 20 min                │
│ □ Walk 10 min                │
│                              │
│ Growth Ready                 │
│ Cognitive Potential 18       │
│ [Train Now]                  │
│                              │
│ Learning Lv. 3  Steady       │
└──────────────────────────────┘
```

## 必須
- Current Story Objective
- 1–3 個 Today Life Quest
- Growth Potential
- Hero visual
- CTA

## 不放
- 大量 KPI
- 商城
- Social feed
- 8 Attributes 全展開

---

# 5. Life Quest List

```text
┌──────────────────────────────┐
│ Life                         │
│ Today                        │
│                              │
│ ● Read 20 minutes            │
│   Learning · Normal          │
│   [Start]                    │
│                              │
│ ● Walk 10 minutes            │
│   Fitness · Easy             │
│   [Start]                    │
│                              │
│ + Add Quest                  │
│                              │
│ [Upcoming] [History]         │
└──────────────────────────────┘
```

設計重點：

- 每個 Quest 一眼知道「要做什麼」
- 不顯示複雜 multiplier
- Evidence 不在列表造成壓力

---

# 6. Life Quest Detail

```text
┌──────────────────────────────┐
│ Read 20 minutes              │
│ Learning                     │
│                              │
│ Estimated: 20 min            │
│ Expected: ~25 Life XP        │
│ Potential: Cognitive         │
│                              │
│ [Start Timer]                │
│ [Complete Manually]          │
│                              │
│ Reschedule                   │
│ Make Easier                  │
│ Archive                      │
└──────────────────────────────┘
```

---

# 7. Timer Screen

```text
┌──────────────────────────────┐
│ Read 20 minutes              │
│                              │
│          12:43               │
│                              │
│ [Pause]       [Finish]       │
│                              │
│ You can leave the app.       │
│ Your timer will continue.    │
└──────────────────────────────┘
```

規則：

- 不要求保持前景
- Timer 是 Evidence，不是監控
- 回來後可 Finish

---

# 8. Quest Complete

```text
┌──────────────────────────────┐
│ Quest Complete               │
│                              │
│ Read 20 minutes              │
│ +25 Learning XP              │
│ +18 Cognitive Potential      │
│                              │
│ Timer verified               │
│ +2 bonus XP                  │
│                              │
│ [Train Now]                  │
│ [Back Home]                  │
└──────────────────────────────┘
```

此畫面是第一個核心 reward moment。

---

# 9. Character Creation

```text
┌──────────────────────────────┐
│ Character Creation           │
│                              │
│ Name                         │
│ [______________]             │
│                              │
│ Mana Capacity       8 [+]    │
│ Mana Output         8 [+]    │
│ Computation         8 [+]    │
│ Processing          8 [+]    │
│ Precision           8 [+]    │
│ Efficiency          8 [+]    │
│ Ambient Sync        8 [+]    │
│ Analysis            8 [+]    │
│                              │
│ Points Remaining: 32         │
│                              │
│ [Continue]                   │
└──────────────────────────────┘
```

需：
- tooltip 解釋每個 Attribute
- 禁止一次顯示大量公式

---

# 10. Aptitude Result

```text
┌──────────────────────────────┐
│ Aptitude Test                │
│                              │
│ Analysis       ★★★★          │
│ Processing     ★★★           │
│ Mana Output    ★★            │
│ ...                          │
│                              │
│ Fate Reroll available        │
│ [Reroll One]                 │
│ [Accept]                     │
└──────────────────────────────┘
```

---

# 11. Weapon Selection

```text
┌──────────────────────────────┐
│ Choose Training Weapon       │
│                              │
│ [Longsword]                  │
│ Balanced / Reaction          │
│                              │
│ [Spear]                      │
│ Reach / Control              │
│                              │
│ [Arcane Gun]                 │
│ Range / Precision            │
│                              │
│ [Staff]                      │
│ Spell / Complexity           │
└──────────────────────────────┘
```

---

# 12. Character Screen

```text
┌──────────────────────────────┐
│ Character                    │
│ [Hero visual]                │
│                              │
│ Weapon: Standard Staff       │
│                              │
│ Attributes                   │
│ Analysis       12            │
│ Computation    11            │
│ Processing     10            │
│ [View All]                   │
│                              │
│ Growth Ready                 │
│ Cognitive 18                 │
│ [Training]                   │
└──────────────────────────────┘
```

---

# 13. Training Hall

```text
┌──────────────────────────────┐
│ Training Hall                │
│                              │
│ Cognitive Potential: 18      │
│                              │
│ Function Analysis Drill      │
│ Analysis ↑                   │
│ Cost: 10 Cognitive           │
│ [Train]                      │
│                              │
│ Complexity Exercise          │
│ Computation ↑                │
│ Cost: 10 Cognitive           │
│ [Train]                      │
└──────────────────────────────┘
```

---

# 14. Training Confirmation

```text
┌──────────────────────────────┐
│ Function Analysis Drill      │
│                              │
│ Cost                         │
│ Cognitive Potential -10      │
│                              │
│ Expected Growth              │
│ Analysis Progress +X         │
│                              │
│ [Cancel] [Begin Training]    │
└──────────────────────────────┘
```

不直接顯示：

```text
+1 stat
```

若實際為 progress bar，可顯示：

```text
Analysis 12
██████░░  → ███████░
```

---

# 15. Adventure Screen

```text
┌──────────────────────────────┐
│ Astraea Academy              │
│                              │
│ [Exploration View]           │
│                              │
│ Objective                    │
│ 前往魔法理論教室             │
│                              │
│ [virtual controls / tap]     │
└──────────────────────────────┘
```

---

# 16. Dialogue

```text
┌──────────────────────────────┐
│ [World Background]           │
│                              │
│        [Character]           │
│                              │
│ Rio                          │
│ 「你看到的不是火球。」        │
│ 「是 Function 的結果。」      │
│                              │
│ > 什麼意思？                 │
│ > 我大概懂了。               │
└──────────────────────────────┘
```

背景不切空白。

---

# 17. Function Theory Tutorial

```text
┌──────────────────────────────┐
│ Function Theory              │
│                              │
│ Gather(Energy)               │
│      ↓                       │
│ Shape(Bolt)                  │
│      ↓                       │
│ Move(Target)                 │
│                              │
│ [Tap a node to inspect]      │
└──────────────────────────────┘
```

---

# 18. Function Ordering Exercise

```text
┌──────────────────────────────┐
│ Arrange the Function         │
│                              │
│ [ Move ]                     │
│ [ Gather ]                   │
│ [ Shape ]                    │
│                              │
│ Drag into order              │
│                              │
│ [Check]                      │
└──────────────────────────────┘
```

---

# 19. Spell Pool

```text
┌──────────────────────────────┐
│ Spell Pool                   │
│                              │
│ Arc Bolt                     │
│ Attack                       │
│ [Details] [+ Deck]           │
│                              │
│ Barrier                      │
│ Defense                      │
│ [Details] [+ Deck]           │
│                              │
│ Weak Node Scan               │
│ Analysis                     │
│ [Details] [+ Deck]           │
└──────────────────────────────┘
```

---

# 20. Spell Detail

```text
┌──────────────────────────────┐
│ Arc Bolt                     │
│ Attack                       │
│                              │
│ Mana: 8                      │
│ Complexity: Low              │
│ Full Chant / Chantless       │
│                              │
│ Function Graph               │
│ Gather → Shape → Move        │
│                              │
│ [Add to Deck]                │
└──────────────────────────────┘
```

---

# 21. Prepared Deck

```text
┌──────────────────────────────┐
│ Prepared Deck       6 / 6    │
│                              │
│ [Arc Bolt]                   │
│ [Barrier]                    │
│ [Step Shift]                 │
│ [Weak Node Scan]             │
│ [Mana Stabilize]             │
│ [Interrupt Pulse]            │
│                              │
│ [Confirm Deck]               │
└──────────────────────────────┘
```

需清楚傳達：

> 這六張在戰鬥中全部可用，不是抽牌。

---

# 22. Pre-Battle Screen

```text
┌──────────────────────────────┐
│ Training Encounter           │
│                              │
│ Arcane Sentry Mk-I           │
│                              │
│ Party                        │
│ Hero                         │
│                              │
│ Prepared Deck 6/6            │
│                              │
│ [Edit Deck] [Start Battle]   │
└──────────────────────────────┘
```

---

# 23. Combat — Basic Layout

```text
┌──────────────────────────────┐
│ Turn: Hero > Sentry          │
│                              │
│        Enemy                 │
│       [Sentry]               │
│                              │
│             [Hero]           │
│                              │
│ Enemy Intent: Targeting Hero │
│                              │
│ Mana 24 / 30                 │
│                              │
│ [Attack] [Spell] [Move]      │
│ [Quick]  [End Turn]          │
└──────────────────────────────┘
```

---

# 24. Combat — Spell Picker

```text
┌──────────────────────────────┐
│ Spell                        │
│                              │
│ Arc Bolt          8 MP       │
│ Barrier           6 MP       │
│ Step Shift        5 MP       │
│ Weak Node Scan    4 MP       │
│ Mana Stabilize    5 MP       │
│ Interrupt Pulse   7 MP       │
└──────────────────────────────┘
```

---

# 25. Function Graph Combat Panel

```text
┌──────────────────────────────┐
│ Enemy Function               │
│                              │
│ Detect       ✓               │
│   ↓                          │
│ LockTarget   ACTIVE          │
│   ↓                          │
│ Pounce       ???             │
│                              │
│ Weak Node detected           │
│ [Interrupt]                  │
└──────────────────────────────┘
```

---

# 26. Reaction Prompt

```text
┌──────────────────────────────┐
│ Reaction Opportunity         │
│                              │
│ LockTarget is vulnerable.    │
│                              │
│ [Interrupt Pulse]            │
│ [Weapon Interrupt]           │
│ [Skip]                       │
└──────────────────────────────┘
```

---

# 27. Weak Node Success

```text
Function Interrupted

LockTarget failed.
Pounce cannot acquire target.
```

需：
- strong animation
- haptic
- clear cause-and-effect

這是 MVP combat aha moment。

---

# 28. Post-Battle Report

```text
┌──────────────────────────────┐
│ Training Complete            │
│                              │
│ Magic Casts          4       │
│ Techniques Used      2       │
│ Weak Nodes Exploited 1       │
│ Damage Prevented     18      │
│ Mana Remaining       7       │
│                              │
│ Rio:                         │
│ 「你開始先理解，再行動了。」 │
│                              │
│ [Continue]                   │
└──────────────────────────────┘
```

禁止 S/A/B/C grading。

---

# 29. Progress Screen

```text
┌──────────────────────────────┐
│ Life Progress                │
│                              │
│ Learning Lv.3                │
│ Steady                       │
│ ███████░░░                   │
│                              │
│ Fitness Lv.1                 │
│ Inactive                     │
│ ██░░░░░░░░                   │
│                              │
│ Languages Lv.2               │
│ Steady                       │
│ ████░░░░░░                   │
└──────────────────────────────┘
```

---

# 30. MVP Navigation Acceptance

玩家必須能在最多 2 個操作內從 Home 到：

- Today Life Quest
- Continue Story
- Training
- Prepared Deck

---

# 31. UX Risk Checklist

避免：
- Life UI 太像 Todoist
- RPG UI 太像企業 dashboard
- Function Graph 太像工程 IDE
- Evidence 看起來像監控
- Training 像 Excel 分點
- Deck 看起來像 gacha CCG

---

# 32. Wireframe Deliverable Boundary

本文件只定義：
- screen
- hierarchy
- interaction
- flow

不定義：
- final visual style
- exact color
- typography
- final animation
- final character art

那些屬 `UI_VISUAL_DESIGN_SPEC.md` / Figma 階段。

---

# 33. MVP UX Thesis

> **玩家完成真實行動後，應自然地想到「我要回 Astraea 看角色怎麼成長」；而不是覺得自己只是完成一個 Todo。**