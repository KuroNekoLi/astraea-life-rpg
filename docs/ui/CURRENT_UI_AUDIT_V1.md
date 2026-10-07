# Astraea Current UI Audit v1

**Status:** Phase 1 audit  
**Purpose:** Identify the highest-value migration work before high-fidelity combat design.

## Strengths

- Five-destination app shell already matches the intended product IA.
- Existing midnight / starlight / gold palette is a usable starting identity.
- Home, Adventure, Deck, Character, Training, and Life are already separated by feature.
- Core player journeys exist, so redesign can be validated against real flows rather than static mockups.
- Combat has a dedicated screen and a new Pure Dart CTB engine available for migration.

## Priority Findings

### P0 — Localization

Current presentation code contains many hardcoded English strings and some mixed Traditional Chinese story content.

Required migration:

```text
Flutter gen_l10n
English ARB
zh-TW ARB
stable content IDs
localized Quest / Story / Spell labels
no new hardcoded player-facing strings
```

This is a Phase 1 blocker because high-fidelity UI must be designed against both languages.

### P0 — Combat is still visually and technically legacy

`AshfangBattleScreen` is a portrait prototype screen backed by the legacy combat flow.

It currently exposes prototype/debug language and round-based concepts that are superseded by CTB v1.

Do not polish this screen in place as if its IA were final.

Phase 2 should design the landscape CTB screen, then Phase 3 migrates to `lib/game_engine/combat/v1/`.

### P1 — Home hierarchy is too shortcut-driven

The current Home hero area is good, but the four-card Journey grid gives generic destinations substantial equal weight.

Target:

```text
current journey
→ best next action
→ growth / Life / Adventure continuity
→ shortcuts
```

### P1 — Character is stat-first

Character currently leads quickly into an eight-attribute grid.

Target: identity / build / weapon / visible growth first, detailed attributes second.

### P1 — Adventure still exposes prototype structure

Adventure direction is stronger than utility screens, but should further emphasize world, chapter, party/location, and continuation rather than progress bookkeeping.

### P1 — Deck lacks spell-art identity

The data model is correct for a prepared loadout, but cards currently rely mainly on gradients/icons/text.

Phase 1 establishes card semantics; Visual Asset production may later add spell artwork while keeping runtime labels/cost/state native.

### P2 — Utility surfaces are visually generic

Life and Training use many standard Cards/ListTiles.

This is acceptable functionally, but shared components should gradually gain Astraea hierarchy without sacrificing clarity.

## Migration Order

1. Localization infrastructure and hardcoded-string migration.
2. Global design tokens / shared components.
3. Home + Adventure hierarchy cleanup.
4. Character + Training identity cleanup.
5. Deck visual language.
6. Combat high-fidelity specification.
7. Combat implementation + generated content assets.
8. Whole-flow real-player playtest.
