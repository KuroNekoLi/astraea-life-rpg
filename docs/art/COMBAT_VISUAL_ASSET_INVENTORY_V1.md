# Combat Visual Asset Inventory v1

**Status:** Phase 2 asset brief  
**Owner:** `astraea-visual-asset-director`  
**Generation:** ChatGPT Images 2.5 when appropriate

This inventory lists visual-content assets that may materially improve the first CTB Ashfang battle.

Functional HUD elements remain native Flutter.

## P0 — Required for the first high-fidelity playable

### 1. Training Hall Battle Background

**ID:** `combat_bg_astraea_training_hall`  
**Type:** landscape background  
**Target:** battlefield center  
**Needs generation:** YES

Purpose:

- establish Astraea Academy identity
- provide readable combat depth
- leave the center clear for actors
- support Near / Mid / Far without drawing literal lanes

Constraints:

- no HUD
- no text
- no characters
- no giant foreground obstruction
- low visual noise behind actors
- academy fantasy, not sci-fi laboratory
- landscape crop safe from 16:9 through 20:9

### 2. Ashfang Training Construct

**ID:** `enemy_ashfang_training`  
**Type:** enemy battle illustration / sprite-like transparent asset  
**Needs generation:** YES

Gameplay read:

- Primary Aggressor
- Secondary Caster
- academy training construct
- capable of physical pounce and constructed Fireball

Constraints:

- clear silhouette at mobile combat size
- readable front/three-quarter stance
- no baked health bar
- no text
- no background if transparent generation is viable
- magical training construct, not robotic sci-fi mech

## P1 — Strong polish after P0 is integrated

### 3. Fireball SC Artwork

`spell_fireball_cast`

Reusable spell artwork only.

No frame / name / Mana / UI.

### 4. Weak Node Scan Artwork

`spell_weak_node_scan_reveal`

Shows magical structure and an authored vulnerability.

Must not resemble hacking UI.

### 5. Rio Analysis Cut-In

`cutin_rio_analysis`

Only after canonical character appearance references are confirmed.

Do not generate if character identity is not sufficiently specified.

## Not generated

These remain Flutter:

- Action Timeline
- bars
- buttons
- enemy Intent ribbon
- Prepared SC frame
- Reaction overlay
- Function Graph
- Zone overlay
- targeting
- status icons
- localization text
