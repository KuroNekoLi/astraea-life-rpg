# Combat Simulator QA Prompt

Use this prompt with ChatGPT Work / Codex / a local coding agent that has computer-use access to this repository and the host macOS desktop.

```text
You are the simulator QA engineer for Astraea Life RPG.

Repository:
KuroNekoLi/astraea-life-rpg

Local repo:
Use the existing local clone. Do not create a new app or replace project configuration.

Mandatory project context before testing:
1. Read AGENTS.md.
2. Read FLUTTER_ENGINEERING_STANDARDS.md.
3. Read docs/ui/ASTRAEA_UI_UX_FOUNDATION_V1.md.
4. Read docs/ui/COMBAT_HIGH_FIDELITY_DESIGN_V1.md.
5. Read docs/systems/COMBAT_RULES_V1_BASELINE.md.
6. Read docs/qa/COMBAT_LANDSCAPE_DEVICE_QA_V1.md.
7. Read docs/playtest/ASHFANG_REAL_PLAYER_PLAYTEST_V1.md.
8. Use skills/astraea-real-player-playtester/SKILL.md.
9. Use skills/astraea-ui-ux-director/SKILL.md.
10. Use skills/astraea-vision-guardian/SKILL.md.

Goal:
Run the real Flutter app on iOS Simulator and Android Emulator in landscape and verify the Ashfang Tutorial + Free Practice flow. Do not substitute widget tests for simulator evidence.

Before launching:
- git status must be understood; do not destroy unrelated local changes.
- flutter pub get
- dart run build_runner build
- dart run tool/check_localized_ui.dart
- dart format --output=none --set-exit-if-changed .
- flutter analyze
- flutter test
- dart test test/domain test/game_engine

If any command fails:
- diagnose it,
- fix only if the failure belongs to this task,
- rerun the full relevant gate,
- record the fix and commit.

iOS Simulator:
1. Confirm Xcode / Simulator is available.
2. Start a modern iPhone simulator with a notch or Dynamic Island if possible.
3. Prefer one compact and one large device, for example:
   - iPhone 15 / equivalent compact modern iPhone
   - iPhone 15 Pro Max / equivalent large iPhone
4. Run the app with flutter run on that simulator.
5. Rotate to landscape using Simulator UI / computer use.
6. Verify safe areas and both landscape orientations if practical.

Android Emulator:
1. Use flutter emulators / Android Studio Device Manager.
2. Prefer a Pixel-class emulator around 19.5:9–20:9.
3. Launch it and run flutter run.
4. Rotate to landscape.
5. If shell rotation is useful:
   adb shell settings put system accelerometer_rotation 0
   adb shell settings put system user_rotation 1
6. Restore normal auto-rotation when finished.

Run this exact Tutorial path:
Adventure
→ Start Ashfang Training Battle
→ Fireball I · Chantless
→ Interrupt known Fireball
→ Analyze Modified Function
→ reveal Stabilization Weak Node
→ exploit Interrupt
→ Fireball II · Full Chant
→ observe pending Resolve event on Timeline
→ Hold Formation
→ Fireball II Resolve
→ Fireball I finisher
→ Victory
→ Free Practice

Then test Free Practice without following a scripted solution:
- confirm Basic Attack / Guard / Fireball I / Fireball II are simultaneously available on Hero turn
- intentionally Save Reaction once
- on Rio turn, Analyze the active Function
- verify Weak Node appears only after Analysis
- verify Exploit Weak Node appears when knowledge supports it
- try a non-Analysis Interrupt path in a separate reset
- verify battle continues and no tutorial-only highlighted answer forces the choice

Repeat key screens in:
- English
- Traditional Chinese zh-TW

Because the app follows system locale, change the simulator/emulator system language/locale rather than hardcoding locale in production code.

For each device, explicitly inspect:
- notch / Dynamic Island / cutout safe area
- bottom gesture bar
- Timeline readability
- enemy intent ribbon
- Stability text collision
- sticky primary CTA visibility
- Reaction overlay height
- Analysis graph node labels
- Ashfang artwork size/cropping
- Training Hall background crop
- actor HP/Mana readability
- zh-TW overflow
- English long-label overflow
- touch target comfort
- orientation transition
- return to Adventure
- Tutorial → Free Practice transition

Text-scale QA:
- default text size
- one larger accessibility text size
Do not claim accessibility PASS if larger text prevents progression.

Visual QA:
Capture screenshots for:
1. Tutorial opening
2. Reaction window
3. Analysis Weak Node state
4. Hero Full Chant pending Resolve
5. Victory
6. Free Practice Hero turn
7. Free Practice Reaction window
Capture at least one English and one zh-TW screenshot.

Performance observation:
Do not invent FPS numbers.
Record subjective jank/input-delay observations.
If profiling is available, use Flutter DevTools/profile mode and record actual evidence separately.

Real-player review:
After technical QA, switch to the Real Player Playtester perspective and answer:
- Does this feel like a real RPG battle rather than a productivity UI?
- Can I explain Interrupt vs Analysis after playing once?
- In Free Practice, do I make a choice or merely follow highlighted UI?
- Is Full Chant timing understandable?
- Does Weak Node feel discovered rather than handed to me?
- Is Ashfang visually readable at phone scale?
- Is the battlefield too busy after adding the background/art?
- What is the single most confusing moment?
- Would I voluntarily play a second enemy encounter?

Severity:
P0 = cannot complete / crash / wrong rule
P1 = major confusion / wrong tactical meaning / severe layout issue
P2 = polish or learnability issue
P3 = minor cosmetic issue

Output:
Create or update:
docs/qa/COMBAT_LANDSCAPE_DEVICE_QA_RESULTS_V1.md
docs/playtest/ASHFANG_REAL_PLAYER_PLAYTEST_FINAL_V1.md

Include:
- devices/emulators actually tested
- OS versions
- viewport/orientation
- language
- screenshots or repository-relative evidence where possible
- PASS/FAIL for each checklist item
- findings with P0/P1/P2/P3
- exact reproduction steps
- fixes applied
- remaining blockers

Final rule:
Do NOT mark DEVICE_VERIFICATION as PASS unless you actually ran the app on both iOS Simulator and Android Emulator.
Do NOT claim physical-device PASS from simulators.
Do NOT redesign combat rules during QA.
```
