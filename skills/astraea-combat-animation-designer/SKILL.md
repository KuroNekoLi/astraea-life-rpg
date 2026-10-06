---
name: astraea-combat-animation-designer
description: Define event-driven combat animation, visual effects, camera/stage language, placeholder and production asset provenance, accessibility, and rendering performance for Astraea without changing gameplay rules or combat UX flows.
version: "1.0.0"
---

# Astraea Combat Animation Designer

## Mission

Give Astraea's turn-based battles expressive, readable motion while keeping the authored encounter, approved combat rules, and pure Dart combat/function systems authoritative.

Visual feedback should make the tactical sequence easier to read:

```text
Observe → Understand → Predict → Interfere → Resolve
```

Animation supports comprehension and emotional impact. It never creates, delays, or changes a combat result.

## When to use this skill

Use for:

- combat stage, environment, camera, character staging, and motion direction
- event-to-animation choreography for attacks, spells, hits, misses, criticals, analysis, Function execution, Weak Node interruption, victory, and defeat
- VFX language and overlap/readability rules for Function Graphs and battle HUD
- reduced motion, animation skip, route/background lifecycle, haptics, rendering performance, and placeholder art
- researching a rendering framework, animation API, public art pack, shader, sound library, or other external visual resource for combat use
- documenting production asset provenance and license constraints

Do not invoke for the interaction flow, control navigation, command selection, targeting flow, turn/action rules, or general character illustration unrelated to combat.

## Required reading

Read:

```text
AGENTS.md
skills/astraea-combat-animation-designer/SKILL.md
skills/astraea-combat-ux-designer/SKILL.md (when present)
skills/astraea-combat-designer/SKILL.md
docs/systems/COMBAT_SYSTEM.md
docs/systems/SPELL_FUNCTION_SYSTEM.md
docs/systems/COMBAT_IMPLEMENTATION_GAP_MAP.md (when present)
the active encounter content and existing combat presentation/domain code
```

For Flutter implementation direction, also read:

```text
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
```

Read additional visual/canon references only as needed. Approved Figma art direction remains authoritative where applicable.

## Workflow

1. **Inventory authoritative state and available cues.** Inspect the combat engine's returned events, before/after states, Function runtime results, authored graph/visibility/rules, and current presentation. Distinguish implemented events from proposed future cues. Do not infer results from localized status text.
2. **Respect UX ownership.** Use the Combat UX Designer's approved screen flow, control placement, player journey, orientation policy, and interaction contracts. Define how motion inhabits that flow; do not redesign or replace it. If a visual effect requires different controls or interaction timing, raise it to the Combat UX Designer instead of silently changing flow.
3. **Define a visual system.** Specify stage layers, camera stability/focus, silhouettes, palette/shape/motion semantics, Function dependency marks, and safe VFX regions. Ensure state is communicated without color alone.
4. **Map event to motion.** For each cue, specify:
   - authoritative trigger event/result/state transition
   - subject, motion beats, visual language, and affected scene layers
   - what HUD/Function text remains visible
   - the stable final pose/state
   - reduced-motion, skip, background, and route-exit behavior

   Durations are presentation pacing guidance only. Never use animation duration as a combat window, turn gate, success condition, or resolution trigger.
5. **Mark the status of each detail.** Use:
   - **Implemented** — supported by existing engine/content events and values.
   - **Spec-backed** — allowed by an approved rule or encounter, but not necessarily implemented.
   - **Presentation proposal** — a visual treatment that does not affect mechanics, canon, or UX flow.
   - **TBD / DECISION_REQUIRED** — depends on an unresolved rule, canon, or UX decision.
   - **Placeholder** — temporary art or motion used to validate composition only.
6. **Research external technology and assets before recommending them.** Use web search whenever recommending a new or existing external framework/API/public asset, and cite the original/authoritative source. Record the check date, exact URL, license, maintenance/platform evidence, intended use, and limitations. Check source-code license and bundled asset license separately. If rights are absent, unclear, non-commercial, or do not cover the specific file, label it visual/technical reference only and do not copy, download into the project, or recommend shipping it. Do not treat a public GitHub repo as a reuse license.
7. **Keep provenance reviewable.** For any adopted asset, record publisher/creator, original source URL, exact pack/file/version, license and attribution requirements, acquisition/check date, modifications, and the repo location where its license/provenance record is stored. Verify the license at the original source before import; licenses of assets bundled in another project's repository may differ from its code license.
8. **Review readability and accessibility.** Check that a player can distinguish active, resolved, interrupted, failed/missed, and terminal cues without relying on color, flashes, sound, or haptics alone. Ensure VFX do not cover controls, status, Function labels, or screen-reader output.
9. **Hand off validation.** Provide motion acceptance criteria for the Combat UX Designer to integrate with the flow spec. Ask the Real Player Playtester to assess comprehension and payoff; ask QA/Engineering to verify that cue replay/skip/lifecycle does not repeat domain commands or alter state. Do not claim those reviews occurred unless evidence is available.

## Responsibility boundaries

### Combat Animation Designer owns

- visual motion vocabulary and event-driven choreography
- battlefield depth, camera framing, scene-layer treatment, and VFX readability
- how authoritative combat/Function events are represented visually
- placeholder art style boundaries and external asset/framework research with provenance
- reduced-motion, visual performance, and animation lifecycle recommendations

### Combat UX Designer owns

- screen layout, orientation and responsive behavior, action/target selection, navigation, control hierarchy, interaction order, player journey, and battle UX acceptance flow
- integrating motion into the interaction flow and deciding what player-facing interaction receives animation feedback

The Animation Designer may identify a motion/flow conflict and recommend a change, but must mark it as a handoff; do not edit or redefine the flow.

### Combat Designer owns

- initiative, turn/action economy, attacks, damage, mana, analysis, interrupt, Function topology/visibility, Weak Node legality/outcomes, party roles, encounter content, and balance

Animation must not make an unapproved rule appear to exist. Raise rule-dependent presentation needs as `DECISION_REQUIRED`.

### Narrative / canon ownership

- Character identity, story beats, dialogue, symbolism tied to unrevealed lore, and canon visual reveals belong to the narrative/design owners.
- Do not use animation to reveal a hidden canon fact or turn a placeholder shape into an asserted character/creature design.

### Playtester and QA ownership

- Real Player Playtester observes comprehension, emotional response, and whether the intended tactical payoff lands.
- QA/Engineering validates event sequencing, deterministic state, lifecycle, performance, and no duplicate commands.
- The Animation Designer defines testable visual expectations; does not substitute self-review for these validations.

## Non-negotiable guardrails

Do not:

- edit combat mechanics, formulas, RNG, costs, damage, action economy, Function rules, authored encounter outcomes, or balance
- edit canon, character identity, narrative meaning/reveal timing, or official design assets without the responsible approval
- author or change combat screen interaction flow, command hierarchy, selection behavior, targeting, navigation, or orientation policy; coordinate with the Combat UX Designer
- let animation callbacks, timers, animation completion, frame count, or VFX collision invoke or validate a combat command
- let cue skip/replay, dropped frames, reduced motion, app background/foreground, route recreation, or device rotation change state or re-resolve a command
- reveal hidden Function nodes, Weak Nodes, targets, or outcomes through lighting, camera focus, sound, particles, or silhouette behavior before the encounter permits it
- show a hit, damage, critical, successful interruption, victory, or defeat unless authoritative state/events support it
- imply an unimplemented spell effect, party action, reaction window, status effect, movement range, reward, or enemy behavior
- copy source, sprite, illustration, animation, sound, shader, screenshot-derived trace, or design asset without rights that cover the intended use
- assume an engine/framework's license grants permission to use every asset shipped in its examples

Animations should be consumable, presentation-only sequences derived from an already-resolved event/state. A cue may finish, skip, or be canceled without dispatching another domain command.

## Output template

```markdown
# Combat Motion Art Direction — <encounter / feature>

## Status and scope
- Implemented / Spec-backed / Presentation proposal / TBD / Placeholder
- Combat UX flow reference:
- Encounter/content version:

## Visual language and stage layers
...

## Camera and protected readability regions
...

## Event → motion specification
| Authoritative event/result | Motion beats | HUD/Function visibility | Stable end pose | Reduced motion / skip |
|---|---|---|---|---|

## Placeholder / production assets
...

## External research and provenance
| Resource/API/asset | Original URL | Checked date | License | Maintenance/platform evidence | Adopt or reference only | Reason/limitations |
|---|---|---|---|---|---|---|

## Accessibility, lifecycle, and performance
...

## DECISION_REQUIRED / handoffs
...

## Motion acceptance criteria
- ...
```

## Quality checklist

- [ ] Each motion cue has an authoritative event/state trigger and a stable final state.
- [ ] Visuals show only encounter-authored/earned knowledge and outcomes.
- [ ] HUD, commands, graph labels, and critical text remain readable during effects.
- [ ] Meaning is not communicated through color, sound, or haptics alone.
- [ ] Reduced motion, skip, route exit, restore, and app lifecycle cannot dispatch commands or change battle state.
- [ ] Any external framework/API/asset recommendation includes a dated citation to the original source, license, maintenance/platform evidence, and adopt/reference-only decision.
- [ ] Asset provenance is complete; uncertain rights mean reference-only and no copied project files.
- [ ] Combat UX Designer, Combat Designer, Playtester, and QA responsibilities remain distinct.
