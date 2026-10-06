# M3 — Character and Training Path

## Current state: PARTIAL; prototype policy approved

- Character name, canonical eight attributes, Base 8, exactly 32 allocation points, per-attribute cap 15, and four authored initial weapon choices are implemented and persisted locally.
- The character creation screen is accessible from Home. A widget-level first-playable test completes this step.
- Pure Dart allocation validation remains covered by domain tests.
- Training displays the persisted Physical, Cognitive, and Communication Potential balances and all six authored drills. Each drill quotes its matching Potential cost, Aptitude, prior Attribute growth, and resulting Attribute value.
- TrainingConversion is persisted idempotently from the versioned policy and rebuilds both Potential and Attribute projections. Matching Physical drills are available immediately when the player has enough Physical Potential.
- Versioned MVP prototype rules are approved for Training cost/growth, Aptitude, and Fate (`character-growth-mvp-1`).
- A pure Dart policy loader quotes Training costs from authored definitions, Aptitude ratings, and prior growth; it implements injected Aptitude rolls and a one-use mandatory Fate replacement. Character creation persists the rolled profile and seed.
- Fate replacement UI and a richer display of a character's Aptitude profile remain incomplete.

## Approved policy

The `character-growth-mvp-1` asset is explicitly prototype-only. It sets 18 base Potential for +1 permanent Attribute growth; Aptitude `1d6` changes cost by +2/0/−2 across ratings 1–2/3–4/5–6; per-Attribute prior growth tiers multiply cost by ×1/×2/×3 at 0–4/5–9/10+; Fate rerolls one chosen Aptitude once and the new result is mandatory. Full policy and examples are in `docs/systems/CHARACTER_PROGRESSION_SYSTEM.md`.

## Verification

- Character allocation source-of-truth: pure Dart CharacterInitialAllocation.
- First-playable widget integration: PASS for character creation, Life completion/reward, and six-card deck (M7 test path; integrated combat is not included).
- Training widget/repository tests: PASS for authored Analysis training and matching Physical reward → Reaction Drill conversion, including persisted cost, Attribute delta, and projection rebuild.
- Pure Dart policy tests cover version loading, cost tiers, injected Aptitude rolls, mandatory one-time Fate replacement, and policy/profile version checks.
- Human Android emulator playtest report received on 2026-10-06; the original findings and follow-up are recorded in `docs/prototype/playtests/2026-10-06-real-player-playtest.md`.
- Physical Android/iOS hardware verification and post-fix human retest: NOT_VERIFIED.

## Next implementation sequence

1. Add Fate replacement UI and make the persisted Aptitude profile understandable on the Character screen.
2. Connect the prepared character/deck and approved encounter inputs to a resumable battle UI with Weak Node payoff and post-battle feedback.
3. Retest the corrected Life → Training → Character → Adventure journey with players on Android and iOS; review balance and version any policy changes before beginning the seven-day pilot.
