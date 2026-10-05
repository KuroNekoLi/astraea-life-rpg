# Astraea Academy — 劇情結構

本文件整理目前已確立的主線順序、Scene 1～6 vertical slice、第一部中後段主線與劇情揭露邊界。

## 1. 故事基調

這是一個關於「魔法能否保護人」的學院成長故事。

前期採用官方／公共世界觀：

- 魔法是文明的保護力量。
- 異形是城市外的公開威脅。
- Astraea 是培育保護者的學院。
- 主角因童年救援事件而進入這條道路。

後期逐步重新解釋魔法、異形、世界代價與 The Fading 之間的關係。

第一部的核心戲劇曲線：

```text
學會使用魔法
    ↓
相信魔法能保護人
    ↓
魔法失能事件
    ↓
調查「為什麼人開始無法施法」
    ↓
接觸 Institute Zero 與隱藏真相
    ↓
發現 Mio
    ↓
得知她正在主動切斷人類與魔法系統的連結
    ↓
Final Battle — Mio
```

## 2. 序幕 Prologue

序幕不是一般 NPC 對話，而是 cinematic narration。

順序：

1. Astraea motto card
2. 魔法從少數人的奇蹟變成文明基礎
3. 城市基礎設施與公共魔法
4. 異形仍在城市外威脅人類
5. 魔法使用者成為文明保護者
6. 主角童年救援 flashback
7. 橘教授說：「別怕。」、「待在我身後。」
8. 主角形成信念：「魔法可以保護人。」
9. Astraea title card
10. 轉入現在的 Academy Gate

序幕不可出現：

- The Fading 真相
- order debt
- Reality Cost
- Local Entropy
- Institute Zero
- Mio 真正身分
- 魔法與 Aberration 的真正因果
- 學院內部隱藏真相

## 3. Scene 1 — Astraea Academy 入學

### 開場

進入 Academy Gate 後先播放：

### Narration

```text
「星環中央魔導學院。」

「集魔法教育、研究與異形應對人才培育於一身，
世界上最重要的魔導學府之一。」
```

### Inner Monologue

```text
「……終於。」
「真的考上了。」
「從那一天開始，我就一直想來這裡。」
「總有一天……」
「我也想成為能夠用魔法保護別人的人。」
「先去報到吧。」
```

### 交還控制

- 關閉 presentation layer。
- 鏡頭回到 Hero。
- 顯示目標：`新生報到　·　前往學院正門與佐伯悠真交談`。
- 玩家取得移動控制。

### Yuma 互動

流程固定為：

```text
接近 Yuma
→ 顯示 E 互動提示
→ 玩家按 E
→ Hero 與 Yuma 面向彼此
→ 鏡頭短暫 focus
→ Character Dialogue layer 出現
```

第一段：

```text
佐伯悠真
「喂。」

「你走那麼快幹嘛？」
```

選項：

```text
〉怕遲到。
  我只是想早點看看學院。
  你自己走太慢。
```

第二段會回到主角童年與入學動機，並保存選擇供未來對話使用。

## 4. Scene 2 — 新生適性測試與角色建立

Scene 2 才開始：

- 玩家命名
- 32 點能力分配
- Recommended Builds
- Build Tendency
- 初始武器選擇
- 八項 Aptitude Roll
- Exceptional Roll
- Fate Reroll
- 最終能力檔案
- Rio／Hina 正式介紹

武器選項：

1. Astraea Longsword：1d8，Balanced
2. Standard Spear：1d10，Reach
3. Training Arcane Gun：1d8，Range 15m
4. Standard Staff：1d6，Spell Focus；每場第一次 Full-Chant Spell 獲得 Complexity benefit

## 5. Scene 3 — 第一堂基礎術式理論

教授核心教學：

```text
「很多人第一次學魔法時，會把它理解成一種願望。」
「這個理解很浪漫。」
「也完全不夠用。」
「魔法不是願望。」
「魔法是把世界從狀態 A，轉換成狀態 B 的方法。」
```

Scene 3 應建立：

- `f(S0) = S1` 的直觀概念；
- Spell 可以拆成 Function Graph；
- 人類需要透過媒介把意圖整理成可被執行的 request；
- 暫時不回答「到底是什麼系統在回應 request」。

不得在此揭露 Reality Cost。

## 6. Scene 4 — Full Chant vs Chantless

內容：

- 比較 Full Chant 與 Chantless
- 說明詠唱如何承擔部分 computation / encoding
- 說明 Chantless 不是沒有計算
- Hina 展示高輸出 Chantless
- Rio 進行理性分析

核心概念：

```text
她沒有省略施法所需的處理。
她只是把本來由詠唱完成的計算與 request encoding，搬進自己的腦子裡。
```

玩家此時應理解：

```text
Full Chant:
Human → Chant → Magic System

Chantless:
Human → Mental Encoding → Magic System
```

但「Magic System」可以用學院基礎理論的抽象名稱描述，不揭露最終本體。

## 7. Scene 5 — Spell Card / Prepared Deck Tutorial

內容：

- Spell = 可執行的 Function / Function Graph
- Spell Card = Function 的具現化
- Spell Card 可以保存、載入並重複提交一個已構築完成的術式 request structure
- 戰鬥不會給施法者無限構築時間
- 因此需要預先準備術式
- 玩家建立 Prepared Deck
- Scene 5 Deck 上限固定為 6 張

必須避免讓玩家誤解 Spell Card 是單純收藏卡：

```text
Function Graph
→ Construct / Encode
→ Spell Card
→ Prepared Deck
→ Cast
```

## 8. Scene 6 — Training Battle

敵人：

- Arcane Sentry Mk-I
- Ashfang Training Construct

戰鬥 subset：

- Main Action
- Quick Action
- Movement
- Reaction
- Initiative：d20 + Processing modifier
- Attack：d20 + attack bonus vs defense
- Nat 1：automatic miss
- Nat 20：critical／enhanced success
- Seeded RNG
- Weak Node 分析
- Technique 與 Spell attack

戰鬥設計目標：

- 通常不超過 8 rounds
- 新手命中率大致 60～75%
- 不用 letter grade 評價玩家
- 以行為統計呈現結果

戰後統計：

- Magic Casts
- Techniques Used
- Weak Nodes Exploited
- Damage Prevented
- Mana Remaining
- Damage Taken
- Critical Hits

教授依照行為給出不同評語，不把任何一種玩法標記為絕對正確：

```text
防禦／支援型：你還是會先看別人。
分析型：你開始學會先理解，再行動了。
攻擊型：出手比以前果斷多了。
```

## 9. Vertical Slice 結束點

玩家完成：

1. 開始新遊戲
2. 抵達 Astraea
3. 與 Yuma 對話
4. 完成角色建立
5. 認識 Rio 與 Hina
6. 上基礎術式理論課
7. 理解 Function Graph
8. 完成 Full Chant／Chantless 教學
9. 理解 Spell Card 是 Function 的具現化
10. 建立六張牌的 Prepared Deck
11. 完成 Training Battle
12. 擊敗 Arcane Sentry Mk-I
13. 擊敗 Ashfang Training Construct
14. 完成戰後教授對話

Vertical Slice 結束時，玩家應更相信「魔法是一套可以被理解、訓練、最佳化並用來保護人的技術」。這會成為第一部中後段反轉的情緒基礎。

## 10. 第一部中段 — 魔法失能事件

### 10.1 起始症狀

事件應先以「個人施法故障」的形式出現，而不是直接宣布世界危機。

可能流程：

```text
少數學生 Spell Card activation failed
↓
改用其他 Spell Card 仍失敗
↓
Full Chant 也無法施法
↓
Magic Circle / Device 也出現相同失敗
↓
確認不是單一媒介故障
```

一開始學院可提出多種合理誤判：

- Mana exhaustion
- Spell Card corruption
- training system failure
- environmental interference
- magical infrastructure instability

### 10.2 擴大

失能現象逐步擴大：

1. 一般學生零星發生。
2. 同班／同區域出現群聚。
3. 高年級學生也開始失效。
4. 教職員或專業施法者受到影響。
5. 公共魔法設施出現異常。
6. 醫療、交通、防禦等系統開始受衝擊。
7. Astraea 進入災難狀態。

### 10.3 Mystery 的關鍵線索

真正共同失效的不是 Spell Card，而是：

```text
Human
  ↓
Medium
  ↓
Connection / Interface
  ↓
Magic System
```

因此 Rio 或其他分析角色可以逐步排除：

```text
Chant failure
Circle failure
Spell Card failure
Device failure
```

最後得出：不同媒介共同依賴的「人類與魔法系統之間的連結」出了問題。

## 11. 第一部後段 — Institute Zero 與真正因果

隨著調查深入，主角逐步接觸 Astraea 內部的 Institute Zero。

Institute Zero 是學院內部知曉真正秘密的一群人。

主角最終會接近以下真相：

```text
Magic Usage
→ Reality Cost
→ Entropy
→ Aberrations
→ More Magic
→ More Entropy
→ The Fading
```

### 揭露節奏

不應一次 exposition dump 全部真相。建議分層：

1. 先證明失能不是媒介本身故障。
2. 再揭露人類與魔法系統存在可被干預的連結。
3. 再接觸 Institute Zero。
4. 再得知 Reality Cost / Entropy。
5. 再重新理解 Aberrations。
6. 最後才揭露 The Fading 與 Mio 的未來。

## 12. Mio Reveal

### 12.1 身分

Mio 是來自 The Fading 已經發生之未來的時間朔行者。

她親眼看過文明在魔法與 Aberration 的惡性循環中走向毀滅。

### 12.2 動機

Mio 不否認魔法今天能救人。

她的判斷是：

```text
只要 Human Magic Usage > 0
→ Reality Cost 持續累積
→ Entropy 持續上升
→ The Fading 最終仍會發生
```

所以她不是要改善魔法，而是要讓：

```text
Human → Cannot Use Magic
```

### 12.3 手段

Mio 不摧毀 Magic System，也不刪除 Spell、Function 或 Mana。

她破壞的是：

```text
Connection(Human, Magic System)
```

所以受害者可能：

- 仍有 Mana；
- 仍記得 Chant；
- 仍持有 Spell Card；
- 仍懂 Function Graph；

但所有 request 都無法真正被送達／執行。

## 13. 第一部 Final Battle — Mio

第一部最後戰役是主角對抗 Mio。

這場戰鬥的意義不能只是「阻止反派」。它必須正面碰撞兩個命題：

```text
Hero:
魔法可以保護人。

Mio:
正因為魔法真的可以保護人，
人類才永遠不會停止使用它。
```

Mio 的目標是透過大規模破壞人類—魔法系統介面，讓人類徹底失去施法能力，從源頭終止 Reality Cost 與 entropy 的持續累積。

主角反對她的理由不必等同於「魔法完全沒有代價」，而可以是：

- 不能以立即文明崩潰作為唯一解；
- 現在依賴魔法生存的人會大量受害；
- 尚未證明不存在第三條路；
- Mio 的未來真相不代表她有權替所有人做不可逆決定。

### 第一部結局細節 — TBD

尚未正式確認：

- Mio 是否被擊敗、逃走、暫時合作或失去能力；
- 魔法失能是否完全逆轉；
- 有多少人永久失去施法能力；
- Institute Zero 是否正式曝光；
- The Fading 是否向大眾公開；
- 第二部社會秩序會受到多大改變。

## 14. Last Spell 的劇情位置

Last Spell 是一場戰鬥只能使用一次、使用後角色退出戰鬥的特殊 Spell Card 分類。

它不是單一劇情終極魔法，而是可以成為角色 build、Boss battle 與重要演出的高風險機制。

後期在 Reality Cost 真相揭露後，Last Spell 應自然產生新的倫理重量：

```text
極高戰術價值
vs
極高 Reality Cost
```

第一部是否讓主角、Mio 或其他角色在 Final Battle 使用專屬 Last Spell，目前未定。

## 15. Counter-Function / 反運算的劇情位置

Counter-Function 是高階術式分析概念：分析敵方 Function Graph，尋找 `f⁻¹` 或局部可逆節點。

可逐步從：

```text
Weak Node Analysis
```

發展到：

```text
Function Analysis
→ Invertibility
→ Counter-Function
```

它適合成為 Rio、主角 Analysis build 或 Institute Zero 研究的重要技術線。

## 16. 劇透邊界

### Scene 1～6 可知

- Magic = State A → State B
- Function / Function Graph
- Full Chant / Chantless
- Spell Card
- Prepared Deck
- Mana
- Aberrations 是公開敵人
- Astraea 是保護文明的學院

### Scene 1～6 不可知

- Reality Cost
- Local Entropy 真義
- order debt
- Aberrations 是 entropy / 世界平衡反應
- The Fading
- Institute Zero
- Mio 是時間朔行者
- Mio 的失能計畫
- 人類與 Magic System 的連結可以被破壞

## 17. 劇情 presentation 規則

- Narration、Inner Monologue、Character Dialogue 使用同一套 runtime state。
- Story data 不得把 presentation command 寫進純文字。
- Dialogue data、Dialogue runtime、Dialogue presentation 分離。
- 對話時世界背景仍可見。
- Choice 使用 JRPG 風格列表，不使用大型網頁按鈕。
- 顯示 expression ID，但 portrait 缺失時必須安全 fallback。
- Space／Enter：第一次完成當前跑馬燈，第二次進入下一行。
- Backlog 必須保留旁白／內心／角色對話的類型標記。