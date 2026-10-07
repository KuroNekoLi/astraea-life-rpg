# Combat Landscape Device QA v1

**Status:** Automated viewport coverage implemented; physical-device execution pending
**Scope:** Ashfang Tutorial + Ashfang Free Practice
**Locales:** English + Traditional Chinese (zh-TW)

## Purpose

Validate that the landscape combat surface remains usable across realistic phone aspect ratios before physical-device sign-off.

This document separates two evidence classes:

```text
Automated Flutter viewport evidence
≠
Physical-device evidence
```

Passing widget tests does not count as physical-device verification.

## Automated Viewport Matrix

Covered by:

```text
test/features/combat/ashfang_landscape_viewport_matrix_test.dart
```

Target landscape sizes:

- 844 × 390
- 852 × 393
- 915 × 412
- 960 × 432
- 1200 × 700

Checks:

- tutorial primary CTA remains present
- free-practice primary actions remain present
- no Flutter overflow / layout exception
- zh-TW renders on a narrow landscape phone
- portrait mode shows the rotate-device message

## Physical-Device Matrix

Required before final visual sign-off.

### iOS

At least one modern iPhone with:

- notch / Dynamic Island safe area
- landscape gesture area
- default text size
- one larger text setting

### Android

At least one modern Android phone with:

- 19.5:9 or 20:9 display
- gesture navigation
- display cutout if available
- default font size
- one larger font size

## Manual Test Path

For each device:

1. Launch Ashfang tutorial.
2. Confirm landscape transition / orientation behavior.
3. Complete:
   - Fireball I Chantless
   - Reaction Interrupt
   - Analysis
   - Weak Node Interrupt
   - Fireball II Full Chant
   - Hold Formation
   - Fireball I finisher
4. Enter Free Practice.
5. Verify several independent decisions:
   - Basic Attack
   - Guard
   - Fireball I
   - save Reaction
   - Analyze on Rio turn
   - exploit Weak Node
6. Repeat once in zh-TW.

## Visual / Interaction Checklist

- no clipped text
- no content hidden under notch / system gesture area
- Timeline remains readable
- command buttons remain tappable without accidental overlap
- sticky CTA remains visible
- Reaction overlay fits without scrolling at normal text size
- Analysis node labels remain readable
- enemy intent does not collide with Stability text
- actor HP bars remain legible
- long zh-TW text does not overflow
- larger system text does not block progression
- touch targets feel comfortable with thumb use
- no unintended portrait AppShell appears inside battle
- transition back to Adventure works

## Performance Observation

Record:

- frame-rate feel during panel transition
- input latency
- Timeline animation smoothness
- Reaction overlay opening
- any jank when localization changes

No FPS claim should be made without real runtime measurement.

## Current Verification Status

### Automated

- landscape viewport tests: implemented
- English combat flow: implemented
- zh-TW combat render: implemented
- portrait rotate fallback: implemented

### Physical Device

```text
DEVICE_VERIFICATION = UNAVAILABLE
```

No physical-device or simulator-control capability is available in the current execution environment.

Do not convert this status to PASS until the manual matrix above is actually executed.
