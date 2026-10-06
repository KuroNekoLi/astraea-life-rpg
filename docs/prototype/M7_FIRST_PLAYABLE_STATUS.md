# M7 — First Playable Integration

## Implemented and verified path

- Widget integration test starts at Home, creates and persists a character, selects a Life Quest, confirms a reward, advances the authored prototype scenes, confirms six Spell Cards, then replaces the Riverpod application scope and resumes the completed Story / Prepared Deck state.
- CombatCheckpointRepository persists and restores unit HP/Mana, positions, turn/revision, event log, outcome, and serializable RNG seed/state.
- M2 timer and reward data persist through Drift; database schema and local record storage have reopen coverage.
- Function tutorial behavior is independently covered from analysis through cancelled Pounce.
- All six versioned Training definitions can be previewed; matching Potential can be converted through the persisted Training flow. Widget coverage now includes a Physical reward spent on Reaction Drill.
- Training retains the primary navigation, offers Character and Adventure next steps, and a completed chapter offers the interactive Function Analysis tutorial.

## Current state: NOT COMPLETE / DECISION_REQUIRED

The planned M7 acceptance chain still requires a playable deterministic encounter, Weak Node tactical payoff inside that battle, post-battle feedback, and resuming the battle itself after app restart. The current integration journey stops after character → Life reward → story/deck; the Training screen and the Function tutorial are separate playable steps, and the checkpoint is tested at repository level.

MVP prototype Training/Aptitude/Fate values are approved and versioned in `character-growth-mvp-1`; these still require balance review after playtesting. Training conversion UI/persistence are implemented for all authored definitions. Combat encounter balance and integrated battle UI are not complete. Do not claim first-playable acceptance until the battle flow and a player-facing end-to-end test cover the full chain.

## Verification

- First-playable integration widget journey through Prepared Deck and app-scope restart: PASS.
- Combat checkpoint round-trip: PASS.
- Android emulator human playtest report received; issues are recorded in `docs/prototype/playtests/2026-10-06-real-player-playtest.md`.
- Physical Android/iOS device execution and post-fix human retest: NOT_VERIFIED.
