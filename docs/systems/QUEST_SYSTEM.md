# Quest System Specification
## `QUEST_SYSTEM.md`

**版本：** v1.0  
**狀態：** Working Specification  
**隸屬文件：** `Life_RPG_Astraea_GDD_v1.1.md`  
**相關文件：**
- `LIFE_PROGRESSION_SYSTEM.md`
- `COMBAT_SYSTEM.md`

**系統定位：** 定義 Life RPG × Astraea Academy 中所有 Quest 的分類、建立、追蹤、完成、驗證、獎勵與敘事邊界，並確保「現實人生行動」與「Astraea 世界冒險」互相支援但不混淆。

> 文件標記  
> - **Canon**：已由既有 Astraea 文件確立。  
> - **GDD Proposal**：為 Life RPG 新增的系統設計提案。  
> - **TBD**：待後續 UX、playtest、balance 或 narrative 決策。  

---

# 1. Quest System Vision

Quest System 不是一個換皮 Todo List。

它負責把兩種完全不同的行為分開管理：

```text
REAL LIFE
Life Quest
→ 真實世界行動
→ Life Progress
→ Growth Potential
```

以及：

```text
ASTRAEA
Story / Game Quest
→ 探索
→ 對話
→ 戰鬥
→ 劇情
→ 世界狀態改變
```

核心原則：

> **Life Quest 讓角色成長；Story Quest 讓角色冒險。**

兩者互相支援，但不能混成「跑步 30 分鐘 = Boss -300 HP」。

---

# 2. Quest Taxonomy

Quest 分成兩個最上層類別：

```text
Quest
├── Life Quest
└── Astraea Quest
```

---

# 3. Life Quest

Life Quest 發生在真實世界。

用途：

- 記錄投入
- 建立 Life XP
- 累積 Growth Potential
- 維持 Momentum
- 支援 Main Quest
- 形成 Life History

Life Quest 不直接推動主線劇情。

---

# 4. Astraea Quest

Astraea Quest 發生在遊戲世界。

用途：

- 劇情推進
- 世界探索
- NPC 關係
- 教學
- 戰鬥
- Research
- 解鎖 Spell / Function
- Boss
- 世界狀態變化

---

# 5. Hard Separation Rule

錯誤設計：

```text
Life Quest:
Run 3 km

Reward:
Boss takes 500 damage
```

正確設計：

```text
Run 3 km
↓
Fitness XP
↓
Physical Growth Potential
↓
Training
↓
Character Build improves
↓
Player enters Boss Battle
```

---

# 6. Life Quest Types

## 6.1 Quick Quest

低摩擦、短時間。

例如：

```text
Walk 10 minutes
Read 10 pages
Practice English 10 minutes
Review today's spending
```

目的：

> 降低啟動阻力。

---

## 6.2 Habit Quest

週期性行為。

例如：

```text
Exercise 3 times per week
Read before bed
Practice English 4 days per week
Review spending daily
```

---

## 6.3 Challenge Quest

具有明確挑戰性。

例如：

```text
Run 5K
Finish one book
Complete one mock interview
30 days without impulse purchase
```

---

## 6.4 Milestone Quest

真實成果。

例如：

```text
Publish first app
Finish first 10K
Complete certification
Build emergency fund
Finish a course
```

Milestone Quest 通常應連結：

> Life Achievement。

---

# 7. Astraea Quest Types

## 7.1 Main Story Quest

推進主線。

例如：

```text
新生報到
參加適性測試
調查失能事件
追查 Institute Zero
阻止 Mio
```

---

## 7.2 Side Quest

補充：

- NPC
- 世界觀
- Party relationship
- Spell / Research
- optional combat

---

## 7.3 Training Quest

用於：

- Character Attribute training
- Weapon practice
- Spell test
- Function Analysis
- Counter practice

---

## 7.4 Exploration Quest

例如：

```text
Explore Research Wing
Search Aberration Zone
Find missing student
Survey broken magic infrastructure
```

---

## 7.5 Research Quest

例如：

```text
Analyze failed Spell Card
Compare Function logs
Construct Counter-Function
Study unknown Node
```

---

## 7.6 Combat Quest

目的明確的戰鬥任務。

例如：

```text
Defeat Arcane Sentry Mk-I
Neutralize Ashfang Training Construct
Protect evacuation route
```

---

# 8. Canon Story Quest Structure

第一部已確立：

```text
Learn Magic
↓
Believe Magic Protects People
↓
Magic Disability Incident
↓
Investigate Failure
↓
Institute Zero
↓
Reality Cost
↓
Entropy
↓
The Fading
↓
Mio
↓
Final Battle
```

Story Quest 必須遵守既有劇透邊界。

---

# 9. Scene 1–6 Quest Boundary

Scene 1–6 可出現：

- Magic
- Mana
- Function
- Function Graph
- Chant
- Chantless
- Spell Card
- Prepared Deck
- Aberration
- Astraea

不可提前透過 Quest text 暴露：

- Reality Cost
- The Fading
- Local Entropy 真義
- Institute Zero
- Mio 真正身分
- Aberration 真正來源
- Human ↔ Magic System connection 可被破壞

---


# 9.1 Quest Domain Model — Accepted

**Decision OD-004: Accepted**

Quest model 正式拆分：

```text
QuestTemplate
= authored reusable Life template

UserLifeQuest
= player-owned configured Life Quest

StoryQuestDefinition
= authored Astraea quest

StoryQuestState
= player's runtime progress
```

`UserLifeQuest` 可以由 `QuestTemplate` 建立，也可完全自訂；它不是 authored story content。

`StoryQuestDefinition` 由 Content Pipeline 管理，`StoryQuestState` 只保存玩家對該 authored quest 的執行狀態。

# 10. Quest Lifecycle

所有 Quest 使用一致狀態模型：

```text
Draft
Available
Accepted
Active
Completed
Failed
Skipped
Expired
Archived
```

不是每種 Quest 都需要全部狀態。

---

# 11. Life Quest Lifecycle

建議：

```text
Created
↓
Scheduled
↓
Active
↓
Completed / Skipped / Rescheduled
↓
Archived
```

---

# 12. Story Quest Lifecycle

建議：

```text
Locked
↓
Available
↓
Accepted / Auto-Started
↓
In Progress
↓
Objective Complete
↓
Resolved
```

---

# 13. Quest Objective Model

Quest 可以包含一個或多個 Objective。

```text
Quest
└── Objectives[]
```

Objective 類型：

- Complete Activity
- Reach Location
- Talk to NPC
- Analyze Function
- Defeat Enemy
- Survive
- Protect
- Collect Evidence
- Investigate
- Make Choice
- Complete Training

---

# 14. Objective State

```text
Locked
Available
Active
Completed
Failed
Optional
```

---

# 15. Life Quest Creation

MVP 建立 Life Quest 時，只問：

```text
What?
Which Domain?
How often?
Estimated duration?
```

系統推導：

- XP range
- evidence options
- Growth Potential category
- repeat policy
- diminishing-return group
- suggested difficulty

玩家不能自己輸入：

```text
Reward: +1000 XP
```

---

# 16. Quest Templates

系統應提供預設 Template，避免 setup friction。

## Fitness
```text
Walk 5,000 steps
Run 20 minutes
Workout 30 minutes
Stretch 10 minutes
```

## Learning
```text
Read 20 minutes
Study 30 minutes
Finish one lesson
```

## Languages
```text
Practice 15 minutes
Speak 10 minutes
Listen 20 minutes
```

## Career
```text
Work on project 30 minutes
Review one technical topic
Update portfolio
```

## Finance
```text
Review daily spending
Update budget
Read finance material
```

---

# 17. Smart Defaults

新增 Life Quest 時，系統應盡量預設：

- sensible duration
- repeat frequency
- evidence mode
- reward band

避免讓使用者設計一整套遊戲經濟。

---

# 18. Quest Difficulty

MVP：

```text
Easy
Normal
Hard
Epic
```

Difficulty 是：

> 對此玩家的相對挑戰程度。

不是客觀全球難度。

---

# 19. Difficulty Inputs

未來可根據：

- historical completion
- duration
- frequency
- user Momentum
- similar Quest history
- self-reported difficulty

動態建議。

---


# 19.1 Difficulty Ownership — Accepted

Quest System 擁有 normalization 後的 difficulty label：

```text
Easy
Normal
Hard
Epic
```

Quest 不直接保存最終 XP multiplier。

`LifeProgressionEngine` 依 `formula_version` 將 difficulty 映射為 Challenge Factor。

# 20. Difficulty Reward Rule

難度會影響 Life XP，但不能：

```text
Hard = 5x XP
```

避免使用者全部標 Hard。

系統需限制 multiplier。

---

# 21. Daily Quest Selection

推薦每天：

```text
1–3 Core Life Quests
+ optional quests
```

避免預設 10–20 個。

---

# 22. Daily Quest Goal

Quest 系統應幫玩家回答：

> 今天最值得做的幾件事是什麼？

而不是：

> 今天總共有多少 Todo。

---

# 23. Weekly Quest

可支援：

```text
Run 3 times this week
Read 5 days
Practice English 4 days
```

Weekly Quest 不應要求固定每日 streak。

---

# 24. Life Goal — Real Life

## GDD Proposal

玩家可以設定一個主要現實方向。

例如：

```text
Improve English
Get Fit
Build My First App
Read 12 Books
Build Emergency Fund
```

Life Goal 可以包含子 Life Quest。

---

# 25. Main Story — Astraea

Astraea Main Story 則是：

> 主線劇情。

兩者名稱相同容易混淆。

命名已定案：

```text
Life Goal
Main Story
Life Quest
Story Quest
```

不得再使用 `Main Quest` 同時指稱兩種概念。

---

# 26. Quest Recommendation

Quest Recommendation 可考慮：

- active Life Goal
- Focus Domain
- Momentum
- historical success
- available time
- current Astraea training needs

但不能操縱玩家：

> 為了某個 stat 強迫做特定現實活動。

---

# 27. Build-Aware Recommendation

可以說：

> 你最近累積了很多 Cognitive Potential，可以考慮回 Academy 做 Analysis Training。

但不應說：

> 你 Analysis 太低，今天必須讀 60 分鐘。

---

# 28. Quest Completion

Life Quest 完成時：

```text
Quest Complete
↓
Evidence check
↓
Life XP
↓
Growth Potential
↓
Momentum update
↓
History
```

---

# 29. Evidence Integration

Evidence levels：

```text
E0 Self Report
E1 Timer / Note / Photo
E2 Connected Data
E3 Outcome
```

Quest 自身定義：

```text
verification_policy
```

例如：

```text
Optional
Recommended
RequiredForCompetitive
```

---


# 29.1 Verification Policy Ownership — Accepted

Quest 只保存 `verification_policy` 參照值；其 enum 與語意由 `EVIDENCE_SYSTEM.md` 定義：

```text
Optional
Recommended
RequiredForCompetitive
RequiredForAchievement
```

Quest System 不自行實作第二套 Evidence policy logic。

# 30. Evidence UX

不使用：

```text
PROVE YOU DID THIS
```

改：

```text
Complete Quest
+30 Life XP

Add timer verification
+3 bonus XP
```

---

# 31. Self-Report

Self-report 必須合法。

原因：

- 降低摩擦
- 支援無法自動驗證的活動
- 單人模式不需要過度警察化

---

# 32. Competitive Quest

若未來有：

- leaderboard
- guild challenge
- public event
- ranked activity

則：

```text
Verified evidence required
```

---

# 33. Anti-Grind

Quest system 必須防止：

```text
喝水
喝水
喝水
喝水
```

無限刷 XP。

方法：

- diminishing return
- duplicate detection
- activity grouping
- normalized duration
- daily saturation

---

# 34. Duplicate Quest Detection

系統可辨識：

```text
Read 20 minutes
Reading 20m
Read book 20 mins
```

可能屬同一 group。

MVP 可簡單依：

- Domain
- Template
- normalized title
- time proximity

判斷。

---

# 35. Quest Farming Prevention

不應讓：

```text
1 個 60 分鐘 Study
```

拆成：

```text
6 個 10 分鐘 Study
```

獲得 6 倍 reward。

XP 應按：

> normalized activity duration + category saturation

計算。

---

# 36. Failure

Life Quest 未完成：

```text
Skip
Reschedule
Make Easier
Remove
```

不：

- 扣 XP
- 降 Level
- 傷害角色
- 失去裝備

---

# 37. Story Quest Failure

Story Quest 可以：

- Retry
- Branch
- Change strategy
- Return later

但不應破壞玩家真實生活 Progress。

---

# 38. Expiry

## Life Quest

Habit / Daily Quest 可以 expired，但：

> expired ≠ punishment。

## Story Quest

通常不設現實時間 expiry。

避免 FOMO。

---

# 39. Time-Limited Seasonal Quest

若有 Season：

可以有限時。

但 reward 優先：

- cosmetic
- narrative side content

不要：

- 永久 power
- permanent stat advantage

---

# 40. Story Gating Rule

Life Quest 不能成為硬性主線門檻。

錯誤：

```text
Complete 10 workouts
→ unlock Chapter 4
```

較佳：

```text
Complete Life Quests
→ stronger / more flexible build

Chapter 4
→ still accessible via baseline progression
```

---

# 41. Soft Gating

Life Progress 可影響：

- extra dialogue
- optional route
- spell variant
- training option
- side quest
- cosmetic
- tactical shortcut

---