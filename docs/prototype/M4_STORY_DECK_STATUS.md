# M4 — Story Runtime and Prepared Deck

## Delivered prototype excerpt

- Versioned story asset contains Scene 1–5 tutorial beats from approved source documents, with explicit prototype-excerpt status.
- Story runtime advances scenes with expected-revision checks and persists story flags/index in Drift.
- Scene 3 shows an interactive Function Graph explanation; Scene 4 compares Full Chant / Chantless; Scene 5 lets the player select six unique Spell Cards from authored proposal names.
- Prepared Deck is persisted separately from story state and is described as a loadout, not a random draw deck.
- No restricted late-story reveals were added.

## Scope limit

This is not the complete authored Scene 1–5 dialogue/cinematic implementation. Yuma/Rio/Hina character interactions, relationship state, and narrative review remain open. Content is labeled prototype excerpt and should receive narrative/real-player review before a pilot.

## Verification

- Story/deck content validation: PASS.
- Cross-feature widget flow character → Life Quest/reward → Scenes 1–5 → six-card Prepared Deck: PASS in the first-playable integration widget test.
- flutter analyze and full tests will be rerun after M5–M8 integration.
