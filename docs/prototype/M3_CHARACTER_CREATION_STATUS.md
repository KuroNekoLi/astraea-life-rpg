# M3 — Character and Training Path

## Current state: PARTIAL; prototype policy approved

- Character name, canonical eight attributes, Base 8, exactly 32 allocation points, per-attribute cap 15, and four authored initial weapon choices are implemented and persisted locally.
- The character creation screen is accessible from Home. A widget-level first-playable test completes this step.
- Pure Dart allocation validation remains covered by domain tests.
- A read-only Training preview now displays the persisted Physical, Cognitive, and Communication Potential projections from confirmed Life Quest rewards. It spends nothing and does not imply that Potential directly changes Attributes.
- Versioned MVP prototype rules are approved for Training cost/growth, Aptitude, and Fate (`character-growth-mvp-1`).
- A pure Dart policy loader quotes Training costs from authored definitions, Aptitude ratings, and prior growth; it implements injected Aptitude rolls and a one-use mandatory Fate replacement.
- Training preview remains read-only while the persistence/UI flow for Aptitude creation and TrainingConversion is implemented.

## Approved policy

The `character-growth-mvp-1` asset is explicitly prototype-only. It sets 18 base Potential for +1 permanent Attribute growth; Aptitude `1d6` changes cost by +2/0/−2 across ratings 1–2/3–4/5–6; per-Attribute prior growth tiers multiply cost by ×1/×2/×3 at 0–4/5–9/10+; Fate rerolls one chosen Aptitude once and the new result is mandatory. Full policy and examples are in `docs/systems/CHARACTER_PROGRESSION_SYSTEM.md`.

## Verification

- Character allocation source-of-truth: pure Dart CharacterInitialAllocation.
- First-playable widget integration: PASS for character creation, Life completion/reward, and six-card deck (M7 test path; combat/training not included).
- Training preview widget: displays saved balances, zero balances for absent categories, and the no-conversion boundary.
- Pure Dart policy tests cover version loading, cost tiers, injected Aptitude rolls, mandatory one-time Fate replacement, and policy/profile version checks.
- Real-player/device review: NOT_VERIFIED.

## Next implementation sequence

1. Persist the Aptitude profile and Fate-used flag during character creation, using the approved versioned policy and serializable RNG.
2. Add an idempotent Training Conversion flow that only accepts quoted values from the approved policy and updates the Attribute projection.
3. Connect the prepared character/deck and approved encounter inputs to a resumable battle UI with Weak Node payoff and post-battle feedback.
4. Run the full first-playable flow with real players, review balance, and version any policy changes before beginning the seven-day pilot.
