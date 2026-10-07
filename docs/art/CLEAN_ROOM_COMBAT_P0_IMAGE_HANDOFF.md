# Clean-room Image Worker Handoff — Combat P0

**Purpose:** Production runtime art only  
**Rule:** One asset = one fresh image-generation context  
**Do not run both tasks in the same image conversation.**

This file is an execution handoff. Each task below must be copied into a **new image-only conversation / worker** with no Astraea development chat history.

The worker must not receive:

- project status
- CI logs
- Flutter implementation discussion
- QA reports
- milestone percentages
- playtest findings
- unrelated screenshots
- the other asset task

If a canonical reference image is supplied, use **image edit** instead of regenerating identity from text.

---

# Worker A — Astraea Training Hall Background

## Context supplied to worker

Only this task.

## Prompt

```text
IMAGE-ASSET-ONLY TASK.

Create exactly ONE independent runtime game asset.

ASSET:
Astraea Academy Training Hall battle background.

PURPOSE:
Landscape battlefield environment for a mobile Japanese fantasy academy RPG.

CANVAS:
Wide landscape composition.
Crop-safe from 16:9 through 20:9.
No transparency required.

SCENE:
A prestigious indoor magical academy training arena.
Elegant academy architecture, high arches, observation galleries, restrained warm-gold details, dark midnight-blue materials, subtle starlight accents.

MAGICAL IDENTITY:
Structured magic is visible only as subtle environmental arcane geometry integrated into the floor and architecture.
It should feel magical and academic, not technological.

COMPOSITION:
Open central combat area.
Keep the center and lower-middle relatively low-detail so combat characters remain readable.
Place stronger architectural detail toward the upper and outer edges.
Preserve useful visual depth for an abstract Near / Mid / Far battle system without drawing literal lanes.

STYLE:
Polished Japanese fantasy RPG environment artwork.
Painterly game-art finish.
Astraea Academy fantasy.
Midnight, starlight, restrained gold.
Readable rather than overly ornate.

STRICT OUTPUT:
One environment asset only.

NO:
characters
enemy
Ashfang
HUD
buttons
health bars
Mana bars
timeline
text
numbers
card frame
near/mid/far labels
presentation sheet
concept sheet
turnaround sheet
collage
multiple variants
dashboard
progress visualization
cyberpunk interface
modern laboratory
watermark
```

## Acceptance

PASS only if:

- environment only
- no baked UI or text
- no characters/enemy
- central battlefield is readable
- mobile landscape crop works
- academy fantasy identity is clear

Reject otherwise.

---

# Worker B — Ashfang Training Construct

## Context supplied to worker

Only this task plus one canonical Ashfang reference image if available.

## Preferred mode

```text
REFERENCE IMAGE EDIT
```

If a canonical or near-canonical Ashfang image exists:

- preserve creature identity
- preserve silhouette/material language
- remove environment
- isolate full body
- produce transparent background

Do not redesign from scratch unless no usable reference exists.

## Prompt

```text
IMAGE-ASSET-ONLY TASK.

Create exactly ONE isolated runtime enemy asset.

SUBJECT:
Ashfang Training Construct.

WORLD ROLE:
Astraea Academy magical combat-training construct.

GAMEPLAY ROLE:
Primary Aggressor.
Secondary Caster.

CANVAS:
Transparent background.
One full-body subject only.

POSE:
Three-quarter battle-facing stance.
Bestial quadruped posture.
Ready to lunge or pounce.
Entire silhouette visible.
Limbs clearly separated and readable at small mobile-game size.

VISUAL IDENTITY:
Elegant enchanted academy construct.
Dark refined magical material.
Restrained blue starlight arcane seams.
Small warm-gold training details.
A few meaningful structural nodes.
A subtle magical focusing structure showing it can construct spells.

GAMEPLAY READ:
Fast physical pressure.
Pouncing threat.
Also capable of structured magic casting.

STYLE:
Polished Japanese fantasy RPG enemy asset.
Arcane academy fantasy.
Not science-fiction robotics.

STRICT OUTPUT:
One isolated full-body enemy only.
Transparent background.

NO:
environment
floor
arena
character
party
HUD
health bar
Mana bar
timeline
text
nameplate
number
Weak Node marker
target marker
card frame
presentation sheet
concept sheet
turnaround sheet
collage
multiple variants
modern robot
mech
military drone
firearm
cyberpunk interface
watermark
```

## Acceptance

PASS only if:

- one isolated Ashfang
- full body visible
- transparent background
- silhouette remains readable when reduced
- Aggressor + Caster identity reads
- no baked UI/text
- no Weak Node marker
- no unrelated environment

Reject otherwise.
