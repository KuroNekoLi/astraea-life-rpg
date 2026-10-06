# M7 — First Playable Integration

## Implemented and verified path

- Widget integration test starts at Home, creates and persists a character, selects a Life Quest, confirms a reward, advances the authored prototype scenes, confirms six Spell Cards, then replaces the Riverpod application scope and resumes the completed Story / Prepared Deck state.
- CombatCheckpointRepository persists and restores unit HP/Mana, positions, turn/revision, event log, outcome, and serializable RNG seed/state.
- M2 timer and reward data persist through Drift; database schema and local record storage have reopen coverage.
- Ashfang encounter v2 connects the trained Analysis projection to the authored Function analysis modifier, reveals LockTarget, and uses the existing FunctionRuntimeEngine to cancel Pounce on interruption.
- Adventure links to a playable Ashfang encounter. Player attacks, enemy Pounce, HP, turn state, Weak Node knowledge, and victory use the existing CombatEngine and versioned encounter input data.
- Ashfang battle checkpoint stores combat state, active Function, analysis/reveal knowledge, and RNG state. Reopening the app restores an in-progress encounter.
- The end-to-end widget journey now includes Life reward → Training conversion → prepared story/deck → Ashfang battle → Weak Node interruption → victory feedback; it tears down and recreates the application provider scope before the battle.
- All six versioned Training definitions can be previewed; matching Potential can be converted through the persisted Training flow. Widget coverage now includes a Physical reward spent on Reaction Drill.
- Training shows when accumulated Potential is below all authored costs and returns the player to Life Quest selection without altering reward or cost inputs.

## Current state: IMPLEMENTED / PLAYER RETEST PENDING

Combat parameters in `ashfang-training-2` are explicit illustrative encounter inputs marked `illustrative-inputs-awaiting-playtest`. They remain unbalanced prototype values and are not canon or launch tuning. The battle flow is playable and resumable; real-device usability and balance review remain pending.

MVP prototype Training/Aptitude/Fate values are approved and versioned in `character-growth-mvp-1`; these still require balance review after playtesting. Training conversion UI/persistence are implemented for all authored definitions. Fresh-install verification confirms the first 10-minute self-reported Walk grants 10 Physical Potential; starting Growth Potential is 0, and the minimum Training cost is 16, so the first reward alone cannot fund a drill. The Training screen now explains this accumulation expectation and links back to Life Quest selection. No approved reward or cost was changed.

## Verification

- First-playable integration widget journey through Prepared Deck and app-scope restart: PASS.
- Combat checkpoint round-trip: PASS.
- Clean-install first Walk reward and insufficient Training balance regression: PASS.
- Ashfang battle engine, Weak Node payoff, and battle checkpoint resume: PASS.
- Full integration widget journey through Training, Prepared Deck, Ashfang interruption, and victory: automated test added; final verification pending.
- Android emulator human playtest report received; issues are recorded in `docs/prototype/playtests/2026-10-06-real-player-playtest.md`.
- Physical Android/iOS device execution and post-fix human retest: NOT_VERIFIED.
