# Astraea Combat High-Fidelity Design v1

**Status:** Phase 2 implementation-ready UX specification  
**Surface:** Landscape combat only  
**Locales:** English + Traditional Chinese (zh-TW)  
**Rules authority:** `docs/systems/COMBAT_RULES_V1_BASELINE.md`  
**UX authority:** `docs/systems/ASTRAEA_COMBAT_UX_FLOW_V1.md`  
**Global UI foundation:** `docs/ui/ASTRAEA_UI_UX_FOUNDATION_V1.md`

## 1. Design Decision

The current portrait Ashfang prototype is **not** the visual base for Combat v1.

Combat v1 is rebuilt around the CTB headless engine and uses a dedicated landscape shell:

```text
Action Timeline
+ Battlefield
+ Context Panel
+ contextual Reaction / Analysis overlays
```

The primary experience is:

> Read the battlefield, understand intent, make one tactical decision, and see the consequence clearly.

The combat HUD must feel like a JRPG battle screen, not an operations dashboard.

---

## 2. Landscape Composition

Reference composition:

```text
┌──────────────┬──────────────────────────────────────────┬─────────────────────┐
│ ACTION       │ ENEMY INTENT / CASTING                  │ CURRENT ACTOR       │
│ TIMELINE     ├──────────────────────────────────────────┤ HP / MANA / REACT   │
│              │                                          │                     │
│ Hero         │              BATTLEFIELD                 │ COMMANDS             │
│ Rio          │                                          │ Attack               │
│ Function     │      Party                 Ashfang       │ Technique            │
│ Ashfang      │                                          │ SC                   │
│ Yuma         │                                          │ Analyze              │
│              │                                          │ Guard                │
│              │                                          │ Move                 │
│              ├──────────────────────────────────────────┤                     │
│              │ PARTY STATUS / CAUSE FEEDBACK            │                     │
└──────────────┴──────────────────────────────────────────┴─────────────────────┘
```

Baseline proportions:

- Timeline rail: 12–15%
- Battlefield: 57–62%
- Context panel: 23–28%

The center battlefield always receives the widest region.

### Width behavior

For wider phones:

- keep Timeline rail capped
- keep Context panel capped
- give extra width to Battlefield

Do not stretch side panels until text lines become unnecessarily long.

### Safe areas

All three columns respect:

- camera cutouts
- rounded corners
- gesture areas
- system overlays

No primary action may sit directly against a physical screen edge.

---

## 3. Visual Hierarchy

### Tier 1 — battle-changing information

Always readable:

- current actor
- next Timeline events
- enemy Intent
- Casting / Active Function state
- HP / Mana
- legal reaction opportunity

### Tier 2 — tactical options

Shown when relevant:

- Main commands
- Prepared SCs
- available movement
- target choices
- known Counter options

### Tier 3 — deep Function information

Only shown when requested or revealed:

- runtime Stability
- Function nodes
- dependencies
- Weak Node
- Counter path
- reversibility

Analysis never promotes Tier 3 information that has not actually been revealed.

---

## 4. Battlefield

The battlefield is not a grid.

MVP spatial model:

```text
Near ↔ Mid ↔ Far
```

The background may visually suggest depth, but Zone state must be represented by native Flutter overlays.

### Zone presentation

Use subtle ground bands / anchor indicators only when:

- Move is selected
- an action's legal range is being previewed
- a forced-movement result is being explained

Do not permanently draw three giant labeled lanes across the battlefield.

### Combatants

Each combatant needs:

- clear silhouette
- team identity
- target selection state
- active actor state
- casting state
- defeated state

Characters should not be represented primarily as tiny stat cards.

---

## 5. Enemy Intent Ribbon

The enemy Intent belongs above the battlefield, not inside the command panel.

Examples:

```text
ASHFANG
Fireball I · Full Chant
Target: Hero
Resolve event visible on Timeline
```

Unknown:

```text
ASHFANG
Unknown Function · Full Chant
Target: Hero
Stability: ?
```

After Analysis:

```text
Modified Fireball
Stability 58
Potential structural vulnerability discovered
```

Do not display:

> Use Interrupt now.

The UI exposes information, not the answer.

---

## 6. Action Timeline

Timeline items may represent:

- character Turn
- enemy Turn
- Spell Resolve
- active Battlefield Function
- important status tick

Each item needs:

- icon / portrait marker
- short localized label
- ordering
- relationship to caster where relevant

Raw internal AV values are not displayed in normal player UI.

### Timeline movement

When an event moves because of Haste / Slow / Delay:

1. animate to the new position
2. show a brief localized cause label
3. do not reset the whole rail visually

---

## 7. Context Panel — Root Commands

Default state:

```text
CURRENT
Hero

HP
Mana
Reaction

Attack
Technique
SC
Analyze
Guard
Move
```

Main command buttons are vertically grouped and comfortably tappable.

Quick Action is not a seventh equal command.

If a Quick Action exists, show it in a smaller secondary section:

```text
QUICK
[ Mark Target ]
```

Unavailable actions remain visible only when knowing why matters.
Show the reason in concise copy.

---

## 8. Prepared SC Panel

Selecting SC transforms the Context Panel; it does not cover the battlefield.

Each Prepared SC row includes:

- localized spell name
- Tier
- role
- Mana cost
- availability
- small artwork thumbnail when approved art exists

Do not show unprepared spells as castable.

### SC detail state

After selecting one SC:

```text
Fireball II
Elemental · Attack

Mana 22
Range Mid–Far

Casting
○ Full Chant
○ Chantless

[ Continue ]
```

Only legal casting modes appear.

Tier is not visually framed as a rarity rank.

---

## 9. Casting Mode

### Full Chant

Communicate:

- delayed resolve
- high stability / completeness
- Interrupt window
- Timeline position

On confirm:

- Mana changes immediately
- caster visibly enters Casting
- resolve event is inserted into Timeline
- command panel exits normal Main choices

### Chantless

Communicate:

- immediate construction
- no normal pre-resolve Interrupt window
- current caster requirements

Do not label Chantless as simply "weaker".

---

## 10. Target Selection

Target mode preserves the Context Panel and Battlefield.

Legal targets:

- receive a native highlight
- show Zone legality
- show concise expected effect where rules allow

Illegal targets:

- remain visible
- are not tappable
- may show one concise reason

No full-screen target-selection page.

---

## 11. Analysis Workspace

Analysis replaces the right Context Panel while the battlefield remains visible.

### Initial unknown state

```text
UNKNOWN FUNCTION

Known
- target: Hero
- Full Chant
- resolve position on Timeline

Unknown
- exact Stability
- internal dependencies
```

### Analysis result

Show only evidence actually granted by Function Knowledge.

Possible information:

- family / signature
- Stability
- nodes
- dependencies
- Weak Node
- Counter tags
- reversibility

Weak Node is optional.

### Function Graph

Use native vector / Flutter rendering:

- nodes
- edges
- active node
- revealed node
- vulnerable dependency
- cancelled dependency

Do not use a generated raster image as the interactive Function Graph.

---

## 12. Reaction Overlay

A Reaction window uses a centered, compact overlay.

The battlefield and Timeline remain visible behind it.

Example:

```text
REACTION

Fireball construction is vulnerable.

Rio
Interrupt Shot
IP 50

Function Stability 42

[ INTERRUPT ]
[ SAVE REACTION ]
```

For unknown Stability:

```text
Function Stability ?
Outcome uncertain
```

Reaction is turn-based and should not create dexterity pressure.

Only open the overlay when at least one legal response exists.

---

## 13. Interrupt Feedback

Successful Interrupt:

- unfinished Function geometry fractures
- resolve event leaves Timeline
- caster enters recovery
- concise cause feedback appears

Example:

```text
Interrupt 50 ≥ Stability 42
Function broken
```

Failed Interrupt:

```text
Interrupt 40 < Stability 58
Construction continues
Stability reduced to 50
```

The equation may appear in tactical detail, but primary feedback uses natural language.

---

## 14. Counter State

Counter is not offered during the Casting-only window.

Once a Function becomes active:

- Interrupt action disappears
- legal Counter options may appear
- active Function remains visible in Timeline / Battlefield state

This visual change is important because it teaches:

```text
unfinished → Interrupt
established → Counter
```

---

## 15. Party Status Strip

Compact strip at the lower battlefield edge.

For each member:

- name
- HP
- Mana
- Reaction availability
- maximum 4 visible status icons before overflow

Do not repeat full command-card detail here.

The current actor receives a stronger highlight.

---

## 16. Cause Feedback

Every important combat result should answer:

> Why did that happen?

Use short transient feedback:

- Out of range
- Guard reduced damage
- Reaction spent
- Weak Node bonus applied
- Counter path unknown
- Casting interrupted

Do not create a scrolling technical console.

Detailed formulas belong in optional detail views.

---

## 17. Ashfang Tutorial High-Fidelity Flow

### Beat A — Chantless

Hero:

```text
SC
→ Fireball I
→ Chantless
→ Ashfang
→ immediate resolve
```

Teaches direct prepared spell use.

### Beat B — Known Full Chant

Ashfang begins known Fireball I.

UI automatically identifies:

- spell
- Full Chant
- target
- Timeline resolve event

Rio Reaction becomes legal.

Teaches Interrupt without Analysis tax.

### Beat C — Modified Function

Ashfang begins Modified Fireball.

UI shows:

```text
Unknown / modified structure
```

Analyze becomes the highlighted teaching action.

Analysis reveals authored information including the real Weak Node if present.

### Beat D — Full Chant payoff

Hero begins Fireball II Full Chant.

Timeline clearly shows delayed resolve.

Party survives / protects the casting window.

### Beat E — low-tier finish

Hero uses Fireball I Chantless.

Demonstrates that lower Tier remains tactically useful.

---

## 18. Visual Direction

Combat uses the global Astraea language:

- midnight world foundation
- starlight arcane information
- gold for important player identity / success
- coral for danger / hostile pressure
- teal for Analysis
- restrained glow

Avoid:

- generic Material dashboard
- cyberpunk terminal
- excessive glass panels
- every panel using a gradient
- visual noise behind combat silhouettes

Panels should feel like magical instruments inside an RPG, not enterprise cards.

---

## 19. Motion

Use motion to explain state.

Good motion:

- Timeline event slides
- resolve event enters
- target pulse
- Function construction assembles
- Weak Node reveal traces dependency
- interrupt fracture
- context panel transition

Avoid:

- constant idle panel movement
- ornamental animation that delays input
- long modal transitions

Respect reduced-motion accessibility preferences when possible.

---

## 20. Localization

Every combat label is localized.

Required locales:

```text
en
zh_TW
```

Constraints:

- buttons allow longer English and Chinese labels
- do not embed localized UI text in generated background / enemy art
- spell artwork contains no spell name or cost
- Timeline items use short labels
- formulas use locale-safe number formatting when introduced

The same combat flow must remain usable after locale switch.

---

## 21. Accessibility

Required:

- critical states never color-only
- selected targets use border / marker / semantic state
- Reaction availability uses icon + semantics
- Function Graph node states use shape / icon / text
- minimum comfortable touch targets
- text scaling review
- semantic labels for graph nodes and command buttons

---

## 22. Flutter Component Contract

Phase 3 should build reusable components approximately along these boundaries:

```text
CombatScreenV1
├── CombatTimelineRail
├── EnemyIntentRibbon
├── BattlefieldViewport
│   ├── BattlefieldActor
│   ├── ZoneOverlay
│   └── FunctionEffectLayer
├── PartyStatusStrip
├── CombatContextPanel
│   ├── RootCommandPanel
│   ├── PreparedScPanel
│   ├── CastingModePanel
│   ├── TargetPanel
│   └── AnalysisPanel
├── ReactionOverlay
└── CombatCauseFeedback
```

Components consume presentation models derived from CTB v1 state.

Do not pass raw database rows to combat Widgets.

---

## 23. Phase 3 Acceptance

Phase 3 is not complete until:

- landscape-only combat shell renders
- CTB Timeline uses `lib/game_engine/combat/v1/`
- Ashfang and player state render from one presentation state
- commands execute real engine transitions
- Full Chant inserts real resolve events
- Reaction Interrupt uses real Reaction Charge
- Analysis reads real Function Knowledge
- Weak Node cannot appear without engine knowledge
- English and zh-TW render
- no hardcoded player-facing strings
- loading/error/end states exist
- Flutter tests cover core states
- Real Player Playtester can complete the Ashfang learning flow
