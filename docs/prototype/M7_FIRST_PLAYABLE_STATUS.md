# M7 — First Playable Integration

## Implemented and verified path

- Widget integration test starts at Home, creates and persists a character, selects a Life Quest, confirms a reward, advances the authored prototype scenes, confirms six Spell Cards, then replaces the Riverpod application scope and resumes the completed Story / Prepared Deck state.
- CombatCheckpointRepository persists and restores unit HP/Mana, positions, turn/revision, event log, outcome, and serializable RNG seed/state.
- M2 timer and reward data persist through Drift; database schema and local record storage have reopen coverage.
- Function tutorial behavior is independently covered from analysis through cancelled Pounce.

## Current state: NOT COMPLETE / DECISION_REQUIRED

The planned M7 acceptance chain includes TrainingConversion, a playable deterministic encounter, Weak Node tactical payoff inside that battle, post-battle feedback, and resuming the battle itself after app restart. The current integration journey stops after character → Life reward → story/deck; the checkpoint is tested at repository level and the Function scenario is a separate tutorial screen.

Training policy and combat balance values remain unresolved in the specifications. Do not claim first-playable acceptance until those content decisions are approved, a training/battle UI is connected, and a player-facing end-to-end test covers the full chain.

## Verification

- First-playable integration widget journey through Prepared Deck and app-scope restart: PASS.
- Combat checkpoint round-trip: PASS.
- Real Android/iOS device execution and external real-player playtest: NOT_VERIFIED.
