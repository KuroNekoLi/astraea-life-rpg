# ADR-011 — Pure Dart Combat Local Package

## Status

Accepted.

## Context

Astraea's combat reducer, battle models, Function Graph runtime, and seeded RNG need a stable engine boundary that can be tested and reused independently from the Flutter application. Their prior location under `lib/game_engine/` was already pure Dart, but it was compiled and owned only as part of the app package.

The combat presentation may later gain richer Flutter or 2D scene animation. Rendering and animation must not become a second authority for turn rules, damage, Function execution, or encounter balance. Existing authored encounter values and current rules remain authoritative; this module decision does not resolve pending combat design or balance questions.

## Decision

Create `packages/astraea_combat` as a local, pure Dart package in the repository. Its public API is exposed through the single barrel `package:astraea_combat/astraea_combat.dart` and owns the existing combat models/reducer, Function Graph/runtime, and RNG implementations.

The package must not depend on Flutter, Riverpod, Drift, routing, or application features. Encounter definitions and numeric inputs remain authored by the app/content layer and are passed into the engine; this ADR does not add or imply new gameplay rules.

The root Flutter app depends on the package by local path. Existing `lib/game_engine/{combat,function_graph,rng}/` import paths remain thin export facades during migration so app features and tests can move to the package incrementally. Persistence adapters, encounter loading, orchestration, and UI remain in the application until separately changed.

This boundary is not a decision to build every layer ourselves. It isolates Astraea's existing rules. Rendering, animation, input, and general-purpose scheduling should use an existing framework where it fits; `astraea_combat` remains the authoritative rules layer and must not become a second renderer or scene engine.

## Alternatives Considered

Research was checked on 2026-10-06. Versions, activity and platform declarations below are a point-in-time snapshot and must be checked again before adding a dependency. Search query log appears after the candidate review.

| Candidate | License and maintenance/platform evidence | Fit and disposition |
|---|---|---|
| [Flame](https://github.com/flame-engine/flame) / [pub.dev](https://pub.dev/packages/flame) | MIT. pub.dev lists Flame 1.38.2, Android/iOS/desktop/web and a release 39 days before this review. GitHub listed 10.8k stars, about 3,990 commits, and a push on the review date. `GameWidget` can sit within an existing Flutter widget tree; Flame provides sprites, animation, effects, particles and input. | **Preferred candidate for a future 2D scene/animation spike.** It provides rendering infrastructure, not a ready-made JRPG combat reducer, turn economy, or Function Graph. Keep combat state/rules in this package and use Flame to present events if a prototype validates the added dependency. Do not add Flame solely to obtain a separate package boundary. |
| [Bonfire](https://github.com/RafaelBarbosatec/bonfire) / [pub.dev](https://pub.dev/packages/bonfire) | MIT. pub.dev lists Bonfire 4.0.0 and Android/iOS/desktop; the repository had about 1,480 stars and a push on 2026-09-07. Its current feature set includes RPG actors, maps, real-time melee/ranged attacks, projectiles, combat feedback, life bars and behavior-tree AI. | **Do not use as the turn-combat system.** Its maintained RPG machinery is oriented toward top-down exploration/action. Astraea needs a menu-driven turn loop and Weak Node / Function Graph interactions. It may be reconsidered if the product adds a Bonfire-style action world. |
| [Scene-Dash v2](https://github.com/ali-solak/scene_dashV2) / [pub.dev](https://pub.dev/packages/scene_dash_v2) | MIT. pub.dev listed 0.5.6, all Flutter platforms, three GitHub stars and a release within hours of this review; GitHub showed an update on 2026-10-06. It has a pure-Dart ECS core, headless tests, event/state/routine systems, and a combat sample. Its scene integration uses `flutter_scene`; its published quick start asks for Flutter 3.47+ and `--enable-flutter-gpu`. | **Interesting architecture to evaluate, not a mature combat module.** The sample is an ECS/3D action-combat slice, not an Astraea turn-based rules package. Current Flutter 3.47.6 meets the listed minimum, but GPU/data-asset flags, the young release history, and a different scene model need a deliberate spike before adoption. It could inform future orchestration/rendering; it does not replace Function Graph rules. |
| [Just Game Engine](https://github.com/just-unknown-dev/just-game-engine) / [pub.dev](https://pub.dev/packages/just_game_engine) | BSD-3-Clause. pub.dev listed 1.6.1, Android/iOS/desktop/web, and a release 54 days before review. GitHub showed 4 stars and a push on 2026-09-30. It provides 2D Canvas rendering, sprite/tween animation, particles, ECS, scene graph and a fixed-timestep loop, but has a young/low-adoption footprint and a broad set of sibling dependencies. | **Do not replace the rules layer with it.** It may be compared with Flame for presentation if Flame cannot meet the intended scene effects. Its published feature list does not provide the specific turn-based RPG/Function Graph combat model Astraea needs. The larger dependency surface needs a prototype before selection. |
| [flutter_ludo](https://pub.dev/packages/flutter_ludo) | MIT. pub.dev listed 0.2.0, Android/iOS/desktop/web, published 9 days before review. It advertises a pure/stateless engine, turn-based state, animations, JSON save/restore, bots and rules/widget tests. | **Reference only.** It demonstrates a reusable engine/UI split and deterministic testing, but its board, turn and movement rules are Ludo-specific. Its low release age/adoption and incompatible domain mean it cannot serve as Astraea's combat engine. |
| [DevilF Engine](https://github.com/ym6745476/devilf) / [pub.dev](https://pub.dev/packages/devilf_engine) | BSD-3-Clause. pub.dev still lists 0.1.0 (published five years earlier), Android/iOS/web and 35 weekly downloads; GitHub showed 89 stars and the last push on 2025-06-12. It is a Flutter/Dart 2D RPG engine with a playable example, but no evidence of a maintained, modular JRPG turn-combat API. | **Do not adopt.** The stale package release, low package use and lack of matching turn-based/Function Graph semantics make it a weaker base than maintaining the existing rules and selecting a renderer separately. |
| [Parry](https://github.com/NinthDesertDude/Parry) | No license declared on GitHub; C# library targeting .NET Framework 4.7.2; 24 commits, 0 stars, last push 2022-12-17. Its README describes a real turn-based system with turn progression, movement/targeting, arbitrary move callbacks, events and weighted target selection. | **Do not reuse or port.** It is the closest rules-framework concept found, but it is stale, has no declared reuse license, targets a different runtime, and does not implement Astraea's Function Graph. Its design can be studied for turn orchestration only. |
| [OpenRpg](https://github.com/openrpg/OpenRpg) | MIT. GitHub listed C#, 96 stars, and a push on 2026-07-08. It is a .NET RPG data/model framework with an `OpenRpg.Combat` area for common combat models and logic. | **Do not adopt as the runtime.** It is not Dart/Flutter code and its generic combat model is not the authored Astraea rules. It is a potentially useful model-design reference, but porting or bridging would add cost without preserving implementation. |
| [Sol](https://github.com/Gameaday/sol) | MIT. GitHub listed Dart, 2 stars, a push on 2026-02-09. Its project guide describes a Flutter + Flame retro RPG for Android/iOS with a `BattleScreen` and turn-based combat. | **Example project only.** It can inform screen structure and a full-project integration pattern. It is not a standalone package, has a small maintenance/adoption signal, and carries its own RPG rules and assets rather than Astraea's Function Graph semantics. |

### Research queries

The following queries were used against GitHub and pub.dev search on 2026-10-06:

- `site:pub.dev/packages Flutter turn based RPG combat engine Dart`
- `site:github.com Dart turn based RPG combat engine Flutter`
- `site:pub.dev/packages Flame Flutter game engine GameWidget components`
- `site:github.com Flame turn based RPG combat Flutter`
- `site:pub.dev/packages "RPG" "turn-based combat" Flutter engine package Dart license`
- `github pure Dart RPG combat engine turn based MIT Dart game logic`
- `pub.dev game framework turn based combat engine pure Dart RPG`
- `Dart package RPG combat framework turn order status effect package`

### Research conclusion

No mature, maintained, Dart/Flutter-compatible standalone RPG combat engine was found that can replace Astraea's turn rules and still support its authored Function Graph, Weak Node analysis/interruption, deterministic state, and existing encounter content. That conclusion is limited to the searched public GitHub and pub.dev candidates above; it is not a claim that no such code exists anywhere.

Retain the local package for the existing Astraea-specific pure-Dart rules and compatibility boundary. Reuse Flame rather than inventing a general 2D rendering/animation engine if a scene spike confirms it fits. Treat Scene-Dash v2 and Just Game Engine as alternatives for an explicitly scoped technical prototype, not as implicitly approved production dependencies. This decision does not settle the battle UI or lock-screen/orientation design.

## Consequences

Positive:

- combat rules and Function runtime can be tested through a Dart-only package boundary
- the same reducer API can serve Flutter widgets or a future animation renderer without granting render code rule authority
- app migration can happen incrementally through compatible facade paths

Costs and constraints:

- local path dependency must be published/versioned separately if another repository later consumes it
- API and serialized save compatibility require deliberate versioning when domain models evolve
- root app remains responsible for persistence, authored content, UI, platform orientation, and animation playback

## Non-goals

This decision does not select Unity, Flame, or another renderer; add combat mechanics or rebalance authored values; extract Drift persistence; or prescribe a UI layout or screen orientation.
