# Astraea Combat UX Flow v1

**狀態：** UX Proposal（依據目前 Canon 與 Working Specification 整理；不新增世界觀 canon）  
**相關文件：** [`WORLD_BIBLE.md`](../world/WORLD_BIBLE.md)、[`SPELL_FUNCTION_SYSTEM.md`](SPELL_FUNCTION_SYSTEM.md)、[`COMBAT_SYSTEM.md`](COMBAT_SYSTEM.md)、[`CHARACTER_PROGRESSION_SYSTEM.md`](CHARACTER_PROGRESSION_SYSTEM.md)

## 1. 目的與設計原則

本文件描述玩家進入一場 Astraea 回合制戰鬥後，從讀取戰場、選擇行動、執行 Spell Card（SC）到理解結果的完整 UX flow。場景例子是三人小隊對上學院的 **Ashfang Training Construct**；具體敵方數值、角色能力、回合順序與技能效果以遊戲內容資料為準，本文件不定義平衡數值。

### 核心原則

1. **易懂 JRPG 作為表層，Function 作為深層。** 新手先能讀懂誰要行動、敵人要做什麼、有哪些指令。進階玩家才逐步使用 Chant、Analysis、Function Graph、Weak Node 與 Counter-Function。
2. **Analysis 不是固定開場稅。** 已知標準 Spell 直接顯示辨識結果；只有未知、改造、複合或需要確認 runtime parameters 的術式，才引導玩家使用 Analysis。
3. **玩家做戰術選擇，不做公式輸入。** 內部 Function Graph 可以有參數與節點；玩家看到的是清楚的結果預覽與有限戰術選項，例如 High / Focused / Wide。
4. **回饋要說明因果。** 命中、失敗、Interrupt、抵抗與資源變化都應短暫說明原因，讓玩家知道自己的判斷造成什麼結果。
5. **可見資訊按需揭露。** 第一戰不一次展示完整 Graph；可預測的已知資訊直接呈現，複雜分析結果在需要時才展開。
6. **SC 是已準備好的 Function template。** SC drawer 是術式的戰鬥快捷選單，不是抽卡或隨機手牌。

### Canon 與 UX 提案的界線

本文件引用的魔法本質、Signature/Tier、Prepared SC、Full Chant/Chantless、Analysis、Weak Node、Interrupt/Reverse Operation 與 Last Spell 定義，以相關系統文件標記為準。畫面佈局、提示文字、步驟次序、教學節奏與示例中的 High/Focused/Wide 為 UX 提案；它們不會自動成為世界觀 canon 或最終戰鬥規則。

## 2. 代表教學戰

### 隊伍與對手

- **隊伍：** 主角、Yuma、Rio（三人隊伍範例；實際可用角色依劇情配置）。
- **敵人：** Ashfang Training Construct，學院用練習構裝體。
- **玩家已準備：** 至少一張 Fireball I；後續流程用到的 Fireball II 也必須已在當場可用的 Prepared Deck 中，否則應在戰前準備介面處理。MVP Prepared Deck 上限為六張，見角色成長與戰鬥文件。
- **示例假設：** Rio 可使用 Analysis 與 Interrupt；隊友可採取保護 Full Chant 施法者的行動。這些具體角色配招是腳本假設，不宣稱為角色 canon。

### 進戰前到戰鬥結束

```text
Encounter intro
→ 顯示敵人與練習目標
→ Battle HUD 出現，標示目前回合與行動順序
→ 教學提示聚焦於當下可用的一個概念
→ 玩家選行動、確認目標與施法模式
→ 敵方 Intent / Casting State 更新
→ 敵我行動解析，回饋結果及狀態變化
→ 進入下一個行動或回合
→ 勝利摘要：使用的行動、關鍵戰術與資源狀況
```

不應在進戰鬥時先要求玩家對敵人使用 Analysis；若敵人開始已知標準 Fireball，HUD 即可標示名稱與已知基本應對。

## 3. Battle HUD：版面與資訊層級

### 建議的窄螢幕優先配置

```text
┌──────────────────────────────────┐
│ ROUND 2       行動順序            │
│ 主角 → Ashfang → Rio → Yuma       │
│                  └─ Fireball 完成 │
├──────────────────────────────────┤
│                                  │
│       ASHFANG TRAINING            │
│          CONSTRUCT                │
│       HP ███████░░                │
│                                  │
│ Intent  Fireball I · 已知術式     │
│ Casting Full Chant · 進度 2/3     │
│ Target  主角 · 約 1 次友方行動後  │
│                                  │
│        [Battlefield / Units]      │
├──────────────────────────────────┤
│ 主角       Yuma        Rio        │
│ HP 142/160  HP …       HP …       │
│ MP 72/100   MP …       MP …       │
│ Reaction ●  ●          ●          │
├──────────────────────────────────┤
│ 主角的回合 · Main Action          │
│ Attack  Technique  SC             │
│ Analyze  Guard      Move           │
│ Quick Action: 可用／已使用         │
└──────────────────────────────────┘
```

桌面版可將隊伍狀態放在側欄、行動選單放在底部；資訊的優先順序一致。

### 資訊層級

| 優先 | 資訊 | 呈現原則 |
|---|---|---|
| 1 | 當前操作角色、回合、Turn Order | 持續可見；敵方施法完成或重大狀態也列入時間軸。使用 icon、名稱與先後位置，不只依賴顏色。 |
| 2 | Enemy Intent、目標、Casting State | 敵方即將行動時保持醒目；明確區分「正在詠唱」與「Spell 已 active」。顯示剩餘階段／事件，不用模糊倒數。 |
| 3 | 角色 HP、Mana、Reaction | 隊員卡片上就近呈現數值與可用狀態；資源不足時，在對應行動預覽中說明。 |
| 4 | Main Action、Quick Action、Movement | 顯示可用指令及不可用原因；已消耗的行動不再看起來可按。 |
| 5 | Graph、Weak Node、詳細參數 | 僅在 Analysis 或玩家主動展開時出現；預設摘要只保留決策所需資訊。 |

### Turn Order 與施法事件

- 顯示友方及敵方的行動順序；重要的 Casting completion / Spell resolution 作為時間軸事件呈現。
- 施法事件要能與 caster 及目標對應；玩家應看出「哪個事件會在誰的行動後發生」。
- 若順序可能因速度、Interrupt 或狀態改變，變更時更新時間軸並提供短提示。
- 不以不確定的「幾秒後」描述回合制事件；採用「下一個行動後」「還有一個施法階段」等與實際解析一致的單位。

### Enemy Intent 與 Casting State

狀態至少分辨：

1. **Preparing / Chanting：** Spell 尚未完成，Interrupt window 開啟；顯示已辨識名稱或「Unknown Spell」，以及可確認的目標／範圍資訊。
2. **Active / Resolved：** Spell 已成立或正在作用；不再把 Interrupt 當作可用解法，轉而提示 Dodge、Guard、Counter 或 Reverse Operation（僅在角色有可用能力且條件符合時）。
3. **Interrupted：** 顯示施法被中止、原因及敵方後續狀態；若僅打斷部分 Function，應明確說明效果而不假定整招消失。

## 4. 可選行動與 Action 類別

指令名稱可以保留簡潔 JRPG 用語，進階規則在選擇或預覽時解釋。

| 行動 | UX 說明 |
|---|---|
| **Attack** | 選擇武器攻擊與目標；快速顯示命中／傷害預覽及可能觸發的敵方狀態。 |
| **Technique** | 顯示角色已學會的戰技，說明效果、目標、代價及行動類別。 |
| **SC** | 開啟 Prepared SC drawer，再選術式、施法模式、該 Tier 可控參數與目標。 |
| **Analyze** | 對未知或改造中的 Function 取得可用情報；已知 Spell 仍能被分析，但 UI 不把它當成辨識名稱的必要步驟。 |
| **Guard** | 顯示防禦對象、預期保護效果及涵蓋時段；若敵人已鎖定別的單位，提示保護是否有效。 |
| **Move** | 以簡化戰場位置／可達格表示移動，顯示移動後可能避開的目標線或可接近的互動區。 |

### Main Action、Quick Action、Movement

- 將 **Main Action** 作為主要指令入口；角色卡或選單上清楚標出主行動是否已花費。
- **Quick Action** 以獨立的次要區域或 action point 顯示，不要和 Main Action 混成兩個同等主要按鈕。只有符合規則的技能才標為 Quick Action。
- **Movement** 顯示可移動範圍、終點與位置效果；依戰鬥規則可與 Main / Quick Action 交換順序時，UI 不應暗示移動必須先或必須後。
- 預覽行動時同步顯示本回合尚可做什麼；若某選擇會消耗 Quick Action 或限制移動，在確認前說明。

### Reaction

- Reaction 是回合外、由觸發事件帶出的反應選擇，不放進一般 Main Action 按鈕列。
- 角色卡顯示 Reaction 可用／已使用（例如空心圓／實心圓或文字標籤）。
- 發生可反應事件時，將觸發事件、可用選項、費用與決策期限放進清楚的反應提示；Interrupt 若以 Reaction 執行，應在此處出現。
- 不讓玩家因為未盯著角色卡而錯過反應；提供視覺聚焦及可存取的文字提示。具體是否暫停解析、反應窗口長度為 TBD。

## 5. SC 使用流程

### 標準 flow

```text
SC 指令
→ Prepared SC drawer
→ 選擇 SC / Tier
→ 選擇 Full Chant 或 Chantless
→ 顯示該 Tier 可控制的 parameters
→ 選擇 Target / Area
→ 確認執行
→ 顯示 Mana、預估效果、耗時／Interrupt window 與可見風險
→ 執行並更新 Casting State / Turn Order
```

### 每一步的資訊

1. **Prepared SC drawer：** 只列出本場已 Prepared 的 SC；每列含名稱、Tier、簡短用途、Mana 狀態與可用性。已學會但未準備的 Spell 不應看起來可直接施放；可用提示說明「戰前可加入 Prepared Deck」。
2. **選 SC：** 同一 Spell Family 可展開不同 Tier。比較時突出控制差異與資源差異，不把 Tier 做成純傷害排行。
3. **Full Chant / Chantless：** 只顯示該角色、該 SC Tier 當下可用的模式。Full Chant 預覽一般較穩定／完整、施法時間較長且有 Interrupt window；Chantless 速度較快、由施術者承擔更多運算負擔，可能犧牲穩定度、Efficiency、Precision 或輸出。避免固定倍率承諾，除非內容資料明確提供。
4. **Parameters：** 僅呈現該 Tier 開放控制的項目；其他參數以模板／預設摘要呈現。以語意選項及滑桿呈現允許範圍，不暴露需要玩家輸入的函數值。
5. **Target：** 使用戰場直接點選、目標列或範圍預覽。清楚顯示施法對象與可能波及的隊友／場景。
6. **Confirm：** 一次檢視模式、主要選項、目標、Mana、預計解析時點與可能的 Interrupt window。確認後才提交行動；可返回前一步調整。

### 例：Fireball I

Fireball I drawer item 可顯示：

```text
Fireball I · Elemental
範圍攻擊 · 本 Tier 可控：Target、Basic Power
其餘由標準模板提供
```

玩家選 High / Focused / Wide 等高階戰術描述時，UI 將其映射到合法的 runtime parameter 範圍，並預覽取捨（例如集中威力或擴大範圍）；確切選項是否屬於 Fireball I 或更高 Tier，由 SC 內容定義。這些名稱是示例，不是固定 Signature 或平衡規則。

## 6. Spell Family 與 Tier 的呈現

- **同一 Spell Family 共享完整 Signature。** Tier 是同一 Signature 開放不同程度的控制權，不是不同魔法，也不是抽卡稀有度。
- **每 Tier 只開放部分 parameters。** 高 Tier 可讓玩家覆寫更多控制項；低 Tier 的其他設定由已構築模板提供。
- **低 Tier 與高 Tier 可共存。** 角色升級取得更高 Tier 後，不應讓舊 Tier 在 UX 上自動消失。低 Tier 可代表較低 Mana、較低 Complexity、較快使用或更易 Chantless；具體是否各項成立需由內容資料和平衡驗證。
- **成本需多維展示。** 高 Tier 通常有更高 Mana、Complexity 與 Chantless burden；不要只用星級／顏色表示強弱。
- **展示角色適配。** Chantless 可用性依角色能力、術式 Tier 與 Family 複雜度，不是同一 Tier 對所有角色一刀切。若 Chantless 鎖定，清楚指出所需能力或目前限制；不要讓玩家在選擇後才發現不能施放。
- **不得讓 UI 假定跨 Spell Family 的 Tier 等級可直接比較。** 例如 Fireball III 不必然等於另一個 Family 的 Tier III。

## 7. Known Spell 與 Unknown / Modified Spell

### 已知標準 Signature

```text
敵方開始標準 Fireball I
→ HUD 辨識「Fireball I · Known Signature」
→ 顯示已知的基本意圖、施法狀態與可用應對
→ 玩家可直接選擇 Interrupt / Guard / Dodge / 已知 Counter 等合適行動
```

Signature 可辨識不代表本次 runtime parameters 全知。若目標、範圍、強度或穩定度仍未知，UI 可標示「目標已知、輸出未確認」等部分情報，避免把基本辨識誤示為完全分析。

### 未知、改造或複合術式

```text
敵方開始 Unknown / Modified Function
→ HUD 顯示 Unknown / Modified Spell，保留已觀察到的目標與施法階段
→ 選 Analyze
→ 顯示 Analysis progress / 本次取得的情報
→ 摘要 Graph 結構、危險條件及可供決策的候選點
→ 玩家依情報選 Interrupt、移動、Guard、Counter 或 Reverse 路線
```

Analysis 結果可包括完整度不同的 Signature、Function Graph 片段、runtime parameter 線索、possible Weak Node、可逆性或 Counter path；**不保證每次都出現 Weak Node**。若分析未能給出答案，應指出尚未確認什麼，而不是假裝玩家操作失敗。

## 8. Interrupt 與 Reverse Operation 的時間界線

```text
Casting / Function construction 尚未完成
→ Interrupt：打斷 caster 或 casting process

Spell 已完成並 active / 正在 resolve
→ Dodge / Guard / Counter / Reverse Operation：處理已成立的 Function
```

- 對尚在詠唱的標準 Fireball，學生通常可直接利用已知知識與可見窗口嘗試 Interrupt；不需先 Analysis。
- Full Chant 的外部 encoding 通常給出較明確的 Interrupt window；Chantless 也不是不可干擾，只是沒有相同的傳統 Chant 中斷線索，實際可干涉點依術式與戰鬥規則。
- Spell 已 active 後，不應仍顯示「Interrupt 可取消本次施法」的誤導按鈕。可以在資訊面板保留該術式 caster 或後續 Function 的影響，但要區分中止施法與處理既成效果。
- Reverse Operation 需要相應情報、能力與可行條件；沒有可用反運算時，UI 應突出可行的 Guard / Dodge / Counter，而非顯示灰色神秘選項。

## 9. Scripted Tutorial：逐回合示例

以下是教學腳本草案；確切 initiative、行動成本、數值與成功率屬 TBD。行動先後需按真實 Turn Order 解析，不應為了劇本暗中改變規則。若 Rio 在敵方完成詠唱前沒有自然行動，Interrupt 應以可用 Reaction 或合法時機呈現，不能把主行動與 Reaction 規則混為一談。

### Round 1：Chantless、Full Chant 與 Interrupt

1. 回合 HUD 顯示小隊與 Ashfang 的行動順序；教學只提示「觀察敵人的施法徵兆」。
2. 玩家選主角 **SC → Fireball I → Chantless**，選擇目標、確認後施放。短提示指出 Chantless 把更多運算負擔交由施術者承擔，以速度換取反應性；此處不要求玩家理解公式。
3. Ashfang 開始 **Full Chant Fireball I**。Intent 顯示已知標準 Signature、目標、Casting progress，以及預計完成事件；標示 Interrupt window。
4. 若 Rio 有合法行動／Reaction，玩家選 **Interrupt**。成功時敵方 Fireball 未完成並顯示中止結果；若未成功或玩家放棄，則按既有規則繼續詠唱，教學仍解釋接下來可用的防禦選項。
5. 回合結束摘要對照兩種施法模式及 Interrupt 的結果，不宣稱 Chantless 永遠威力較低或 Interrupt 必然成功。

### Round 2：未知／改造術式與 Analysis

1. Ashfang 開始一個 **Unknown / Modified Fireball**；HUD 不直接把它當普通 Fireball 的完整情報，只標示觀察到的基礎輪廓、目標與 casting 狀態。
2. Rio 選 **Analyze**。用短暫聚焦動畫呈現結構被讀取，避免把分析表演成長時間獨立小遊戲。
3. Analysis panel 顯示該次情報：簡化 Function Graph、已知與未知部分，並可標一個 **Potential Weak Node**（「候選」而非保證弱點）。此結果是本教學腳本指定的示例，不表示每種 Analysis 都能得到 Weak Node。
4. 玩家讀取情報後，由 Yuma／主角選擇相符的解法：Interrupt 若仍在詠唱期且解法針對施法過程；或依候選節點移動、Guard、使用 Counter。UI 說明這次行動對 Graph 的作用。
5. 若玩家選擇不同解法，讓戰鬥仍能繼續；教學目標是展示「情報改善決策」，不把唯一答案設成硬鎖，除非 Encounter 另有明確劇情需求。

### Round 3：Full Chant Fireball II 與隊友保護

1. 玩家選 **Fireball II → Full Chant**。選擇畫面顯示比 Fireball I 更多可控 parameters、較高成本／Complexity，以及預計較長的完成時間（數值由內容定義）。
2. 確認後時間軸加入主角的 Casting completion；HUD 顯示施法者目前受威脅及 Interrupt window。
3. 隊友以 Guard、位移、控制或其他合法支援行動保護施法者；支援行動的具體效果依角色配招設定。若隊友無法直接阻止所有中斷，HUD 不應保證 Full Chant 一定完成。
4. Spell 完成時，回饋 Full Chant 提供的穩定／完整編碼優勢與實際效果；避免將其畫成無風險的「蓄力 buff」。

### Round 4：Fireball I 補刀，展示低 Tier 價值

1. Ashfang 剩餘 HP 進入可由低 Tier 處理的範圍（實際數值由 encounter tuning 決定）。
2. 玩家使用 **Fireball I** 完成戰鬥。選單仍保留 Fireball II 作為另一選擇，讓玩家看到低 Tier 並未因高 Tier 解鎖而消失。
3. 勝利摘要指出：I 適合低成本、快速處理；II 提供更多控制權與較高負擔。這是該次遭遇的使用情境，不把兩者固定成普遍傷害定律。

## 10. Function Graph 與 Analysis UI

### Progressive disclosure

- 預設戰鬥 HUD 顯示「結果與決策」層，不常駐完整 Graph。
- 使用 Analysis 或主動展開後，先顯示 Graph 摘要／關鍵路徑；可點節點查看已知效果、依賴與可信度。
- 用線型、標籤及文字輔助表示已知、推測與未知；色彩不能是唯一區分方式。
- 潛在 Weak Node 使用「候選／可能」標記，並指出信心或尚缺資訊（具體信心模型 TBD）。
- 只有當節點與行動決策相關時才突出；完整 Graph 可作為可選深度資訊，不阻塞一般戰鬥節奏。

### 不要求手動輸入函數參數

玩家不應被要求填寫 `power=...`、`radius=...` 等任意數值才能施法或破解 Graph。UI 以語意化選項表達玩家可控制的範圍，例如：

| 戰術標籤（示例） | 玩家理解的取捨 |
|---|---|
| **High** | 集中於較高輸出或更強作用；可能提高成本／負擔。 |
| **Focused** | 集中目標或縮小作用區；降低波及風險。 |
| **Wide** | 擴大涵蓋範圍；可能稀釋單點效果或增加代價。 |

標籤與實際參數映射由每個 SC Tier 的內容定義。無關、未開放或不影響玩家決策的參數留在模板內部。

## 11. 第一場戰鬥的教學範圍

### 第一戰必教

1. SC 是從 Prepared SC 使用已構築的 Spell，不是抽卡；玩家如何打開並施放一張 SC。
2. **Full Chant vs Chantless：** 速度、運算負擔、穩定／輸出取捨與中斷暴露差異；用結果示範，不塞公式。
3. **Enemy Chant → Interrupt：** 認出已知 Fireball，讀取 Casting State，在完成前選擇中斷。
4. **Unknown Spell → Analysis：** 未知或改造術式才需要用 Analysis 將資訊轉為戰術選項。

### 第一戰延後或不教

- **Weak Node：** 放在教學戰後半段（Round 2）或後續遭遇；先讓玩家懂得「分析未知」，再介紹 Weak Node 是可能結果之一。若 Round 2 密度過高，將 Weak Node 延至第二場戰鬥。
- **Last Spell：** 不進第一戰教學。其角色專屬、使用後本場戰鬥無法再行動的代價，需要獨立教學時機與明確確認 UI。
- **高階 Counter / Reverse Operation：** 不要求新手第一戰理解 Graph 反運算；先讓玩家學會防禦與一般 Interrupt，再逐步引入。
- **時間／因果大魔法：** 不進第一戰，避免引入尚未建立的高階規則、長期代價與後期劇情資訊。

教學提示應可重看、可略過，且在玩家第一次遇到該狀態時才出現；不要在每次施放重複阻塞操作。

## 12. UX Acceptance Criteria

以下為可觀察的 UX 驗收目標，具體量化門檻需 playtest 後設定：

- 玩家能在不打開次級頁面的情況下找到當前角色、敵方 Intent、Casting State 與行動順序。
- 標準 Fireball 被辨識時，玩家不會被迫 Analysis 才能看到名稱或嘗試一般應對。
- 玩家能在施法前分辨 Full Chant 與 Chantless 的主要取捨及預計完成時點。
- 玩家能從 drawer 看出 SC 必須已 Prepared，且不同 Tier 是同 Family 的不同控制權配置。
- 確認前能看到目標、範圍、資源成本與重要中斷風險；誤選不會因資訊被藏起而不可逆。
- 玩家能分辨「Casting 中可 Interrupt」與「已 active 要防禦／反制」，不會把兩者視為同一按鈕的不同名稱。
- Analysis 至少回報可採取行動的情報或明確的不確定性，不保證 Weak Node，也不因沒出現 Weak Node 而顯示為失敗。
- Function Graph 詳細層可用但不強制；玩家不需手動輸入函數數值才能完成戰鬥。
- Reaction 是否可用、Quick Action 是否已花費、Mana 是否不足，都有文字或非顏色提示。
- 第一戰核心教學能在不引入 Last Spell、複雜 Reverse Operation 或時間／因果大魔法的情況下完成。
- 回合結算與戰鬥摘要能解釋玩家決策如何改變結果，不把結果歸因於不可理解的隱藏規則。

## 13. Failure Modes 與防護

| 失敗模式 | UX 防護 |
|---|---|
| 每場戰鬥先 Analyze 才能玩 | Known Signature 直接辨識；Analysis 按未知程度與決策需求出現。 |
| Intent 顯示了名稱，卻未說明施法進度 | 分開呈現 Intent 與 Casting State，並把完成事件放進時間軸。 |
| 玩家以為 Interrupt 可取消已 active 的 Spell | 狀態轉換時更換可用應對標籤，明示 Interrupt window 已關閉。 |
| Drawer 看起來像抽卡或隨機手牌 | 固定列出戰前 Prepared Deck；不使用抽牌、洗牌或稀有度隱喻。 |
| Tier 被誤解為純傷害排行 | 同時呈現可控 parameters、Mana、Complexity、Chantless eligibility 與施法時間。 |
| 高 Tier 取代低 Tier，低 Tier 成為無用舊技能 | 允許低、高 Tier 共存；展示低 Tier 的成本／速度／易用場景，實際平衡以 playtest 驗證。 |
| Graph 過度複雜、遮住戰場 | Progressive disclosure；先摘要，再由玩家主動展開細節。 |
| Analysis 保證吐出 Weak Node | 以「可能／候選」顯示；讓其他情報仍能支援決策。 |
| 數值參數輸入破壞節奏 | 以受限、可理解的戰術選項取代任意函數值輸入。 |
| Reaction 事件閃過或被忽略 | 事件聚焦、清楚期限與文字提示；暫停／自動解析策略仍待定。 |
| 教學戰腳本為了劇情違反行動規則 | 腳本遵守 Initiative、Action 與 Reaction 規則；若無合法 Interrupt 時機，改用 encounter 佈局而非暗改規則。 |

## 14. 外部參考方向（非 Canon）

以下僅用來討論可讀性與互動節奏；Astraea 不應照搬其規則、美術或進度系統：

- **Octopath Traveler：** 可參考行動順序與弱點資訊的快速可讀性；Astraea 的 Function / Analysis 是自有系統，不等同其 Break 機制。
- **Honkai: Star Rail：** 可參考少量主要輸入與清楚 action order 的注意力配置；Astraea 的行動解析與施法事件應依自身規則設計。
- **Persona 5：** 可參考快速 command access 與降低選單操作負擔；不代表採用其戰鬥流程。
- **Sea of Stars：** 可參考敵方蓄力期間給玩家明確反應窗口的可讀性；Astraea 使用 Signature、Casting State 與 Interrupt 時機，不複製 Locks 機制。

這些作品是 UX 討論的參照，不構成 Astraea canon、規則來源或機制承諾。

## 15. Open Questions / TBD

1. 戰鬥的最終視角與裝置適配：窄螢幕直向、橫向或依平台切換？
2. Turn Order 的預測精度：Reaction、Interrupt、速度變化後如何即時重排？Cast completion 在 initiative 中的解析單位為何？
3. Reaction 觸發時是否暫停戰鬥、提供限時選擇，或採其他非即時制流程？錯過反應時的預設行為？
4. SC drawer 的實際欄位、比較方式、Prepared Deck 數量與戰鬥中切換限制如何呈現？MVP deck limit 六張見相關系統文件。
5. 每個 Spell Tier 的參數清單、High/Focused/Wide 等選項及對應預覽由何種內容 schema 驅動？
6. Full Chant 的完成事件、分段時間、被 Interrupt 後的部分效果與 Mana 退還規則？
7. Chantless 的穩定度／輸出／Efficiency 預覽需要多精確，才不會暗示不存在的固定倍率？
8. Analysis 的時間成本、成功／部分情報模型、Graph 可信度標示與可重複分析限制？
9. Weak Node 候選資訊的 confidence 呈現，以及分析資訊如何因敵人改造而過期？
10. Guard、Dodge、Counter 與 Reverse Operation 的共用預覽和錯誤風險說明如何統一？
11. 教學提示、無障礙標籤、色弱支援、字級與觸控目標的驗收門檻？
12. 玩家是否需要在戰後查看完整 Combat Log / Function Graph 重播？
13. Ashfang 教學戰的確切角色、配招、輪序、HP、Mana、敵人階段與勝負條件由哪份 Encounter 文件維護？

## 16. Source of Truth

- `docs/world/WORLD_BIBLE.md`：魔法、Signature、媒介、SC、Prepared Deck、Analysis 與 Interrupt / Reverse Operation 的世界觀 canon。
- `docs/systems/SPELL_FUNCTION_SYSTEM.md`：Function Graph、Spell Family/Tier、Prepared Deck、Chant 模式、Analysis、Weak Node 與 Interrupt 規格。
- `docs/systems/COMBAT_SYSTEM.md`：Action、Turn、Reaction、敵意圖、施法狀態、Interrupt 與 Counter/Reverse 的戰鬥規格。
- `docs/systems/CHARACTER_PROGRESSION_SYSTEM.md`：角色屬性如何支援 Initiative、Chantless、Reaction、Precision 與 Analysis。

若本 UX 文件和上述 canon／系統規格有衝突，以來源文件為準，並回頭更新本文件的 UX 推導；數值與規則尚未定案時維持 TBD。
