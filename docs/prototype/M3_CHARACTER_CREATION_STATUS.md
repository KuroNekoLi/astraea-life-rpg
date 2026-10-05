# M3 — Character and Training Path

## Current state: BLOCKED / partial implementation

- Character name, canonical eight attributes, Base 8, exactly 32 allocation points, per-attribute cap 15, and four authored initial weapon choices are implemented and persisted locally.
- The character creation screen is accessible from Home. A widget-level first-playable test completes this step.
- Pure Dart allocation validation remains covered by domain tests.

## DECISION_REQUIRED

The source documents do not define Aptitude roll range/distribution, Fate reroll bounds, Training Potential costs, aptitude modifiers, or permanent attribute growth amounts. No numeric values were present in the GDD examples. The implementation does not execute Aptitude/Fate rolls or Training conversions in the UI.

The user was asked whether to keep Training preview-only, use editable prototype values, or provide exact values. Awaiting response. Until resolved, do not display an executable Training offer or fabricate growth.

## Verification

- Character allocation source-of-truth: pure Dart CharacterInitialAllocation.
- First-playable widget integration: PASS for character creation, Life completion/reward, and six-card deck (M7 test path; combat/training not included).
