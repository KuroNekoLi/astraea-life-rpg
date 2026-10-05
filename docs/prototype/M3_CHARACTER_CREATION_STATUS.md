# M3 — Character and Training Path

## Current state: BLOCKED / partial implementation

- Character name, canonical eight attributes, Base 8, exactly 32 allocation points, per-attribute cap 15, and four authored initial weapon choices are implemented and persisted locally.
- The character creation screen is accessible from Home. A widget-level first-playable test completes this step.
- Pure Dart allocation validation remains covered by domain tests.
- A read-only Training preview now displays the persisted Physical, Cognitive, and Communication Potential projections from confirmed Life Quest rewards. It spends nothing and does not imply that Potential directly changes Attributes.
- The preview explains that Training conversion is unavailable pending approved Training cost/growth, Aptitude, and Fate rules.

## DECISION_REQUIRED

The source documents do not define Aptitude roll range/distribution, Fate reroll bounds, Training Potential costs, aptitude modifiers, or permanent attribute growth amounts. No numeric values were present in the GDD examples. The implementation does not execute Aptitude/Fate rolls or Training conversions in the UI.

The user selected “Prototype values from GDD examples” for reward/progression decisions, but the referenced source documents do not actually specify Training/Aptitude/Fate values. The requested basis therefore does not authorize invented conversion numbers. Keep the screen preview-only until a concrete policy/content table is approved.

## Verification

- Character allocation source-of-truth: pure Dart CharacterInitialAllocation.
- First-playable widget integration: PASS for character creation, Life completion/reward, and six-card deck (M7 test path; combat/training not included).
- Training preview widget: displays saved balances, zero balances for absent categories, and the no-conversion boundary.
- Real-player/device review: NOT_VERIFIED.

## Next implementation sequence

1. Resolve the Training/Aptitude/Fate policy and version its authored values; this is the current product decision gate.
2. Add an idempotent Training Conversion flow that only accepts those authored values and updates the Attribute projection.
3. Connect the prepared character/deck and approved encounter inputs to a resumable battle UI with Weak Node payoff and post-battle feedback.
4. Run the full first-playable flow with real players before beginning the seven-day pilot.
