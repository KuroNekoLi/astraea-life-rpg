# Astraea Academy — 角色設定

本文件整理 Astraea Academy 目前已確立的角色設定。除非標示為「暫定」「TBD」或「後期 spoiler」，否則視為 Chapter 1 Scene 1～6 的角色基準。

## 角色使用原則

- 角色資料與對話文字分離，角色名稱、portrait、expression 由 presentation data 解析。
- Scene 1～6 的人物對話不得提前揭露 The Fading、Reality Cost、Local Entropy、order debt、Institute Zero、Mio 的真正身分或 Aberration 的真正來源。
- Professor Tachibana 不應被寫成可疑反派；目前設定是他真心相信魔法能救人。
- Mio 可以存在於資料模型 placeholder，但不在 Scene 1～6 的 playable flow 正式登場。
- 角色對魔法真相的 knowledge state 必須明確區分「玩家目前知道」與「角色本人可能知道」。

## Player Character / Hero

### 身分

- 玩家主角，姓名由玩家決定。
- 童年曾在 Aberration 災害中被魔法師救下。
- 救命恩人後來成為 Astraea 教授。
- 主角因此形成核心信念：**「魔法可以保護人。」**

### 性格與敘事功能

主角的個性應保留足夠空間給玩家選擇，不預設固定職業或單一 build。Scene 1 的選項可以改變後續語氣與關係資料，但不應否定主角相信魔法能保護人的核心歷史。

這個核心信念不是錯誤認知：魔法確實曾經救過主角，也持續在日常生活中救人。後期衝突的重點是逼迫主角面對「短期救援」與「長期世界代價」可以同時為真。

### 第一部角色弧

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
仍必須決定是否阻止 Mio 消除人類施法能力
```

主角第一部的成長不應簡化為「發現魔法是壞的」。真正問題是：知道代價後，是否仍能找到比 Mio 更好的答案。

### 能力模型（Scene 2 開始使用）

八項能力：

1. Mana Capacity
2. Mana Output
3. Computation
4. Processing
5. Precision
6. Efficiency
7. Ambient Sync
8. Analysis

角色建立規則：

- 所有能力 Base = 8。
- 玩家有 32 點 Fixed Allocation。
- Fixed Allocation 上限為 15。
- Scene 2 再進行八項 Aptitude Roll。
- 最後提供一次 Fate Reroll，只能重骰一項且必須接受新結果。

## 佐伯悠真 / Saeki Yuma

### 基本資料

- 性別：男性
- 身分：主角好友、同學
- Scene 1：Academy Gate 第一個正式互動角色
- 目前世界 sprite ID：`YUMA`

### 個性

- 務實
- 可靠
- 有些吐槽
- 熟悉主角的童年經歷
- 說話直接，但不是惡意挖苦

### 擅長方向

- Space
- Mobility
- Support

### Scene 1 功能

Yuma 的存在要讓玩家感受到主角不是孤立地進入學院。他會在主角接近後等待玩家按下 E，而不是自動彈出對話。

初次對話：

```text
「喂。」

「你走那麼快幹嘛？」
```

第一層選項：

```text
「怕遲到。」
「我只是想早點看看學院。」
「你自己走太慢。」
```

後續會談到主角童年事件與信念：

```text
「我也想成為救人的魔法師。」
「總有一天，我也要加入異形應對部隊。」
「魔法可以保護人，我一直都是這麼想的。」
```

### 第一部中段功能

Yuma 適合作為魔法失能事件的「生活層面」觀察點：他不一定第一個解出理論，但能讓玩家看到失能如何影響普通學生、戰鬥訓練與日常依賴。

是否讓 Yuma 本人早期成為失能者：TBD。

## 神谷理央 / Kamiya Rio

### 基本資料

- 性別：女性
- 外觀識別：眼鏡
- 身分：優等生、同學
- 目前世界 sprite ID：`RIO`

### 個性

- 理性
- 重視證據與結構
- 喜歡術式理論與分析
- 對魔法工程與最佳化有信心
- 不應寫成冷漠或沒有同理心，而是習慣先分析問題

### 擅長方向

- Analysis
- Information
- Optimization
- Function Graph analysis
- 後期可發展 Counter-Function / 反運算

### Scene 2 反應方向

- 主角 Computation／Analysis 高：注意主角解析能力。
- 主角 Precision／Processing 高：認為主角適合實戰。
- 能力平衡：認為主角沒有明顯偏科。

Rio 的正式介紹與能力依賴反應屬於 Scene 2，不應在 Scene 1 強行塞入。

### 魔法失能事件中的功能

Rio 適合作為最早發現「問題不在單一媒介」的人之一。

她可以透過排除法發現：

```text
Spell Card fails
Full Chant fails
Magic Circle fails
Device fails
```

若不同介面同時失效，則真正共同問題可能位於：

```text
Human → Magic System
```

之間的 connection / interface。

這可以成為 Rio 從「最佳化既有魔法」走向「質疑魔法系統本身」的重要角色轉折。

## 朝倉陽菜 / Asakura Hina

### 基本資料

- 性別：女性
- 外觀識別：馬尾
- 身分：同學
- 目前世界 sprite ID：`HINA`

### 個性

- 活潑
- 直率
- 行動力強
- 不喜歡過度理論化
- 不是笨蛋；她只是偏好直接感受與實作

### 擅長方向

- 高 Mana Capacity
- 高 Mana Output
- Energy Magic
- Chantless casting

### 與 Rio 的對比

```text
Hina：輸出、直覺、能量魔法、Chantless
Rio：理解、分析、結構、最佳化
```

Hina 的正式介紹與 Chantless 相關內容屬於 Scene 2～4。

### 魔法理論功能

Hina 是證明「Chantless 仍然需要 request encoding」的最佳角色。

她不是跳過魔法介面，而是：

```text
Human
→ Mental Encoding
→ Magic System
```

因此後期若 Mio 切斷的是「Human ↔ Magic System」連結，Hina 即使不用詠唱也一樣會受到失能影響。這能成為玩家排除「詠唱系統故障」的重要證據。

## 橘教授 / Professor Tachibana

### 狀態

目前是工作名稱，可以保留為 configurable character data。

### 基本資料

- 身分：Astraea 教授
- 也是主角童年時的救命恩人
- 目前世界 sprite ID：`TACHIBANA`

### 個性與敘事定位

- 溫和
- 有權威感
- 真心相信使用魔法救人是必要的
- 不是可疑反派
- Scene 1～6 不揭露他是否知道 The Fading

序幕代表台詞：

```text
「別怕。」
「待在我身後。」
```

### 核心倫理位置

Tachibana 最重要的角色價值是：即使後期知道魔法具有世界代價，他也不必因此被改寫成虛偽人物。

他的立場可以成立於：

```text
「我知道使用魔法可能讓未來付出代價。」
「但如果我現在不用，那個人今天就會死。」
```

這使他能與 Mio 形成真正的倫理對照：

```text
Tachibana：優先拯救眼前的人
Mio：優先避免未來整個世界毀滅
```

### Institute Zero 關係 — TBD

尚未確定：

- Tachibana 是否屬於 Institute Zero；
- 是否曾經參與；
- 何時知道 Reality Cost / The Fading；
- 他知道多少 Mio 相關資訊。

在定案前，不得透過早期演出暗示他必然是 Institute Zero 成員或陰謀者。

## Mio

### 狀態

- 第一部後期核心角色／最終對手。
- Scene 1～6 不正式登場。
- 早期不得透過 UI、背景文件或 NPC 閒聊提前揭露真正身分。

### 真正身分

Mio 是 **時間朔行者**。

她來自已經發生 The Fading 的未來，親眼看過魔法文明最終因長期 entropy 累積與 Aberration 惡性循環走向毀滅。

### 核心認知

Mio 知道：

```text
Magic Usage
→ Reality Cost
→ Entropy
→ Aberrations
→ More Magic
→ More Entropy
→ The Fading
```

她並不否認魔法能救人。

她真正的判斷是：

> 正因為魔法真的能救人、便利而且有效，人類才不可能靠自律停止使用它。

### 目標

Mio 的目標是：

> **讓人類徹底失去使用魔法的能力。**

她不是要摧毀世界的魔法法則，也不是要讓 Mana 不存在。

她要切斷：

```text
Connection(Human, Magic System)
```

使人類仍然可能：

- 擁有 Mana；
- 記得 Chant；
- 持有 Spell Card；
- 理解 Function Graph；

但所有施法 request 都無法真正傳遞到魔法系統並被執行。

### 第一部行動

Mio 的計畫會先以局部失能開始：

```text
少數一般學生
↓
群聚案例
↓
高階施法者
↓
魔法基礎設施
↓
災難化
```

主角在調查最後發現造成事件的人是 Mio。

第一部最後戰役為主角對抗 Mio。

### 與主角的主題對立

Hero：

```text
「魔法可以保護人。」
```

Mio 並非簡單回答「不，魔法不能」。

她的答案更接近：

```text
「我知道魔法可以保護人。」
「問題就在這裡。」
「因為它真的有效，人類才永遠不會停止使用它。」
```

兩人的核心衝突因此不是善惡，而是：

```text
眼前可被救下的人
vs
未來必然走向 The Fading 的世界
```

### 時間朔行與 Reality Cost

Mio 回到過去本身即使需要巨大魔法干預，也不構成她目標上的邏輯矛盾。

她的策略是承受一次性的高額成本，以換取之後永久終止人類施法：

```text
Time Reversal
→ one-time massive intervention
→ Human Magic Usage eventually becomes 0
→ no continuing Reality Cost accumulation
```

時間朔行的具體術式、限制與代價：TBD。

## Institute Zero（角色關係摘要）

Institute Zero 是 Astraea Academy 內部掌握魔法真正秘密的部門／派系。

角色關係目前確定：

- Mio 與 Institute Zero 不是同一勢力。
- Institute Zero 知道 Magic / Entropy / Aberration / The Fading 的核心關係。
- Mio 採取「讓所有人失去施法能力」的極端解法。

尚未確定：

- Institute Zero 對 Mio 的態度；
- 是否早已知道 Mio 的存在；
- 是否主張第三條路；
- Tachibana 與 Institute Zero 的關係。

## Last Spell 與角色設計

Last Spell 是一場戰鬥只能使用一次、使用後施術者無法繼續戰鬥的特殊 Spell Card 分類。

每個重要角色未來可以有自己的 Last Spell，但不應強制所有角色都具備。

角色專屬 Last Spell 應反映：

- 個性
- build
- Function specialization
- 劇情位置
- 願意承受的代價

目前尚未定義 Hero、Rio、Hina、Yuma、Tachibana、Mio 的專屬 Last Spell。

## 角色呈現資料結構

角色 metadata 不應重複寫入每份 dialogue：

```text
character_id
display_name_key
portrait_default
portrait_expressions
nameplate_style
text_style_override（optional）
voice_id（future）
```

目前 expression IDs 至少預留：

- neutral
- happy
- annoyed
- thinking
- surprised
- serious

若沒有合法 portrait asset，使用安全的 placeholder，不要把無關的 stock character 當成正式角色。