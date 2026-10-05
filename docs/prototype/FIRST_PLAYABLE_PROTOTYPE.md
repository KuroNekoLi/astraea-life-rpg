# First Playable Prototype Specification
## `FIRST_PLAYABLE_PROTOTYPE.md`

**版本：** v1.0  
**狀態：** Build Specification  
**目的：** 定義第一個真正可以從頭玩到尾、可拿給測試者使用的 playable build。

---

# 1. Prototype Goal

First Playable 不等於完整 Vertical Slice 美術品質。

它的任務是驗證：

```text
Real-Life Action
→ Reward
→ Training
→ Character Build
→ Function Combat
→ Emotional Payoff
```

是否真的成立。

---

# 2. Prototype Success Definition

測試者能獨立完成：

```text
Start
↓
Enter Astraea
↓
Create Character
↓
Choose Life Domain
↓
Complete Real-Life Quest
↓
Receive Growth Potential
↓
Train
↓
Learn Function
↓
Build Deck
↓
Fight
↓
Exploit Weak Node
↓
Finish Slice
```

---

# 3. Build Target

第一版：

```text
Android
```

優先。

原因：
- 開發與 debug 速度
- 使用者本身 Android 經驗
- KMP domain 未來再帶 iOS

若 shared Compose UI 已穩定，可同步跑 Desktop debug target。

---

# 4. Prototype Visual Fidelity

使用：

- placeholder anime portraits
- simple academy backgrounds
- minimal character movement
- simple spell VFX
- polished Function Graph UI

優先級：

```text
Interaction clarity
>
Visual polish
```

但不能像純工程 demo。

至少要有 JRPG 氛圍。

---

# 5. Prototype Content

## Scene 1
Academy Gate + Yuma

## Scene 2
Character Creation + Weapon

## Life Layer
Choose Learning / Fitness / Languages

## Scene 3
Function Theory

## Scene 4
Full Chant vs Chantless

## Scene 5
Spell Card + Deck

## Scene 6
Two Battles

---

# 6. Life Quest Prototype

至少支援：

```text
Read 20 minutes
Walk 10 minutes
Practice Language 15 minutes
```

可自訂 title，但 MVP 測試優先模板。

---

# 7. Prototype Fast Test Mode

開發 / usability test 需要：

```text
Developer Fast Mode
```

可把 20 min timer 壓縮成例如 20 sec。

重要：

- Fast Mode 不可存在 production player build
- 不產真實 Life Progress telemetry

---

# 8. First Real-Life Moment

正式測試者第一次看到：

```text
Read 20 minutes
[Start Timer]
[Complete Manually]
```

測試員可真的離開 app。

這是核心產品測試，不應全部用 fake data。

---

# 9. Reward Moment

完成後：

```text
+ Learning XP
+ Cognitive Potential
```

如果 timer：

```text
Timer Verified
+ small bonus
```

動畫控制在：
- 1–2 秒核心 feedback
- 可跳過

---

# 10. Training Moment

回到 Astraea。

NPC / UI 提示：

> 你今天累積的投入可以轉成訓練。

提供：

```text
Function Analysis Drill
Complexity Exercise
```

---

# 11. Attribute Impact

至少讓一個成長結果可被感知。

推薦：

```text
Analysis ↑
```

後續 Ashfang Battle：

- 更早 reveal Weak Node
或
- Analysis Action 成功率更高

測試者必須感覺：

> 剛才 Life Quest 真的影響戰鬥。

---

# 12. Function Theory Interaction

顯示：

```text
Gather
↓
Shape
↓
Move
```

玩家拖拉排序。

完成後：

> Function Graph unlocked.

---

# 13. Chant Tutorial

同一簡單 Spell 展示：

## Full Chant
- 2-step execution
- stable

## Chantless
- 1-step
- Processing / Precision check

不做複雜 failure。

---

# 14. Deck Tutorial

提供 8 張 Spell。

玩家選 6 張。

Prototype Spell Pool：

```text
Arc Bolt
Focused Shot
Energy Burst
Barrier
Deflect
Step Shift
Weak Node Scan
Interrupt Pulse
```

若需要 Support：
可替換一張攻擊卡為 `Mana Stabilize`。

---

# 15. Battle 1 — Arcane Sentry

## Goal
教：
- Turn Order
- Main Action
- Movement
- Attack
- Spell

## Party
Hero only

## Duration
約 3–4 rounds

---

# 16. Battle 2 — Ashfang Training Construct

## Goal
教：
- Party
- Function Graph
- Weak Node
- Reaction
- Interrupt

## Suggested Party
Hero + Rio + Hina

Yuma 可先只作 narrative / tutorial support，降低控制負擔。

---

# 17. Ashfang Function

```text
Detect(Target)
↓
LockTarget
↓
Charge
↓
Pounce
```

Weak Node：

```text
LockTarget
```

---

# 18. Weak Node Aha Moment

流程：

```text
Ashfang begins Function
↓
Rio comments
↓
Graph reveals
↓
LockTarget highlighted
↓
Reaction opens
↓
Player uses Interrupt
↓
Pounce loses valid target
↓
Strong feedback
```

這一段是 prototype 最重要的 combat moment。

---

# 19. Prototype End

Battle 後：

```text
Post-Battle Report
↓
Rio / Professor feedback
↓
“Vertical Slice Complete”
```

接著顯示：

```text
Tomorrow
Your Life Quests will continue.
```

不揭露 Mio。

---

# 20. Prototype Screens

Must：

1. Prologue
2. Academy Gate
3. Dialogue
4. Character Creation
5. Domain Selection
6. Life Quest
7. Timer
8. Quest Complete
9. Home
10. Training
11. Function Tutorial
12. Chant Tutorial
13. Spell Pool
14. Prepared Deck
15. Battle
16. Function Graph
17. Reaction Prompt
18. Post-Battle Report
19. Progress

---

# 21. Prototype Technical Milestones

## P1 — Skeleton
- navigation
- local DB
- content loading
- story scene runner

## P2 — Life Loop
- Life Quest
- timer
- RewardGrant
- Growth Potential
- TrainingConversion

## P3 — Character/Deck
- attributes
- weapon
- spell pool
- Prepared Deck

## P4 — Combat Core
- initiative
- commands
- seeded RNG
- mana
- spell execution

## P5 — Function Combat
- Function Graph
- Weak Node
- interrupt
- reaction

## P6 — End-to-End
- Scene 1–6
- persistence
- analytics events
- UX polish

---

# 22. Prototype Acceptance Tests

## Life

```text
Given Read 20m quest
When complete
Then exactly one RewardGrant exists
```

Retry same completion：
```text
No duplicate reward
```

---

## Training

```text
Given Cognitive Potential
When Function Analysis Training
Then exactly one TrainingConversion exists
And AttributeState projection updates
```

---

## Story

```text
Given revision 10
When transition expects revision 10
Then revision becomes 11
```

Wrong revision：
```text
Rejected
```

---

## Deck

```text
Exactly 6 active slots max
All selected cards available in battle
No random draw
```

---

## Combat

Same:
- initial state
- seed
- commands

must produce same result.

---

## Weak Node

Interrupting `LockTarget` must alter downstream `Pounce`.

不能只是 cosmetic label。

---

# 23. Prototype Telemetry

必要事件：

```text
prototype_started
character_created
life_domain_selected
life_quest_started
life_quest_completed
reward_granted
training_converted
deck_confirmed
battle_started
function_revealed
weak_node_exploited
battle_completed
prototype_completed
```

---

# 24. Qualitative Test Script

測試後問：

1. 你覺得這是一款什麼產品？
2. Life Quest 和遊戲任務有什麼差別？
3. 剛才讀書 / 運動後，角色到底發生了什麼？
4. Training 有沒有必要？
5. 你覺得 Function Graph 是什麼？
6. 為什麼剛才 Ashfang 的 Pounce 失敗？
7. 你會想明天再做一個 Life Quest 嗎？
8. 你會想知道 Astraea 後面的故事嗎？

---

# 25. Must-Pass Comprehension

測試者應能用自己的話說：

```text
Life Level = 投入
Growth Potential = 真實行動轉成 RPG 成長的中介
Training = 選擇角色怎麼長
Function Graph = Spell 如何運作
Weak Node = 可以破壞 Function 的節點
```

---

# 26. Kill Conditions

若多數測試者：

- 覺得 Life Quest 只是 Todo
- 不想回遊戲 Training
- 看不懂 Function Graph
- Weak Node 沒有爽感
- 覺得 Life activity 是遊戲門票
- 不願意第二天再開

則先重構 loop，不繼續擴內容。

---

# 27. Prototype Out of Scope

- Backend account
- Cloud sync
- Health Connect
- Apple Health
- Social
- Guild
- PvP
- Reality Cost
- Institute Zero
- Mio
- Last Spell
- full world map
- advanced crafting
- monetization

---

# 28. Definition of Done

First Playable 完成必須：

- 從 Prologue 到 Battle 2 無 blocker
- Life Quest 可真實完成
- Timer 可背景運作
- Reward 不重複
- Training 確實影響 combat
- Deck 真正控制 battle spell availability
- Function Graph 不是假 UI
- Weak Node 真正改變 enemy Function
- app 重啟不丟 progress
- analytics semantic events 正常產生

---

# 29. What We Build After Success

只有 prototype 通過後才擴：

```text
First real Aberration mission
↓
More Academy exploration
↓
Function Knowledge
↓
Research System
↓
Weekly Recap
↓
Health integration
```

---

# 30. Prototype Thesis

第一個 playable prototype 最重要的不是畫面多漂亮。

而是讓玩家真正經歷：

```text
我在現實做了一件事
↓
角色真的因此改變
↓
這個改變真的影響了一場戰鬥
↓
而且這場戰鬥本身真的好玩
```

只要這條成立，Life RPG × Astraea 才值得進入下一階段。