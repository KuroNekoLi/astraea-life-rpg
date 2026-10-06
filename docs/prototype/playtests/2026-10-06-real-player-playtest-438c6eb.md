# Astraea 實機玩家複測：`438c6eb`

**日期：** 2026-10-06  
**結果：** 已在 Android 模擬器安裝並操作 debug build；未修改或提交程式碼。  
**DEVICE_VERIFICATION = AVAILABLE**

## 測試環境與範圍

- Repo branch：`feature/first-playable-golden-path`
- 測試 commit：`438c6eb0953e541e49e7e0dc6ca283ad3f5f4dc2`（與指定 commit 完全相同）
- Flutter：3.47.0；APK：`build/app/outputs/flutter-apk/app-debug.apk`
- App：`dev.astraea.astraea_life_rpg`，versionName `0.1.0`、versionCode `1`；debug 標記可見
- 模擬器：AVD `Pixel_10a`，裝置回報 `sdk_gphone16k_arm64`，1080×2424、420 dpi
- Android：版本 17，API 37
- 安裝狀態：執行 `pm clear` 成功後安裝該 commit 建置的 APK，再首次啟動；使用者資料為乾淨狀態
- 證據目錄：[screenshots/2026-10-06-438c6eb](screenshots/2026-10-06-438c6eb/)

本報告只記錄模擬器實際畫面與觸控結果。Walk、Exercise、Read 均以 App 提供的 **Complete with self-report** 做測試用自我回報；沒有實際走路、運動或閱讀，亦不將它們描述成現實活動。沒有執行的路徑另列為「未驗證」。

## 玩家逐步紀錄

| 階段 | 預期 | 實際操作與畫面結果 | 玩家理解／感受、困惑 | 下一步 |
|---|---|---|---|---|
| Splash / onboarding | 初次啟動說明產品並給出清楚開始點 | 乾淨啟動顯示 Astraea Splash 與「Tap to start」；Onboarding 寫「Your everyday effort can shape your Astraea self」，列出 Choose a Life Quest、Earn Growth Potential、Build your RPG self，並說沒有連續天數懲罰；點擊後進 Home。見 [01](screenshots/2026-10-06-438c6eb/01-splash.png)、[02](screenshots/2026-10-06-438c6eb/02-onboarding.png) | 我理解真實生活任務會轉成角色成長；「No streak penalties」降低漏做的壓力。 | 依 Home CTA 開始選任務／建立角色。 |
| Home | 新手能判斷第一件該做什麼 | 首屏主卡寫「One real action starts your journey」及「Choose a Life Quest」，下方 Life Quests、Adventure、Character、Prepared Deck 與固定底部導覽。見 [03](screenshots/2026-10-06-438c6eb/03-home.png) | 第一個目標很明確，是選 Life Quest；不必猜主要入口。 | 開始 Character 建立。 |
| 建立角色 | 輸入基本資料、理解屬性配置、保存角色 | 從 Character 空狀態進 Create Character，輸入 `Mira` 並 Continue；畫面回 Life Quest，之後 Character 顯示 Mira，八項屬性初始皆 12。見 [04](screenshots/2026-10-06-438c6eb/04-character-empty.png)、[05](screenshots/2026-10-06-438c6eb/05-character-builder.png)、[07](screenshots/2026-10-06-438c6eb/07-character-save-result.png) | 保存成功。配置畫面同時可見「Base 8」與「Base 12」字樣（見圖），新玩家不容易知道哪個才是屬性基準；需要逐項讀說明才能判斷 build focus。 | 選擇 Walk 10 minutes。 |
| 第一個 Life Quest | 選 Walk 10 minutes，完成回報並確認首筆獎勵 | Life Quest 清單選 Walk 10 minutes → Start → Complete with self-report → Confirm reward。獎勵頁寫 `+10 fitness Life XP`、`+10 Physical Potential`、`Self-report · private`。見 [08](screenshots/2026-10-06-438c6eb/08-quest-templates.png)、[10](screenshots/2026-10-06-438c6eb/10-walk-quest-detail.png)、[11](screenshots/2026-10-06-438c6eb/11-walk-reward-preview.png) | 我明白這是自己回報，不是感測器證明。這次只為測試點選，沒有走路。首筆獎勵明示 +10 Physical Potential。 | 進 Training 看餘額與成本。 |
| 第一筆 Training 餘額不足 | 確認沒有額外初始 Potential、成本明確、可回 Life Quest | Training 顯示 Physical 10、Cognitive 0、Communication 0。Reaction Drill：Processing 12→13、Aptitude 2/6、cost 20 Physical Potential，按鈕為「Need 10 more Physical Potential」；Precision Movement：Precision 12→13、Aptitude 5/6、cost 16，需 6 點。頁面寫「Potential is building toward your next Training」，說新角色從 0 Growth Potential 開始，並提供「Choose another Life Quest」。見 [12](screenshots/2026-10-06-438c6eb/12-training-after-first-reward.png)、[13a](screenshots/2026-10-06-438c6eb/13a-training-reaction-details.png) | 這清楚表示沒有免費起始點，需做匹配任務累積；可以返回 Life Quest。Reaction Drill 不是首個可用訓練，成本與不足額清楚。 | 完成匹配 Physical 任務。 |
| 獎勵畫面／餘額更新 | 再做匹配 Fitness 任務，餘額應更新 | Exercise 20 minutes → self-report（測試用途，沒有運動）→ 獎勵頁顯示 +18 fitness Life XP、+18 Physical Potential；Confirm 後 Training 仍顯示 Physical 10、Cognitive 0、Communication 0，而不是更新後餘額。其後 Read 20 minutes 的 self-report（測試用途，沒有閱讀）預覽 +18 Cognitive Potential，Confirm 後同一 Training 頁仍顯示 10/0/0。見 [14](screenshots/2026-10-06-438c6eb/14-exercise-quest-added.png)、[15](screenshots/2026-10-06-438c6eb/15-exercise-reward-preview.png)、[16](screenshots/2026-10-06-438c6eb/16-training-after-exercise.png)、[21](screenshots/2026-10-06-438c6eb/21-read-reward-preview.png)、[22](screenshots/2026-10-06-438c6eb/22-training-after-learning.png) | 獎勵預覽和 Training 餘額對不上；我不確定是否已入帳，因為畫面沒有明說需重新進頁／重開 App。沒有再點確認或手動改餘額。 | 強制結束再開 App，以玩家可用的方式確認保存。 |
| App 重開 / 重新整理 | 確認角色、獎勵保存與下一步 | `force-stop` 後重開先回 Splash，不是原 Training；點 Tap to start 回 Home，Mira 及 Walk、Exercise、Read 任務仍在。之後再用 Walk 10 minutes self-report（測試用途，未實際走路）並確認 +10；確認後 Training 顯示 Physical 38、Cognitive 18、Communication 0。這個總數與本次預覽的三筆 (+10、+18、+10 Physical；+18 Cognitive) 相加一致；本次沒有單獨觀察「重開後、再次確認 Walk 前」的 Training 餘額，因此不把刷新歸因於其中某一操作。見 [23](screenshots/2026-10-06-438c6eb/23-after-process-restart.png)、[24](screenshots/2026-10-06-438c6eb/24-relaunch-next-screen.png)、[27](screenshots/2026-10-06-438c6eb/27-walk-reward-after-relaunch.png)、[28](screenshots/2026-10-06-438c6eb/28-training-fresh-after-reward.png) | 資料有保留，但重新啟動每次要回 Splash；獎勵確認後餘額一度仍顯示舊數字，玩家不能確定是否入帳。 | 以實際畫面顯示的 38 點執行 Physical 訓練。 |
| Physical 訓練 | 查看成本、扣款與屬性成長 | Reaction Drill 實際成本 20 Physical；操作前餘額 38，畫面目標 Processing 12→13；按 Train Processing 後 Training 顯示 Physical 18、Cognitive 18、Communication 0，Processing 13→14 及「Training complete. Your attribute grew permanently.」；Character 顯示 Processing 13（+1 trained）。見 [28](screenshots/2026-10-06-438c6eb/28-training-fresh-after-reward.png)、[29](screenshots/2026-10-06-438c6eb/29-physical-training-result.png)、[30](screenshots/2026-10-06-438c6eb/30-character-after-physical.png) | 扣 20 後餘 18，前後值和永久成長訊息清楚，角色頁稍後能看到 +1。 | 看 Analysis drill 報價與 Cognitive Potential。 |
| Learning / Analysis 訓練 | 累積 Cognitive、查看成本並訓練 Analysis | Read 20 minutes 顯示 +18 learning XP、+18 Cognitive Potential；首次確認後重開已見 Cognitive 18。為重新進入 Training 又重複 Read 測試自我回報，預覽仍寫 +18，但 Training 顯示 Cognitive 仍 18，沒有變成 36。Function Analysis Drill 顯示 Analysis 12→13、Aptitude 6/6、cost 16 Cognitive；按 Train Analysis 後 Training 卡片顯示 Analysis 13→14 及完成 toast。見 [32](screenshots/2026-10-06-438c6eb/32-read-repeat-reward.png)、[33](screenshots/2026-10-06-438c6eb/33-training-after-repeat-read.png)、[34](screenshots/2026-10-06-438c6eb/34-analysis-drill-details.png)、[35](screenshots/2026-10-06-438c6eb/35-analysis-training-result.png) | 成本比 18 餘額少 2，操作可用。第二次同一 Read 任務的 +18 預覽沒有反映到餘額；我不能從 UI 判斷是重複任務限制還是確認／刷新問題。 | 查看 Character 的持久屬性，再進 Adventure 比對戰鬥 modifier。 |
| Character 訓練回饋 | Character 應呈現訓練後 Analysis | 第一次從 Training 切至 Character 時仍看到 Analysis 12，而非剛才卡片的 13；同頁 Processing 13 正確。戰鬥勝利後再打開 Character，Analysis 顯示 13（+1 trained），Processing 亦為 13（+1 trained）。見 [36](screenshots/2026-10-06-438c6eb/36-character-after-analysis.png)、[37](screenshots/2026-10-06-438c6eb/37-character-analysis-stat.png)、[61](screenshots/2026-10-06-438c6eb/61-character-after-battle.png) | 不是訓練操作失敗：後續畫面顯示 +1；但剛訓練完立即切頁時數字過期，令我懷疑訓練未保存。 | 用實際戰鬥檢查 Analysis modifier / Function 分析。 |
| Adventure / Chapter One / Deck | 完成五段故事與六張牌組，得到下一步 | Adventure 初始為 0/5；點 Continue Adventure 逐段前進。在 Function Theory 的 Function Graph 依提示點 Gather、Shape、Move 三個節點，三次觸控後畫面沒有可見的選取狀態或說明改變，之後按 Continue 前往下一段。完成故事敘述與 Full Chant and Chantless，選六張牌 Arc Bolt、Focused Shot、Energy Burst、Barrier、Deflect、Step Shift，Confirm Prepared Deck。完成頁顯示 Chapter One complete、牌組已保存，指示練習閱讀敵方 Function，並有 Start Ashfang Training Battle 主按鈕。見 [38](screenshots/2026-10-06-438c6eb/38-adventure-entry.png)、[42](screenshots/2026-10-06-438c6eb/42-function-theory.png)、[43](screenshots/2026-10-06-438c6eb/43-function-graph-gather.png)、[44](screenshots/2026-10-06-438c6eb/44-function-graph-move.png)、[46](screenshots/2026-10-06-438c6eb/46-prepared-deck-step.png)、[47](screenshots/2026-10-06-438c6eb/47-deck-selected.png)、[49](screenshots/2026-10-06-438c6eb/49-chapter-complete.png) | 故事結束給出具體的可操作下一步。Function Graph 的點選提示沒有帶來可見互動回饋，沒有形成 aha；初次 Adventure 概覽底部 Continue Adventure 按鈕被固定底導覽遮掉一部分，需先滑動頁面才看清／操作。故事教學中途有英中混用，語言切換突兀。 | 啟動 Ashfang Training Battle。 |
| Ashfang 回合與弱點 | 攻擊、結束回合，分析並中斷 LockTarget，檢查戰鬥狀態保存 | Encounter 明示 `ashfang-training-2 · illustrative-inputs-awaiting-playtest`。Round 1，Hero Analysis modifier +5、HP 24/24；Ashfang 依序顯示 DetectTarget → LockTarget → Pounce、HP 16/16。Attack Ashfang 一次後 End turn，Ashfang HP 8/16；提供 Analyze Weak Node、Resolve Pounce，Interrupt LockTarget 初始 disabled。Force-stop / 重啟，回 Splash；返回 Adventure 的 5/5 完成頁再開戰鬥，恢復 Round 1、Hero 24/24、Ashfang 8/16 與相同待處理 Function。Analyze Weak Node 後畫面顯示 `Weak Node revealed: LockTarget` 及「Interrupting this node cancels downstream Pounce」；Interrupt 後 Round 2 ACTIVE，畫面明示 Pounce cancelled，Attack / End turn 可用。見 [50](screenshots/2026-10-06-438c6eb/50-ashfang-battle-start.png)、[52](screenshots/2026-10-06-438c6eb/52-battle-end-turn.png)、[53](screenshots/2026-10-06-438c6eb/53-battle-relaunch.png)、[57](screenshots/2026-10-06-438c6eb/57-battle-after-resume.png)、[58](screenshots/2026-10-06-438c6eb/58-analyze-weak-node.png)、[59](screenshots/2026-10-06-438c6eb/59-locktarget-interrupted.png) | 狀態恢復精確，弱點提示到取消結果的因果清楚。Interrupt 前需先分析，這個 disabled 狀態搭配後續提示足夠可理解。測試期間不需重複點擊。 | 再攻擊一次完成遭遇。 |
| 勝利 | 結束戰鬥並確認回饋 | Round 2 再按 Attack Ashfang；畫面顯示 VICTORY、Ashfang HP 0/16、Hero HP 24/24，文字「Ashfang is defeated. The Weak Node changed the battle.」及「Training encounter complete」「Your trained Analysis informed the Weak Node interaction. Battle state is saved.」見 [60](screenshots/2026-10-06-438c6eb/60-final-battle-attack.png) | 勝利因果與下一個設計意圖易懂。戰鬥中顯示 Analysis modifier +5；由於沒有訓練前的戰鬥基線，無法證明此 +5 是因訓練增加多少。 | 查看 Character 最終值，結束。 |

## P0–P3 問題

以下 severity 依玩家影響判定；沒有推測內部原因。

| ID / Severity | 問題與證據 | 重現步驟 | 影響 / 建議 |
|---|---|---|---|
| RP-01 · **P1** | 確認 Life Quest 獎勵後，當前 Training 頁仍顯示舊 Potential（Physical 10/Cognitive 0），儘管前一頁已呈現 Exercise +18 Physical 與 Read +18 Cognitive。重開 App 並再確認 Walk 後，餘額才顯示 Physical 38/Cognitive 18。 | 乾淨資料建立角色 → Walk self-report / Confirm → Training 記錄 10/0/0 → 返回完成 Exercise self-report / Confirm → Training 仍 10/0/0；再完成 Read self-report / Confirm 仍 10/0/0；force-stop/relaunch、再次完成 Walk / Confirm，Training 顯示 38/18/0。圖 [16](screenshots/2026-10-06-438c6eb/16-training-after-exercise.png)、[22](screenshots/2026-10-06-438c6eb/22-training-after-learning.png)、[28](screenshots/2026-10-06-438c6eb/28-training-fresh-after-reward.png)。 | 玩家無法判斷獎勵有沒有入帳，可能退出成長循環或重複領取／操作。建議讓 Confirm 後的總額即時一致，或在確認頁明確說明入帳狀態。 |
| RP-02 · **P1** | 同一 Learning Read 的 +18 Cognitive reward preview 可以再次出現，但確認後 Training 仍是 Cognitive 18（非 36）；UI 未告知此重複任務是否受限。 | 已有一次 Read +18 後，重新從 Life 清單 Start Read 20 minutes → self-report → 確認 +18 → Training 查看 Cognitive。圖 [32](screenshots/2026-10-06-438c6eb/32-read-repeat-reward.png)、[33](screenshots/2026-10-06-438c6eb/33-training-after-repeat-read.png)。 | 對獎勵語意／重複任務規則造成疑問。需讓重複任務預覽、確認後入帳總額一致，或明確標示限制。此為畫面觀察，原因未驗證。 |
| RP-03 · **P2** | Character 在訓練後第一次切入仍顯示 Analysis 12；之後重新查看才顯示 13（+1 trained）。 | Training 按 Train Analysis，查看 Training 卡片已變為 13→14；立即切 Character 看到 Analysis12；勝利後再切 Character 看到13。圖 [35](screenshots/2026-10-06-438c6eb/35-analysis-training-result.png)、[36](screenshots/2026-10-06-438c6eb/36-character-after-analysis.png)、[61](screenshots/2026-10-06-438c6eb/61-character-after-battle.png)。 | 暫時不一致使玩家懷疑訓練是否保存。建議訓練完成後相鄰頁面立即顯示同一個屬性值。 |
| RP-04 · **P2** | 初次 Adventure overview 的主要 Continue Adventure CTA 部分落在固定底部導覽後方；需捲動才完整可見。 | 乾淨安裝首次進 Adventure，在頁面頂端觀察底部；向上滑後按 Continue Adventure。圖 [38](screenshots/2026-10-06-438c6eb/38-adventure-entry.png)、[39-adventure-scroll](screenshots/2026-10-06-438c6eb/39-adventure-scroll.png)。 | 新玩家可能看不出主要按鈕完整存在；需讓 CTA 在導覽上方可視／可觸及。 |
| RP-05 · **P2** | Character Builder 同時出現 Base 8 與 Base 12。 | 建立新角色，在配置頁比較標頭與每項屬性的 base 文案。圖 [05](screenshots/2026-10-06-438c6eb/05-character-builder.png)。 | 讓人困惑屬性預設值與可配置點數的關係；建議用一致詞句說明 Base、配置點與最終值。 |
| RP-06 · **P3** | Adventure 故事教學有中英混用。 | 完成至 Function Theory / Full Chant and Chantless，閱讀同一畫面內中文與英文段落。圖 [42](screenshots/2026-10-06-438c6eb/42-function-theory.png)、[45](screenshots/2026-10-06-438c6eb/45-next-adventure-scene.png)。 | 不阻止完成，但會打斷閱讀節奏；統一同一玩家流程的語言。 |
| RP-07 · **P2** | Function Theory 說明點選節點查看術式作用，但點 Gather、Shape、Move 後沒有可見的選取狀態或節點細節。 | 在 Function Theory 依序點三個圓形節點並比較畫面，再按 Continue 才進入下一段。圖 [43](screenshots/2026-10-06-438c6eb/43-function-graph-gather.png)、[44](screenshots/2026-10-06-438c6eb/44-function-graph-move.png)。 | 互動提示沒有產生回饋或 aha；玩家可能以為沒點到或圖只是裝飾。建議讓點選結果可見，或改成明確的靜態說明。 |

沒有觀察到 crash、按鈕需要重複點擊、觸控無反應或戰鬥卡住。未以無障礙工具測試觸控熱區尺寸，故熱區尺寸仍未驗證。

## Todo-App Risk

**Risk 1 / 4 — Slight risk。** Life Quest、Character、Training、故事、牌組與可操作戰鬥串成明顯 RPG payoff；Weak Node 中斷帶來具體回合決策，不是只有任務紀錄換裝飾。Life Quest／Training 頁仍有 utility UI 感，且獎勵確認後餘額未即時同步會削弱信任；但本次仍看到角色成長、Chapter One 與戰鬥勝利，符合 skill 所述「有一些 utility 畫面，但有強遊戲回饋」。 |

## Critical MVP Questions

1. **我認為這是什麼？** 真實生活行動推動角色成長，並進入魔法學院故事與戰鬥的 RPG。
2. **我第一步要做什麼？** 清楚：Home 主按鈕指向 Choose a Life Quest。
3. **為什麼要做生活任務？** 遊戲給的理由是 Life Quest 獎勵能成為 Growth Potential、永久屬性與 RPG build；這個成長方向本身有吸引力，但獎勵餘額沒有即時更新後，我個人的持續動機變得猶豫。
4. **做完後 RPG 哪裡改變？** Processing 成長 +1，Analysis 最後顯示 +1 trained，能分析並中斷 Ashfang Weak Node；獎勵確認後的舊餘額讓成長回饋斷裂。
5. **我懂 Training 嗎？** 大致懂；類別餘額、成本、Aptitude、屬性前後值與不足點清楚。
6. **我懂 build 為何重要嗎？** Function Analysis Drill 說 build focus 是 reveal enemy Function Weak Nodes；本次戰鬥用 Weak Node 中斷 LockTarget。Builder 的 Base 8／Base 12 仍有矛盾感。
7. **戰鬥感覺像真正遊戲嗎？** 有回合、HP、敵方行動序列及弱點中斷，像可玩的回合制戰鬥原型；單一示範 encounter 且標示 illustrative，尚不足以判定完整遊戲感。
8. **Function Graph 有 aha 嗎？** 沒有。依提示點三個節點後沒有可見反應；真正理解弱點因果是在 Ashfang encounter 分析出 LockTarget 時。
9. **有沒有像 Todo app 加 RPG 皮？** Life Quest 清單／自我回報偏 utility，但其後 Training、故事、牌組與 Weak Node 戰鬥提供強遊戲回饋，所以整體不只是換皮任務清單。
10. **我明天會回來嗎？** Maybe, but hesitant；弱點戰鬥吸引人，任務餘額不同步使我擔心投入是否有保存。
11. **我是否理解生活行動不會取代戰鬥？** **未驗證**：本次走到獨立 Ashfang encounter，但沒有在 onboarding 後直接詢問或測試玩家是否把真實行動誤認為戰鬥替代品。

### 戰鬥後問題

1. **我為何贏？** Round 1 攻擊使 Ashfang 到 8/16；分析出 LockTarget 並中斷後，畫面說 Pounce cancelled；Round 2 再攻擊使 Ashfang 到 0/16。
2. **什麼錯誤可能讓我輸？** **未驗證**：本次沒有選 Resolve Pounce 分支，也沒有測敗北條件或敵方傷害結果。
3. **Analysis 揭露什麼？** Weak Node: LockTarget。
4. **Weak Node 是什麼？** LockTarget。
5. **我是因理解敵人還是只點最高數字？** 我先分析再中斷，並依照畫面提示操作；這次選擇是基於我理解到的因果，不是只選最大傷害數字。
6. **第二場 encounter 會否帶來新決策？** **未驗證**：沒有第二場 encounter 可比較。

## Best / Worst Moment

- **Best moment：** 分析出 LockTarget 後按 Interrupt，遊戲清楚寫出 Pounce 被取消並立即回到 Round 2，可接著攻擊；因果鏈易懂，勝利回饋也具體。
- **Worst moment：** 我剛確認 +18 任務獎勵，但 Training 還是顯示原本 10/0/0；像是努力沒有被記錄。重開再做一次任務才看見更新。

## Would I Return Tomorrow?

**Maybe, but hesitant.** Home 的入口與任務／戰鬥方向有吸引力，勝利後能看懂弱點分析的用途；但任務獎勵餘額在確認後未即時更新，會讓我擔心明天投入也不會留下進度。

## Top 3 Fixes（玩家優先順序）

1. **P1：** Confirm reward 後即時刷新 Potential，並讓獎勵預覽、實際入帳、Training 餘額保持一致；明示重複完成任務的獎勵規則。
2. **P2：** Training 完成後立即同步 Character 屬性值，不要先顯示舊 Analysis，再於稍後才顯示 13。
3. **P2：** 修正 Adventure CTA 與底部導覽的遮擋，並澄清 Character Builder 的 Base 8 / Base 12 文案。

Function Graph 節點沒有可見回饋（RP-07，P2）也應納入後續修整；因 Top 3 先列出回饋可信度、屬性即時同步與主要章節入口可視性，Graph 回饋列為下一項。

## 未驗證項目與範圍限制

- 實體 Android 手機與非模擬器裝置；本次只有 Pixel_10a AVD。
- App Store／release build、production sign-in、網路同步、多使用者或跨裝置資料。
- 訓練前的 Ashfang battle modifier，故 Analysis 13 對 modifier +5 的數值增量未驗證。
- 重新安裝清除以外的完整資料重設以外狀態；本次資料以 `pm clear` 後安裝建立。
- 背景／前景切換、OS process eviction、長時間離線、timer 實際 10／20 分鐘等待、系統字體放大、TalkBack、橫向與其他解析度。
- 通話、語言等尚未操作的 Life Quest；Function Analysis Tutorial 獨立入口沒有另行走一遍（本次實際完成 Chapter One 並走 Ashfang encounter）。
- Life Quest 的 skip、reschedule、rest 流程未操作。
- 玩家是否清楚生活行動不會取代戰鬥，未直接詢問或測試。
- 戰鬥平衡、戰鬥輸入代表性與真實玩家偏好；App 自己明示 `illustrative-inputs-awaiting-playtest`，本報告僅評估本次實際操作回饋。
