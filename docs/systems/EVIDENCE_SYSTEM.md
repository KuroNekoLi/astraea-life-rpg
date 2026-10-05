# Evidence System Specification
## `EVIDENCE_SYSTEM.md`

**版本：** v1.0  
**狀態：** Working Specification  
**隸屬文件：** `Life_RPG_Astraea_GDD_v1.1.md`  
**相關文件：**
- `LIFE_PROGRESSION_SYSTEM.md`
- `QUEST_SYSTEM.md`
- `COMBAT_SYSTEM.md`

**系統定位：** 定義 Life RPG × Astraea Academy 如何判斷、記錄與呈現現實世界行動的可信度，讓 Life Progress 具有可追溯性，但不把產品變成監控工具或懲罰式 anti-cheat 系統。

> 文件標記  
> - **Canon**：已由 Astraea 既有設定明確確立。  
> - **GDD Proposal**：為 Life RPG 新增的系統設計提案。  
> - **TBD**：待 UX、privacy、platform integration、playtest 或法規決策。  

---

# 1. System Vision

Evidence System 的目的不是：

> 判定玩家有沒有說謊。

而是：

> **讓玩家知道自己的 Life Progress 有多少是由真實、可追溯的行動支持。**

核心流程：

```text
Life Quest
↓
Activity Completion
↓
Evidence Collected
↓
Verification Level
↓
Life XP / Bonus
↓
History
↓
Evidence-backed Progress
```

---

# 2. Core Philosophy

## 2.1 Self-Report Is Valid

Self-report 永遠合法。

如果玩家完成：

```text
Read 20 minutes
```

但沒有 Timer、照片、外部資料：

```text
[Complete]
```

仍可得到 Life XP。

---

## 2.2 Evidence Is a Bonus

Evidence 的價值應該是：

- 提升可信度
- 提供小幅 bonus
- 支援 Achievement
- 支援 Competitive Mode
- 提升歷史紀錄品質

而不是：

> 沒有 Evidence 就沒有 Progress。

---

## 2.3 Verification ≠ Moral Judgment

不能使用：

```text
Trust Score
Honesty Score
Integrity Rank
```

也不能：

> Evidence 低 → 你是不可信的人。

Evidence 只描述：

> **資料可信程度。**

---

## 2.4 Privacy First

Evidence 可能包含：

- location
- health
- photo
- finance
- code activity
- schedule

因此必須遵循：

> 最小化蒐集、最小化保存、最小化公開。

---

# 3. Evidence Levels

系統定義四層。

```text
E0 — Self Report
E1 — Lightweight Evidence
E2 — Connected Verification
E3 — Outcome Evidence
```

---

# 4. E0 — Self Report

## Definition

玩家自己宣告：

> 「我完成了。」

例如：

```text
Quest: Read 20 minutes
User taps Complete
```

沒有額外證據。

---

## Rules

- 合法
- 可獲得完整 Base Life XP
- 不做懲罰
- 不標示為「unverified fraud」
- 不可用於某些 Competitive Quest

---

# 5. E1 — Lightweight Evidence

## Definition

由 App 內或使用者提供的低摩擦證據。

例如：

- timer
- note
- photo
- screenshot
- URL
- manual duration log
- in-app checklist
- reflection

---

# 6. E1 — Timer

Timer 是 MVP 最重要的 Evidence 來源。

流程：

```text
Start Quest
↓
Start Timer
↓
Activity
↓
Stop Timer
↓
Complete Quest
```

Timer 只能證明：

> App 計時期間經過了多少時間。

不能證明：

> 玩家全程真的在做該活動。

因此仍屬 E1，不是 E2。

---

# 7. E1 — Note / Reflection

可讓玩家輸入：

```text
What did you work on?
```

用途：

- context
- reflection
- personal history

不能因為文字寫得多就給更多 XP。

---

# 8. E1 — Photo / Screenshot

可以支援：

- workout photo
- book page
- project screenshot
- study material

但：

> 不應要求 AI 自動判斷「照片是否證明完成」。

除非後續有明確模型與 privacy 設計。

---

# 9. E1 — URL

可用於：

- article published
- project page
- GitHub PR
- public result

如果系統只保存 URL、未驗證內容：

> 仍屬 E1。

若能透過 integration 驗證 outcome：

> 可提升至 E2 / E3。

---

# 10. E2 — Connected Verification

## Definition

Evidence 來自可信的連接系統或裝置資料。

例如：

- Health Connect
- Apple Health
- Strava
- GitHub
- Google Calendar
- in-app verified assessment
- supported course completion source

---

# 11. E2 — Health Data

可能包括：

- steps
- workout
- distance
- duration
- activity type

例如：

```text
Quest:
Run 5 km

Health Source:
5.12 km running workout
```

可標記：

```text
Verified
```

---

# 12. E2 — GitHub

可能驗證：

- commit
- PR
- merged PR
- release
- contribution activity

但不能：

```text
1 commit = meaningful coding
```

Evidence 只證明：

> 某類輸出存在。

Life XP 仍需 normalize。

---

# 13. E2 — Calendar

Calendar 只能證明：

> 事件存在。

不能證明：

> 玩家真的參與或完成。

因此 Calendar integration 通常只能：

- prefill Quest
- support context
- weak verification

是否視為 E2：**TBD**。

---

# 14. E2 — In-App Assessment

如果 Life Quest 是：

```text
Practice vocabulary
```

App 內完成：

- quiz
- practice
- challenge

可以由系統完整驗證。

這屬高品質 E2。

---

# 15. E3 — Outcome Evidence

## Definition

Evidence 指向：

> 真實世界中相對明確的成果。

例如：

- race result
- certification
- published app
- published article
- completed course certificate
- public release
- verified milestone

---

# 16. E3 Is Not “More XP”

E3 不應只是：

```text
×1.5 XP
```

主要價值：

- Achievement
- Milestone
- Trophy Cabinet
- Life History
- profile credibility

---

# 17. Evidence Strength vs Reward

建議：

```text
E0 → ×1.00
E1 → ×1.05
E2 → ×1.10
E3 → Achievement / milestone bonus
```

具體數值：**TBD**。

Evidence bonus 差距刻意小。

---


# 17.1 Evidence Does Not Calculate Final XP — Accepted

Evidence System 只產生：

```text
EvidenceSummary
```

包含：
- highest valid evidence level
- bonus eligibility
- competitive eligibility
- verification status

最終 XP 由 `LifeProgressionEngine` 依 `formula_version` 計算。Evidence System 不直接寫入 Life XP。

# 18. Why Bonus Must Be Small

如果：

```text
Self Report = 30 XP
Verified = 60 XP
```

玩家會被迫提供 Evidence。

產品會變成：

> surveillance productivity app。

因此 bonus 應：

> 有感，但非必要。

---

# 19. Evidence Requirement Policy

每個 Quest 可設定：

```text
Optional
Recommended
RequiredForCompetitive
RequiredForAchievement
```

---

# 20. Optional

一般 Life Quest。

玩家：

```text
Complete
```

即可。

---

# 21. Recommended

系統提示：

> Timer verification available.

但不強迫。

---

# 22. RequiredForCompetitive

例如：

```text
October Running Challenge
```

只接受：

- Health data
- GPS
- supported source

---

# 23. RequiredForAchievement

部分高價值 Achievement：

```text
First Marathon
```

可要求 E2 / E3。

但：

> 個人私有 Achievement 是否允許 self-report

可另行設定。

---

# 24. Evidence and Anti-Cheat

Anti-cheat 分兩層。

## Single Player

核心原則：

> 玩家可以相信自己。

系統只限制：

- duplicate XP farming
- impossible duration
- obvious exploit
- repeated same-source claims

---

## Social / Competitive

需要：

> Stronger verification.

避免：

- leaderboard abuse
- reward fraud
- guild exploit

---

# 25. Evidence-backed Progress

系統可計算：

```text
Evidence-backed XP
/
Total Life XP
```

例如：

```text
Life Progress

Total XP: 18,420
Evidence-backed: 76%
```

---

# 26. Naming

避免：

```text
Trust Score
Honesty Score
```

推薦：

```text
Evidence Coverage
Verified Progress
Progress Data Quality
```

最終名稱：**TBD**。

---

# 27. Evidence Coverage Visibility

預設：

> Private。

使用者可自行選擇是否公開。

不應作全球排名。

---

# 28. Verification Source

每筆 Evidence 應記錄：

```text
source_type
source_provider
source_record_id
verified_at
verification_version
```

避免重複驗證。

---

# 29. Evidence Provenance

每筆 Evidence 應有來源：

```text
manual
timer
photo
health_connect
apple_health
strava
github
in_app
external_outcome
```

---

# 30. Duplicate Detection

需要防止：

同一筆 Activity 被：

```text
Health Connect
+
Strava
+
Manual Quest
```

重複計 XP。

---

# 31. Duplicate Strategy

可能依：

- timestamp
- duration
- activity type
- provider ID
- distance
- linked Quest

建立：

```text
Activity Fingerprint
```

---

# 32. Duplicate Resolution

若偵測到：

```text
Run 5km
```

同時來自 Health 與 Strava：

應：

> 合併 Evidence Source

而不是：

> 給兩次 Progress。

---

# 33. Evidence Conflict

若：

```text
User says 60 min
Health says 31 min
```

不直接指控玩家。

UI 可：

> We found a 31-minute workout. Use this activity?

使用者可：

- use verified record
- keep manual
- edit Quest

---

# 34. Impossible Data

例如：

```text
Run 100 km in 10 min
```

系統應：

- flag
- exclude from competitive
- avoid bonus
- preserve raw data for review if needed

不一定刪除 personal record。

---

# 35. Manual Editing

玩家可以修改：

- title
- note
- category
- quest association

但已驗證的：

```text
source duration
distance
timestamp
```

不應直接被改寫。

可另外保存：

```text
user_override
```

---

# 36. Evidence Immutability

Verification Source 的原始 reference 應：

> append-only / immutable semantics。

避免後續修改讓歷史失真。

---

# 37. Evidence Expiration

通常：

> 不過期。

但外部 URL 可能失效。

系統仍保存：

- verified_at
- metadata snapshot

是否保存 snapshot：**TBD**。

---

# 38. Privacy Classification

Evidence 類型需標記 sensitivity。

例如：

```text
LOW:
Timer
Note

MEDIUM:
GitHub
Calendar

HIGH:
Health
Location
Finance
Photos
```

---

# 39. Health Privacy

Health evidence：

- 預設 Private
- 不公開 heart rate
- 不公開 medical data
- 只保存 Quest 所需最低資訊

例如：

```text
5.12 km
31 min
Running
```

而非完整 health record。

---

# 40. Location Privacy

如果 GPS verification：

應盡量保存：

- distance
- duration
- activity type

不必永久保存：

> 精確路線。

除非使用者明確選擇。

---

# 41. Finance Privacy

Finance Evidence 預設：

```text
Private
```

不應把：

- account balance
- transaction details

作 public progression data。

---

# 42. Photo Privacy

照片：

- 預設 Private
- 不進 public feed
- 使用者可刪除
- 不必要則不永久保存

---

# 43. Evidence Minimization

核心原則：

> 儲存「足以支持 Progress 的證據摘要」，而不是原始資料全集。

---

# 44. Data Retention

每種 Evidence 應定義：

```text
raw retention
derived retention
deletion behavior
```

例如 Health：

```text
Raw external record:
not copied / minimal

Derived:
duration, type, verification timestamp
```

---

# 45. User Delete

**Decision OD-008: Accepted**

個人 progression 中，刪除 Evidence **不回退已經確認的 RewardGrant**。

例如：

```text
Base XP = 30
E2 bonus = +3
Confirmed RewardGrant = 33
```

之後使用者刪除 Evidence：

```text
Life XP remains 33
Evidence payload deleted / detached
Evidence Coverage recalculated
Verified badge may disappear
Competitive eligibility may be revoked
```

理由：

> Evidence deletion 不應形成「你可以刪除隱私資料，但刪除就懲罰你」的產品誘因。

規則：

- `RewardGrant` 為歷史 immutable transaction，不 retroactively rewrite。
- 可刪除或最小化 Evidence payload，依 retention policy 處理。
- EvidenceSummary 重新投影。
- 未 finalization 的 competitive event 可因失去必要 Evidence 而失去 eligibility。
- 已 finalized 的 competitive 結果政策另行定義。

# 46. Connected Integrations

Long-term roadmap：

```text
Health Connect
Apple Health
Strava
GitHub
Google Calendar
Learning platforms
```

每個 Integration 必須單獨做：

- permission scope
- data minimization
- duplicate policy
- verification strength

---

# 47. Integration Trust Levels

不同 provider 不應自動都視為同樣可信。