# 實機複測改善計畫：`438c6eb`

日期：2026-10-06  
來源：[實機玩家複測報告](2026-10-06-real-player-playtest-438c6eb.md)  
目標版本：`feature/first-playable-golden-path`，起始 commit `438c6eb0953e541e49e7e0dc6ca283ad3f5f4dc2`

## 分析摘要

本次最傷害信任的是獎勵確認後 Training 仍顯示舊 Potential（RP-01），其次是訓練後 Character 暫時顯示舊屬性（RP-03）。兩者都讓玩家看不出剛才的永久成長是否保存。程式路徑追蹤發現：Life Quest 確認流程只刷新任務清單，Training provider 仍可能沿用先前快取；Training 成功後也沒有刷新 Character profile provider。這是程式碼路徑分析，不代表已直接檢查實測裝置中的資料庫。

RP-02 的畫面也符合舊 Training 資料未刷新，但是否真的產生第二筆 Read 獎勵，僅憑當時畫面無法確定。模板資料沒有明載重複政策或遞減組，系統文件則要求每個模板定義這些政策，因此本次不改獎勵或任務重複規則；需要產品／遊戲設計角色先定義後，再決定如何向玩家呈現。

其餘高優先發現是 Adventure 首屏 CTA 遭底部導覽遮擋（RP-04）、Character Builder 混淆 Base 8 與最終值（RP-05），以及 Function Graph 節點沒有可見互動回饋（RP-07）。RP-06 語言混用列為後續文案工作，須交由 Narrative Director 核對語意與術語。

## 本次改善範圍與驗收

| 發現 | 優先級 | 計畫／驗收標準 | 狀態 |
|---|---:|---|---|
| RP-01 獎勵後 Potential 過期 | P1 | 成功確認獎勵後刷新 Training golden path 與 Potential；進入 Training 即顯示最新持久餘額。不得改獎勵公式或補發獎勵。 | 已實作，待分析／格式檢查；尚未裝置複測 |
| RP-02 重複 Read 的回報與餘額不一致 | P1 | 本次先隨 RP-01 刷新資料；實機重測比較每次獎勵預覽、確認結果與最新餘額。若重複任務政策仍未定義，暫不改規則，列為待決策。 | 根因未完全驗證；規則待決策 |
| RP-03 訓練後 Character 顯示舊值 | P2 | 訓練成功後刷新 Character profile；切頁看到的永久屬性值與 Training 結果一致。 | 已實作，待分析／格式檢查；尚未裝置複測 |
| RP-04 Adventure 主要 CTA 被底導覽遮擋 | P2 | 初次開啟 Adventure，無需先滑動即可看見並操作主要 Continue CTA；底部導覽不遮擋可視或觸控區域。 | 已實作 sticky CTA，尚未裝置複測 |
| RP-05 Builder 的 Base 8／Base 12 語意混淆 | P2 | 清楚區分基礎值 8、分配點數及最終起始值；八項屬性的 build focus 可辨識；不改總點數、上限或分配規則。 | UI 改善進行中，待檢查 |
| RP-07 Function Graph 點選無回饋 | P2 | 點選節點後有清楚選取狀態與對應說明，玩家可理解 Gather、Shape、Move 的角色；維持教學，不描述為戰鬥。 | UI 改善進行中，待檢查 |
| RP-06 故事流程中英混用 | P3 | 由 Narrative Director 核對語境、術語與一致語言後再修改，避免自行改寫世界觀文案。 | 延後至文案角色審閱 |

## 保留的產品與遊戲規則

- 不修改 Growth Potential 獎勵、Training 成本、Aptitude、屬性成長與戰鬥平衡。
- 不補發或手動調整餘額，也不更動 append-only `RewardGrant`、`TrainingConversion` 與其 projection 設計。
- 不自行決定 Life Quest 重複完成／遞減回報政策；明確定義後再更新模板、預覽及確認回饋。
- Function Analysis Tutorial 保持教學定位；Ashfang encounter 的 illustrative 標記與已觀察到的戰鬥因果不在本次範圍內。
- 原始實機報告與截圖作為未修改的觀察記錄保留。

## 驗證計畫

1. 已檢視各角色的 source diff；沒有更動獎勵、成本、屬性成長或戰鬥規則。Dart formatter 與 `git diff --check` 均已執行。
2. `flutter analyze` **未完成**：目前環境 Flutter 3.32.2 / Dart 3.8.1，套件解析指出專案要求 Dart `^3.12.0`。此環境版本不相容，故不能報告分析通過。本次沒有新增或執行測試。
3. 尚需使用相容 SDK 重新分析／建置，並在 Android 模擬器乾淨資料上複測 RP-01、RP-02、RP-03、RP-04、RP-05、RP-07，保存新的裝置證據。未完成前，不宣稱程式修正已通過靜態分析或實機驗證。
