# M1 Status — DONE

## Delivered

- Pure Dart MVP domain models for users/profiles, three approved Life Domains, quests/activities/evidence, story quests/state, character relationships, Attributes, spell content/Function Graphs/decks, battle definitions and runtime state.
- `RewardPreview` remains provisional; `RewardGrant` is the canonical immutable transaction. Idempotency allows identical retries and rejects conflicting payloads.
- Growth Potential and AttributeState are calculated as projections from grants and TrainingConversions.
- Training conversions validate authored definitions, available balance and idempotency.
- Initial character allocation validates eight Attributes, Base 8, exactly 32 allocation points and cap 15.
- Story transitions compare `expectedStoryRevision`, return a conflict for stale commands and increment once on success.
- All domain/game-engine sources remain free of Flutter, Riverpod and Drift imports.

## Verification

- `dart format --output=none --set-exit-if-changed .` — PASS.
- `flutter analyze` — PASS, no issues.
- `flutter test` — PASS, 16 tests across M0/M1.
- `dart test test/domain test/game_engine` — PASS, 14 pure Dart tests.
- `git diff --check` — PASS.

## Product values left configurable

Life XP, evidence bonus, diminishing return, Growth Potential conversion, aptitude and Training costs/Attribute deltas are not given final numeric values in their source specifications. M1 requires explicit, versioned policy/content inputs and supplies no defaults. M2 must use approved authored values before it can present or canonically commit a reward.

## Review

Primary-agent code review completed. A separate review-agent context was unavailable in this execution context. No player-facing UI was added in M1, so player playtest is not applicable.

## Next milestone

M2 — Persisted Life Quest completion flow.
