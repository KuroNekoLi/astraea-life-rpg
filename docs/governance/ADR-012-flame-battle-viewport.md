# ADR-012 — Flame for the Landscape Battle Viewport

## Status

Accepted — 2026-10-06

## Context

The combat UX and motion specifications call for a landscape JRPG battlefield with authored character/enemy staging, sprite motion, particles, camera effects, and an event-driven presentation. They also assign all combat commands and Function Graph interactions to Flutter/application code backed by `astraea_combat`. The battle route must request landscape and prevent input while the device remains in portrait.

Flutter already provides implicit and explicit widget animation, `AnimationController`, `CustomPaint`, `CustomPainter`, and Canvas APIs. Those are a strong fit for ordinary interface transitions and a small number of bespoke drawings. A custom-rendered, animated battlefield would additionally need Astraea to own sprite frame scheduling, scene object lifecycle, effect cleanup, camera transforms, and reusable scene composition. The UX/motion specifications ask for those facilities while keeping the battle HUD integrated with normal Flutter widgets.

Research was rechecked on 2026-10-06. The app workspace uses Flutter 3.47.6 stable / Dart 3.13.5. pub.dev reports Flame 1.38.2 as its latest stable release (published 2026-08-27), MIT licensed, targeting Android, iOS, Linux, macOS, web, and Windows. Its published SDK constraints are Dart `>=3.11.0 <4.0.0` and Flutter `>=3.41.0`, so the current app toolchain satisfies them. The package is maintained under the verified `flame-engine.org` publisher; its changelog/release history includes 1.38.2. These are package metadata and release facts, not a claim that every Flame feature has been validated on every listed target. [pub.dev package](https://pub.dev/packages/flame), [pub.dev versions and SDK minimum](https://pub.dev/packages/flame/versions), [MIT license](https://pub.dev/packages/flame/license), [Flame GitHub](https://github.com/flame-engine/flame).

Flutter's official animation APIs support typed implicit/explicit animations and frame-driven `AnimationController`s; `CustomPainter` provides a Canvas delegate and a repaint mechanism. Flame's `GameWidget` is a Flutter widget that can occupy only part of a widget tree, while its component system, sprite animation, effects, and particle components provide game-scene lifecycle facilities. These capabilities directly match the isolated battlefield stage. [Flutter animation overview](https://docs.flutter.dev/ui/animations/overview), [AnimationController API](https://api.flutter.dev/flutter/animation/AnimationController-class.html), [CustomPainter API](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html), [GameWidget guide](https://docs.flame-engine.org/latest/flame/game_widget.html), [Flame components](https://docs.flame-engine.org/latest/flame/components/components.html), [Flame effects](https://docs.flame-engine.org/latest/flame/effects/effects.html), [Flame particles](https://docs.flame-engine.org/latest/flame/rendering/particles.html).

### Research queries

- `site:pub.dev/packages/flame Flame 1.38.2 license SDK platforms`
- `site:docs.flame-engine.org/latest GameWidget Flame game widget component effects particles`
- `site:api.flutter.dev/flutter/widgets/CustomPainter-class.html CustomPainter Flutter`
- `site:api.flutter.dev/flutter/animation/AnimationController-class.html AnimationController Flutter`
- `site:github.com/flame-engine/flame Flame release changelog 1.38.2`

## Decision

Add Flame 1.38.2 as a root Flutter app dependency and use it only for the landscape battlefield viewport. A `GameWidget` hosts a narrowly scoped battlefield presentation adapter; Flame may own visual scene components, sprites, authored animation clips, particles, camera framing/shake, and visual-effect lifetimes.

Flutter remains responsible for the battle route and orientation lifecycle, safe areas, timeline, unit status, command rail, spell/deck and Function Graph panels, dialogs, combat log, accessibility semantics, and all user input/command dispatch. Flutter receives immutable battle-state snapshots and ordered presentation events from the application layer, which in turn calls `astraea_combat`. The presentation adapter maps those already-resolved events to visuals; it cannot decide legality, hit/miss, damage, turns, Function execution, Weak Node visibility, interruption, or outcomes. Animation completion never dispatches a combat command.

`packages/astraea_combat` remains pure Dart and authoritative for the existing combat and Function Graph rules. Flame must not be added to that package. The battle viewport is landscape-only per `COMBAT_UX_FLOW_SPEC.md`; orientation requests and restoration remain centralized at the route/platform integration layer, outside the Flame game object.

Flutter built-in animation/painting remains the selected tool for Flutter HUD transitions and small bespoke non-scene visuals. It is not selected as the main battlefield renderer because the requested stage needs a maintained 2D component/sprite/effect lifecycle. This is a limited renderer choice, not a migration of the app to an engine. Unity and native engine embedding are out of scope.

## Alternatives considered

| Option | Evidence and fit | Decision |
|---|---|---|
| Flutter implicit/explicit animations plus `CustomPaint` / `CustomPainter` | First-party Flutter APIs, no added dependency, full Flutter semantics/layout/accessibility integration. Suitable for HUD transitions, simple vector staging, and isolated custom visuals. Flutter exposes frame-driven controllers and Canvas painting, but Astraea would have to build and maintain the battlefield's sprite/component/effect lifecycle itself. | Keep for Flutter UI and simple paint work; do not make it the primary animated scene runtime for this scope. |
| Flame 1.38.2 | MIT; current stable package, Dart 3.11+ and Flutter 3.41+; pub.dev lists Android/iOS and other Flutter targets. `GameWidget` embeds as a regular Flutter widget. Flame provides component lifecycle, sprite animation, camera/effect and particle facilities. | Adopt only for battlefield presentation. It meets the toolchain constraints and supplies the commodity 2D scene lifecycle required by the motion spec. Verify Android/iOS behavior with a device/emulator spike before shipping. |
| Unity or native engine integration | No integration path is required for this 2D viewport; it would introduce another runtime/build/lifecycle boundary and duplicate the Flutter UI integration. No Unity embedding compatibility or license/build spike was in scope or performed. | Do not pursue for this viewport. Reopen only with a separately approved platform/product case and verified integration research. |

## Boundaries and integration contract

```text
Flutter route / controller
  ├─ owns orientation, input, accessibility, HUD, commands, persistence
  ├─ invokes astraea_combat and receives authoritative result + ordered events
  └─ sends immutable presentation snapshot/events to the viewport adapter
       └─ Flame GameWidget (landscape stage only)
            ├─ scene composition, sprites, animation, particles, camera/effects
            └─ no combat commands, RNG, rules, graph authority, or persistence
```

- Use stable combatant/node identifiers from domain/content as visual component keys; do not key persistent state by display name.
- Start a success visual only after the corresponding authoritative event arrives. A miss, rejected command, failed analysis, or failed interruption must not play a success effect.
- Keep the viewport non-authoritative and make its initial/restored pose derive from the latest state snapshot. Checkpoint restore must not replay stale events; route exit, app backgrounding, skip, and reduced-motion settings must settle visuals without reissuing commands.
- Flutter owns pointer and keyboard command controls. The battlefield must not absorb taps meant for Flutter controls; use an appropriate non-interactive hit-test configuration or Flutter hit-testing boundary, and verify semantics with the actual composed route.
- Keep Function Graph semantics and accessible labels in Flutter widgets. Flame visuals may mirror the graph's known state but cannot disclose hidden nodes or replace text/shape labels with color-only cues.
- Keep the initial dependency on the root app only. Do not add Flame or Flutter dependencies to `astraea_combat`.

## Risks and mitigations

- **Platform/orientation:** pub.dev lists Android and iOS but package metadata does not validate Astraea's route-level landscape request, safe insets, system bars, resume behavior, or iOS orientation declarations. Implement orientation centrally as specified and verify route enter/exit, portrait overlay, process resume, Android emulator/device, and iOS simulator/device where available.
- **Lifecycle and stale effects:** Flame's game loop can outlive an individual state transition if ownership is unclear. Give the route/controller one explicit viewport lifetime; pause/dispose when leaving or backgrounded. Rebuild from an authoritative snapshot after restore and deduplicate visual events by battle/revision/event identity.
- **Input and accessibility:** `GameWidget` can participate in hit testing, while Flutter controls must remain usable and semantically complete. Keep commands outside the game scene and review screen-reader order, text scaling, touch targets, reduced motion, and portrait blocking in Flutter integration tests and device review.
- **Performance and memory:** sprites, particles, camera effects, and layered backgrounds can add raster cost and decoded-image memory. Bound particle/effect count, dispose image caches according to route/app ownership, avoid unnecessary `saveLayer`/overdraw, and profile on representative Android hardware before increasing scene complexity.
- **Assets and license:** Flame code is MIT. This does not grant rights to third-party art/audio. Record provenance and license for every shipped asset and retain required notices.
- **Toolchain drift:** Flame 1.38.2 requires Flutter 3.41+ and Dart 3.11+. Keep the dependency constrained and recheck SDK compatibility during Flutter upgrades.

## Acceptance criteria before production battle UI is considered complete

1. Dependency resolution succeeds on the repository's Flutter 3.47.6 / Dart 3.13.5 toolchain, with Flame present only in the root app dependency graph and `astraea_combat` still pure Dart.
2. An Android landscape route can embed and dispose the Flame viewport while Flutter HUD/commands remain interactive; portrait input is blocked by the UX spec's rotate state.
3. A presentation adapter renders from domain snapshots and ordered resolved events. It cannot dispatch commands or mutate combat/function rules.
4. At least attack hit/miss, enemy intent/function presentation, successful/unsuccessful analysis/interruption, and terminal outcome are visually gated on their corresponding authoritative data; restore/skip/reduced-motion shows the same final state without stale playback.
5. Flutter semantics expose all critical status and Function Graph information without relying on Flame canvas text or color alone.
6. Device profiling and visual review confirm stable frame pacing on representative Android hardware and that effects do not obscure controls, status, or accessible content. iOS orientation behavior is verified before iOS release.

## Consequences

- The app adds a modest, MIT-licensed Flutter 2D runtime while retaining Flutter as the interface and platform shell.
- Scene implementation can use a maintained component/effect system instead of inventing an Astraea-only renderer.
- The viewport integration needs an explicit event-to-visual mapping, lifecycle ownership, asset provenance, and on-device performance review.
- This ADR changes no combat rules, balance values, encounter content, routing, or UI components.

## Non-goals

This decision does not implement a battle screen or scene, add character/enemy art, define a new animation timeline or combat mechanic, change checkpoint schema, or establish a Unity/native integration.
