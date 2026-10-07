# Astraea Global UI/UX Foundation v1

**Status:** Working baseline for Phase 1  
**Scope:** Entire Flutter client, portrait application surfaces and landscape combat  
**Locales:** English + Traditional Chinese (zh-TW)  
**Design owner:** `skills/astraea-ui-ux-director/SKILL.md`

## 1. Product Experience

Astraea is a real JRPG connected to real-world action.

The interface must make the player primarily feel:

```text
I am growing my Astraea self and continuing an RPG journey.
```

not:

```text
I am managing a gamified task manager.
```

This is the top-level UX test for every major screen.

## 2. Global Navigation

Primary portrait navigation is fixed at five destinations:

```text
Home | Life | Adventure | Deck | Character
```

Training is a Character child flow.
Story and Function Lab are Adventure child flows.
Battle is entered from Adventure and uses a dedicated landscape shell.

Do not expand the primary navigation merely because a subsystem exists.

## 3. Screen Composition

Major screens follow:

```text
Context / identity
↓
Current meaningful state
↓
Primary action
↓
Supporting information
↓
Optional detail
```

Debug/prototype metadata must never outrank player-facing meaning.

## 4. Interaction Hierarchy

Each state should have one visually dominant primary action.

Use:

- Filled — primary
- Tonal / outlined — secondary
- Text / icon — tertiary

Do not present several equal primary calls-to-action unless the game decision truly requires equal tactical choices.

## 5. Visual System

Foundation colors remain midnight / starlight / gold, but use them semantically.

- midnight: world / depth
- starlight: arcane information / selected neutral state
- gold: identity / reward / exceptional importance
- coral: danger / attack
- blue: defense
- violet: spatial / uncommon structure
- teal: analysis / information
- green: recovery / positive state

Color is never the sole information carrier.

## 6. Tokens

Use a 4-point spacing grid.

Spacing: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40+.

Radii: 8 / 12 / 16 / 20 / 24 / 28+ based on hierarchy.

Shared values belong in `lib/design_system/`, not repeated literals across screens.

## 7. Typography

Semantic levels:

- hero/display
- screen title
- section title
- body
- supporting
- label/metadata
- numeric/combat resource

Use all caps only for short labels such as `ACTION ORDER`, `ATTRIBUTES`, or `PREPARED SC`.

## 8. Portrait Screen Intent

### Home

Purpose: continue the player's journey.

The current journey and best next action outrank generic shortcut grids.

### Life

Purpose: choose and complete sustainable real-world action.

No guilt language, streak pressure, or productivity-dashboard framing.

### Adventure

Purpose: continue story / objective / battle.

This is the strongest portrait RPG surface.

### Deck

Purpose: express tactical preparation.

Prepared SCs are direct-access loadout slots, never a draw pile.

### Character

Purpose: express player identity and growth.

Character art / identity / build direction should eventually outrank raw attribute grids.

### Training

Purpose: convert earned Growth Potential into deliberate, visible build growth.

## 9. Combat Surface

Combat is landscape-only.

Baseline:

```text
12–15% Action Timeline
57–62% Battlefield
23–28% Context / Commands
```

The Battlefield stays dominant.

SC selection, Analysis, and parameter selection use the right Context Panel.
Reaction uses a focused overlay while preserving Battlefield and Timeline context.

Detailed behavior is governed by `docs/systems/ASTRAEA_COMBAT_UX_FLOW_V1.md`.

## 10. English + Traditional Chinese

Supported locales:

```text
en
zh_TW
```

Rules:

- all player-facing strings come from localization resources or locale-aware authored content
- no hardcoded display strings in Widgets
- no sentence concatenation
- use placeholders and plurals
- persistent/domain data uses stable IDs, not localized labels
- Quest, Story, Spell, Attribute, Training, and combat labels resolve from stable IDs
- generated artwork contains no critical translated text
- layout must be validated in both locales

System locale is the Phase 1 selection mechanism.
Manual language selection is a future Settings enhancement.

## 11. Async / State UX

Every major async surface defines:

- loading
- empty
- error
- disabled
- selected
- success/changed where relevant

Empty states preserve player dignity.

## 12. Accessibility

- mobile touch targets
- semantic labels
- text scale resilience
- contrast review
- no color-only critical state
- Function Graph uses icon/shape/label in addition to color

## 13. Visual Asset Policy

There is no required Figma dependency today.

Visual authority comes from project specs, current implementation, approved assets, and the Visual Prompt Playbook.

Use `astraea-visual-asset-director` when a new content image is needed.
ChatGPT Images 2.5 may be used for suitable fictional Astraea assets.

Functional UI remains native Flutter.

## 14. Phase Sequence

```text
Phase 1 — Global UI/UX Foundation
Phase 2 — Combat high-fidelity design
Phase 3 — Flutter implementation
Visual Asset Production — when needed
Ashfang playable battle
Real Player Playtest
```

Phase 2 must not invent a separate visual language from Phase 1.
