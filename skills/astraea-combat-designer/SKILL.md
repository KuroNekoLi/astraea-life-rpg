---
name: astraea-combat-designer
description: Design and review Astraea's turn-based tactical combat, Function Graph, Weak Node, reactions, spells, encounters, enemy intent, and Counter-Function mechanics. Use for combat rules, card balance, bosses, and encounter tutorials.
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

Unless an approved baseline says otherwise:

### Initiative

```text
d20 + Processing modifier
```

### Attack

```text
d20 + Attack Bonus vs Defense
```

- natural 1: miss
- natural 20: critical / enhanced result
- beginner expected hit rate: about 60–75%
- deterministic seeded RNG preferred for replay/debugging

### Turn Economy

```text
Turn Start
↓
Status Resolution
↓
Movement
↓
Main Action
↓
Quick Action
↓
Turn End
```

Movement, Main Action, and Quick Action may be ordered flexibly when rules allow.

Reaction occurs outside the actor's turn.

Typical reaction budget:

```text
1 Reaction / round
```

### Positioning

MVP preference:

```text
Zone + Relative Range
```

Examples:

- Close
- Near
- Far

Do not introduce a full grid unless the encounter value justifies it.

---

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

Targets:

- normal battle: 3–6 rounds
- tutorial: ≤ 8 rounds
- boss: longer through phases, not HP sponge design

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
- seed:
- expected:
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

## External Research

Before proposing a new combat mechanic, encounter pattern, party role, boss phase, or balance approach, use web search to inspect relevant public references. Search the specific design problem rather than assuming familiarity with a genre is sufficient.

- Prefer primary sources: official game/system documentation, developer talks or postmortems, source repositories, and original design articles.
- Record the research date, URLs, the relevant pattern, and why it does or does not fit Astraea.
- Check source-code and asset licenses separately before proposing reuse. A public repository or screenshot is not permission to copy its code, art, sound, names, or proprietary content.
- Treat commercial games as observable design references, not as authority for Astraea rules. Do not copy their formulas, action economy, character abilities, encounter text, or proprietary assets.
- Approved Astraea specifications and explicit user decisions remain authoritative. External examples can expose options or risks, but cannot silently resolve Astraea's TBD values or mechanics.
- For a new numeric balance proposal, state its source and validation method; do not present another game's values as Astraea balance. Mark unresolved mechanics `DECISION_REQUIRED`.
- If web research is unavailable, state `NOT_RESEARCHED` and keep the recommendation provisional.

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

## Research / Reference Patterns
- checked date:
- sources:
- fit and reuse boundary:

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
