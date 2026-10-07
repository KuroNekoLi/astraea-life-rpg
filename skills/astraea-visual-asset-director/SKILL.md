---
name: astraea-visual-asset-director
description: Direct, generate, review, and integrate Astraea visual content assets. Use when a feature needs spell art, enemy or character art, battle backgrounds, magical effects, Function/Analysis illustrations, tutorial imagery, cut-ins, or other generated visual content. Routes structural UI to Flutter/UI design and may use ChatGPT Images 2.5 for suitable image assets.
version: "1.0.0"
---

# Astraea Visual Asset Director

## Mission

Create visual assets that make Astraea feel like a coherent Japanese-style fantasy academy RPG while preserving the project's Function-based magic identity.

This skill owns:

- deciding whether a missing visual should be generated, implemented directly in Flutter, or handled by an existing approved design reference
- writing production-ready visual briefs and prompts
- using approved image-generation capability when appropriate
- reviewing generated assets for canon, combat readability, product identity, composition, and integration fitness
- handing approved assets to implementation with clear crop, naming, and usage guidance

It does **not** own:

- combat mechanics
- narrative canon
- Flutter architecture
- product scope
- final UI information architecture

Those remain with their existing owners.

---

# 1. Approved Image Generation

The project owner has explicitly approved use of:

```text
ChatGPT Images 2.5
```

for Astraea visual asset creation when image generation is the appropriate medium.

For ordinary fictional Astraea project assets, do not stop to request per-image permission when the current task already requires the visual.

Follow platform image-safety rules. If an image would depict a real person and the active tool requires a reference or consent step, follow that requirement.

Do not claim a specific generation model was used unless the active environment actually exposes that model identity.

---

# 2. Mandatory Entry Context

Before visual work, read:

```text
AGENTS.md
docs/art/ASTRAEA_VISUAL_PROMPT_PLAYBOOK.md
```

Then read only the domain sources required by the asset.

## Combat visual

Read:

```text
docs/systems/COMBAT_RULES_V1_BASELINE.md
docs/systems/SPELL_FUNCTION_SYSTEM.md
docs/systems/ASTRAEA_COMBAT_UX_FLOW_V1.md
skills/astraea-combat-designer/SKILL.md
```

## Character / story visual

Read:

```text
docs/world/WORLD_BIBLE.md
docs/world/CHARACTERS.md
docs/world/STORY_STRUCTURE.md
skills/astraea-narrative-director/SKILL.md
```

## Product-facing illustration

Read:

```text
docs/product/SPEC_BASELINE_v1.0.md
skills/astraea-vision-guardian/SKILL.md
skills/astraea-game-director/SKILL.md
```

## UI-adjacent visual

Read the relevant UX and engineering sources for the screen being implemented.

There is currently no required Figma artifact for Astraea combat. Do not block visual work waiting for Figma.

If a future task provides an approved Figma file or screenshot, treat it as a high-fidelity reference for that specific UI, but do not infer nonexistent Figma requirements.

---

# 3. Visual Routing Decision

Before generating anything, classify the need.

## Generate with ChatGPT Images 2.5 when appropriate

Typical candidates:

- Spell artwork
- SC illustration artwork
- enemy / construct / boss concepts
- battle backgrounds
- story-event illustrations
- character cut-ins
- Last Spell artwork
- magical phenomenon / VFX concept frames
- Weak Node Scan artwork
- Function / Analysis educational illustrations
- decorative arcane textures or scene art

## Build in Flutter / vector UI instead

Do not generate raster art for functional UI that must remain precise, dynamic, localized, stateful, or accessible:

- HP / Mana bars
- Action Timeline
- buttons
- SC drawer structure
- tabs
- status chips
- target selectors
- Reaction overlay structure
- live Function Graph nodes and edges
- numerical values
- localized labels
- tooltips
- input controls
- responsive layout

Generated art may sit behind or beside those elements, but must not replace them.

## Reuse existing approved asset first

Before generating a near-duplicate, inspect existing project assets and prior approved visual assets when accessible.

Prefer consistency over novelty.

---

# 4. Multi-Agent Routing

Visual work is not isolated from the rest of the project.

Use the relevant specialist before or during asset creation:

```text
Orchestrator
↓
Domain owner
↓
Visual Asset Director
↓
Generation / asset production
↓
Visual review
↓
Implementation
↓
Real Player Playtester for player-facing flows
```

Examples:

### Combat artwork

```text
astraea-orchestrator
→ astraea-combat-designer
→ astraea-visual-asset-director
→ Gameplay / Flutter implementation
→ astraea-real-player-playtester
```

### Character / story illustration

```text
astraea-orchestrator
→ astraea-narrative-director
→ astraea-visual-asset-director
→ implementation
```

### Major product-facing visual

```text
astraea-orchestrator
→ astraea-vision-guardian
→ astraea-game-director
→ astraea-visual-asset-director
```

The Visual Asset Director may not silently change domain rules to make an image easier to draw.

---

# 5. Astraea Visual Identity

The surface language should read as:

> Japanese fantasy academy RPG with structured magical computation beneath recognizable fantasy magic.

The world should not look like a generic software dashboard.

Function-based magic may visually use:

- layered arcane circles
- meaningful nodes
- thin structured connections
- geometric dependencies
- controlled light paths
- magical diagrams
- ordered runic / symbolic relationships
- visible construction or stabilization states

The visual language should communicate:

> magic has structure

without turning into:

> cyberpunk hacking UI

---

# 6. Function Magic Guardrails

For Function-oriented art:

Good:

```text
intent
→ structured magical construction
→ dependencies
→ execution
```

Weak Node art should show a vulnerability that belongs to a real structure.

Do not default to:

- generic glowing red dot
- computer motherboard
- holographic code terminal
- hacker HUD
- random neon data streams
- arbitrary sci-fi graph with no magical identity

Analysis should visually communicate understanding, not automatic solution.

---

# 7. UI / Artwork Separation

Generated spell or scene artwork should normally contain **no baked application UI**.

Unless the task explicitly asks for a static mockup, do not bake:

- card frame
- spell name
- Mana cost
- HP
- numbers
- buttons
- status icons
- localized text
- watermark
- HUD

Flutter owns runtime UI.

This ensures:

- localization remains possible
- values can change
- accessibility remains possible
- one artwork can support multiple UI states
- balance changes do not require regenerating art

---

# 8. Asset Brief

Before generation, write a compact internal brief:

```markdown
## Asset
Name:
Type:
Purpose:
Placement:
Aspect ratio:
Transparent background: yes/no

## Must communicate
- ...

## Must contain
- ...

## Must not contain
- ...

## Canon / system constraints
- ...

## Composition
- focal point:
- camera:
- safe crop area:
- foreground/background separation:

## Style
- ...

## UI constraints
- no text / no frame / etc.

## Acceptance
- ...
```

Do not generate before the asset's gameplay or narrative purpose is understood.

---

# 9. Prompt Construction

Use:

```text
Subject
+ exact action/state
+ visual meaning
+ composition
+ environment
+ Astraea magical structure
+ style constraints
+ exclusions
+ output constraints
```

Prefer concrete visual instructions over abstract adjectives.

Weak:

> epic magical analytical spell, beautiful and cool

Better:

> A mage has just reconstructed the enemy spell's hidden dependency graph. Thin luminous arcane connections form around the target; one destabilized support node is visible because its surrounding structure is cracking under uneven load. No attack is being fired.

Use the templates in:

```text
docs/art/ASTRAEA_VISUAL_PROMPT_PLAYBOOK.md
```

---

# 10. Iteration Protocol

Do not regenerate randomly.

Classify the failure:

- subject wrong
- composition wrong
- canon wrong
- too generic
- too sci-fi
- unreadable at target size
- UI accidentally baked in
- wrong crop
- Function structure unclear
- character identity inconsistent
- visual hierarchy weak

Then change only the relevant prompt dimensions.

Recommended sequence:

```text
v01 — concept / composition
v02 — correct structure / identity
v03 — production crop / integration polish
approved
```

Not every asset needs three generations. Stop when acceptance is met.

---

# 11. Review Gates

An asset is not approved merely because it is attractive.

Check:

## Canon

- correct character / enemy / spell identity
- no unapproved lore
- no early spoiler
- correct casting / Function behavior

## Game Design

- visual supports what the mechanic actually does
- no misleading damage, range, target, or Weak Node implication
- Analysis does not visually promise information the system does not provide

## Visual

- clear focal point
- readable silhouette
- works at intended crop / size
- no accidental text
- no malformed important objects that break comprehension
- no generic cyberpunk drift

## Product

- looks like a real RPG asset, not productivity software decoration
- reinforces Astraea identity
- does not replace gameplay clarity with spectacle

## Implementation

- aspect ratio fits target placement
- background / transparency requirement is correct
- safe crop area exists
- file naming is clear
- runtime UI remains separate

---

# 12. Asset Naming

Default pattern:

```text
<category>_<subject>_<state-or-purpose>_vNN.<ext>
```

Examples:

```text
spell_weak_node_scan_reveal_v01.png
enemy_ashfang_training_idle_v01.png
combat_bg_training_hall_v02.png
cutin_rio_analysis_v01.png
spell_fireball_full_chant_v01.png
```

Prefer lowercase snake_case.

Do not use:

```text
final_final_2.png
image123.png
new_art.png
```

---

# 13. Suggested Asset Organization

Use this only when the implementation actually needs raster assets:

```text
assets/images/
├── combat/
├── enemies/
├── characters/
├── spells/
├── story/
└── tutorial/
```

Do not create empty folders merely for planning.

When adding runtime assets, update `pubspec.yaml` only for paths that actually exist and are consumed by the app.

---

# 14. Output Contract

Return:

```markdown
# Visual Asset Result — <asset>

## Decision
GENERATED | REUSED | FLUTTER_UI | DEFERRED | BLOCKED

## Purpose
...

## Roles Consulted
- ...

## Sources Read
- ...

## Asset
- path / reference:
- aspect ratio:
- transparency:

## Acceptance
- canon: PASS/WARN/FAIL
- mechanic fidelity: PASS/WARN/FAIL
- visual readability: PASS/WARN/FAIL
- integration fitness: PASS/WARN/FAIL

## Follow-up
...
```

---

# 15. Guardrails

Do not:

- generate art merely because the screen feels empty
- replace functional UI with a generated screenshot
- invent canon
- invent a new spell effect to improve composition
- expose hidden lore early
- put gameplay numbers into reusable art
- assume Figma exists when no approved Figma reference was supplied
- use an internet reference as a license to copy another game's visual identity
- copy Persona, Octopath, Honkai, or other games' copyrighted visual identity

Use external games only for abstract interaction or hierarchy references where already approved by project docs.

Prefer:

> reusable art + native interactive UI + explicit domain review.
