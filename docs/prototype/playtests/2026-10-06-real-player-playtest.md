# Real Player Playtest — Astraea

**結論：核心方向看得懂，但「生活任務 → RPG 成長 → 冒險」尚未形成順暢的可玩循環。**我實際完成了 Life Quest 的自我回報流程並看到獎勵；到 Training 時，獎勵不足以使用畫面中唯一可見的訓練項目。之後沒有看到可玩的 Adventure 場景或戰鬥。

## 測試情境

- **平台：**Android 模擬器，Android Studio Running Devices 顯示 **Pixel 10a API 37.1**，模擬器識別為 `emulator-5554`。
- **Android 版本／API：**模擬器標籤顯示 API 37.1；實際 Android 版本與正式 API 整數 **未驗證**。
- **App／build：**Android Studio 以 `main.dart` 啟動；App 畫面有紅色 `DEBUG` 標記。App 版本號、build number、安裝包資訊 **未驗證**。
- **安裝狀態：**是否為乾淨安裝 **未驗證**。
- **測試日期：**2026-10-06。
- **程式碼：**未修改。
- **玩家狀態：**我選了 **Complete with self-report** 來檢查流程，並沒有實際走路 10 分鐘。模擬器因此記錄了一次任務完成與獎勵；測試後沒有建立角色。

## 初見理解

**我覺得這是：**把現實生活行動連到 RPG 角色成長與學院冒險的遊戲。Onboarding 說明 Life Quest 能帶來 Growth Potential，並提到 Training、deck 與 academy exploration；連結大致清楚。

**我不確定的是：**第一次進入後，Home 同時提供 Adventure、Life Quests、Character、Prepared Deck 等入口，沒有明確告訴我哪個是唯一首要行動。畫面中的 Prepared Deck 說明文字也被截斷。

## 關鍵路徑紀錄

| 畫面／步驟 | 預期 → 操作 | 實際發生與我的理解 | 情緒、下一步與嚴重度 |
|---|---|---|---|
| Splash／Onboarding | 首次開啟 → 點 `Tap to start`，再點 `Enter Astraea` | 看到「讓現實的努力，成為改變世界的魔法」；Onboarding 說明生活行動能塑造角色，沒有連勝懲罰，進度會保留。 | 對產品方向有好奇；接著找第一個任務。 |
| Home | 找到新手第一步 | 同時看到 `Continue Adventure`、Life Quests、Character 等多條路；Today 顯示 `Walk 10 minutes` 和 `Growth Potential ready`。 | 看得出生活與 RPG 有關，但有多個入口可選。Home 導覽：**P2**；Prepared Deck 說明被截斷：**P3**。 |
| Life Quest | 點 Life Quests → 在 All 清單選任務 | 清單顯示 1 個任務：`Walk 10 minutes`、Fitness、約 10 分鐘；有 Start 按鈕。頁面也說沒有 streak penalty。 | 任務標題、類別、時間都容易理解；任務選擇少，但不是操作障礙。 |
| 任務方式 | 點 Start → 選擇如何完成 | 詳情寫明可以自我回報，計時器只增加輕量 evidence；我選 `Complete with self-report`，沒有實際走路。 | 自我回報讓我比較安心；`evidence` 一詞仍讓我想問系統會記錄什麼。 |
| 任務完成／獎勵 | 完成回報 → 查看所得獎勵 → 確認 | 顯示 `+10 fitness Life XP`、`+10 Physical Potential`，並標示 `Self-report · private`。點 `Confirm reward` 後直接進 Training；**沒有看到獨立獎勵動畫或獎勵頁**。 | 獎勵數字明確，也有一點完成感；但轉場很快。 |
| Training | 將剛得到的獎勵用於角色訓練 | 頁面說 Life Quest rewards 會變成 Growth Potential，再用於永久角色成長。餘額為 Physical 30、Cognitive 0、Communication 0。唯一可見的 `Function Analysis Drill` 需要 18 Cognitive Potential，按鈕停用；提示要完成 Learning Life Quest 才能取得 Cognitive Potential。頁面內未看到其他訓練項目，嘗試捲動也沒有更多內容。 | 我剛得到的是 Physical Potential，卻不能使用唯一可見的訓練。**P1：獎勵沒有接上當下可用的成長選擇。** |
| Training → 後續導覽 | 從 Training 找 Character 或 Adventure | Training 畫面沒有看見底部導覽。我按 Android Studio 模擬器的系統 Back 後回到 Android 主畫面，App 已離開前景。 | 以玩家角度會以為 App 被關掉，得重新找回入口。**P1：領獎後的流程導覽不明顯。** |
| Character | 重開 App → 從 Astraea Academy 點 `Create Character` | 看到角色名稱欄與「分配 32 點」、Base 8、Maximum 15；Mana Capacity、Mana Output、Computation、Processing、Precision、Efficiency、Ambient Sync、Analysis 都顯示 Base 12、各分配 4。各屬性對玩法的影響未在此頁說明。 | 能看出是在建立角色，但不知道如何分配比較有意義；我沒有完成或儲存角色，所以角色成長效果 **未驗證**。此介面：**P2**。 |
| Adventure | 從 Astraea Academy 點 `Continue Academy Story` | `Academy Story` 頁只看到 `Scene 1–5 complete. Your Prepared Deck is saved.`，其餘可見區域空白；沒有辨識到可繼續的按鈕、任務目標或戰鬥入口。 | 不知道該做什麼，也沒有故事懸念可推動我繼續。**P1：本次 Adventure 沒有呈現可遊玩的下一步。** |

## 關鍵發現

### RP-01 — 任務獎勵不能用於 Training 畫面中的唯一訓練

**Severity：P1**  
**重現：**Home → Life Quests → Walk 10 minutes → Start → Complete with self-report → Confirm reward → Training。  
**結果：**任務給了 10 Physical Potential；Training 顯示 Physical 30、Cognitive 0，但唯一可見的 Function Analysis Drill 需要 Cognitive Potential 18，且不可用。  
**玩家影響：**我理解「生活獎勵可以轉成角色成長」，卻無法用這次獎勵完成成長，回報後的期待落空。

### RP-02 — 領獎後不容易接著進入 Character／Adventure

**Severity：P1**  
**重現：**在 RP-01 的 Training 頁查看導覽。  
**結果：**沒有看到頁面內導覽；使用模擬器系統 Back 後回到 Android 主畫面。重新開啟 App 才看到 Astraea Academy 入口。  
**玩家影響：**核心流程不像連續旅程；我需要自行猜測如何繼續。

### RP-03 — Character 建立需要分配屬性，但選擇依據不明

**Severity：P2**  
**重現：**重開 App → Astraea Academy → Create Character。  
**結果：**顯示 32 點、8 個屬性與基礎數值，但建立頁未說明屬性分別會改變什麼遊戲體驗。  
**玩家影響：**我不想隨便分點，因為看不出選擇後果；沒有建立角色，因此 Character 實際成長未驗證。

## Todo-App Risk

**分數：2／4 — Noticeable**

證據：

- Life Quest 清單、任務分類、時間與回報流程本身接近一般待辦／習慣追蹤操作。
- RPG 關聯在 Onboarding 與 Training 文案中說得出來，但剛完成的任務獎勵不能用於唯一可見的訓練項目。
- Adventure 頁只顯示故事已完成與 deck 已保存，沒有實際遊玩或戰鬥的直接證據。

所以這次體驗中的「RPG 回報」偏弱；不能據此斷定整個遊戲都只是待辦清單，因為本次沒有成功玩到戰鬥。

## Critical MVP Questions

1. **我覺得這是什麼？**結合生活任務、角色成長與學院冒險的 RPG。
2. **我第一步該做什麼？**Life Quest 是可理解的選擇，但 Home 同時展示多個入口，首要路徑不夠集中。
3. **為什麼要做現實任務？**Onboarding 說現實行動會塑造角色，完成後也確實顯示 Life XP 與 Potential。
4. **做完後 RPG 有什麼改變？**畫面顯示 +10 fitness Life XP、+10 Physical Potential；但沒有確認角色屬性已因此改變。
5. **我懂 Training 嗎？**部分理解：頁面文字說 Potential 可以用來訓練；但這次得到的類型無法用於唯一可見的訓練。
6. **我懂 build 為什麼重要嗎？**目前只知道生活會塑造 build，及 Analysis 與揭露敵人 Function Weak Nodes 有關；屬性選擇如何影響玩法 **未驗證**。
7. **戰鬥像真正的遊戲嗎？****未驗證**；本次沒有看到戰鬥。
8. **Function Graph 有沒有帶來 aha moment？****未驗證**；沒有完成角色訓練或進入相關戰鬥。
9. **有沒有像套 RPG 皮的 Todo app？**有明顯風險，評分 2／4；證據見上。
10. **明天會回來嗎？****Maybe。**生活任務連到角色成長的概念有吸引力，但這次任務獎勵無法轉成畫面中的訓練，Adventure 也沒有可操作的下一步。

## Best／Worst Moment

- **Best Moment：**完成回報後看到明確獎勵，且標示 `Self-report · private`；我能理解剛才做了什麼、得到什麼。
- **Worst Moment：**Training 顯示 30 Physical Potential，唯一可見訓練卻需要 18 Cognitive Potential。那一刻，我不知道怎麼把剛完成的生活任務轉成角色成長。

## Top 3 Fixes

1. **讓剛取得的 Potential 對應到可立即使用的訓練選項**，或在領取前清楚說明目前可訓練的項目與所需類型。
2. **在獎勵後提供明確的下一步導覽**，讓玩家能接著去 Character 或 Adventure，而不是只能依靠系統 Back／重開 App。
3. **補上 Adventure 的可辨識下一步，並解釋 Character 屬性效果**，讓玩家知道角色選擇會如何改變遊戲。

## 未驗證項目

實際 Android OS 版本與 API 整數、App 版本／build number、乾淨安裝狀態、角色是否能成功建立、訓練後數值是否改變、Adventure 後續場景與戰鬥、Function Graph 體驗、計時任務、背景中斷行為、其他尺寸裝置的 safe area／觸控表現，均 **未驗證**。

---

## Engineering Follow-up — 2026-10-06

The implementation was updated against the findings above. These changes are not a substitute for a post-fix human retest.

- **RP-01:** Training now presents all six `character-growth-mvp-1` drills. Each option shows its matching Potential category, cost, Aptitude rating, and resulting Attribute. A widget regression test spends 18 of 30 Physical Potential on Reaction Drill and verifies the persisted Processing conversion. No Training cost or reward value was changed.
- **RP-02:** Training, Story, Character creation, and Function Analysis now remain inside the five-tab shell. Training also offers direct Character and Adventure actions.
- **RP-03:** Character creation explains the intended build focus for each of the eight Attributes and states that no allocation blocks the main story. These are authored Attribute responsibilities; detailed combat formulas and integrated battle effects remain pending.
- **RP-04:** Completed Adventure and Story screens now offer the interactive Function Analysis tutorial and a route back to Adventure/Home instead of ending on a completion-only message. The tutorial is not a complete battle encounter.
- **Home / P3:** Home now leads with a Life Quest action, and the Prepared Deck card subtitle is shortened to avoid clipping.
- **Verification:** `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`, and `dart test test/domain test/game_engine` pass. A debug APK was built at `build/app/outputs/flutter-apk/app-debug.apk` but was not launched. Android/iOS device execution and a post-fix human playtest remain **NOT_VERIFIED** in the implementation environment.
