# Astraea App Visual Asset Backlog v1

**Status:** Active generation queue  
**Owners:** Astraea Orchestrator + UI/UX Director + Vision Guardian + Visual Asset Director  
**Protocol:** Clean-room Image Generation Protocol  
**Rule:** one asset / one isolated image context

## 1. Audit Summary

Runtime image assets currently integrated in the repository:

- `assets/images/combat/combat_bg_astraea_training_hall_v01.webp`
- `assets/images/combat/enemy_ashfang_training_v01.webp`

A larger set of prior generated Astraea visuals exists in the user's Library. Those are treated as candidate references, not automatically approved runtime assets.

Decision classes:

- **REUSE** — good enough to convert/integrate without regeneration
- **REFERENCE_EDIT** — identity/direction is good; clean-room edit should adapt it for runtime use
- **NEW_GENERATION** — no suitable prior reference exists
- **FLUTTER_UI** — should remain native/vector/stateful, not generated
- **DEFER** — not needed for current first playable

---

## 2. P0 — First Playable / Product Identity

| Asset | Placement | Decision | Reference / source | Priority |
|---|---|---|---|---|
| Academy Arrival / Gate environment | Splash, Onboarding, Adventure Scene 1 | REFERENCE_EDIT | `雲巔星環魔法學院.png` or `陽光魔法學院廣場.png` | P0 |
| Saeki Yuma neutral portrait | Story / dialogue / Adventure | REFERENCE_EDIT | `金色學院中的星圖少年.png` | P0 |
| Kamiya Rio neutral portrait | Story / dialogue / Analysis identity | REFERENCE_EDIT | `魔法學院的星象解析者.png` | P0 |
| Asakura Hina neutral portrait | Story / dialogue / Chantless lesson | REFERENCE_EDIT | `赤焰魔法學院的星紋少女.png` | P0 |
| Professor Tachibana neutral portrait | Story / prologue / theory lesson | REFERENCE_EDIT | `星圖大廳中的沉思教授.png` | P0 |
| Training Hall battle background | Combat | REUSE | already integrated | DONE |
| Ashfang Training Construct | Combat | REUSE | already integrated | DONE |

### P0 non-image decisions

Do **not** generate:

- player Hero fixed portrait — player identity is customizable
- HP / Mana bars
- Action Timeline
- Function Graph
- Reaction overlay
- target markers
- Analysis nodes
- Weak Node indicator
- combat labels
- navigation / cards / buttons

These stay native Flutter.

---

## 3. P1 — Vertical Slice Polish

### Environments

| Asset | Placement | Decision | Reference |
|---|---|---|---|
| Function Theory lecture hall | Story Scene 3 / Scene 4 | REFERENCE_EDIT | `魔法學院的星象講堂.png` |
| Spell Card laboratory | Story Scene 5 / Deck tutorial | REFERENCE_EDIT | `魔法學院的星卡煉金室.png` |
| Academy library | Later Adventure / knowledge scenes | REUSE / light edit | `星辰穹頂下的魔法圖書館.png` |

### Enemy

| Asset | Placement | Decision | Reference |
|---|---|---|---|
| Arcane Sentry Mk-I isolated enemy | Scene 6 / later battle | REFERENCE_EDIT | `星輝聖殿的機械聖騎士.png` |

### Starting weapons

Existing standalone references are strong enough to reuse after runtime conversion:

- Astraea Longsword → `星辉罗盘华丽长剑.png`
- Standard Spear → `星輝天穹秘銀長槍.png`
- Training Arcane Gun → `星環秘術能量手炮.png`
- Standard Staff → `星環水晶星象法杖.png`

Decision: **REUSE**. No regeneration unless integration review finds crop/background problems.

### MVP Spell artwork

| Spell | Decision | Current candidate |
|---|---|---|
| Arc Bolt | REFERENCE_EDIT | `星辉魔导师的蓝焰一击.png` |
| Focused Shot | REFERENCE_EDIT | `Celestial Sharpshooter’s Perfect Arc.png` |
| Energy Burst | REFERENCE_EDIT | `紫藍魔法爆裂的學院庭院.png` |
| Barrier | REFERENCE_EDIT | `星芒結界抵禦紫焰光束.png` |
| Deflect | REFERENCE_EDIT | `銀髮魔導士的星環反擊.png` |
| Step Shift | REFERENCE_EDIT | `星輝瞬影：銀髮魔法疾馳.png` |
| Weak Node Scan | REFERENCE_EDIT | `星環鎖定：魔導核心解析.png` |
| Mana Stabilize | NEW_GENERATION | none accepted |
| Interrupt Pulse | REFERENCE_EDIT / NEW if edit fails | `魔法學院的星環破滅.png` candidate |

Spell artwork rules:

- artwork only
- no card frame
- no spell name
- no Mana number
- no HUD
- no baked localized copy
- generic caster should not accidentally become a canonical named character
- if a prior reference contains a strong identifiable caster, edit toward effect-first composition or crop safely

---

## 4. P2 — Story / Marketing Depth

Generate only after first playable proves the visual language:

- childhood rescue cinematic
- Astraea title / key art
- dormitory / social scene background
- additional story event illustrations
- character expression variants
- character combat cut-ins
- Last Spell artwork
- Aberration enemy family concepts
- Mio portrait / boss identity — **deferred because of spoiler boundary**
- Institute Zero visuals — **deferred**

---

## 5. Screen-by-Screen Image Policy

### Splash / Onboarding

Use Academy Arrival / Gate environment.
Do not bake logo or localized text into the image.

### Home

Reuse academy environment as subtle hero art if needed.
Do not generate dashboard decoration.

### Life Quest

No generated image required for core UX.
Utility clarity takes priority.

### Character Creation

Use weapon assets.
Do not lock the player's appearance with a fixed generated protagonist.

### Character Profile / Training

Optional character silhouette / future avatar system.
No P0 generated image required.

### Adventure / Story

Use environment background + named-character portraits.

### Prepared Deck

Use Spell artwork thumbnails only after P1 spell-art clean-up.
Card chrome and labels remain Flutter.

### Function Lab

Function graph remains Flutter/vector.
Optional educational spell artwork may appear beside it, but does not replace the graph.

### Combat

Existing Training Hall and Ashfang art remain runtime content.
Combat interaction and VFX stay Flutter.

---

## 6. Generation Order

### Batch P0-A — start now

1. Academy Arrival / Gate environment
2. Saeki Yuma portrait
3. Kamiya Rio portrait
4. Asakura Hina portrait
5. Professor Tachibana portrait

Each task is a separate clean-room image job.

### Batch P1-A

6. Function Theory lecture hall clean background
7. Spell Card laboratory clean background
8. Arcane Sentry Mk-I isolated enemy

### Batch P1-B

9–17. nine MVP Spell artworks

### Batch P2

Only after first playable visual review.

---

## 7. Acceptance Rule

Every generated/edited result must be classified:

```text
PASS_RUNTIME
REJECT_RUNTIME
REFERENCE_ONLY
```

Only `PASS_RUNTIME` may be converted and added to `pubspec.yaml`.
