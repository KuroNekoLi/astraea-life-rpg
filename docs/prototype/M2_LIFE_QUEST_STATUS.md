# M2 — Life Quest Vertical Path

## Delivered

- Life Quest list, authored-template picker, detail, timer and completion preview screens.
- Versioned content/reward policy in `assets/content/quests/mvp_v1.json`, using the GDD example duration curve and Growth Potential examples.
- Drift schema migration to version 2; local quest, timer, activity, evidence, RewardGrant, LifeProgress and Growth Potential projection records.
- Timer state survives app backgrounding/restart through persisted start/pause timestamps. Timer evidence is lightweight evidence, not proof of effort.
- User confirmation is required to create a canonical RewardGrant. Completion retries with the same completion id are idempotent; ledger projections are rebuilt from grants in one transaction.
- Self-report remains valid and private. No connected-health integrations.

## Verification

- `dart format --output=none --set-exit-if-changed .`: PASS
- `flutter analyze`: PASS
- `flutter test`: PASS (18 tests)
- `dart test test/domain test/game_engine`: not rerun separately in this milestone; Flutter test includes these suites.
- Device visual review and external real-player playtest: NOT_VERIFIED in this execution environment.

## Notes

Prototype reward parameters are editable/versioned and were selected by user instruction from GDD examples. The timer records elapsed active time; the M2 screen currently presents estimated quest duration in the preview path, and detailed elapsed-duration polish remains open.
