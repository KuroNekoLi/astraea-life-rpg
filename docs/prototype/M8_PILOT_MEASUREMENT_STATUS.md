# M8 — Pilot Measurement

## Current state: measurement foundation ready; human pilot pending

- Added an opt-in, local-only event recorder. Measurement is off by default and events remain in the device's local database; there is no network or export path.
- The Home screen explains what is recorded and offers consent controls. Turning measurement off deletes stored pilot events.
- Event properties use a strict allowlist of keys and bounded values. Character names, notes, evidence, custom quest text, health data, and other free-form data are excluded.
- Instrumented available milestones: character created, Life Quest completed, reward granted, Prepared Deck confirmed, Function revealed, and Weak Node exploited. Recording is idempotent where a stable source identifier exists.
- Event contract includes training conversion, battle completion, and prototype completion, but those events cannot be emitted until the corresponding M3/M7 flows exist.

## Pilot execution: NOT VERIFIED

No seven-day human pilot has been conducted. The protocol in `pilot/PILOT_PROTOCOL.md` is a draft ready for product-owner review, with participant count, consent/retention ownership, success thresholds, and next-scope decision still open. Do not treat M8 as validated or make product decisions from synthetic data.

MVP prototype Training/Aptitude/Fate policy is now approved and versioned. M3 still lacks persisted Aptitude/Fate creation and executable TrainingConversion UI; M7 lacks the integrated battle/feedback journey. Those implementations and player review are prerequisites for a meaningful end-to-end pilot.

## Verification

- Recorder tests cover default opt-out, local allowlisted writes, idempotency, strict property validation, and deletion on opt-out.
- Full Flutter formatting, analysis, widget/unit tests, and pure Dart domain/game-engine tests are required before delivery.
