# Combat Motion Art Direction

**Status:** MVP presentation guidance; does not approve or change combat rules
**Scope:** Landscape turn-based combat stage, motion, and visual effects
**Pairs with:** `docs/systems/COMBAT_SYSTEM.md`, `docs/systems/SPELL_FUNCTION_SYSTEM.md`, and `docs/systems/COMBAT_IMPLEMENTATION_GAP_MAP.md`
**UX flow:** To be cross-checked against the Combat UX flow specification when it is complete.

## 1. Purpose

Give combat outcomes physical presence and readable cause-and-effect while keeping the authored encounter and pure Dart combat/function engines authoritative. This document defines how presentation should move and look; it does not define attacks, success chances, damage, action costs, or narrative events.

The visual language should support Astraea's combat sequence:

```text
Observe → Understand → Predict → Interfere → Resolve
```

Prioritize readable anticipation, decisive action, and a visible consequence. Use motion to clarify which combatant acted, what the engine resolved, and how an authored Function changed.

## 2. Status and implementation boundary

- **Implemented:** the combat reducer returns semantic events such as `attackResolved`, `hit`, `criticalHit`, `miss`, `defeated`, `moved`, and `turnEnded`. Ashfang's Function runtime currently tracks `active`, `resolved`, or `interrupted` state and a cancellation set for authored downstream nodes.
- **Spec-backed:** a Weak Node is a Function node whose authored rule allows interference. Ashfang's authored `LockTarget` rule cancels downstream `Pounce` when a legal interrupt succeeds.
- **Presentation proposal:** derive short-lived motion cues from a completed command resolution and its before/after state. The view can sequence those cues, but it must not delay, roll back, or repeat resolution.
- **Placeholder:** no approved battle character or enemy illustrations are supplied for this pass. Use original vector shapes, gradients, and simple procedural marks until production art is commissioned or licensed.
- **Not included:** damage tuning, attack formulas, new combat actions, new Function outcomes, enemy AI, authored dialogue, or final character/monster design.

For an event not currently represented by a domain event, use the corresponding returned Function runtime result/state transition as the presentation trigger. Do not infer a gameplay event from localized feedback text, elapsed animation time, a button press, or an animation callback.

## 3. Scene layer stack

Keep the play space visually rich while reserving clear areas for combat information and touch controls. These layers are ordered back to front:

1. **Atmosphere:** dark blue-violet gradient, distant academy/training-arena silhouettes, sparse stars or motes. Keep movement slow and low contrast.
2. **Arena architecture:** a few large arches or rune pylons on a distant plane. Use parallax only when it helps depth; avoid continuous camera travel.
3. **Ground plane:** a simple perspective ellipse/platform with a readable horizon and restrained floor markings. It anchors both combatants and gives movement cues a stable origin.
4. **Combatants:** player and enemy silhouettes with separate shadow/contact rings. Align them to authored positions/zones; do not add grid cells, reach indicators, cover, or movement affordances without encounter data.
5. **Function visualization:** a compact node chain or authored graph visualization. It is an information layer attached to the enemy's current Function, not scenery and not an automatic enemy weakness display.
6. **Action VFX:** trails, impact bursts, node pulses, link breaks, and outcome motes. Clip these to the battlefield stage so they do not wash over HUD or controls.
7. **HUD and controls:** draw above the stage with opaque or high-contrast surfaces. Keep HP, Mana, turn order, node labels, and commands legible over all backgrounds and effects.
8. **Outcome treatment:** a restrained victory/defeat veil and result title. The outcome layer may dim the stage but must leave the authoritative result and next navigation action clear.

Use `RepaintBoundary` or equivalent isolation for the animated stage when it reduces unnecessary UI repaints. Keep HUD widgets out of the Flame canvas if Flame is adopted: the engine can own stage sprites/VFX while Flutter owns accessible text, status, and input.

## 4. Camera and composition

- Compose for landscape: player presentation occupies the left stage zone, enemy presentation the right, with a clear central interaction lane. The final Combat UX specification owns exact panel sizing and responsive breakpoints.
- Keep the horizon and combatants stable between commands. Use a brief focus shift or scale emphasis for the acting unit; return to the established framing before the next decision.
- Prefer lateral tracking and shallow perspective over a free-moving camera. Do not let a camera flourish hide current HP, initiative, Function state, or primary controls.
- On an attack, bias the camera slightly toward the contact point. On Analysis, move visual emphasis from the actor to the Function graph. On interruption, emphasize the severed dependency and then the enemy's cancelled motion.
- Camera shake is reserved for a confirmed impact or interruption and should be subtle, short, and stage-only. Never shake the whole app, command tray, or readable graph labels.
- The stage may remain mounted beneath an orientation gate while the route requests landscape, but portrait must not expose an operable command layout. If the platform cannot honor a landscape request on a large display, keep the gate and scene responsive; never crop commands or place essential state offscreen.

## 5. Motion vocabulary

Motion should be legible at a glance, not realistic simulation. Use easing with a clear anticipation and settle phase. Avoid repeated high-frequency flashes, full-screen white frames, rapid zooms, and color-only signals.

The durations below are presentation targets, not turn windows or timing rules. They may be shortened by reduced-motion settings or player skip. The engine result is already final before these sequences play.

| Cue | Trigger | Visual beat | Result language |
|---|---|---|---|
| **Idle** | Stage mounted; no active cue | Player: calm breathing and light cloth/hair sway. Enemy: heavier, slower mechanical or magical pulse; occasional armor/rune shimmer. Loop with varied pauses, not metronomic bobbing. | Establishes opposing presence without implying a combat action or telegraph not present in encounter data. |
| **Turn focus** | Active combatant changes in resolved state | A brief rim light or platform ring grows under the active unit; the turn-order marker settles on the corresponding entry. | “Whose turn is this?” answered by position, icon, and label rather than color alone. |
| **Attack anticipation** | A resolved attack command is presented | Attacker leans/charges for a short beat; weapon or hand gathers a narrow trail. Keep the preparation under roughly 180 ms when possible. | Shows the acting unit and attack direction. |
| **Attack contact** | `attackResolved` plus its outcome events | On confirmed hit, move the attacker forward and snap back; place a contained impact shape at the target contact point. On miss, let the attack pass or disperse before contact. | Only show hit or miss after the reducer's event. Never make a miss look like damage. |
| **Cast / Function execution** | A resolved spell command or authored Function state advancement | Brief glyphs/nodes illuminate in authored execution order; energy travels along authored edges toward its target. Use a distinct, calmer line/arc language for spell structure and a separate impact language for its resolved effect. | Animate only nodes and edges the encounter/runtime says are active, completed, or resolved. No animation may fill hidden graph data. |
| **Hit reaction** | `hit` event and target state change | Target recoils once, silhouette compresses briefly, then returns to stance. A small impact mark and optional floating value use the resolved event value only. | Present actual resolved damage; do not substitute an estimated or authored maximum. |
| **Miss** | `miss` event | Trail passes beside or dissolves before the target; target remains in its prior state with at most a small evasion/brace motion if supported by the visual model. | Label the result clearly as “Miss” or equivalent. Do not show HP loss, hit flash, or false target stagger. |
| **Critical** | `criticalHit` event | A stronger but still brief contact flash, a second concentric ring, and a more pronounced single recoil. Use a distinct icon/shape and a “Critical” label. | Distinguishes the event; the numeric result still comes only from resolved state/event data. Do not imply a new multiplier or extra effect. |
| **Analysis / Weak Node reveal** | Analysis resolution; reveal cue only when `revealed` is true | A scan passes across the visible Function nodes. On success, the now-known `LockTarget` node receives a crisp outline/pulse and its authored dependency to `Pounce` becomes easy to follow. On failure, scan fades without marking a node. | The success text/callout explains the authored relation: interrupting `LockTarget` cancels downstream `Pounce`. Do not make the node glow as weak before knowledge is revealed. |
| **Weak Node interruption** | Successful `FunctionInterruptResult` / resulting interrupted state | Pause the enemy's forward motion; the active node distorts once, then the authored outgoing link snaps or drains toward the cancelled `Pounce` node. The enemy's attack motion stops and settles into recovery. Use a visible broken-line/closed-gate mark, not red alone. | State the cause and consequence together: `LockTarget interrupted` → `Pounce cancelled`. Never play this success sequence for an invalid or failed interrupt. |
| **Victory** | Authoritative `CombatOutcome.victory` | Enemy deactivates or lowers its stance, arena highlights lift, and a warm contained light resolves behind the result title. Player returns to an idle pose. | Celebrate the resolved outcome without adding loot, score, reward, or narrative dialogue not provided by the app state/content. |
| **Defeat** | Authoritative `CombatOutcome.defeat` | Player settles into a readable defeated pose; arena contrast lowers and the outcome title appears without a prolonged fail loop. Enemy remains present but does not taunt unless authored dialogue exists. | Keep the result and available next step explicit. Do not imply lost progression, retry cost, or punishment unless game rules define it. |

Suggested total stage cue lengths: ordinary attack around 450–800 ms; analysis sweep around 350–650 ms; interruption around 650–950 ms; outcome settle around 700–1,100 ms. These are implementation defaults for pacing only; they are not action timing, reaction windows, or success conditions.

## 6. Visual language for Function structure

- Use **thin, connected lines** for dependencies, **solid node marks** for visible known structure, and a **distinct interrupted-link glyph** for an authored cancellation. Use labels/icons/patterns with color, not color alone.
- Unknown or hidden structure must remain absent or use an explicitly authored unknown marker. Do not render `Pounce` as an unknown node if the encounter hasn't authored it as visible; current Ashfang content may render its authored graph according to the current tutorial UX.
- Before Analysis reveals `LockTarget`, display only the intent and graph information allowed by the encounter. After a successful reveal, visually connect `LockTarget` to the cancelled `Pounce` dependency. Analysis failure should not leak the correct node through particle behavior, camera focus, sound, or a highlighted path.
- Avoid an anatomical “weak spot” target marker. The Weak Node is a structural point in a Function, not a glowing body part.
- Treat node state transitions as concise state cues. Do not animate every graph node continuously; persistent animation makes the enemy's actual active step difficult to identify.

## 7. HUD and VFX avoidance

- Define a protected HUD/control region before authoring effects. VFX, camera crop, floating values, character silhouettes, and parallax edges must not obscure turn order, HP/Mana, active intent, node labels, or command buttons.
- Keep damage values next to their target but inside the stage viewport. Remove them after a short read period; persistent values belong in a combat log, not as floating labels.
- Never place node labels on top of a moving beam or impact burst. Pulse the node frame/edge rather than flashing the label itself.
- Avoid color-only semantics. Pair hit/miss, critical, revealed, active, cancelled, victory, and defeat colors with text, shape, icon, motion direction, or line pattern.
- Keep luminance changes moderate and avoid rapid full-screen flashes. Ensure white/gold effects retain outline against bright backgrounds.
- Keep haptic feedback optional and event-bound. If enabled, use at most one short confirmation on a successful Weak Node interruption or terminal result; never use haptics to indicate an unconfirmed button press as if it succeeded. Respect platform capability and user/system settings.

## 8. Placeholder art direction

Until approved/licensed assets exist, create original shapes locally in Flutter/Flame:

- **Player placeholder:** layered cool-blue silhouette, readable head/torso/weapon contour, soft cyan edge. Avoid pretending this is a finished depiction of the Hero.
- **Ashfang placeholder:** broad, angular training construct silhouette with clear head, forelimbs, and a few geometric plates. Use a warm amber core to suggest an artificial construct, but do not imply a canon body feature or exposed biological weak point.
- **Arena placeholder:** gradient sky, distant arch/pylon silhouettes, elliptical platform, sparse runic marks generated as simple vector geometry.
- **Spell/attack placeholder:** geometric slash, ring, ribbon, or line pulse. Keep VFX distinct from graph edges so players can tell execution visuals from Function dependencies.
- Label internal screenshots or developer builds as placeholder art where practical. Replace each placeholder only with original commissioned art or assets whose license and attribution have been reviewed.

These shapes are scaffolding for layout, contrast, silhouette and timing. They are not final art direction for character identity, costume, weapon, species, or story canon.

## 9. Animation lifecycle and presentation safety

- Start a cue from a newly consumed resolution event/state revision, not from `build()` and not from an arbitrary widget rebuild.
- Associate cues with a stable resolution/revision identifier so route recreation, checkpoint restore, or state refresh does not replay a resolved attack as a new command. On restore, show the current stable pose/state; do not replay old combat as if it just happened.
- A cue may be skipped, interrupted by navigation, or stopped when the app backgrounds. Stopping it must leave the same domain state and must not dispatch any combat command.
- If reduced motion is enabled, replace travel/impact animation with a quick opacity/outline transition and persistent result label. `MediaQuery.disableAnimations` and accessibility navigation preferences should be considered by the widget layer.
- Do not encode a reaction opportunity, input timeout, parry timing, cast interruption window, or success in an animation duration. Current Ashfang analysis/interruption is governed by adapter/engine state, not by tapping during a frame.
- Pause decorative idle/parallax animation when the route is not visible or `TickerMode` is disabled. Resume from a neutral pose rather than catching up elapsed decorative motion.
- Any future animation-completion callback is presentation-only. It may clear a cue or advance to the next already-resolved visual beat, but it must never invoke `attack`, `analyze`, `interrupt`, `endTurn`, or another domain command.

## 10. Performance and platform notes

- MVP may use Flutter `CustomPainter`, transforms, gradients, and opacity for procedural staging. Add Flame only if a persistent component tree, sprite animation, or particle workload materially improves the implementation; it is not required for this art direction.
- If Flame is used, embed its `GameWidget` as the stage region and keep Flutter overlays/HUD as widgets. Do not move combat state, RNG, or Function rules into Flame components.
- Keep animated layers bounded to the stage and avoid large translucent full-screen layers. Reuse paints/paths where practical; avoid allocating complex particle lists on every frame.
- Prefer deterministic, seeded-looking visuals only if the presentation seed is explicitly separate from gameplay RNG. Visual randomness must never read or advance combat RNG.
- Target stable 60 fps on representative mid-range phones. If profiling shows missed frames, reduce particle count, blur, and moving layers before reducing text contrast or battle-state feedback.
- On route exit, dispose animation controllers/listeners and stop tickers. On app background, suspend decorative motion and do not persist transient animation progress as battle state.

## 11. Verified frameworks, assets, and visual references

Web sources and repository/license pages were checked on **2026-10-06**. “Adoptable” below means the stated code/asset license permits commercial use subject to its terms; keep a copy of the source license and asset attribution/receipt with any imported files. No source code, art, or design asset has been copied as part of this document.

### Suitable to adopt for MVP implementation

| Candidate | License and current status | Use | Why / limits |
|---|---|---|---|
| [Flame](https://github.com/flame-engine/flame) | MIT. The package page listed stable **1.38.2**, published 39 days before this check; platform support lists Android and iOS. The repo and package show ongoing releases/maintenance. | Optional Flutter battlefield renderer: `GameWidget`, `SpriteAnimationComponent` / `SpriteAnimationGroupComponent`, and `ParticleSystemComponent`. Keep Flutter HUD and controls as widgets. | Fits the current Flutter application and provides a component lifecycle for event-driven stage animation and contained VFX. It is a rendering/game-loop toolkit, not Astraea's turn/action/Function rules. Pin a stable 1.x version if selected: Flame 2.0 is prerelease and the particle API is a planned breaking-change area. Adding it remains a dependency decision outside this document. [MIT](https://github.com/flame-engine/flame/blob/main/LICENSE), [stable package/release](https://pub.dev/packages/flame), [GameWidget API](https://pub.dev/documentation/flame/latest/game/GameWidget-class.html), [sprite animation API](https://pub.dev/documentation/flame/latest/components/SpriteAnimationComponent-class.html), [particle API](https://pub.dev/documentation/flame/latest/components/ParticleSystemComponent-class.html). |
| [Kenney RPG Base](https://kenney.nl/assets/rpg-base) | **CC0**, confirmed on the publisher's asset page. 2D tile pack, 230 files; released 2014. | Arena/environment greybox: floor tiles, wall/stone/trim forms where they fit. | Explicit public-domain dedication makes this a low-friction placeholder source. Its pixel-art look is a blockout aid, not a match for Astraea's anime fantasy target. |
| [Kenney Roguelike Characters](https://kenney.nl/assets/roguelike-characters) | **CC0**, confirmed on the publisher's asset page. 2D pixel character pack, 450 files; publisher lists v2.0 as fixing a spritesheet issue. | Temporary player/enemy silhouette and animation placeholders after checking sprite-sheet dimensions and importing only needed frames. | Clear reuse license and character-oriented files; deliberately label screenshots as placeholder art. The pixel style and character designs are not Astraea canon and should not ship as final character art without a separate visual/product decision. |
| [Kenney Tiny Dungeon](https://kenney.nl/assets/tiny-dungeon) / [Tiny Town](https://kenney.nl/assets/tiny-town) | Each publisher page marks the pack **CC0**. Tiny Town is also credited by GDQuest's Open RPG. | Optional arena/background blockout shapes, if a required asset can be identified and its pack source is recorded. | Suitable for a fast scene composition prototype; style is small-scale pixel art and does not replace commissioned arena/environment art. Use Kenney's original download/page as provenance, not extracted copies from another repository. |

### Good visual or architecture references; do not import as a battle module

| Project | License / maintenance evidence | Borrow at a high level | Do not reuse |
|---|---|---|---|
| [GDQuest Godot Open RPG](https://github.com/gdquest-demos/godot-open-rpg) | MIT source. Repo identifies itself as a work-in-progress educational demo, not a framework; asks for Godot 4.6.2. GitHub showed 444 commits and activity through May 1, 2026 at this check. It credits Kenney Tiny Town separately. | Scene responsibility, combat-state choreography, and how a graph of RPG systems can be organized. | No direct project port into Flutter. Its source license does not automatically grant rights to third-party assets; obtain Kenney packs from Kenney's CC0 source page if needed. |
| [i-Jiro Unity3D Turn Based RPG](https://github.com/i-Jiro/Unity3D-Turn_Based_RPG) | **GPL-3.0**; README says the demonstration graphics are not included. Project was built with Unity 2021.3.4 and presents itself as a case study; no release package is listed. | Observe JRPG staging, action anticipation/recovery, turn/result presentation, and damage-popup hierarchy. | Do not port source into Astraea without a separate GPL compatibility decision. Do not assume referenced sprites/shaders are covered by the repository license. |
| [michalsobr TurnBasedBattle](https://github.com/michalsobr/TurnBasedBattle) and its [itch demo](https://michalsobr.itch.io/turnbasedbattle) | Unity 6.4 according to README; GitHub topic activity showed an update on Apr 12, 2026. README says portfolio/educational use and identifies third-party Asset Store/audio/art sources under their own licenses; no permissive code license is stated. | Inspect its attack/skill/target/victory timing and transition hierarchy through screenshots or demo. | Visual reference only. Do not copy code or any project/third-party asset until the creator and every asset owner grant suitable commercial rights. |
| [LeviOS31 Godot JRPG Combat Addon](https://github.com/LeviOS31/JRPG-turn-based-combat-addon-Godot) | MIT source; Godot 4.6; GitHub labels it **In development**, with six stars and no releases shown. Its own README lists turn-order variants, location backgrounds, replaceable UI, and waves as TODO or uncertain future work. | Inspect how character/skill resources and turn-manager seams are presented in a small addon. | Not a production-ready or Flutter-compatible addon. Do not port its Godot scripts or infer unimplemented presentation behavior. |

Flame API detail: the stable package documents `GameWidget` as a regular Flutter widget that can host the game in part of a layout and can provide Flutter widget overlays. `SpriteAnimationComponent` supports frame/sprite animation in a position component; `SpriteAnimationGroupComponent` can switch named visual states; `ParticleSystemComponent` hosts a bounded particle effect with lifecycle cleanup. The official `docs.flame-engine.org/latest` pages displayed an “older version” notice during this check, so the links above target pub.dev API docs for the current stable package instead. The docs examples are MIT-licensed; the prose documentation is CC BY 4.0. [GameWidget guide](https://docs.flame-engine.org/latest/flame/game_widget.html), [sprite components](https://docs.flame-engine.org/latest/flame/components/sprite_components.html), [particle guide](https://docs.flame-engine.org/latest/flame/rendering/particles.html), [Flame package license](https://github.com/flame-engine/flame/blob/main/LICENSE).

**MVP recommendation:** begin with original Flutter-painted geometry or the verified Kenney CC0 packs for layout/silhouette placeholders; use Flame 1.x only if the battle stage benefits from its sprite/component/particle lifecycle. Drive each visual cue from Astraea's own resolved combat/function state. Keep a provenance note with any downloaded file, and replace placeholders with original or separately licensed production art before claiming a finished visual identity.

## 12. Review checklist

- [ ] The visual scene reads as a turn-based RPG battlefield in landscape, with stable character positions and clear stage boundaries.
- [ ] Every attack, hit, miss, critical, analysis reveal, interrupt, victory, and defeat cue begins only after the corresponding authoritative event/state is available.
- [ ] A miss has no damage visual; a failed/invalid interrupt never shows a severed dependency or successful Ashfang cancellation.
- [ ] The Weak Node is shown as a Function structure node, not a body weak spot, and is not revealed before encounter/runtime knowledge permits it.
- [ ] The scene shows only encounter-authored nodes, dependencies, intent, and effects.
- [ ] VFX and camera motion never hide HUD, commands, important labels, or accessibility semantics.
- [ ] Reduced-motion mode and skip/route-exit behavior settle on the exact same final battle state without reissuing commands.
- [ ] Restored checkpoints start from a stable presentation pose and do not replay stale actions.
- [ ] Placeholder geometry is visibly distinct from final approved character/enemy art.
- [ ] No unlicensed code, image, sound, shader, animation, or design asset has been copied.
