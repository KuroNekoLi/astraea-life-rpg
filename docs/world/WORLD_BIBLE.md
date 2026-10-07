# Astraea Academy — 世界觀設定

本文件整理 Astraea Academy 目前已確立的世界觀、魔法理論、公開知識與後期真相。除非標示為「TBD」「暫定」或「Proposed」，其餘內容視為目前 canon。

## 1. 世界一句話

Astraea 是一個把魔法視為文明基礎技術的世界；魔法學院同時也是高等教育機構、研究中心、魔法工程中心與異形應對人才培育場所。

世界表面相信「魔法保護文明」。真正的後期衝突則在於：人類越依賴魔法，世界越接近無法逆轉的熵增與 The Fading。

## 2. 魔法的本質

魔法不是單純的願望，也不是無條件的奇蹟。Astraea 的基礎術式理論將魔法描述為：

> 將世界從狀態 A 轉換為狀態 B 的方法。

可抽象表示為：

```text
f(S0) = S1
```

- `S0`：施法前的世界狀態
- `f`：魔法 Function／Spell 所代表的運算
- `S1`：施法後的世界狀態

### 2.1 人類不是直接改寫 Reality

人類施法時，必須先透過某種媒介向一個更高層的魔法系統提交「意圖／請求」。該系統再將請求轉換為真正對現實執行的 Function。

```text
Human Intent
    ↓
Medium / Encoding
    ↓
Magic System
    ↓
Function Execution
    ↓
World State A → B
```

目前 canon 只確定：

- 人類與魔法系統之間存在一個必須透過媒介建立的連結。
- Chant、Magic Circle、Spell Card、Magical Device、Mental Calculation 都可以成為這個介面的不同實作方式。
- 人類不是「直接命令現實」，而是將可被魔法系統理解的 request 編碼後提交。

### 2.2 魔法系統本體 — TBD

目前尚未確定「接收 request 並執行 Function 的 Magic System」究竟是：

- Reality 本身的一層規則；
- 某種遍佈世界的魔法場；
- 更高層的自然系統；
- 或尚未揭露的存在。

第一部不需要回答這個問題。即使 Institute Zero 掌握大量真相，也不代表它已理解該系統的最終本體。

### 2.3 八大魔法系統 — 分類已確定

目前採用以下八大系統，作為學院教學與 Spell 分類的主要框架。各系統精確邊界可以重疊；代表術式和 Tier 目錄見 `docs/systems/SPELL_FUNCTION_SYSTEM.md`，具體內容仍可持續設計與平衡：

- Elemental（元素／自然現象）：操作熱、冷、電、流體等自然現象。
- Kinetic（動力）：操作力、速度、動量與向量。
- Spatial（空間）：操作距離、位置與空間連接。
- Temporal（時間）：操作局部時間速度、順序與延遲。
- Life（生命）：操作生物狀態、組織、恢復與強化。
- Mind / Information（精神／情報）：操作感知、資訊、認知與記憶。
- Causality（因果）：操作有限條件、觸發、結果機率與因果關係。
- Structural / Arcane（術式構造／奧術）：直接分析、穩定或干涉魔法 Function。

系統分類本身不代表稀有度或力量階級。Temporal 與 Causality 是學院可正常教授的魔法系統；學生可學習 Slow 等低階術式。Time Stop、Temporal Reversal、Return to Past，以及改寫現實或歷史因果等，屬大魔法或極高階術式，一般學生無法接觸。其門檻應由 Tier、Complexity、使用要求、稀有度與存取限制表達，不把整個系統定義為禁術。

## 3. Function 與 Function Graph

Spell 可以被拆解為 Function Graph。複雜術式不是單一步驟，而是由多個子 Function 串接而成。

```text
Gather(Energy)
    ↓
Shape(Bolt)
    ↓
Move(Target)
```

另一個示例：

```text
Detect(Target)
    ↓
LockTarget
    ↓
Fire(Bolt)
```

Function Graph 同時具有三個用途：

1. **教學**：讓學生理解 Spell 的組成與依賴。
2. **工程**：讓魔法師分析、最佳化、修改術式。
3. **戰鬥**：讓高 Analysis 角色找出 Weak Node、可干涉節點與可能的反運算路徑。

這套 Function Graph 是 Astraea 的核心差異化系統之一，應維持自製，不由通用 addon 接管。

## 4. 媒介、詠唱與施法

所有施法都必須經過某種「意圖 → 可執行 request」的轉換。

常見媒介包括：

- Chant
- Mental Calculation
- Magic Circle
- Spell Card
- Magical Device

### 4.1 Full Chant

Full Chant 不是向神祕存在祈禱，而是一種高結構化的外部 computation / encoding mechanism。

它可以替施法者承擔部分：

- Function sequencing
- target specification
- parameter binding
- stability verification
- request encoding

因此初學者即使 Computation 或 Processing 不高，仍能依靠完整詠唱穩定施法。

### 4.2 Chantless

Chantless 並不是「沒有媒介」或「沒有計算」。

> Chantless 是把原本由外部詠唱完成的計算與 request encoding，搬到施法者自身完成。

簡化表示：

```text
Full Chant:
Human → Chant → Magic System

Chantless:
Human → Mental Encoding → Magic System
```

Chantless 因此通常要求更高的 Processing、Computation、Precision 或相關天賦。

## 5. Spell 與 Spell Card

### 5.1 Spell

Spell 是一個已經有明確效果、可被執行的魔法 Function／Function Graph。

例如：

```text
FireBolt(target, power)
```

本質上仍是：

```text
World State A → World State B
```

### 5.2 Spell Card

> **Spell Card 是一個 Function 的具現化。**

更精確地說：Spell Card 是將某個已構築完成的 Function／Function Graph 以可保存、攜帶、載入與重複提交的形式具現化的施法媒介。

```text
Function Graph
    ↓
Construct / Encode
    ↓
Spell Card
    ↓
Bind Parameters
    ↓
Submit Request
    ↓
Magic System
    ↓
Execute Function
```

Spell Card 不是「擁有這張卡才會這個魔法」的收藏卡牌邏輯，而是術式工程上的 executable representation / reusable request structure。

### 5.3 Prepared Deck

魔法師可能理解或學過大量 Spell，但戰鬥不會提供從零構築所有 Function 的時間。

因此戰鬥前會把一組 Spell Card 放入 Prepared Deck，等於事先載入本場戰鬥可快速呼叫的術式。

Scene 5 的教學上限固定為 6 張。

Spell Card（SC）是戰鬥前準備好的 **combat-ready Function template**。角色理論上可使用所有已學會的基礎魔法；但戰鬥中只能快速使用有限數量的 Prepared SC，因為魔法師能同時維持的 Prepared Functions 有限。MVP 上限為 6 張。此限制是施法準備與維持能力，不表示角色只學會或只擁有這些魔法。

### 5.4 Spell Family、Signature 與 Tier

每個 Spell Family 有完整 Signature。SC Tier 表示該 Tier 對完整 Signature 開放多少可控 parameters；未開放的部分由術式模板處理。Tier 越高通常帶來較高 Mana Cost、Complexity 與 Chantless 負擔，但各 Spell Family 的 Tier 不可直接橫向比較。例如 Fireball III 可能只在部分面向約等於 Flame Lance I。

解鎖較高 Tier 不會移除低 Tier。不同 Tier 的 SC 可各自獨立準備；高熟練者的 Fireball I 也可能比一般施術者的 Fireball III 更強。Tier 描述的是可控制的術式層級，不是固定的角色強度排序。

SC 可選擇 Full Chant 或 Chantless。能否 Chantless 取決於施術者對該 SC／Tier 的理解與個人能力；多數學生可對 Fireball I 等基礎術式詠唱破棄，高階 Spell 或 Tier 通常只有更熟練、能力更強者能詠唱破棄。

## 6. Last Spell

**Last Spell 是角色專屬、每名角色每場戰鬥最多使用一次的特殊 Spell Card。**它不是一般高 Tier SC，也不是所有角色共用的 Spell Family。

規則：

- 每名角色每場戰鬥最多使用自己的 Last Spell 一次；隊伍中不同角色各自有一次使用機會。
- 效果遠超一般 SC，可是極高輸出、特殊效果或改變戰場規則，不限於傷害。
- 發動後施術者立即失去本場戰鬥剩餘時間的行動能力，直到戰鬥結束。
- Last Spell 不屬於一般 SC 的 I → II → III Tier progression。解鎖可透過角色劇情、重大成長或特殊條件；具體條件依角色設計。
- 不同角色擁有不同的 Last Spell，表達個人的魔法系統、戰鬥定位、性格、故事與天賦。

其設計精神是用角色剩餘的戰鬥能力，換取一次極端的 Function Execution。Last Spell 與 Fireball V 等一般高階 SC 不同：一般高階 SC 即使 Mana Cost 與 Complexity 很高，施放後仍留在正常戰鬥循環；Last Spell 使用後角色退出本場戰鬥。

```text
Last Spell
    ↓
Extreme Function Execution
    ↓
Caster gains LastSpellExhaustion until battle end
```

`LastSpellExhaustion` 是獨立且本場不可解除的戰鬥狀態，不等同於昏迷、瀕死或受傷，也不能單靠恢復 HP 或 Mana 移除。Mana 可同時大量消耗或歸零，但不是角色失去行動能力的唯一原因。其具體身心呈現可因角色而異。

Last Spell 是否占用一般 Prepared Deck 的 6 個位置：**TBD**。

Last Spell 的巨大輸出也意味著它理論上可能帶來極高 Reality Cost；此點可在後期真相揭露後成為戰術與倫理衝突。

## 7. Counter-Function / 反運算

高階術式分析可以嘗試尋找敵方 Spell 的反函數。

若：

```text
f(A) = B
```

且存在：

```text
f⁻¹(B) = A
```

則可以透過 Counter-Function 嘗試反轉、解除或抵銷該 Spell 的結果。

例如：

```text
CompressSpace(normal) → compressed
ExpandSpace(compressed) → normal
```

### 7.1 限制

不是所有 Function 都存在完整、唯一的反函數。

因此 Counter-Function 可能需要：

- 額外 state 資訊；
- 找出 Function Graph 中可逆的局部節點；
- 只逆轉部分效果；
- 改以破壞 Weak Node 或中止後續節點。

這讓 Analysis 不只是「看弱點」，而可以進一步成為高階魔法工程與戰鬥能力。

## 8. Mana 與成本

### 8.1 Mana Cost

Mana 是施法者可觀察、可管理的施法成本。

不同角色具有不同：

- Mana Capacity
- Mana Output
- Efficiency
- Ambient Sync

### 8.2 Reality Cost

後期真相：魔法除了消耗施法者 Mana，也會讓世界本身支付代價。

> **Reality Cost 是魔法強制改寫世界狀態所造成的世界層級成本。**

可區分為：

```text
Mana Cost     = caster pays
Reality Cost  = world pays
```

Reality Cost 在 Scene 1～6 不公開。

## 9. Entropy、Aberrations 與 The Fading

### 9.1 Entropy / Local Entropy

魔法是對世界的干預。每次 Function 改寫 Reality，都會使世界的 entropy 增加。

Reality Cost 是一次魔法造成的世界代價；Local Entropy 則描述某個區域長期累積後的世界不穩定程度。

概念上可表示：

```text
E(t+1) = E(t) + Cost(spell)
```

### 9.2 Aberrations

公開世界觀中，Aberrations 是威脅文明的敵對存在。

真正因果則是：

> **世界為了回應／平衡魔法造成的 entropy 增加，會產生 Aberrations。**

因此形成惡性循環：

```text
Magic Usage
    ↓
Reality Cost
    ↓
Entropy rises
    ↓
Aberrations increase
    ↓
Humans need more Magic
    ↓
More Reality Cost
    ↓
More Entropy
```

這個循環是世界走向 The Fading 的核心原因。

### 9.3 The Fading

The Fading 是長期魔法使用造成的 entropy 累積，最終導致的世界級崩壞現象。

其本質不是單純「魔力枯竭」，而是 Reality 長期承受干預後，逐漸失去維持穩定狀態的能力。

```text
Magic
→ Reality Cost
→ Entropy
→ Aberrations
→ More Magic
→ More Entropy
→ The Fading
```

Mio 所來自的未來，已經發生 The Fading。

### 9.4 order debt — TBD

`order debt` 保留為後期術語，但目前尚未正式確認其與 Reality Cost / Local Entropy 的精確差異。

目前只確定：

- 它與魔法造成的秩序／世界補償問題有關。
- Scene 1～6 不公開。
- 在正式定義前，不應把它當成 gameplay 數值或與 Local Entropy 同義使用。

## 10. 魔法與文明

魔法已經融入日常生活與公共基礎設施：

- 點亮街道
- 驅動交通
- 治療傷患
- 支援城市防禦
- 驅動研究與教育
- 支援異形應對

序幕採用官方／公共世界觀：一般人相信魔法是保護文明的力量，而 Astraea 是守護魔法知識與使用者的學府。

核心口號：

```text
魔法守護文明，星環守護魔法。
MAGIC PROTECTS CIVILIZATION.
ASTRAEA PROTECTS MAGIC.
```

這也意味著後期的「魔法失能」不是單純戰鬥系統故障，而是交通、醫療、防衛、教育與社會運作全面受威脅的文明級災難。

## 11. Astraea Academy 與派系

Astraea Central Academy of Arcana 是世界上最重要的魔導學府之一，兼具：

- 魔法教育
- 魔法研究
- 異形應對人才培育
- 魔法工程與術式分析
- 公共文明防衛功能

Astraea 內部存在不同研究立場與派系。第一部前期不需要讓玩家知道所有派系結構。

### 11.1 Institute Zero

Institute Zero 是 **Astraea Academy 內部的一個秘密部門／派系**，不是外部組織。

它屬於少數已知曉魔法真正代價的人，至少掌握以下核心因果：

```text
Magic
→ Reality Cost
→ Entropy
→ Aberrations
→ More Magic
→ The Fading
```

Institute Zero 的存在與研究內容不應在 Scene 1～6 提前公開。

### 11.2 Institute Zero 的立場 — 部分 TBD

已確定：

- Institute Zero 知道真正秘密。
- 它屬於 Astraea 內部。
- 它不等同於 Mio。

尚未完全確定：

- 是否主張繼續使用魔法並尋找低代價方案；
- 是否主張限制魔法；
- 是否存在內部分裂；
- Professor Tachibana 是否屬於／曾屬於 Institute Zero。

## 12. Mio 與魔法失能

### 12.1 Mio

Mio 是來自 The Fading 未來的時間朔行者。

她回到過去的目的，是阻止人類走向同一個世界毀滅結局。

她的結論是：

> 只要人類仍然能使用魔法，Reality Cost 與 entropy 就會持續累積；因此真正的解法不是讓魔法更有效率，而是讓人類徹底失去使用魔法的能力。

### 12.2 Mio 不是摧毀魔法本身

Mio 的目標不是：

- 消除 Mana；
- 刪除世界的魔法法則；
- 摧毀所有 Spell Card；
- 讓 Function 不再存在。

她破壞的是：

```text
Connection(Human, Magic System)
```

也就是「人類—媒介—魔法系統」之間的施法連結。

因此受影響的人可能仍然：

- 有 Mana；
- 記得 Chant；
- 看得懂 Magic Circle；
- 持有 Spell Card；
- 理解 Function Graph；

但所有施法路徑都無法真正把 request 送達／執行：

```text
Human
  ↓
Medium
  ↓
  X
Magic System
```

### 12.3 魔法失能事件

第一部中段開始，Astraea 會發生魔法失能現象：

1. 一開始只有少數一般學生無法施法。
2. 症狀逐漸擴大成群聚事件。
3. 不同媒介都開始失敗，使「單純 Spell Card 故障」的解釋站不住腳。
4. 教職員與更高階使用者也逐步受到影響。
5. 當公共魔法設施、醫療、防衛與生活系統受影響後，事件演變為災難。
6. 主角調查到最後發現造成這一切的人是 Mio。
7. 第一部最終戰役為主角對抗 Mio。

## 13. 公開真相與後期真相

### Scene 1～6 可以公開

- 魔法是文明的重要技術。
- Mana 是施法成本。
- 魔法需要 Chant、Mental Calculation、Magic Circle、Spell Card 或其他媒介來完成施法。
- 魔法可以被理解為 Function / Function Graph。
- Spell Card 是 Function 的具現化施法媒介。
- 異形威脅人類。
- Astraea 培育魔法使用者與異形應對人才。
- Professor Tachibana 曾在災害中救過主角。
- 主角相信魔法可以保護人。

### Scene 1～6 不可公開

- Reality Cost
- The Fading
- Local Entropy 的真實意義
- order debt
- Aberrations 是世界補償效應
- Magic → Entropy → Aberration 的因果
- Institute Zero
- Mio 的真正身分
- Mio 的魔法失能計畫
- Professor Tachibana 是否知道更深層真相

## 14. 世界呈現規則

- Exploration Mode：玩家在學院環境中移動，NPC 實際存在於世界。
- Dialogue Mode：世界背景仍留在畫面上，對話層覆蓋於下方，不切成空白文字畫面。
- Combat Mode：使用獨立的戰術／卡牌戰鬥呈現。
- 通用對話 addon 只能提供 traversal、branching 等基礎能力；世界鏡頭、角色走位與 Astraea 特有 cinematic actions 由專案自製。

## 15. 核心主題

故事的核心不是簡單判定「魔法是善還是惡」，而是：

> 如果一項技術今天真的能救人，但它的長期累積代價會毀滅世界，人類是否仍有權繼續使用它？

主角、Tachibana、Institute Zero 與 Mio 將從不同位置回答這個問題。
