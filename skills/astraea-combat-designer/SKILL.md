---
name: astraea-combat-designer
description: Design and review Astraea's turn-based tactical combat, Function Graph, Weak Node, reactions, spells, encounters, enemy intent, and Counter-Function mechanics. Use for combat rules, card balance, boss design, encounter tutorials, and combat UX.
version: "1.0.0"
---

# Astraea Combat Designer

## Mission

Make combat feel:

- readable
- tactical
- intelligent
- compact
- expressive
- uniquely Astraea

Combat must communicate:

> **Magic is executable structure. Understanding that structure creates tactical advantage.**

The core combat identity is:

```text
Observe
↓
Understand
↓
Predict
↓
Interfere
↓
Resolve
```

---

## Canonical Combat Foundation

The authoritative combat rules are:

```text
docs/systems/COMBAT_RULES_V1_BASELINE.md
```

Older d20 / Round / seeded attack-RNG rules are superseded for Combat v1.

### Action Timeline

Combat uses:

```text
Continuous / CTB-like Action Timeline
+ Action Delay
```

Character Turns, Spell Resolve events, and important Battlefield Functions may share the Timeline.

Different actions may create different next-action timing.

### Action Economy

Formal Turn baseline:

```text
Optional Move
→ Optional Quick
→ Main
→ End Turn
```

- one Main Action
- up to one Quick Action
- one free Normal Move to an adjacent Zone
- Reaction occurs outside the reacting character's Turn
- each character holds at most one Reaction Charge
- Reaction Charge refreshes at that character's formal Turn start
- a Trigger Window resolves at most one Party Reaction

### Positioning

MVP uses:

```text
Near
↔
Mid
↔
Far
```

Normal Move changes one adjacent Zone. Special movement uses a Technique or SC.

### Deterministic Resolution

Do not reintroduce generic d20 attack resolution as the Combat v1 default.

Important combat decisions should preserve readable cause and effect.

Interrupt baseline:

```text
Interrupt Power >= current Function Stability
→ BREAK
```

Otherwise the Function continues unless another explicit rule applies.

## Prepared Deck

Prepared Deck is:

> **a loadout, not a random-draw deck**

MVP baseline:

```text
6 prepared Spell Cards
```

All prepared cards are accessible.

Use restrictions such as:

- Mana
- cooldown
- action cost
- conditions
- complexity
- cast method
- reaction timing
- interrupt risk

Do not introduce random draw unless explicitly approved as a major design change.

---

## Magic Execution Model

Magic is expressed as a Function or Function Graph.

Example:

```text
Gather(Energy)
↓
Shape(Bolt)
↓
Lock(Target)
↓
Release
```

A Function node may carry:

```text
type
state
visibility
interruptible
reversible
weakness
execution_cost
dependencies
```

Function execution states may include:

- Prepared
- Executing
- Waiting
- Interrupted
- Resolved
- Failed
- PartiallyResolved
- Countered

---

## Function Knowledge

Persistent or encounter-level knowledge can progress through:

```text
0 Unknown
1 Intent
2 Nodes
3 Weak Node
4 Counter Path
```

Do not reveal everything immediately.

Player understanding should be earned through:

- observation
- Analysis
- prior knowledge
- character build
- enemy repetition
- narrative research

---

## Weak Node Design

Weak Node is not “the glowing red button” by default.

It should represent a real dependency or vulnerability in a Function.

Interference outcomes may include:

- cancel
- delay
- reduce
- retarget
- increase cost
- destabilize
- expose
- partial resolution

The player should understand:

```text
why this node matters
+
when the window occurs
+
what happens if interrupted
```

---

## Counter-Function

Advanced progression:

```text
Weak Node Analysis
→ Function Analysis
→ Invertibility
→ Counter-Function
```

Possible counter families:

- Full Inversion
- Partial Inversion
- Local Node Counter
- Sequence Cancel
- State Restore

Not every Function is invertible.

Counter success may depend on:

- Function Knowledge
- Analysis threshold
- timing
- skill
- Mana
- action / Reaction availability
- invertibility
- environment

---

## Casting Methods

### Full Chant

Strengths:

- stable
- high complexity
- reduced mental computation burden

Costs:

- slower
- interruptible
- more telegraphed

### Chantless

Strengths:

- fast
- flexible
- reactive

Costs:

- Processing demand
- Precision demand
- instability risk

Chantless does not bypass the Magic System.

---

## Weapons

MVP role direction:

- Longsword — balanced
- Spear — reach / control
- Arcane Gun — range / precision
- Staff — spell / chant specialization

Weapons should modify tactical options, not merely stat totals.

---

## Party Combat Identity

### Hero

Flexible build expression.

### Saeki Yuma

Changes spatial conditions:

- reposition
- teleport
- cover
- rescue
- range manipulation
- escape

### Kamiya Rio

Changes information:

- reveal nodes
- analyze dependencies
- identify Weak Nodes
- evaluate invertibility
- improve counter windows

### Asakura Hina

Changes tempo and pressure:

- burst
- area pressure
- fast casting
- high Mana output

Avoid party members that differ only by damage color.

---

## Encounter Length

Use action / encounter-time targets rather than global Round counts because Combat v1 uses a continuous Timeline.

Current balance target:

- normal battle: approximately 2–4 minutes and roughly 8–15 Party Main Actions
- elite: longer only when added mechanics justify it
- boss: longer through phases and evolving decisions, not HP sponge design

---

## Enemy Intent

Show enough intent to enable tactical planning.

Do not expose the entire Function Graph automatically.

Good enemy intent can communicate:

- target
- broad action type
- cast timing
- threat area
- visible preparation

Analysis can reveal deeper structure.

---

## Encounter Design Template

For every encounter define:

```markdown
## Encounter
Name:
Purpose:
Expected rounds:

## Player Skill Being Tested
- ...

## Enemy Intent
- ...

## Function Graph
...

## Weak Node
Node:
Why vulnerable:
Window:
Success result:
Failure result:

## Party Opportunities
Hero:
Yuma:
Rio:
Hina:

## Anti-Bruteforce Check
How does understanding outperform raw damage?

## Accessibility
How is the mechanic communicated without relying only on color?

## Deterministic Test Cases
- initial state:
- action / event sequence:
- expected state:
```

---

## Tutorial Philosophy

Tutorial encounters must teach through play.

### Arcane Sentry Mk-I

Teach:

- turn order
- attack
- Spell Card
- enemy intent
- basic resource use

### Ashfang Training Construct

Teach:

- Function Graph
- Weak Node
- reaction timing
- party coordination
- interruption

Do not overload a tutorial with every subsystem.

---

## Boss Design

Bosses test understanding, not endurance.

A boss phase should introduce one or more of:

- new Function topology
- misleading intent
- partial information
- moving Weak Node
- timing pressure
- environment dependency
- Counter-Function opportunity

Avoid:

```text
same pattern
+ 10x HP
```

---

## Last Spell

Last Spell is:

- once per battle
- enormous commitment
- after use, caster cannot continue normally

It should feel narratively and mechanically exceptional.

Do not treat it as an ordinary ultimate meter.

---

## Balance Review

For each Spell Card inspect:

- Mana cost
- action cost
- cooldown
- targeting
- expected value
- setup requirement
- timing sensitivity
- synergy
- redundancy
- Function Graph readability

A powerful card should pay through at least one meaningful constraint.

---

## Output Format

```markdown
# Combat Review — <feature / encounter>

## Verdict
APPROVE | REVISE | REJECT | DECISION_REQUIRED

## Combat Purpose
...

## Mechanics
...

## Function Graph
...

## Player Readability
PASS / WARN / FAIL

## Tactical Choice
PASS / WARN / FAIL

## Anti-Bruteforce
PASS / WARN / FAIL

## Findings
### CD-01
Severity:
Problem:
Player consequence:
Required change:

## Test Cases
- ...
```

---

## Guardrails

Do not:

- silently alter canon
- turn Function Graph into decorative UI
- add complexity without tactical payoff
- hide critical mechanics behind unexplained randomness
- use Life XP as direct battle damage
- make enemies HP sponges
- equate difficulty with information removal only
- make accessibility depend only on color

Prefer:

> comprehension, timing, and decision quality over grinding.