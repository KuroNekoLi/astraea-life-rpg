# Ashfang Balance Test Sheet v0.1

**狀態：** 第一組可執行的數值 benchmark；不是最終平衡值
**用途：** 以固定數值跑完整場戰鬥，檢查主要策略、Mana 節奏、Timeline 與 Interrupt / Analysis 協作。
**關聯規格：** [`COMBAT_RULES_V1_BASELINE.md`](COMBAT_RULES_V1_BASELINE.md)

本表數值是第一輪測試輸入。下方戰鬥流程是 **scripted hand simulation**，用來檢查數值和資源帳是否能形成預期體驗；它不是遊戲執行結果，也不代表已完成實機或玩家測試。先保留這組值，透過 prototype 和 dominant-strategy tests 收集證據後再調整。

## Sheet 1 — Encounter Overview

| 項目 | v0.1 目標 |
|---|---|
| Encounter | Hero + Yuma + Rio vs Ashfang Training Construct |
| 定位 | 第一場完整 Combat Vertical Slice |
| 預期戰鬥時間 | 2–4 分鐘 |
| Party Main Actions | 11–12；目標範圍 8–15 |
| 核心測試 | Timeline、Mana、Chantless、Full Chant、Interrupt、Analysis、Stability、Zones |
| Last Spell | 本場不使用 |
| 勝利條件 | Ashfang HP = 0 |
| 失敗條件 | Party 全滅 |
| 主要問題 | 是否存在明顯 dominant strategy？ |

這場正常戰只要求玩家處理一個主要問題：Ashfang 的 Full Chant Fireball。玩家可 Interrupt、Guard 或調整位置，不需要把所有系統都用一遍。

## Sheet 2 — Actors

### 第一組基準值

| Actor | HP | Mana | Phys Res | Magic Res | Control Res | Mana Output | Efficiency | Precision | Processing | Start Zone | Base Delay |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| Hero | 220 | 100 | 20 | 18 | 20 | 58 | 55 | 52 | 50 | Mid | 100 |
| Yuma | 180 | 110 | 14 | 24 | 26 | 50 | 60 | 68 | 62 | Far | 95 |
| Rio | 170 | 120 | 12 | 30 | 30 | 42 | 65 | 72 | 70 | Mid | 90 |
| Ashfang | **510** | 100 | 28 | 20 | 22 | 52 | 45 | 40 | 42 | Mid | 105 |

Ashfang 的 **510 HP** 是本版主要 benchmark，目標是讓遭遇約需 11–12 個 Party Main Actions，而不是讓三次攻擊就結束。屬性欄位只記錄測試輸入；相關成長屬性如何轉換成輸出或公式仍需另外定義。

## Sheet 3 — Damage Formula

v0.1 暫用 diminishing-returns 曲線：

```text
FinalDamage = RawDamage × 100 / (100 + Resistance)
```

範例：Ashfang Magic Resistance = 20：

```text
90 × 100 / 120 = 75 final damage
```

Hero 的 Fireball I（Raw Magic Damage 90）對 Ashfang 造成 75。Ashfang Physical Resistance = 28 時：

```text
60 × 100 / 128 ≈ 47 final damage
```

因此 Hero 的 Basic Attack 約造成 47。小數如何取整、負 Resistance 如何處理尚未定案；本表顯示取整後的整數結果。

## Sheet 4 — Hero Actions

| Action | Type | Mana | Mana Gain | Raw | Delay | Cast Time | Stability | IP | Stability DMG | Range |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Basic Attack | Physical | 0 | **+10** | 60 | 100 | 0 | — | 10 | 0 | Near–Mid |
| Guard | — | 0 | **+6** | — | 90 | 0 | — | — | — | Self |
| Fireball I — Chantless | Magic/Fire | 14 | 0 | **90** | 95 | 0 | — | — | — | Mid–Far |
| Fireball I — Full | Magic/Fire | 14 | 0 | 118 | — | 55 | 38 | — | — | Mid–Far |
| Fireball II — Chantless | Magic/Fire | 24 | 0 | **100** | 105 | 0 | — | — | — | Mid–Far |
| Fireball II — Full | Magic/Fire | **24** | 0 | **150** | — | **90** | 48 | — | — | Mid–Far |
| Force Bolt I | Magic/Kinetic | 12 | 0 | 66 | 90 | 0 | — | **28** | **8** | Mid–Far |

Fireball II 對 Ashfang 的預期傷害：

```text
Chantless: 100 × 100 / 120 ≈ 83
Full Chant: 150 × 100 / 120 = 125
125 / 83 ≈ 1.51×
```

同 Spell 的 Full Chant / Chantless 比值落在目標 1.3–1.6×。這是本次 benchmark 的輸出比，不代表所有 SC 都必須遵循同倍率。

## Sheet 5 — Yuma Actions

| Action | Type | Mana | Mana Gain | Raw | Delay | 主要效果 |
|---|---|---:|---:|---:|---:|---|
| Basic Attack | Physical | 0 | +10 | 50 | 95 | 基礎攻擊 |
| Guard | — | 0 | **+6** | — | 88 | 減傷 |
| Blink I | Spatial | 10 | 0 | — | 80 | 最多移動 2 Zones |
| Position Swap I | Spatial | 14 | 0 | — | 95 | 交換 Position |
| Spatial Push | Magic/Spatial | **14** | 0 | **36** | 100 | Knockback 1 Zone |

Spatial Push 對 Ashfang：

```text
36 × 100 / 120 = 30 damage
Ashfang: Mid → Far
```

## Sheet 6 — Rio Actions

| Action | Type | Mana | Raw | Delay | IP | Stability DMG | 特殊效果 |
|---|---|---:|---:|---:|---:|---:|---|
| Basic Attack | Physical | 0 | 42 | 90 | 8 | 0 | +10 Mana |
| Guard | — | 0 | — | 85 | — | — | +6 Mana |
| Analysis I | Structural | **10** | — | **80** | — | — | Reveal Stability / Weak Node |
| Interrupt Shot | Physical Technique | 0 | **28** | Reaction | **50** | 6 | Interrupt Reaction |
| Arcane Interference | Magic/Structural | **14** | 18 | 95 | **38** | **14** | Weak Node bonus +15 IP |
| Barrier I | Structural | **16** | — | 90 | — | — | Shield **40** |

Interrupt Shot 是低傷害、高 immediate IP 的反應；Arcane Interference 傷害低、IP 較低，但能造成較高 Stability Damage。兩者應有不同用途。

## Sheet 7 — Ashfang Actions

| Action | Type | Mana | Raw | Cast | Stability | Delay / Recovery | 說明 |
|---|---|---:|---:|---:|---:|---:|---|
| Claw | Physical | 0 | 54 | — | — | 90 | Near |
| Lunge | Physical | 0 | 48 | — | — | 95 | Move 1 Zone + Attack |
| Fireball I Full Chant | Magic/Fire | **16** | 90 | **60** | **42** | Recovery 100 | Known Signature |
| Modified Fireball | Magic/Fire | **22** | 118 | **100** | **58** | Recovery 100 | Initially Unknown |
| Guard | — | 0 | — | — | — | 90 | +6 Mana |

## Sheet 8 — Tutorial Battle Simulation v0.1

這是預期的 scripted hand simulation。實際 Timeline 順序仍須由合法的 CTB 事件和 Reaction 規則產生；不得為了配合表格而暗中增加行動或改變規則。

| # | Actor / Event | Action | Mana | Ashfang HP | Stability | Zone / Result |
|---:|---|---|---|---:|---|---|
| 1 | Hero | Fireball I — Chantless | 100→86 | 510→**435** | — | 75 damage |
| 2 | Ashfang | Begin Fireball I Full Chant | 100→84 | 435 | **42** | Resolve pending |
| 3 | Rio Reaction | Interrupt Shot | 120 | 435→**413** | 50 ≥ 42 | **INTERRUPTED** |
| 4 | Rio | Basic Attack | 120→120 | 413→**380** | — | +10 capped at Max Mana |
| 5 | Yuma | Basic Attack | 110→110 | 380→**341** | — | +10 capped at Max Mana |
| 6 | Hero | Basic Attack | 86→**96** | 341→**294** | — | Mana recovery |
| 7 | Ashfang | Claw Hero | — | 294 | — | Hero 220→175 |
| 8 | Ashfang | Begin Modified Fireball | 92→70 | 294 | **58** | Unknown |
| 9 | Rio | Analysis I | 120→**110** | 294 | 58 revealed | Weak Node found |
| 10 | Yuma | Spatial Push | 110→**96** | 294→**264** | 58 | Mid→Far |
| 11 | Hero | Force Bolt I → Weak Node | 96→**84** | 264→**209** | 58→**50** | IP 48 < 58; no immediate break, 8 Stability Damage |
| 12 | Rio | Arcane Interference → Weak Node | 110→**96** | 209→**194** | 53 ≥ 50 | **INTERRUPTED** |
| 13 | Hero | Begin Fireball II Full Chant | 84→**60** | 194 | Player Casting | Resolve pending |
| 14 | Rio | Barrier I → Hero | 96→**80** | 194 | — | Shield 40 |
| 15 | Ashfang | Lunge → Hero | — | 194 | — | 40 damage absorbed |
| 16 | Resolve Event | Fireball II resolves | — | 194→**69** | — | 125 damage |
| 17 | Yuma | Guard | 96→**102** | 69 | — | Mana recovery + defense |
| 18 | Hero | Fireball I — Chantless | 60→**46** | 69→**0** | — | **FINISH** |

**Hand-check notes:** Ashfang's first Interrupt refunds 8 Mana (half of its 16 base cost), so its Mana is 92 before Modified Fireball. Force Bolt deals 55 final damage and reduces Stability by 8, but its IP 28 + Weak Node bonus 20 = 48 remains below 58. Arcane Interference has IP 38 + 15 = 53, which meets the reduced Stability 50. The second interruption refunds 11 Mana (half of 22); the sequence does not otherwise spend or recover Ashfang Mana.

## Interrupt sequence

### Known Fireball

```text
Fireball I Stability = 42
Rio Interrupt Shot IP = 50
50 ≥ 42 → immediate interrupt; no RNG
```

### Analysis and team Interrupt

Before Analysis, the modified spell's Stability and Weak Node are unknown. Analysis reveals Stability 58 and the **Stabilization** Weak Node. It does not automatically solve the encounter:

```text
Hero Force Bolt: IP 28 + 20 Weak Node = 48 (< 58)
                  Stability Damage 8 → Stability 58 to 50
Rio Arcane Interference: IP 38 + 15 Weak Node = 53 (≥ 50)
                         → interrupt
```

The intended experience is: Analysis reveals actionable information; one action weakens the Function without immediately breaking it; a teammate exploits that opening. This is a hypothesis to test, not evidence from a completed playtest.

## Sheet 9 — Result Summary (Projected)

| KPI | Projected result | Target | Status |
|---|---:|---:|---|
| Ashfang HP | 510→0 | — | Hand simulation completes |
| Party Main Actions | **12** | 8–15 | In range |
| Player Chantless casts | 2 | >0 | Both modes represented |
| Player Full Chant casts | 1 | >0 | Both modes represented |
| Interrupt attempts | **3** | — | One below threshold, two succeed |
| Interrupt successes | **2/3** | Not always / never | Scripted pattern achieved |
| Analysis uses | **1** | 0–1 in normal encounter | One use |
| Basic Attacks | **3** | Useful option | Mana recovery and damage |
| Guard uses | 1 | Optional | Used by Yuma |
| Last Spell | **0** | 0 | Deliberately excluded |
| Hero ending Mana | **46%** | Should not be depleted | Projected |
| Yuma ending Mana | **102/110 = 93%** | Observe | High; do not tune yet |
| Rio ending Mana | **80/120 = 67%** | Should not be depleted | Projected |

The 2/3 Interrupt rate is a scripted tutorial outcome, not a target for all encounters. The desired sequence is one immediate success, one attempt that only reduces Stability, followed by a teammate's successful Interrupt.

## Early observations — not tuning decisions

- **Yuma ends with nearly full Mana.** This encounter may not demand enough from her, or her position manipulation may be inexpensive / infrequent. Mark `OBSERVE IN TEST 0.2`; only adjust if the pattern repeats across several encounters.
- **Hero ends with 46 Mana after four SC uses.** That may be appropriate for a normal 2–4 minute encounter. If Hero repeatedly ends normal fights with 70–90% Mana, investigate whether Mana is too loose.
- **Fireball efficiency is comparable:** Fireball I Chantless is 75/14 ≈ 5.36 damage per Mana; Fireball II Full is 125/24 ≈ 5.21. Tier II buys higher single-use output and control ceiling, not strictly better efficiency, supporting continued use of lower Tiers.
- Do not change Ashfang HP or action values from this hand simulation alone. Validate them in the prototype and dominant-strategy passes first.

## Sheet 10 — Tuning Knobs v0.1

| Parameter | v0.1 | Candidate test range |
|---|---:|---:|
| Ashfang HP | **510** | 450–600 |
| Normal Action Delay | **100** | 90–110 |
| Fast Action | 80 | 70–90 |
| Slow Action | 130 | 120–150 |
| Basic Mana Recovery | **10** | 8–12 |
| Guard Mana Recovery | **6** | 4–8 |
| Normal SC Cost | 12–20 | 10–22 |
| Advanced SC Cost | 24–40 | 20–45 |
| Fireball II Full Cast Time | **90** | 70–120 |
| Fireball I Stability | **42** | 35–50 |
| Modified Spell Stability | **58** | 50–70 |
| Interrupt Shot IP | **50** | 45–60 |
| Arcane Interference Stability Damage | **14** | 10–18 |
| Barrier Shield | **40** | 30–50 |
| Interrupt refund | **50%** | Locked v1 rule |
| Last Spell requirement | 25% Max Mana | Not tested here |

Ranges are exploratory bounds, not promises that every value within them will be viable.

## Sheet 11 — Dominant Strategy Tests

| Test | Behavior | Question |
|---|---|---|
| DS-01 | Hero repeatedly uses Fireball I | Does Mana meaningfully constrain SC use? |
| DS-02 | Everyone only uses Basic Attack | Is SC use necessary or tactically useful? |
| DS-03 | Interrupt whenever possible | Is Interrupt always the best response? |
| DS-04 | Always use Chantless | Does Full Chant have a meaningful use case? |
| DS-05 | Always use Full Chant | Is its reward too high relative to cast risk and delay? |
| DS-06 | Everyone stays Far | Is Far an automatic best Zone? |
| DS-07 | Never Analyze Modified Fireball | Is Analysis valuable or merely optional bonus information? |
| DS-08 | Never Interrupt | Can Guard / positioning and other responses remain viable? |

## Sheet 12 — Playtest Log

| Build | Strategy | Win? | Duration | Main Actions | End Mana | Interrupt | Analysis | Problem | Next Change |
|---|---|---|---:|---:|---|---|---:|---|---|
| 0.1 | Intended Tutorial (hand simulation) | Projected | TBD | **12** | H46 / Y102 / R80 | 2/3 | 1 | Validate action order and play feel | None before first prototype run |
| 0.1 | Fireball spam | — | — | — | — | — | — | — | — |
| 0.1 | Basic only | — | — | — | — | — | — | — | — |
| 0.1 | Chantless only | — | — | — | — | — | — | — | — |
| 0.1 | Full Chant only | — | — | — | — | — | — | — | — |

Change one primary axis per iteration where possible. Use actual prototype observations to decide whether a tuning knob should move; do not treat the projected row as proof of balance.
