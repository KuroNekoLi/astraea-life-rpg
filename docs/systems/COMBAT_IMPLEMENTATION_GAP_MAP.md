# Combat Implementation Gap Map

**狀態：** Implementation guidance; does not approve or change combat rules
**依據：** `COMBAT_SYSTEM.md` v1.0、`SPELL_FUNCTION_SYSTEM.md`、現有 Dart combat/function engines 與 Ashfang training encounter
**目的：** 把已核定基礎、現有實作、安全可落地工作與待決規則分開，供戰鬥 core library、JRPG presentation 和測試使用。

> 本文件是規格到實作的對照表，不新增 canon、數值或平衡規則。標為 Proposal 的內容仍不是自動核定；標為 TBD 的項目不能由 UI 或 engine 作者自行補值。

## 0. `feature/combat-jrpg-experience` 實作狀態

本分支交付第一版橫向 JRPG 戰鬥呈現，沿用既有 encounter-authored inputs：

- `packages/astraea_combat` 抽出純 Dart 戰鬥、Function Graph/runtime 與 seeded RNG API；舊 app import paths 保留為相容 exports。
- Flame 只負責不可互動的戰場 stage；Flutter 負責方向、HUD、指令、無障礙語意與存檔。
- Ashfang 畫面呈現 initiative queue、角色狀態、目標確認、Function 檢視／分析／中斷、戰鬥事件、暫停與終局。分析前不顯示下游 Pounce。
- Spell Cards 可檢視但在此 encounter 不可施放；尚無 authored combat-item domain，因此道具入口停用。沒有新增成本、效果或敵方行動政策。
- 場景是原創程序化 placeholder。角色與 Boss 美術、正式動畫素材、音訊、擴編隊伍戰鬥與數值平衡仍待處理。
- 自動化與 pure-Dart package 驗證結果記於交付摘要。此環境的實機測試為 `NOT_RUN`：`adb devices -l` 沒有連線 Android 裝置，且沒有 iOS 裝置／Xcode。方向、觸控、安全區、生命週期與效能尚須依 `COMBAT_DEVICE_TEST_PLAN.md` 驗收。

## 1. Combat core mapping

| 規格機制 | 現有實作 | 安全可落地 | TBD / 不可默改 |
|---|---|---|---|
| 戰鬥流程是 Observe → Understand → Predict → Interfere → Resolve | `FunctionRuntimeEngine` 可分析節點、揭露 Weak Node、取消下游節點；Ashfang 示範流程串接有限 | 以通用 session/command API 串接已存在的 Combat Engine 與 Function Runtime；由事件提供 presentation 動畫依據 | 不為了完整 UI 加入新 combat effect、額外行動或計算公式 |
| BattleState 包含 round、initiative、units、positions、active functions、reactions、deck、mana、combat log | `CombatState` 有 units、initiative order、active combatant、round、outcome、seed/RNG state、event log；`CombatantState` 有 HP、Mana、zone、reactionAvailable、mainActionUsed | 以通用 combatant/party 資料和可序列化的 state/event API 支援多單位；保留 encounter-authored inputs | derived HP/Defense/stat 公式 TBD；狀態效果、戰場效果、完整 party action rules 尚未交付 |
| Turn: status → movement → main → quick → end；順序可彈性安排 | reducer 支援 main action、MoveCommand、EndTurn；單位只有 `mainActionUsed` | 支援規格已有明確語義的主行動、移動、結束回合；命令依 active actor 和狀態驗證 | Status resolution、Quick Action 列表/成本/次序及更完整的行動點消耗尚未定義，不應呈現為已可用規則 |
| Initiative = d20 + Processing modifier；同值 tie-break 為 proposal | `CombatEngine.rollInitiative` 以 seeded RNG 產生 d20 + Processing 與 seed tie；Ashfang adapter 卻硬編碼 player 先行 | session 建立時可接受 authored initiative order；需要擲 initiative 時呼叫既有 seeded API，讓事件明示順序 | tie-break 規格是 Processing、Precision、seeded tie 的 Proposal；不得默認以其他屬性或新的 tie 規則取代 |
| Attack = d20 + bonus vs Defense；nat 1 miss、nat 20 critical/enhanced | `AttackCommand`/`CastSpellCommand` 使用 seeded d20、bonus/defense、nat 1/20 | 將 encounter-provided attack bonus、defense、normal/critical damage 納入命令並輸出命中/骰值/傷害事件 | HP、Defense、derived-stat、damage 公式 TBD；60–75% 是命中率目標，不是公式 |
| Seeded RNG，便於 replay/debug | RNG state 隨 `CombatState` 保存；Engine 可由 state 接續 | 所有帶隨機性的解析集中於純 Dart engine；公開 seed/state 與穩定事件順序以便 replay test | 不將隨機結果搬入 Widget/動畫；seed 不作玩家提示規則 |
| Main Action / Quick Action / Movement / Reaction | 有主行動、移動 command、可選 Guard Reaction damage reduction；沒有通用 Reaction window/round budget，也沒有 Quick Action 狀態 | 提供命令與結果事件；保留只有 encounter/ability 明確定義才能觸發的效果 | Quick Action 定義、Reaction 可觸發條件與每 round 使用限制雖有規格方向，具體通用規則不可自行擴充；Guard reduction 的數值由 encounter 提供 |
| Zone + relative range 是 MVP preference | 單位只有字串 `zone`，MoveCommand 可寫 destination；Ashfang 兩人都在 near | 支援 authored zone/range 值和合法移動檢查（若 encounter 提供合法值/限制）；presentation 顯示相對站位 | 最終 zone/grid/free-position 仍 TBD；不加入格網、移動距離、掩體或命中修正 |
| Mana 是施法成本；容量、輸出、效率、環境同步 | `CastSpellCommand` 可依輸入扣 Mana | 只依 spell/encounter 已提供的 Mana cost 驗證和扣款，輸出可觀察事件 | Mana Capacity/Output/Efficiency/Ambient Sync 公式 TBD；不可新增回魔規則或自行調 Spell cost |
| Prepared Deck 是 6 張已準備卡片，不是抽牌 | CombatState 尚未帶 deck；reducer 有通用 CastSpellCommand | library 可接收 authored/prepared card definitions，列出可用命令；卡片可存取而非抽牌 | spells、cooldown、Complexity、cast method、action cost/條件須由已核准內容定義；cooldown 可為 null，不應創造 draw RNG |

## 2. Function Graph mapping

| 規格機制 | 現有實作 | 安全可落地 | TBD / 不可默改 |
|---|---|---|---|
| Spell/魔法為可執行 Function；Graph node 透過 dependency/edge 組成 | `FunctionGraph`、`FunctionNode`、`FunctionEdge`；`FunctionRuntimeEngine.resolveNext` 檢查 authored edge | 把 Graph 定義、runtime state、Function knowledge 作為 encounter/session domain state；拒絕不存在的 Graph/node/edge | node schema 中可有 visibility、dependency、cost 等欄位，但執行語義/Complexity scale 仍是 proposal/TBD |
| Active Function 有 Prepared/Executing/Waiting/Interrupted/Resolved/Failed/PartiallyResolved/Countered 狀態 | runtime enum 現有 active/resolved/interrupted；adapter 逐步推進 | 為當前已支持的 active/resolved/interrupted 發出狀態事件；UI 消費事件播放相應節點/施法動畫 | 不用 enum 預留項目暗示該效果已可玩；其餘執行/失敗語義需規格與 authored data |
| Graph 可 Transparent / Partial / Hidden | Ashfang 畫面只用文字顯示固定流程；無圖形視圖或 visibility model | UI 可依 authored visibility 呈現已知節點、未知節點與 intent；Analysis 結果更新 knowledge | 沒有 authored visibility 時不可猜測敵人情報，不自動揭露完整 Graph |
| Function Knowledge K0–K4 | `FunctionKnowledge` 目前有 analyzed/revealed Weak Node sets | session state 維護本場已知資料並發事件；同 seed/save 可恢復既有狀態 | K0–K4、跨戰鬥 persistence 與永久知識進度屬 proposal；未獲產品決策前不新增永久升級 |
| Analysis 可以揭露 node、dependency、timing、invertibility、target 等 | Runtime 實際僅對提供的 node、modifier、difficulty、seeded roll 和 Weak Node rules 檢查 reveal | 只執行 encounter/content 已聲明可分析的項目；成功/失敗皆提供清楚事件和已知資訊更新 | Analysis 難度/修正公式與不同分析種類未完整定案；不得新增暗骰 bonus、免費重試或情報 |
| Weak Node 是有效干涉的 Graph node，不是生理弱點 | `FunctionWeakNodeRule` 將 node 映射到下游取消；interrupt 需 revealed、當前 node、interruptible、有效 rule | 將合法性驗證留在 engine；事件指出被中斷節點和明確受到影響的下游節點 | 弱點 outcome 可以 cancel/delay/reduce/retarget 等，但每種都需 authored rule；不得由 UI 決定下游效果 |
| Interrupt 可由 Technique、Reaction、Spell、Movement、環境作用；成功率因素涵蓋 Precision、Processing、Stability、Complexity | 現有 runtime 為條件式 deterministic success/fail，只有已揭露且 active+interruptible+rule 才成功 | 支援 encounter-authored interrupt command/rule；沒有公式時採資料定義成功條件而不虛構擲骰 | Interrupt success formula **TBD**；不能引入成功率、成本、stun 或額外傷害 |
| Counter-Function 要求 knowledge、analysis、timing、compatible counter、Mana/action、可逆性 | 尚無完整 Counter-Function API | 預留由 authored function rule 指定的型別/資料入口，先不啟用未定效果 | Full/Partial/Local Inversion、Sequence Cancel、State Restore 的合法性、成本、判定和效果要逐項核定；Ashfang 取消 Pounce 是已 authored 的 Weak Node rule，不等同通用 Counter |
| Full Chant / Chantless 是不同施法方法 | domain 無施法方法解析或其 timing/cost | spell definition 可存放已核准的 casting method 欄位，若未配置則不改變解析 | 時間、action cost、stability、interruption/error risk 的數值與公式 TBD/Proposal |
| Last Spell、Reality Cost、Magic disability 等 canon | 目前 MVP engine 未涵蓋 | 保留明確 scope boundary，不以一般 spell command 模擬這些系統 | Spell schema、Reality Cost UI、Last Spell flow 與故障狀態需獨立設計；不得暗中納入 MVP |

## 3. Ashfang training encounter boundary

`assets/content/encounters/ashfang_training_v2.json` 的 `contentVersion` 為 `ashfang-training-2`；combat inputs 明確標示 `illustrative-inputs-awaiting-playtest`。這是測試 Function 分析/中斷流程的示範 encounter，不是平衡核准。

目前 authored graph：

```text
DetectTarget → LockTarget → Pounce
                  Weak Node
                  └─ cancels Pounce
```

現有 adapter 的可玩範圍是單一 player 對單一 Ashfang：普通攻擊、結束回合、分析 LockTarget、已知後中斷、Resolve Pounce；畫面/adapter 另外硬編碼兩名角色、初始順序、當前回合流程及字串回饋。這些是目前示範實作，不應被誤認為通用 party 或 battle UI 規則。

安全可用於垂直切片：保留 JSON authored 數值與 Graph；讓 engine 依輸入執行並保存事件；以 presentation 讀取狀態動畫化 DetectTarget/LockTarget/Pounce；顯示 Analysis 揭露的結構依賴；成功 interrupt 時只取消 JSON 設定的 Pounce。不得調整 HP、命中、傷害、Analysis difficulty、seed、免費行動次數或節點影響來改善演出。

## 4. Presentation acceptance criteria

JRPG 視覺呈現可以豐富，但必須表現同一個 domain state，而非建立第二套戰鬥規則。

1. **戰況可讀：** 橫向戰場有敵我單位/動作區、回合與當前行動者、HP/Mana/condition；命令區不遮住主要演出。每項狀態至少有文字/圖示/形狀等非顏色線索。
2. **回合順序可信：** 顯示的 timeline/queue 完全來自 engine 建立的 initiative order；不硬編碼玩家先手，不以 UI 動畫先後改寫順序。
3. **命令有效性可信：** Attack/Cast/Move/EndTurn/Analysis/Interrupt 由 domain 驗證 actor、target、phase、resource 與 Graph/runtime 前置條件；拒絕非法命令時狀態、seed/RNG 和事件記錄保持可預測。
4. **Spell 卡不抽牌：** 若有已提供的 6 張 deck，戰鬥中可檢視所有 prepared cards；只按已 authored 的 Mana/action/condition 等限制啟用。沒有 spell data 時不以 placeholder 數值假裝可用。
5. **Function 可理解：** Ashfang encounter 顯示 `DetectTarget → LockTarget → Pounce` 狀態；Analysis 成功前不標註 Weak Node；成功後解釋 LockTarget 為何影響下游 Pounce，以及有效干涉的時機。
6. **干涉因果明確：** interrupt 結果說明被中斷 node、命中哪些 authored downstream nodes、敵方效果如何變更；若其他 encounter 使用不同 Weak Node outcome，也遵循其 authored rule。
7. **動畫不擁有規則：** 動畫從 combat/function events 觸發；動畫略過、重播、掉幀或螢幕旋轉不能多扣資源、改骰值、再次命令或令錯誤節點完成。
8. **可重播/可還原：** 相同初始 state、seed 和命令序列產生相同 domain state 與事件順序；checkpoint 必須保存足以延續這些結果的 state。

## 5. Deterministic test cases

這些是行為驗收，不是新增數值。應以明確 authored fixture/input 測試，fixture 數值需沿用已核准或已存在的資料。

- 給定相同 encounter state、seed 和 Attack 命令，重播後 active actor、roll/result、HP、outcome 與事件序列一致。
- 自動測試指定骰值或 seeded stream：自然 1 必定未命中；自然 20 使用 encounter 提供的 critical result；一般結果按 attack bonus 對 Defense 判斷。
- 非當前行動者攻擊、攻擊己方/已敗 target、已耗用 Main Action 重複攻擊、Mana 不足施法、非合法 encounter zone 移動及非當前 actor EndTurn 都被 engine 拒絕，且不部分修改 state/RNG。
- CastSpell 只扣內容提供的 Mana cost；命中、未命中、critical 的 damage 僅採命令/content 提供的值。
- 多單位 fixture 中 party members 依同一 authored initiative queue 個別行動；結束一名成員回合依 queue 移至下一名合法 actor；無存活對手時以既有 victory 語義結束。不可在沒有核准規則時假設隊伍每輪共用一回合或各有一回合。
- Analysis 對非 Weak Node 不會誤報 Weak Node；未達 authored difficulty 不揭露；合法成功會記錄知識；相同 seed 和輸入結果穩定。
- Ashfang `LockTarget` 未揭露、非 active node、node 不可中斷、Weak Node rule 不存在或 downstream rule 未匹配時，Interrupt 不成功且不取消 Pounce；揭露且 active 的合法 LockTarget interrupt 成功並只取消 encounter 指定的 Pounce。
- Function `resolveNext` 不接受 Graph 未定義的 edge；遇到已取消的 authored downstream node 依 runtime interruption 語義處理，且不執行被取消的效果。
- Event consumer 收到命令解析事件時，UI 動畫可任意延遲/略過；重放 animation events 不會再次 dispatch domain command。
- battle state 經序列化/恢復後，同 seed/RNG 狀態、active actor、已知 Function nodes 和下一個相同命令結果不變（repository/schema 細節由 persistence implementation 另測）。

## 6. Decision-required list

以下不阻止目前以 authored data 為依據建立通用 API 和 presentation，但在成為通用規則前必須決定：

- 最終 position model（zone / lane / grid / free positioning）及合法移動、距離、掩體/區域目標語義。
- initiative 同值排序 Proposal 是否核准、敗者/無效單位如何跳過、party queue/同隊單位回合語義。
- Quick Action 的明確清單/成本、Reaction trigger/budget/refill timing、Guard 效果值。
- HP/Defense/derived stats、damage、Mana formulas 與 recovery、Spell cost/cooldown、turn/round status timing。
- Analysis/Interrupt/Counter 判定公式、知識是否跨戰鬥保留及其 K0–K4 progression。
- Function node Complexity/Stability、Full Chant/Chantless 時間與成本、Counter-Function 各型態之授權條件和結果。
- Party synergy、同一 round 多個 Active Functions、異常/狀態效果、battle reward 及 Last Spell/Reality Cost scope。

上述 decision 完成前，通用 core 必須由 encounter-authored order/input/rules 驅動，並以 `DECISION_REQUIRED` 標示缺失的必要資料；不能以方便 UI 的方式默默提供預設戰鬥規則。
