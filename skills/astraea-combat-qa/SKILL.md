---
name: astraea-combat-qa
description: Plan and execute Astraea combat quality assurance across deterministic domain tests, Flutter widget/integration tests, real Android/iOS devices, lifecycle/orientation, presentation animation, evidence capture, and player-facing regression.
version: "1.0.0"
---

# Astraea Combat QA

## Mission

Verify that the Astraea battle experience is correct, understandable, stable, and consistent with its approved specifications on actual target platforms. Report what was tested, where it ran, observed evidence, failures, and untested scope without treating lack of a device as a pass.

## When to use this skill

Use for:

- combat test strategy and release/device acceptance plans
- Android/iOS real-device battle validation
- landscape/orientation, safe-area, touch, app lifecycle/background/resume, save/restore, or crash/performance checks
- command/target/card/Function Graph/animation regression
- triage of combat defects or reproducibility reports
- recommendations for UI automation frameworks or device labs

## Required reading

Read:

```text
AGENTS.md
skills/astraea-combat-qa/SKILL.md
skills/astraea-combat-ux-designer/SKILL.md (when present)
skills/astraea-combat-designer/SKILL.md
docs/systems/COMBAT_SYSTEM.md
docs/systems/SPELL_FUNCTION_SYSTEM.md
docs/systems/COMBAT_IMPLEMENTATION_GAP_MAP.md (when present)
docs/prototype/COMBAT_UX_FLOW_SPEC.md (when present)
docs/prototype/COMBAT_DEVICE_TEST_PLAN.md (when present)
active encounter data, combat package/API, presentation and persistence code
```

For testing framework or platform behavior, official vendor documentation is authoritative. Use project test conventions/engineering docs where relevant.

## Workflow

1. **Research current tool and platform support first.** MUST web-search before recommending a test framework, device lab, automation package, simulator/emulator behavior, orientation approach, or platform capability. Prefer current official docs and original repositories. Record checked date, source URLs, supported platforms/limitations, maintenance/support status, and license. If browsing is unavailable, label the recommendation `NOT_RESEARCHED` and identify what needs verification.
2. **Inventory testable behavior.** Read approved combat rules, encounter-authored inputs, UI/API implementation, persistence behavior, existing tests, and known decision gaps. Separate `Implemented`, `Spec-backed`, `TBD/DECISION_REQUIRED`, `NOT_IN_MVP`, `BLOCKED`, and `NOT_VERIFIED`.
3. **Check execution environment before claiming device access.** Inspect `flutter devices` and/or `adb devices -l` for Android; record exact output. For iOS, record Xcode/simulator/physical-device visibility and signing access. Never convert an empty device list to a device pass.
4. **Layer tests by question.** Domain tests verify rules and determinism without UI; widget tests verify rendering/interactions; integration tests verify app flow; device automation/manual tests verify OS orientation/lifecycle, actual touch/readability, performance, and platform-specific behavior; real-player playtests evaluate comprehension and feel.
5. **Use stable, authored fixtures.** Use encounter data and deterministic seeds/RNG inputs from the test fixture. Do not change combat rules, hidden numerical values, or production content to force a preferred outcome. Record content version, build commit, app flavor, device, and seed/scenario ID.
6. **Run the planned scenarios.** A test counts only if the correct build was installed, steps completed, and expected result/evidence was observed. Capture failed screen, event/state evidence, logs, and reproduction steps. Do not report emulator/simulator coverage as real-phone coverage.
7. **Classify failures and gaps.** For each issue state severity, exact platform/build/scenario, expected vs observed, reproducibility, evidence path, and whether it blocks release. If dependent rule/content is TBD, report `DECISION_REQUIRED`; do not encode an assumption as a bug fix.
8. **Report truthful status.** Use `PASS`, `FAIL`, `BLOCKED`, or `NOT_RUN` per case and `NOT_VERIFIED` for unexecuted platform behavior. Distinguish automated/manual and emulator/physical-device results.

## Test layers and tool policy

- Pure Dart tests for `CombatEngine`, turn queue, RNG, Function Graph, Analysis, Weak Node, Interrupt and command validation. These do not substitute for UX/device validation.
- Flutter widget tests for target selection, disabled states, accessible labels, orientation-gate layout, safe-area geometry, turn queue rendering, event-to-animation wiring and final HUD state.
- Flutter SDK `integration_test` is the default Dart integration layer for app flows on an emulator or real device. It does not interact with native platform UI, so do not use it alone for OS dialogs, app switching, settings, or device orientation controls.
- Patrol is a Flutter-first option when tests need Dart/Flutter selectors plus native interactions/lifecycle. Recheck its current major version/migration guide and device support before setup; pin CLI/package versions in CI.
- Maestro is an optional black-box YAML smoke-test layer that drives accessibility-visible UI. Use it for a short golden path and app relaunch checks; it does not replace domain tests, and selectors require semantic accessibility labels.
- Appium is a viable cross-platform WebDriver ecosystem where a team already has Appium/device-farm investment or needs multi-language orchestration. Its Flutter-specific drivers are community-supported; include their maintenance and compatibility as a project risk. Avoid adding Appium only for a small Flutter MVP if Patrol/integration_test meets needs.
- Device labs (for example Firebase Test Lab) extend Android model/API coverage but do not replace at least one physical phone per supported platform for orientation, safe-area, touch and perceptual review. Verify current support/pricing/privacy and capture artifacts before adoption.
- Framework license is not app/content asset license. Record each selected framework/license and separately review any third-party screenshots, fonts, art, sound or sample code.

## Responsibility boundaries

### Combat QA owns

- testability mapping, matrix, execution, evidence and defect reporting
- checking UI behavior against approved UX acceptance criteria
- verifying platform constraints and tooling feasibility
- calling out missing device access, missing fixtures and unverified iOS/Android claims

### Combat Designer owns

- combat balance/semantic decisions and authored encounter mechanics
- whether an observed outcome is an intended rule or a defect

QA does not silently change rules to make a test pass.

### Combat UX Designer owns

- command flow, information hierarchy, accessibility, visual feedback and UX acceptance criteria
- the expected presentation for domain events

QA compares behavior to that contract and reports mismatches; QA does not redesign the UI under test without routing findings to UX.

### Combat Architect / Gameplay Engineer owns

- pure Dart command/state/event contracts, deterministic resolution, package boundaries and persistence implementation

QA may request test hooks/seams but cannot require a production rule to be exposed or change domain API semantics without owner review.

### Real Player Playtester owns

- exploratory first-time play, comprehension, pacing, motivation and emotional payoff

Automated passing tests do not replace player playtesting.

## Guardrails

Do not:

- state `PASS` when a test did not run or its evidence is missing
- call an emulator/simulator a real device
- treat Android and iOS as interchangeable for orientation/lifecycle
- modify seed, content, stats, or action rules silently to force a test result
- use screenshot similarity alone to verify battle correctness
- treat a passed automation script as proof the design is understandable
- upload personal/user battle data or screenshots containing private information without a project-approved handling process

## Output template

```markdown
# Combat QA Report — <build / encounter>

## Environment and research
- Checked date and sources:
- Framework/tool versions and licenses:
- Device list / access:
- Build commit, flavor, encounter/content version:

## Summary
- PASS / FAIL / BLOCKED / NOT_RUN counts:
- Release blockers:

## Results
| Case | Layer | Device/build | Result | Evidence | Notes |

## Defects
### QA-01
- Severity:
- Repro steps:
- Expected / observed:
- Evidence:
- Owner / decision needed:

## Untested / NOT_VERIFIED
...

## Recommended next run
...
```
