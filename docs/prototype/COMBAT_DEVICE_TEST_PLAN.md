# Combat Device Test Plan

**Status:** Proposed acceptance plan; device execution not performed in this environment.
**Research checked:** 2026-10-06. Recheck official platform and tool documentation before each execution cycle.

## Purpose and evidence status

This plan verifies the approved combat experience on physical Android and iOS phones. Emulator or simulator results are useful for flow coverage, but do not count as real-device evidence for orientation, touch, safe areas, performance, lifecycle, or readability.

Environment inspection for this planning pass:

- `/workspace/android-sdk/platform-tools/adb devices -l` returned only `List of devices attached`; no Android device was attached. Bare `adb` was not on PATH.
- No Xcode/iOS device environment was available.
- Therefore every real-device case below is `NOT_RUN`; there is no physical-device evidence from this pass.

Use `PASS`, `FAIL`, `BLOCKED`, and `NOT_RUN` per test case. Use `NOT_VERIFIED` for untested platform behavior. Record a `DECISION_REQUIRED` blocker when the needed combat mechanic or persistence contract is not approved/implemented.

## Current tooling research and staged recommendation

Sources were checked on 2026-10-06. Recheck current versions, compatibility, and terms before adding dependencies.

| Tool | Appropriate role | Constraints/status | License/provenance |
|---|---|---|---|
| Flutter `integration_test` | Default in-app Dart integration layer for app flows on emulator or device | First-party Flutter package. Does not interact with native platform UI; cannot alone prove OS orientation UI, app switching, settings, or native dialogs. | Flutter packages repository is BSD-3-Clause. |
| Patrol | Flutter selectors plus native interactions and lifecycle/background scenarios | Useful second stage when tests need native UI/app lifecycle. Recheck major version/migration docs and orientation coverage; pin versions. | Original LeanCode project, Apache-2.0. |
| Maestro | Short black-box accessibility-driven YAML smoke flows and relaunch checks | Does not expose engine state; semantics/accessibility labels must be stable. Plan manual OS rotation unless a current official capability is verified. | CLI repository Apache-2.0; Studio is a separate proprietary product. |
| Appium | Cross-platform WebDriver ecosystem where infrastructure already exists | More setup for this MVP; Flutter-specific drivers are community-supported, so compatibility/maintenance is a risk. | Appium Apache-2.0; verify each selected driver separately. |
| Android UI Automator | Native Android-only OS/platform UI checks | Useful for platform-specific interactions; not a shared Android/iOS solution. | Android platform documentation/project; verify test dependency terms when adopted. |

Recommended staged approach:

1. Pure Dart tests for combat rules, deterministic queue/commands/events, Function analysis/interruption, and persistence mapping.
2. Flutter widget tests for layout, semantics, command state, orientation gate, and event-driven feedback.
3. Flutter `integration_test` for the authored golden path and save/restore app flow.
4. Patrol only where native lifecycle or OS UI interaction is needed; Maestro may provide a small black-box smoke path. Keep native orientation control/manual checks in the device plan until verified for the chosen tool/version.
5. Run Android device-lab coverage for model/API breadth if adopted, plus at least one physical phone per supported OS for final landscape, safe-area, touch, and performance acceptance. Do not treat lab/emulator coverage as physical-phone evidence.

Tool references:

- Flutter integration testing: https://docs.flutter.dev/cookbook/testing/integration/introduction ; https://docs.flutter.dev/testing/overview ; https://docs.flutter.dev/testing/integration-tests
- Flutter package license: https://github.com/flutter/packages/blob/main/LICENSE
- Flutter performance guidance: https://docs.flutter.dev/perf/ui-performance
- Patrol overview/first test/CLI/migration: https://patrol.leancode.co/documentation/native/overview ; https://patrol.leancode.co/documentation/write-your-first-test ; https://patrol.leancode.co/cli-commands/test ; https://patrol.leancode.co/native-to-platform-migration ; source: https://github.com/leancodepl/patrol
- Maestro documentation/source: https://maestro.mobile.dev/ ; https://github.com/mobile-dev-inc/maestro
- Appium documentation/drivers/source: https://appium.io/ ; https://appium.io/docs/en/latest/ecosystem/drivers/ ; https://github.com/appium/appium
- Appium Flutter driver (community project): https://github.com/appium/appium-flutter-driver
- Android UI Automator: https://developer.android.com/training/other-components/ui-automator
- Android device testing / Firebase Test Lab: https://developer.android.com/studio/test/test-in-android-studio ; https://patrol.leancode.co/documentation/integrations/firebase-test-lab

Orientation constraints to verify on the target OS versions:

- Flutter `SystemChrome.setPreferredOrientations`: https://api.flutter.dev/flutter/services/SystemChrome/setPreferredOrientations.html . It documents Android 16/API 36 behavior for displays at least 600dp wide and the iPad multitasking caveat.
- Android orientation/resizability guidance: https://developer.android.com/develop/adaptive-apps/guides/app-orientation-aspect-ratio-resizability ; Android 16 behavior changes: https://developer.android.com/about/versions/16/behavior-changes-16?hl=en . Android 16 may ignore orientation locks on large displays, with stated exceptions; validate the actual phone/tablet/window class rather than assume a lock always applies.
- Apple supported interface orientations: https://developer.apple.com/documentation/bundleresources/information-property-list/uisupportedinterfaceorientations . Validate iPhone and iPad separately if both are supported.

License and asset boundary: framework license does not grant reuse rights for game screenshots, art, audio, fonts, or sample content. Capture only Astraea-owned or approved test material; record third-party asset provenance and license separately.

## Device matrix

Fill model, OS/build, app build/commit, display size, and result before execution. Each platform must include a physical phone. Use at least two Android phone profiles and two iPhone profiles where available, covering current and oldest supported OS and different notch/dynamic-island/safe-area shapes. Add tablets/foldables only if declared supported; their orientation behavior is a distinct test class.

| ID | Target | Profile | Required status |
|---|---|---|---|
| AND-PHONE-1 | Physical Android phone | Current supported Android; one OEM/display cutout profile | NOT_RUN |
| AND-PHONE-2 | Physical Android phone | Oldest supported Android or second OEM/safe-area profile | NOT_RUN |
| IOS-PHONE-1 | Physical iPhone | Current supported iOS; current safe-area profile | NOT_RUN |
| IOS-PHONE-2 | Physical iPhone | Oldest supported iOS or alternate screen/safe-area profile | NOT_RUN |
| AND-LARGE (conditional) | Android tablet/foldable/windowed mode | API 36+ and >=600dp window if supported | NOT_RUN / NOT_IN_SCOPE |
| IOS-IPAD (conditional) | Physical iPad | Multitasking enabled/disabled if supported | NOT_RUN / NOT_IN_SCOPE |

## Entry criteria and setup

- Candidate build installs from a recorded commit; record flavor, package/version, content version, encounter ID, combat package version, and build mode.
- Approved golden encounter and deterministic fixtures exist for normal hit, miss, critical, analysis success/failure, interrupt success/failure, victory, defeat, and multi-unit turn queue. If an approved fixture or rule is absent, mark its case `BLOCKED` and request the owning designer's decision; do not create production values to unblock QA.
- Enable event/log capture and Android logcat or iOS device console as applicable. Capture screen recording for timed presentation; screenshots alone do not prove event ordering or command uniqueness.
- For each run, capture device model, OS version/build, display/resolution, orientation lock setting, text scale, reduced-motion setting, network state if relevant, seed/scenario ID, and tester.
- Reset app data only for clean-install cases. Keep separate save snapshots for restore cases.

## Test cases

### Orientation and entry/exit

| ID | Procedure | Pass criteria | Evidence |
|---|---|---|---|
| OR-01 Cold launch and battle entry | Force-stop; set phone portrait; cold launch; navigate to battle route. | Non-battle screens remain usable per app design; battle enters landscape. No battle command is operable until a valid landscape presentation is ready. No stretched or cropped critical HUD. | Portrait and landscape recording; route/event log; device and OS metadata. |
| OR-02 Portrait cannot operate | During battle, rotate to portrait and attempt all visible command controls. Repeat with OS orientation lock on/off where available. | Portrait is either prevented by supported OS configuration or presents a clear landscape-required gate; no hidden/overlapping command accepts a tap. Return to landscape restores the same battle state and no command is duplicated. | Recording, command/event count before/after rotation, orientation state. |
| OR-03 Exit restoration | Exit battle through every supported exit path (victory/defeat/back/cancel if approved); inspect next route orientation. | Battle-specific landscape request is released/restored according to app policy. No route remains forced landscape unintentionally. | Route transitions, orientation readings, logs. |

### Layout, input, accessibility

| ID | Procedure | Pass criteria | Evidence |
|---|---|---|---|
| UX-01 Safe areas | Run battle on each notch/cutout profile; inspect stage, queue, HUD, command rail, dialogs, and bottom/top edges. | Interactive/text content avoids unsafe insets; no clipping/overlap; backdrop may extend behind inset only where intentional. | Annotated screenshots for each device. |
| UX-02 Touch accuracy | Tap every primary menu, target, card, cancel, confirm, pause, and exit control at center and near edges; repeat taps around adjacent controls. | Taps activate intended control once; controls do not overlap; touch target is at least 48dp where practical or has a documented platform-appropriate accessible hit region. | Recording and control map; event log confirms one command per accepted tap. |
| UX-03 Text scaling | Test system text/display scale at 1.0x, 1.3x, and 2.0x where platform permits. | Labels, HP/status, turn order, Function labels, and dialogs remain readable and actionable; overflow does not cover controls. If the battle experience deliberately caps scaling, the app communicates supported behavior accessibly. | Screenshots, scale setting, accessibility audit notes. |
| UX-04 Reduced motion | Enable OS reduced-motion setting; run attack, cast, hit, critical, analysis, interrupt, victory, defeat. | Non-essential motion is reduced; event/result information remains clear; no timing dependency or lost/duplicated command. | Before/after recordings and event log. |

### Commands, targeting, and turn queue

| ID | Procedure | Pass criteria | Evidence |
|---|---|---|---|
| CMD-01 Weapon attack | Open active character menu; choose weapon attack; choose target; cancel once, then select and confirm. | Menu/target state matches UX contract; cancel returns without resolving; confirmed attack resolves once against selected valid target; log/HUD/event agree. | Recording, command/event IDs, resulting state. |
| CMD-02 Spell card | Open spell selection, inspect card details/availability, select/cancel/target/confirm only for an approved executable card fixture. | Preview reflects authored data; unavailable card cannot be submitted; target and resolved event match. If current encounter has names-only/non-executable cards or no approved spell rules, mark execution `BLOCKED`/`NOT_IN_MVP`, and verify the disabled/explanatory state only. | Screen recording, fixture/version, command log. |
| CMD-03 Items | Open item entry. | If item domain/effects are absent, item affordance is visibly disabled or a non-actionable placeholder; no invented inventory/effect/command can be dispatched. | Screenshot and command/event log showing no item command. |
| TURN-01 Multi-unit queue | Use an approved fixture with multiple allied units and boss/enemy units; progress turns through a full cycle. | Displayed order and active actor always match engine-authored queue; each actor receives exactly its authorized turn; defeated/ineligible actors are handled per approved rule; no UI-derived initiative. If fixture/rules absent, BLOCKED. | Queue recording, engine event sequence, scenario ID. |
| CMD-04 Invalid target/repeated input | Tap confirm rapidly; repeat after transition; select defeated/invalid target where UI exposes it. | Engine validation remains authoritative; invalid commands show understandable feedback; one accepted action maximum for the gesture/command; no duplicate resolution. | Timestamped command/event IDs and recording. |

### Combat results and Function Graph

| ID | Procedure | Pass criteria | Evidence |
|---|---|---|---|
| RES-01 Hit/miss/critical | Run one deterministic fixture for each authored result. | Animation, HUD, and log show the same authoritative result; hit/miss/critical visuals are distinguishable without color alone; no client-side result inference. If chance/formula/fixture is TBD, BLOCKED pending approved case. | Event stream plus recordings/screenshots and seed. |
| FUNC-01 Analyze | Inspect visible Function; perform Analysis using approved fixture; include success and failure if specified. | Only authored/earned knowledge is exposed; analysis result and Weak Node state match engine event; log explains result without revealing hidden nodes prematurely. | Before/after Function view, events, scenario fixture. |
| FUNC-02 Interrupt | Target known Weak Node and attempt an approved interrupt; include success and failure fixture if rules permit. | Function topology visibly changes only when authoritative interrupt event says so; downstream behavior/result matches authored encounter and log. Failure cost/consequence is tested only if specified. If missing, BLOCKED/DECISION_REQUIRED. | Function graph before/after, event order, state snapshot, recording. |
| TERM-01 Victory | Complete approved victory fixture. | Input is locked only after authoritative terminal state; victory feedback/reward summary matches outcome; exit does not rerun last command. | Recording, terminal event, final state. |
| TERM-02 Defeat | Complete approved defeat fixture. | Defeat feedback and recovery/exit options match approved product behavior; no false victory/reward state; repeated taps do not duplicate resolution. | Recording, terminal event, final state. |

### Persistence, lifecycle, stability

| ID | Procedure | Pass criteria | Evidence |
|---|---|---|---|
| LIFE-01 Save/restore | Save at approved safe battle checkpoints, force-stop and relaunch, resume. Include a turn boundary and Function-analysis/interrupt state if persistence contract supports them. | Restored actor/queue, HP/status, Function knowledge/topology, log cursor, and available commands match saved authoritative state. No action is replayed and no event is duplicated. Unsupported checkpoint semantics are BLOCKED pending decision. | Pre/post state snapshots, event IDs, recording, saved content/build version. |
| LIFE-02 Background/resume | Background app during command menu, target selection, animation playback, and between turns; resume. | Battle recovers to a valid state; in-flight command resolves at most once; animation may resume/settle but cannot re-dispatch; controls remain correctly locked/unlocked. | OS lifecycle timestamps, state/event log, recording. |
| LIFE-03 Interrupted install/process | Kill app at the same phases as LIFE-02, relaunch. | Behavior follows approved persistence/recovery policy; never presents state inconsistent with authoritative saved state. If no policy exists, BLOCKED and route for decision. | Crash/kill method, snapshots, logs. |
| PERF-01 Session performance/crash | Profile build; play ten consecutive full encounters per physical phone, including effect-heavy moments; monitor frame timeline, memory trend, crash/ANR/device logs. | Zero crash, ANR, unhandled exception, input deadlock, or corrupted state. Record frame metrics. Provisional UX budget: target 60fps where supported, p95 frame time <=16.7ms and investigate any repeated >100ms stall; treat these as proposed QA thresholds requiring product/platform sign-off before using as release gate. | DevTools/perf trace, device logs, start/end memory, recordings, run count. |

## Measurement and evidence protocol

For each case, record:

- Case ID, result, tester, date/time, physical/emulator classification.
- Device model, OS/build, app build/commit, screen size/density, orientation, text scale, reduced-motion setting.
- Encounter/content version, deterministic scenario/seed, starting save snapshot, expected result source.
- Steps and observed result, including timestamps for command, domain event, animation start/end, and terminal state where relevant.
- Evidence paths for video, screenshots, logs, event trace, state snapshots, and performance trace. Redact personal data before sharing.
- Defect ID/owner and whether the cause is UX, implementation, authored content, platform constraint, or unresolved rule decision.

Capture a short landscape recording for each scenario and a screenshot at each asserted state. Preserve event IDs/counts to prove no duplicated commands. A screenshot by itself is insufficient for turn order, animation timing, lifecycle recovery, or command uniqueness.

## Exit criteria

- All applicable phone-matrix cases are `PASS` with evidence on at least one physical Android phone and one physical iPhone.
- No unresolved P0/P1 crash, orientation, command duplication, state corruption, safe-area blocking, or terminal-outcome defect.
- Cases requiring unapproved mechanics are explicitly `BLOCKED` with a named decision owner; they are not converted to passes by testing a placeholder.
- Emulator/simulator and device-lab results are reported separately from physical phone results.
- Every remaining `NOT_RUN`/`NOT_VERIFIED` item is listed in the release note/test report.
