# Combat P0 Visual Asset Briefs v1

**Status:** Ready for generation after Combat v1 layout verification  
**Owner:** `astraea-visual-asset-director`  
**Generator:** ChatGPT Images 2.5 when available

## Asset 01 — Astraea Training Hall Battle Background

**ID:** `combat_bg_astraea_training_hall_v01`  
**Type:** battle background  
**Target placement:** `BattlefieldViewport`  
**Aspect:** wide landscape, crop-safe from 16:9 through 20:9  
**Transparency:** no

### Purpose

Make the first battle feel like it occurs inside Astraea Academy rather than on a generic gradient while keeping combat silhouettes and Function overlays readable.

### Must communicate

- prestigious fantasy magic academy
- dedicated practical spell-training arena
- structured magic exists in this world
- safe controlled training environment
- enough depth for Near / Mid / Far abstraction

### Must show

- wide training floor
- arcane architectural motifs
- subtle magical geometry embedded into the environment
- academy structure / columns / elevated observation elements
- readable center area with restrained detail

### Must not show

- characters
- enemies
- HUD
- text
- buttons
- card frame
- giant explicit Near / Mid / Far labels
- cyberpunk screens
- hacking terminals
- modern laboratory equipment
- watermark

### Composition

- central combat area remains open
- strongest architectural detail toward upper/background edges
- lower center remains readable behind actors
- left and right edges remain crop-safe
- no large foreground prop covering combatants

### Prompt

```text
Create exactly ONE independent image.

ASSET TYPE:
Landscape battle background for a mobile Japanese fantasy academy RPG.

LOCATION:
Astraea Academy practical magic training hall.

PURPOSE:
This is the battlefield background for a tactical JRPG encounter against a magical training construct. The center must remain visually readable behind characters and native Flutter combat UI.

SCENE:
A prestigious indoor academy combat arena with deep midnight-blue architecture, elegant stone and magical materials, tall structural arches, elevated observation galleries, and restrained warm-gold academy accents.

MAGICAL WORLD LANGUAGE:
Subtle layered arcane circles, thin geometric magical relationships, and structured magical markings are embedded into the architecture and training floor. They should suggest that magic has an underlying executable structure, but they are environmental motifs rather than a user interface.

COMPOSITION:
Wide landscape composition.
Open central training floor.
Clear foreground / midground / background separation.
Keep the central and lower-middle region relatively low-detail for battle silhouettes.
Important architecture should remain crop-safe from 16:9 through 20:9.
No giant foreground object.

STYLE:
Polished high-quality Japanese fantasy RPG environment artwork.
Academy fantasy, mysterious but welcoming.
Midnight / starlight / restrained gold visual language.
Painterly game-art finish with clear readable forms.

DO NOT DRAW:
characters
enemy
HUD
text
numbers
buttons
card frame
health bars
near/mid/far labels
cyberpunk hacking interface
computer terminal
modern science laboratory
watermark
```

### Acceptance

- canon: PASS if it reads as Astraea Academy without inventing lore
- mechanic fidelity: PASS if the battlefield supports abstract depth without literal lanes
- readability: PASS if actor silhouettes remain clear
- UI separation: PASS only if no baked UI/text exists

---

## Asset 02 — Ashfang Training Construct

**ID:** `enemy_ashfang_training_idle_v01`  
**Type:** enemy combat illustration / sprite-like cutout  
**Target placement:** `BattlefieldActor`  
**Aspect:** roughly square / portrait subject within transparent canvas  
**Transparency:** preferred

### Purpose

Give the tutorial enemy an immediately readable identity matching its dual role:

```text
Primary: Aggressor
Secondary: Caster
```

### Must communicate

- academy training construct
- animal-like pouncing physical threat
- capable of constructing magic
- controlled training equipment rather than wild monster
- recognizable silhouette on a small phone battlefield

### Must show

- quadruped or strongly bestial magical construct silhouette
- forward-ready stance
- a few restrained arcane structural seams / nodes
- one visually plausible magical focusing structure for casting
- durable training-build materials

### Must not show

- sci-fi robot
- firearm
- military drone
- giant armor clutter
- spell already exploding
- Weak Node highlighted
- UI
- HP bar
- name
- text
- watermark

### Prompt

```text
Create exactly ONE independent enemy game asset.

ENEMY:
Ashfang Training Construct.

ROLE:
A magical training construct used by Astraea Academy.
Primary combat archetype: Aggressor.
Secondary combat archetype: Caster.

SUBJECT:
A bestial quadruped magical construct in a tense ready stance, built to lunge or pounce at students during controlled combat training while also being capable of constructing basic Fireball Functions.

GAMEPLAY READ:
The silhouette must immediately suggest fast physical pressure and pouncing movement.
A restrained magical focusing structure should make it believable that this construct can also perform structured spell construction.

DESIGN LANGUAGE:
Japanese fantasy academy RPG.
Constructed from elegant enchanted training materials rather than industrial machinery.
Subtle luminous arcane seams, a small number of meaningful nodes, and structured magical geometry integrated into the body.
The magical elements should feel arcane and academic, not cyberpunk.

COMPOSITION:
Full body visible.
Three-quarter battle-facing stance.
Strong readable silhouette.
Designed to remain recognizable when displayed relatively small on a landscape mobile battlefield.
Keep limbs separated visually.
Transparent background if supported.

COLOR / MATERIAL DIRECTION:
Dark academy-night materials with restrained starlight magical accents and small warm-gold training details.
Avoid excessive glow.

DO NOT DRAW:
background scene
HUD
health bar
nameplate
text
numbers
Weak Node highlight
generic red target marker
modern robot
mech
military drone
firearm
cyberpunk hacking interface
watermark
```

### Acceptance

- canon: no unapproved story identity
- gameplay: Aggressor + Caster reads without explanation
- mobile readability: clear at reduced size
- Function identity: magical structure visible but not a UI
- transparency: preferred for direct Flutter compositing
