# Life Progression System Specification
## `LIFE_PROGRESSION_SYSTEM.md`

**版本：** v1.0  
**狀態：** Working Specification  
**隸屬文件：** `Life_RPG_Astraea_GDD_v1.1.md`  
**相關文件：** `COMBAT_SYSTEM.md`  
**系統定位：** 將玩家現實世界中的持續投入，轉化為可追蹤、可驗證、可長期累積，且能影響 Astraea RPG Build 的 Progression System。

> 文件標記  
> - **Canon**：已由既有 Astraea 文件明確確立。  
> - **GDD Proposal**：為 Life RPG 新增的系統設計提案，尚未自動成為世界觀 canon。  
> - **TBD**：待後續 user research、playtest、數值平衡或 narrative 決策。  

---

# 1. System Vision

Life Progression System 的任務不是：

```text
做事情
→ 打勾
→ +XP
```

而是：

```text
真實投入
↓
可追蹤的 Life Progress
↓
長期累積
↓
形成玩家的 Life Profile
↓
產生 Growth Potential
↓
在 Astraea 中轉化為 Character Growth
↓
影響 Build、Training 與 Combat Flexibility
```

核心原則：

> **現實生活中的投入，應塑造角色；但不應讓玩家為了遊戲而扭曲現實人生。**

---

# 2. Core Design Principles

## 2.1 Level ≠ Mastery

Life Level 表示：

> **投入程度與累積歷史。**

不表示：

> 真實能力水準。

例如：

```text
English Lv.20
```

代表：

> 玩家長期在英文投入很多時間與行動。

不代表：

> CEFR C1。

---

## 2.2 Consistency > Grinding

系統鼓勵：

- 持續
- 合理頻率
- 多日累積

而不是：

- 單日暴刷
- 長時間過度投入
- 重複低價值行為

---

## 2.3 Evidence Encourages Credibility

Evidence 的目的不是：

> 抓作弊。

而是：

> 提升 Progress 的可信度。

Self-report 永遠合法。

---

## 2.4 Real Life Is Not a Game Economy

不能讓玩家為了最佳化 RPG 數值而：

- 過度運動
- 過度工作
- 瘋狂讀書
- 刻意少睡
- 刻意不花錢
- 重複做無意義任務

---

## 2.5 Story Must Not Be Hard-Gated by Productivity

玩家不能因為：

> 今天沒跑步

就無法繼續主線。

Life Progress 應主要影響：

- Build
- Resource flexibility
- Optional path
- Side content
- Tactical options

不是：

- 主線生存權

---

# 3. Life Domains

## GDD Proposal

初期支援：

```text
Fitness
Learning
Languages
Career
Finance
Creativity
Social
Lifestyle
```

每個 Domain 可以有子項目。

---

# 4. Example Domain Trees

## 4.1 Fitness

```text
Fitness
├── Walking
├── Running
├── Strength
├── Mobility
└── Sports
```

## 4.2 Learning

```text
Learning
├── Reading
├── Course
├── Mathematics
├── Science
└── Self Study
```

## 4.3 Languages

```text
Languages
├── English
├── Japanese
├── Spanish
└── Other
```

## 4.4 Career

```text
Career
├── Coding
├── Projects
├── Professional Learning
├── Portfolio
└── Job Search
```

## 4.5 Finance

```text
Finance
├── Budgeting
├── Saving
├── Investing
└── Financial Learning
```

## 4.6 Creativity

```text
Creativity
├── Writing
├── Drawing
├── Music
├── Photography
└── Making
```

## 4.7 Social

```text
Social
├── Friends
├── Family
├── Community
└── Networking
```

## 4.8 Lifestyle

```text
Lifestyle
├── Cleaning
├── Cooking
├── Organization
├── Sleep Routine
└── Personal Administration
```

---

# 5. Life Quest vs Story Quest

## 5.1 Life Quest

存在於現實世界。

例如：

```text
Read 20 minutes
Run 30 minutes
Practice English
Review spending
Work on side project
```

目的：

> 建立 Life Progress。

---

## 5.2 Story Quest

存在於 Astraea。

例如：

```text
Investigate failed Spell Cards
Escort a research team
Defeat an Aberration
Explore Restricted Sector
```

目的：

> 推進 RPG gameplay 與劇情。

---

## 5.3 Hard Boundary

Life Quest 不應被包裝成假裝是 Story Quest。

例如：

```text
錯誤：
Read 30 minutes to attack the boss.
```

較佳：

```text
Read 30 minutes
↓
Gain Cognitive Growth Potential
↓
Train Analysis
↓
Enter boss battle with stronger Analysis build
```

---

# 6. Life Quest Types

## 6.1 Quick Quest

低摩擦短任務。

例如：

```text
Walk 10 minutes
Read 10 pages
Review today’s expenses
```

---

## 6.2 Habit Quest

週期性活動。

例如：

```text
Exercise 3 times per week
Read before bed
Practice English 4 days per week
```

---

## 6.3 Challenge Quest

有明確挑戰。

例如：

```text
Run 5K
Finish one book
Complete one mock interview
No impulse purchase for 7 days
```

---

## 6.4 Milestone Quest

現實成果。

例如：

```text
Publish an App
Complete a Course
Finish a 10K race
Save first emergency fund
```

---

# 7. Life Quest Creation

建立 Quest 時，MVP 只要求：

```text
What?
Which Domain?
How often?
Estimated duration?
```

系統推導：

- expected XP range
- potential Growth category
- verification options
- diminishing-return group
- quest difficulty recommendation

玩家不能任意填：

```text
+5000 XP
```

---

# 8. Quest Templates

一般使用者不應從空白開始。

系統應提供 Template。

例如：

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
Listen 20 minutes
Speak 10 minutes
```

## Finance
```text
Review daily spending
Update monthly budget
Read one finance lesson
```

---

# 9. Life XP

Life XP 是：

> 對某個 Life Domain 的累積投入量化。

不代表能力。

---

# 10. Life XP Formula

## GDD Proposal

暫定：

```text
Life XP
=
Base Activity XP
× Duration Factor
× Challenge Factor
× Evidence Factor
× Diminishing Return Factor
```

具體數值：**TBD**。

---


# 10.1 Life XP Calculation Ownership — Accepted

**Decision OD-001: Accepted**

Life XP 的最終計算只由 `LifeProgressionEngine` 負責。

輸入：

```text
LifeActivity
+ QuestSnapshot
+ EvidenceSummary
```

輸出：

```text
LifeProgressionCalculator(formula_version)
↓
RewardGrant
```

責任邊界：

- Quest System：提供 difficulty、duration、activity group 等 Quest input。
- Evidence System：提供 EvidenceSummary 與 verification 結果。
- Life Progression Engine：計算最終 Life XP、Growth Potential、Momentum。
- Reward Service：保存 immutable `RewardGrant`。
- Client：只可顯示 deterministic `RewardPreview`，不得成為 authoritative XP source。

# 11. Base Activity XP

Base XP 應來自：

- Quest 類型
- activity category
- expected effort
- normalized duration

不由玩家自由輸入。

---

# 12. Duration Factor

不能線性。

示意：

```text
10 min  → 10 XP
20 min  → 18 XP
30 min  → 25 XP
60 min  → 40 XP
120 min → 55 XP
```

目標：

> 長時間活動有價值，但不鼓勵無限 grinding。

---

# 13. Challenge Factor

Challenge 應反映：

- 對此玩家的相對難度
- 歷史完成率
- 連續投入情況
- milestone 性質

MVP 可先：

```text
Easy
Normal
Hard
Epic
```

但獎勵差距不可過大。

---

# 14. Evidence Factor

建議：

```text
Self Report        ×1.00
Timer              ×1.05
Photo / Note       ×1.05
Connected Source   ×1.10
Outcome Evidence   special recognition
```

原則：

> Evidence 是小 bonus，不是核心 XP 壟斷。

---

# 15. Evidence Levels

## E0 — Self Report

```text
User pressed Complete
```

合法。

---

## E1 — Lightweight Evidence

例如：

- timer
- note
- photo
- screenshot
- URL
- manual duration

---

## E2 — Connected Verification

例如：

- Health Connect
- Apple Health
- Strava
- GitHub
- Calendar
- in-app assessment

MVP 不一定全做。

---

## E3 — Outcome Evidence

例如：

- published app
- certification
- race result
- completed project
- published article

通常對應：

> Achievement

而不是單純 XP multiplier。

---

# 16. Anti-Cheat Philosophy

Single-player：

> 不 aggressively police。

理由：

玩家最終欺騙的是：

> 自己的 Progress History。

但系統需避免：

- obvious farming
- duplicate claims
- impossible durations
- repeated same-action exploits

---

# 17. Social Verification

未來涉及：

- leaderboard
- public challenge
- guild event
- competitive reward

只計：

> Verified activity

或 event-specific evidence。

---

# 18. Diminishing Returns

同類低價值活動重複刷 XP 時：

```text
1st → 100%
2nd → 80%
3rd → 50%
4th+ → very low
```

具體曲線：**TBD**。

---

# 19. Diminishing Return Group

例如：

```text
drink water
drink water
drink water
```

應視為同一 activity group。

但：

```text
running
strength training
mobility
```

可以是不同 group。

---

# 20. Anti-Grind Principle

系統應偏好：

```text
consistency
+
meaningful effort
+
diversity
```

而不是：

```text
hours logged
```

---

# 21. Soft Cap

不設：

```text
Today max = 500 XP
```

但使用：

- diminishing return
- category saturation
- duration normalization
- safety limits

---

# 22. Life Level

Life Level 由累積 Life XP 產生。

例如：

```text
Reading Lv.18
Fitness Lv.12
English Lv.15
```

---

# 23. Level Curve

應採非線性。

前期：

> 快速升級，建立成就感。

後期：

> Level 有重量。

示意：

```text
Lv1 → 100 XP
Lv2 → 150 XP
Lv3 → 225 XP
...
```

實際公式：**TBD**。

---

# 24. Level Integrity

Life Level 不應下降。

它代表：

> 累積投入歷史。

近期狀態交給：

> Momentum。

---

# 25. Momentum

Momentum 表示：

> 最近是否持續投入。

可能狀態：

```text
Dormant
Low
Steady
Strong
On Fire
```

---

# 26. Momentum Window

建議使用：

```text
7-day window
28-day window
```

例如：

```text
Fitness
7-Day Momentum: Strong
28-Day Momentum: Steady
```

---


# 26.1 Momentum Calculation Ownership — Accepted

**Decision OD-018 semantic alignment**

Momentum 只由 `LifeProgressionEngine` 根據 Life Activity 歷史計算。Quest Recommendation、UI 與 Analytics 只能讀取 Momentum，不直接修改。

# 27. Momentum Decay

如果休息：

> Momentum 逐步下降。

但：

- Level 不下降
- XP 不扣
- Achievement 不消失

---

# 28. Rest Day

玩家可以主動設定：

```text
Rest Day
```

效果：

- 不視為 Quest failure
- 不打擊 Momentum
- 不產生普通 XP
- 可記錄為 recovery state

---

# 29. Failure

Quest 未完成時：

```text
Skip
Reschedule
Make Easier
Remove
```

禁止：

- 扣 XP
- Level Down
- Character punishment
- equipment loss
- guilt messaging

---

# 30. Growth Potential

## GDD Proposal

Life XP 不直接等於 Character Attribute。

中間加入：

```text
Growth Potential
```

目的：

1. 避免活動 → stat 直接 mapping
2. 防止玩家為 Stat 扭曲人生
3. 保留 RPG build decision
4. 增加回 Astraea 的理由

---

# 31. Growth Potential Categories

暫定：

```text
Physical Potential
Cognitive Potential
Communication Potential
Creative Potential
Discipline Potential
```

最終分類：**TBD**。

---

# 32. Example Conversion

```text
Run 30 min
↓
Fitness XP
↓
Physical Potential +25
```

```text
Read 20 min
↓
Learning XP
↓
Cognitive Potential +18
```

```text
English speaking 15 min
↓
Language XP
↓
Communication Potential +12
```

---

# 33. Training Conversion

Growth Potential 不直接永遠保存為 RPG Stat。

玩家在 Astraea：

```text
Training Hall
↓
Training Session
↓
Choose Training
↓
Convert Potential
↓
Character Growth
```

MVP prototype conversion costs, growth amounts, Aptitude adjustments, and Fate reroll rules are versioned in `assets/content/progression/character_growth_mvp_v1.json` (`character-growth-mvp-1`). They do not change the rule that Life activity grants Potential rather than Attributes directly.

---

# 34. Training Session Goal

玩家做的是：

> Build decision。

不是：

> 精算 Excel。

例如：

```text
Cognitive Potential available: 40
```
