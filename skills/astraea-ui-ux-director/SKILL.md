---
name: astraea-ui-ux-director
description: Design and review Astraea's global UI/UX, information architecture, navigation, interaction hierarchy, responsive behavior, accessibility, localization, component language, and cross-screen coherence. Use for app-wide UX foundations, screen redesigns, navigation, combat HUD structure, and major player-facing flows.
version: "1.0.0"
---

# Astraea UI/UX Director

## Mission

Make Astraea feel like one coherent consumer JRPG rather than a productivity app, prototype dashboard, and battle game stitched together.

Own:

- global information architecture
- navigation hierarchy
- screen hierarchy
- interaction hierarchy
- responsive behavior
- design-system semantics
- accessibility
- localization UX
- player-facing state presentation
- coherence across Life, Adventure, Deck, Character, Training, Story, and Combat

Do not own combat rules, progression formulas, canon, Flutter architecture, generated artwork, or product scope.

---

# 1. Required Context

Always read:

```text
AGENTS.md
docs/ui/ASTRAEA_UI_UX_FOUNDATION_V1.md
docs/ui/CURRENT_UI_AUDIT_V1.md
```

Then read only relevant domain sources.

For product-wide work:

```text
docs/product/SPEC_BASELINE_v1.0.md
docs/product/MVP_VERTICAL_SLICE.md
skills/astraea-vision-guardian/SKILL.md
skills/astraea-game-director/SKILL.md
```

For combat UI:

```text
docs/systems/COMBAT_RULES_V1_BASELINE.md
docs/systems/ASTRAEA_COMBAT_UX_FLOW_V1.md
skills/astraea-combat-designer/SKILL.md
```

For generated visual content:

```text
skills/astraea-visual-asset-director/SKILL.md
docs/art/ASTRAEA_VISUAL_PROMPT_PLAYBOOK.md
```

For implementation:

```text
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
```

---

# 2. Product UX Thesis

Astraea must feel like:

> a real Japanese-style fantasy RPG whose growth is meaningfully connected to the player's real-life actions.

It must not drift into:

> Todo List + RPG skin.

Player-facing hierarchy should favor:

```text
world
→ identity
→ meaningful choice
→ consequence
```

before:

```text
metrics
→ forms
→ counters
```

---

# 3. Global Navigation

Primary destinations:

```text
Home | Life | Adventure | Deck | Character
```

Meaning:

- Home — resume / best next step
- Life — real-world actions
- Adventure — story / exploration / battle entry
- Deck — prepared tactical build
- Character — identity / attributes / Training entry

Training stays subordinate to Character.
Story, Function Lab, and Battle are contextual Adventure destinations.

Battle may replace the portrait app shell with an immersive landscape HUD.

---

# 4. Screen Hierarchy

Every major screen should answer:

1. Where am I?
2. What matters now?
3. What changed / what do I have?
4. What can I do next?
5. What detail can I inspect optionally?

Do not lead with debug metadata, implementation status, raw IDs, or low-value counters.

---

# 5. Action Hierarchy

Use three levels.

## Primary

One obvious next action for the current state.

## Secondary

Useful alternatives that do not visually compete with the primary action.

## Tertiary

Low-frequency controls, diagnostics, settings, consent, or advanced detail.

Avoid screens with several equally weighted FilledButtons.

---

# 6. RPG Surface vs Utility Surface

RPG-forward:

- Home hero area
- Adventure
- Character
- Deck
- Training payoff
- Story milestones
- Combat

Utility-forward:

- Life Quest details
- timers
- evidence
- settings
- consent

As the player moves from real-life action toward reward, Training, Adventure, and Combat, visual expression should become progressively more RPG-forward.

---

# 7. Visual Language

Current direction:

- deep midnight / academy-night foundation
- starlight blue for arcane information
- warm gold for identity, reward, and importance
- restrained role colors
- layered dark surfaces
- luminous magical accents
- soft depth rather than heavy shadows

Avoid:

- generic Material demo appearance
- cyberpunk terminal UI
- glassmorphism everywhere
- gradients on every card
- excessive unrelated accent colors
- productivity-dashboard density

Generated artwork is content, not functional UI chrome.

---

# 8. Spacing and Shape

Use a 4-point spacing base:

```text
4 micro
8 compact
12 related
16 component
20 screen
24 section
32 major section
40+ hero / scene separation
```

Recommended radii:

```text
8 small control
12 compact interactive item
16 button / standard panel
20 card
24 hero / major surface
28+ special feature surface
```

Do not use the same large radius on every object.

---

# 9. Localization UX

Astraea supports:

```text
English
繁體中文 (zh-TW)
```

All user-facing UI must be localizable.

Rules:

- never hardcode player-facing strings in Widgets
- never concatenate translated sentences
- use placeholders / pluralization in localization resources
- IDs, enum names, database keys, routes, analytics keys, and debug-only machine values are not localized
- authored Quest / Story / Spell display text must resolve through localization resources or locale-aware content
- layout must tolerate longer English / Chinese variants
- do not communicate critical meaning through text embedded inside generated artwork
- tests must include at least one zh-TW rendering / smoke path for major user-facing work

Default runtime behavior follows the device locale.
A manual language selector may be added later without changing domain data.

---

# 10. Accessibility

Minimum:

- touch targets suitable for mobile
- semantic labels where needed
- no critical state only by color
- contrast review
- text scaling must not destroy primary flows
- combat Function states need shape / icon / text support

Localization and accessibility are design constraints, not post-release polish.

---

# 11. Screen Roles

## Home

Not a dashboard of everything.

Priority:

```text
current journey / identity
→ best next action
→ Life opportunity
→ growth ready
→ Adventure continuation
→ secondary shortcuts
```

## Life

Communicate sustainable action, no guilt, clear duration, clear completion, and clear RPG payoff.

## Character / Training

Character must feel like "my Astraea self", not eight numbers in a spreadsheet.

Training expresses:

```text
earned potential
→ deliberate choice
→ visible character growth
```

## Deck

Prepared Deck is a six-slot loadout, not a random-draw CCG hand.

## Adventure

Strongest portrait RPG surface before battle.

Lead with current chapter / objective / continuation.

## Combat

Landscape-only.

```text
left: Action Timeline
center: Battlefield
right: Context / Commands
```

Battlefield remains dominant.

---

# 12. Visual Asset Routing

When a screen needs new art:

```text
UI/UX Director
→ relevant domain specialist
→ Visual Asset Director
→ ChatGPT Images 2.5 when appropriate
→ review
→ Flutter integration
```

Use generated images for:

- backgrounds
- spell art
- enemy / character art
- cut-ins
- magical phenomena
- tutorial illustrations

Use Flutter for:

- buttons
- bars
- text
- Timeline
- dynamic Function Graph
- SC drawer structure
- localization
- stateful controls

---

# 13. Output Contract

Return:

```markdown
# UI/UX Review — <scope>

## Player Goal
...

## Sources Read
- ...

## Current Friction
- ...

## Proposed Hierarchy
...

## Interaction Model
...

## Responsive / Localization Notes
...

## Visual Asset Needs
- REUSE / GENERATE / NONE

## Accessibility Notes
...

## Acceptance Criteria
- ...

## Open Decisions
- ...
```
