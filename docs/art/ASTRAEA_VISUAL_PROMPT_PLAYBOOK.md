# Astraea Visual Prompt Playbook

**Status:** Project-wide prompt and asset-production guide  
**Applies to:** Generated illustration and concept assets for Astraea Life RPG  
**Approved generation capability:** ChatGPT Images 2.5 when available in the active environment  
**Companion skill:** `skills/astraea-visual-asset-director/SKILL.md`

This document standardizes how Astraea agents brief, generate, revise, review, name, and integrate visual assets.

It is intentionally model-agnostic at the prompt-structure level. The project owner has approved ChatGPT Images 2.5, but good prompts should remain portable to future approved image-generation capabilities.

---

# 1. Core Visual Thesis

Astraea should visually read as:

> **Japanese fantasy academy RPG on the surface; structured executable magic underneath.**

The visual system must support both:

```text
recognizable fantasy
+
structured magical computation
```

Examples:

- Fireball should still immediately look like fire magic.
- Analysis should reveal magical structure, not a computer dashboard.
- Weak Nodes should be vulnerabilities in a magical dependency structure.
- Counter / Reverse should feel like manipulating an established magical Function, not casting a random blue explosion.

---

# 2. Default Visual Language

Prefer:

- clear anime / JRPG readability
- strong silhouettes
- intentional composition
- academy-fantasy architecture
- arcane geometry
- structured magical diagrams
- luminous nodes and thin dependency lines
- controlled magical particles
- readable foreground / midground / background separation
- cinematic but usable framing

Avoid by default:

- cyberpunk hacker UI
- generic holographic terminal
- dense random code
- sci-fi motherboard aesthetic
- generic mobile-game card frame
- excessive bloom hiding structure
- unreadable particle clutter
- text generated into the image
- watermarks
- unnecessary logos

---

# 3. What Generated Art Must Not Own

Runtime UI remains native Flutter/UI.

Unless a task explicitly requests a static promotional mockup, generated art should not contain:

- card frame
- card name
- Mana cost
- HP / MP values
- button labels
- status icons
- Action Timeline
- target selector
- localization text
- numeric balance values
- interactive Function Graph UI
- watermark

This separation is mandatory for spell artwork and reusable combat illustrations.

---

# 4. General Prompt Template

Use this as the default skeleton.

```text
Create exactly ONE independent image.

ASSET TYPE:
<spell artwork / enemy concept / battle background / cut-in / tutorial illustration / etc.>

PURPOSE:
<what this image must help the player understand or feel>

SUBJECT:
<who or what is shown>

MOMENT:
<one exact instant in the action>

CORE VISUAL CONCEPT:
<the causal idea the image must communicate>

MUST COMMUNICATE:
- ...
- ...
- ...

MUST SHOW:
- ...
- ...

COMPOSITION:
<camera, focal point, framing, negative space, crop-safe area>

WORLD / SYSTEM CONSTRAINTS:
- ...
- ...

STYLE DIRECTION:
Japanese fantasy academy RPG.
Structured magical computation beneath recognizable fantasy magic.
Arcane geometry and magical relationships, not cyberpunk software UI.

DO NOT DRAW:
- text
- watermark
- card frame
- Mana cost
- UI
- ...
```

Add aspect ratio, transparency, or background constraints only when required by the target integration.

---

# 5. Spell Artwork Template

Spell artwork should depict the spell itself, not its application card.

```text
Create exactly ONE independent image.

IMPORTANT:
This is SPELL ARTWORK ONLY.

Do NOT draw:
- card frame
- spell name
- Mana cost
- text
- number
- icon
- UI
- watermark

Spell:
<SPELL NAME>

System:
<Elemental / Force / Spatial / Temporal / Life / Mind-Information / Causality / Structural>

Subject:
<one exact magical action>

Core visual concept:
<what the Function is doing>

The image must immediately communicate:
- <mechanic meaning>
- <mechanic meaning>
- <fantasy identity>

Function structure:
<if relevant, describe nodes, dependencies, construction, stabilization, etc.>

NOT:
- <commonly confused mechanic>
- <wrong visual metaphor>
- generic scanning UI
- hacking interface

Show one clear moment:
<input/state>
→ <transformation>
→ <result>
```

---

# 6. Analysis / Weak Node Template

Critical rule:

> Analysis reveals information. It does not guarantee a Weak Node.

When a Weak Node truly exists:

```text
The magical structure becomes partially visible around the target:
- meaningful nodes
- thin dependency connections
- layered arcane relationships

One vulnerable dependency is visible because the structure itself indicates instability.

The vulnerable node must look structurally important, not merely highlighted by a generic red target marker.

The image communicates:
unknown structure
→ understanding
→ one actionable vulnerability discovered
```

When no Weak Node exists:

```text
Show successful structural understanding without a singled-out vulnerable node.
The analysis is valuable because it reveals topology, stability, dependencies, or counter-relevant structure.
```

Never force a Weak Node into every analysis image.

---

# 7. Full Chant Template

Full Chant should communicate:

- deliberate construction
- externalized sequencing
- stability
- parameter binding
- time commitment
- vulnerability during construction

Useful visual progression:

```text
intent
→ ordered arcane components
→ stabilized Function structure
→ pending execution
```

Do not portray Full Chant as merely:

> bigger glowing Fireball.

The distinction is structural and temporal, not only power.

---

# 8. Chantless Template

Chantless should communicate:

- immediate internalized construction
- reduced external scaffolding
- precision / processing demand
- fast execution

It still uses a Function.

Do not depict it as:

> magic with no underlying structure.

---

# 9. Interrupt Template

Interrupt occurs **before Function establishment**.

Visual idea:

```text
unfinished Function construction
→ disruptive force reaches a vulnerable construction state
→ structure fractures / collapses before execution
```

Do not show:

- an already-exploded spell being erased
- a completed projectile disappearing after impact

Those belong to Counter / Reverse territory.

---

# 10. Counter Template

Counter acts on an established or incoming active Function.

Visual idea:

```text
active Function
→ compatible opposing Function engages it
→ effect is neutralized / redirected / collapsed
```

Counter should feel reactive and readable.

It does not need to look mathematically complicated.

---

# 11. Reverse Template

Reverse is rarer and more advanced than Counter.

Visual idea:

```text
established Function or magical state
→ structure is understood
→ a valid reversible relationship is engaged
→ state is partially or fully driven toward a prior state
```

Do not make Reverse simply:

> Dispel, but brighter.

The image should imply state transformation or inversion.

---

# 12. Enemy / Construct Template

```text
Create exactly ONE independent enemy concept image.

Enemy:
<NAME>

Combat archetype:
<Aggressor / Caster / Disruptor / Controller / Defender-Support / Analyst-Adaptive>

Gameplay read:
<what the player should predict from silhouette/equipment/posture>

World role:
<training construct / Aberration / academy security / etc.>

Must communicate:
- combat role
- threat direction
- Astraea world identity

Avoid:
- visual complexity unrelated to gameplay
- generic MMO boss armor
- accidental modern military design unless canon requires it
```

For tutorial enemies, readability outranks spectacle.

---

# 13. Battle Background Template

Battle backgrounds must support gameplay readability.

```text
Create a landscape battle background for Astraea.

Location:
<PLACE>

Gameplay needs:
- clear central battlefield
- readable floor / spatial depth
- sufficient contrast behind characters
- reserved low-detail regions behind UI-heavy edges where appropriate

Mood:
<...>

World cues:
<...>

Do not draw:
- characters unless explicitly requested
- HUD
- text
- fake buttons
- dominant foreground objects that obscure combatants
```

For current combat, expect landscape-first composition.

---

# 14. Character Cut-In Template

```text
Create exactly ONE character combat cut-in illustration.

Character:
<NAME>

Moment:
<Analysis / reaction / Last Spell / etc.>

Expression:
<...>

Gesture / pose:
<...>

Gameplay meaning:
<...>

Composition:
dynamic crop suitable for a landscape combat overlay.
Keep important face / hand / spell cue within crop-safe center.

Do not draw:
- dialogue text
- UI frame
- button
- damage number
- watermark
```

Character canon must be verified before generation.

---

# 15. Tutorial Illustration Template

Tutorial art should explain one concept, not decorate a paragraph.

Prefer:

```text
one concept
→ one visible cause
→ one visible result
```

Example:

```text
Enemy begins Full Chant
→ unfinished Function visible
→ Interrupt window exists
```

Avoid combining:

- Mana
- Movement
- Analysis
- Counter
- Weak Node
- Last Spell

all in one tutorial image.

---

# 16. Composition Rules for Mobile

Before generating, identify target placement.

## Full-screen / battle background

- landscape
- central gameplay-safe area
- avoid critical details under side panels
- preserve depth behind character silhouettes

## SC / spell artwork

- strong central focal subject
- works when cropped smaller
- avoid tiny critical details
- no text dependency

## Cut-in

- face and defining action readable at reduced height
- support wide crop
- leave room for UI outside focal area

## Tutorial image

- clarity over cinematic complexity
- one teaching point
- visual arrows should be native UI when possible, not baked into reusable art

---

# 17. Negative-Prompt Library

Use only the exclusions relevant to the asset.

Common Astraea exclusions:

```text
no text
no watermark
no logo
no card frame
no user interface
no fake game HUD
no damage numbers
no cyberpunk hacking screen
no generic sci-fi terminal
no motherboard
no random source code
no excessive neon
no photorealistic modern military styling
no unrelated firearms
no duplicated characters
no extra limbs
```

Do not blindly paste every exclusion into every prompt. Keep prompts semantically focused.

---

# 18. Prompt Review Before Generation

Check:

- What gameplay / narrative purpose does this asset serve?
- Does the prompt specify one clear moment?
- Is the mechanic accurate?
- Does it accidentally reveal hidden canon?
- Does it accidentally bake UI?
- Does it confuse Interrupt / Counter / Reverse?
- Does Analysis incorrectly guarantee a Weak Node?
- Is the composition appropriate for mobile crop?
- Is the visual metaphor magical rather than software-dashboard-like?

If any answer is unresolved, fix the brief before generation.

---

# 19. Output Review After Generation

Score each dimension:

```text
Canon fidelity        PASS / WARN / FAIL
Mechanic fidelity     PASS / WARN / FAIL
Astraea identity      PASS / WARN / FAIL
Readability           PASS / WARN / FAIL
Composition           PASS / WARN / FAIL
Mobile integration    PASS / WARN / FAIL
UI separation         PASS / WARN / FAIL
```

Reject an image with a FAIL in canon, mechanic fidelity, or UI separation.

A visually impressive image is not acceptable if it teaches the wrong mechanic.

---

# 20. Iteration Notes

When revising, write:

```text
Keep:
- ...

Change:
- ...

Do not change:
- ...
```

This is better than rewriting the entire prompt after every generation.

Examples:

### Too sci-fi

Keep:

- node topology
- central pose
- camera

Change:

- holographic blue UI panels → engraved luminous arcane geometry
- code glyphs → magical symbolic relationships

### Weak Node too obvious

Keep:

- topology
- spell color / scene

Change:

- giant red target icon → subtle local instability visible through broken dependency lines

---

# 21. Naming and Versioning

Default:

```text
<category>_<subject>_<purpose>_vNN.<ext>
```

Examples:

```text
spell_weak_node_scan_reveal_v01.png
spell_force_bolt_interrupt_v02.png
enemy_ashfang_training_idle_v01.png
combat_bg_training_hall_v01.png
cutin_rio_analysis_v01.png
```

Use lowercase snake_case.

An asset becomes `approved` through project review, not because the filename says `final`.

---

# 22. Storage

Only create asset directories when real files are ready to be consumed.

Suggested runtime layout:

```text
assets/images/
├── combat/
├── enemies/
├── characters/
├── spells/
├── story/
└── tutorial/
```

When Flutter uses a new asset path, update `pubspec.yaml` and add an integration/widget check where useful.

Do not commit prompts as image metadata when that would expose unnecessary internal notes; keep production prompts in project docs or task artifacts.

---

# 23. Multi-Agent Production Loop

For non-trivial visual work:

```text
Orchestrator
↓
Game Director / Combat Designer / Narrative Director as relevant
↓
Visual Asset Director
↓
ChatGPT Images 2.5 generation when appropriate
↓
Visual Asset Director review
↓
Flutter / gameplay integration
↓
Vision Guardian if product identity is material
↓
Real Player Playtester
↓
QA / screenshot verification
```

The producer should not be the sole verifier of a player-facing visual.

---

# 24. Current Figma Policy

There is currently no required Figma file for this workflow.

Therefore:

- do not block work waiting for Figma
- do not invent a Figma source of truth
- use repo specifications, approved existing visuals, the current Flutter implementation, and this playbook

If an approved Figma design is supplied later for a specific screen, it becomes the high-fidelity visual reference for that screen until superseded.
