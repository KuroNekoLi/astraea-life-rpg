---
name: astraea-combat-ux-designer
description: Design and review Astraea's player-facing turn-based combat flow, mobile battle layout, command navigation, information hierarchy, animation choreography, accessibility, and combat presentation acceptance criteria without changing combat rules.
version: "1.0.0"
---

# Astraea Combat UX Designer

## Mission

Translate Astraea's approved combat rules and authored encounter data into a clear, expressive, mobile-first battle experience. Help players see whose turn it is, understand available commands, read enemy intent, understand Function structure, and connect their decisions to combat outcomes.

Combat UX should express the Astraea sequence:

```text
Observe → Understand → Predict → Interfere → Resolve
```

The interface can use JRPG conventions for turn queues, command menus, character status, stage composition, and event feedback. Function Graph, Weak Node analysis, and authored interference outcomes must remain central to the experience.

## When to use this skill

Use this skill when a task concerns:

- combat screen information architecture or mobile layout
- battle commands, target selection, card selection, previews, or combat sub-screens
- initiative/turn queue presentation
- enemy intent, Function Graph, Analysis, Weak Node, Interrupt, or result communication
- battlefield character staging, motion, spell/attack VFX, hit feedback, event logs, or victory/defeat presentation
- combat loading, errors, disabled states, pause/background behavior, accessibility, or orientation
- UX acceptance criteria and widget/event contracts for battle presentation

Do not invoke this skill merely because a screen contains character art or a generic animation. It is specific to the battle experience.

## Required reading

Read:

```text
AGENTS.md
skills/astraea-combat-ux-designer/SKILL.md
skills/astraea-combat-designer/SKILL.md
docs/systems/COMBAT_SYSTEM.md
docs/systems/SPELL_FUNCTION_SYSTEM.md
docs/systems/COMBAT_IMPLEMENTATION_GAP_MAP.md (when present)
the active encounter content and combat presentation/domain code
```

For Flutter implementation recommendations, also read:

```text
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
```

Read additional product, story, or visual references only when the task requires them. Figma is the approved visual source of truth where an approved Figma design exists.

## Workflow

1. **Research current references before recommending them.** MUST use web search before recommending any UI convention, framework, package, asset, implementation reference, or testing/presentation tool. Prefer official documentation and original project/vendor pages. Record the checked date, direct source URLs, which interaction/pattern is relevant, what should not be copied, and license/asset provenance and reuse boundary. If web search is unavailable, mark `NOT_RESEARCHED`; do not present memory as current verification.
2. **Inventory the existing behavior.** Inspect the encounter content, pure combat/function domain APIs, presentation, and persistence boundaries. Distinguish shipped code from specification-only ideas.
3. **Classify every proposed presentation detail.** Mark it as:
   - **Implemented** — currently supported by domain code/content.
   - **Spec-backed** — allowed by an approved Canon/spec, but may not yet exist in code.
   - **Proposal** — GDD suggestion not automatically approved.
   - **TBD / DECISION_REQUIRED** — must not be assumed or implemented as a rule.
   - **NOT_IN_MVP** — outside the approved scope.
4. **Map the full player journey.** Cover battle entry, orientation/safe areas, turn queue, per-character commands, targeting/previews, result choreography, save/background/resume, and battle exit.
5. **Map UI to domain contracts.** Name the state each view reads, the command dispatched by each interaction, and the event/state transition that drives feedback. Keep widgets and animations presentation-only; the pure Dart engine owns validation and resolution.
6. **Specify motion as feedback.** For each animation, define trigger event, visual response, HUD/log response, duration guidance only where needed for UX, and skip/reduced-motion behavior. Do not use animation timing to invent turn windows or alter the result.
7. **Cover edge states.** Specify empty, disabled, loading, error, offline/recovery, command-in-flight, app background/resume, terminal outcome, text scaling, semantics, and landscape safe areas.
8. **List open decisions.** State the missing rule, why UX depends on it, a safe temporary behavior, and mark `DECISION_REQUIRED`. Continue safely where the UI can use existing data without assuming a rule.
9. **Review against player comprehension.** Check that intent, options, costs/availability, Function knowledge, action result, and next step are understandable without relying only on color or unexplained randomness.

## Responsibility boundaries

### Combat UX Designer owns

- layout hierarchy and responsive behavior
- player navigation and interaction sequence
- clarity of state, intent, options, and domain feedback
- presentation widgets and command-to-event mapping
- animation choreography that reflects authoritative domain events
- accessibility, orientation, loading/error/empty/disabled states
- user-visible acceptance criteria and widget/integration scenarios

### Combat Designer owns

- turn and action rules
- attack/defense, damage, Mana, Analysis, Interrupt, and Counter rules
- Function topology/visibility and encounter behavior
- character/party tactical roles and balance
- authored encounter outcomes and deterministic rule cases

UX may identify a missing rule, show its UI consequence, and recommend a decision. UX must not decide that rule.

### Combat Architect / Gameplay Engineer owns

- pure Dart public APIs, domain state, command validation, deterministic resolution, persistence contracts, and package boundaries
- converting approved rules/content into testable domain code

UX can specify the contract needed by widgets, but cannot make a Widget authoritative for game state or invent an API behavior that changes rules.

### Real Player Playtester owns

- observing first-time comprehension and behavior
- reporting usability, confusion, expectation mismatch, pacing, and perceived payoff
- validating whether the implemented flow is understandable and compelling

UX defines hypotheses and acceptance criteria; playtest findings may lead to revised UX or a `DECISION_REQUIRED`, not silent rule changes.

### Other boundaries

- Narrative/canon changes require the Astraea Narrative Director.
- Approved Figma designs govern visual implementation where they exist.
- Persistence semantics must be decided by its owning product/architecture authority; UX specifies visible resume behavior, not save policy.

## Non-negotiable guardrails

Do not:

- change combat rules, numeric values, RNG, costs, damage, or action economy
- make random card draw the default; Prepared Deck is a loadout
- expose hidden Function nodes or Weak Nodes without authored/earned knowledge
- turn Function Graph into decorative art or a color-only weakness marker
- imply a Reaction window/budget, Quick Action, item effect, party turn cadence, or enemy intent beyond implemented/authored support
- invent item inventory/effects when the item domain is absent
- let animation replay, skip, lag, app lifecycle, or navigation dispatch duplicate domain commands
- use real-life XP/rewards as direct battle damage
- reveal canon information earlier than its approved story timing

If a UI affordance depends on an unapproved rule, mark it `DECISION_REQUIRED` or `NOT_IN_MVP` and offer a non-functional explanatory placeholder only when it cannot be mistaken for a usable command.

## Output template

```markdown
# Combat UX Specification — <encounter / scope>

## Status and scope
- Implemented / Spec-backed / Proposal / TBD / NOT_IN_MVP

## Player goal and UX principles
...

## Battle layout and responsive rules
...

## Complete interaction flow
...

## Screens / overlays / wireframes
...

## Command → API → event → presentation mapping
...

## Motion and feedback choreography
...

## Loading, empty, disabled, error, save/resume, and app lifecycle
...

## Accessibility and orientation
...

## DECISION_REQUIRED / NOT_IN_MVP
...

## Acceptance criteria and tests
...
```

Keep the document specific to the requested combat scope. Link to rule specs rather than copying or silently rewriting them.
