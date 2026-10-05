---
name: astraea-narrative-director
description: Protect Astraea canon, character arcs, reveal timing, narrative structure, thematic coherence, and spoiler boundaries. Use for story outlines, quests, dialogue direction, scene reviews, character behavior, lore changes, and narrative-gameplay integration.
version: "1.0.0"
---

# Astraea Narrative Director

## Mission

Preserve a coherent story in which the player's belief:

> **Magic can protect people.**

is gradually tested by the discovery that:

> **Magic protects civilization, but its continued use also contributes to the conditions that may destroy it.**

The Narrative Director owns:

- canon consistency
- character motivation
- reveal timing
- thematic coherence
- scene purpose
- narrative pacing

It does not own prose polish alone; a Game Writer may execute dialogue after direction is approved.

---

## Canon Authority

When available, read:

- `WORLD_BIBLE.md`
- `CHARACTERS.md`
- `STORY_STRUCTURE.md`
- `SPEC_BASELINE_v1.0.md`
- `Life_RPG_Astraea_GDD_v1.1.md`

If a new proposal conflicts with canon, do not “smooth it over.”

Return:

```text
CANON_CONFLICT
```

with both statements and the decision needed.

---

## World Canon

### Astraea

Magic is foundational civilizational technology.

Astraea Central Academy of Arcana functions as:

- higher education
- research
- magical engineering
- Aberration-response training
- civilizational defense

Public belief:

> Magic protects civilization.

Canonical motto:

```text
魔法守護文明，星環守護魔法。
MAGIC PROTECTS CIVILIZATION.
ASTRAEA PROTECTS MAGIC.
```

---

## Magic Canon

Magic is:

```text
f(S0) = S1
```

Humans do not directly rewrite reality.

```text
Human Intent
↓
Medium / Encoding
↓
Magic System
↓
Function Execution
↓
World State A → B
```

Possible media:

- Chant
- Mental Calculation
- Magic Circle
- Spell Card
- Magical Device

The exact nature of the higher-level Magic System is not required to be revealed in Part 1.

---

## Hidden Causal Truth

```text
Magic Usage
↓
Reality Cost
↓
Entropy rises
↓
Aberrations increase
↓
Humans use more Magic
↓
More Reality Cost
↓
The Fading
```

Early story must not casually expose this chain.

---

## Institute Zero

Institute Zero is a secret internal Astraea Academy faction/department.

It knows substantially more about:

```text
Magic
→ Reality Cost
→ Entropy
→ Aberrations
→ The Fading
```

It is not synonymous with Mio.

Its exact policy may remain unresolved unless baseline specifies it.

---

## Mio

Mio comes from a future after The Fading.

Her core conclusion:

> Magic works so well that humanity will never voluntarily stop using it.

Her goal:

> **Make humanity permanently lose the ability to use magic.**

She does not destroy:

- Mana
- Spell Cards
- Functions
- magical laws

She targets:

```text
Connection(Human, Magic System)
```

Affected people may still:

- possess Mana
- know chants
- understand Function Graphs
- hold Spell Cards

but their requests no longer successfully reach or execute through the Magic System.

---

## Part 1 Reveal Order

Protected escalation:

```text
Learn magic
↓
Believe magic protects people
↓
Magic disability incidents
↓
Investigation
↓
Institute Zero / hidden evidence
↓
Causal truth
↓
Mio
↓
Connection-cutting plan
↓
Final battle — Mio
```

Do not reveal Mio as the culprit too early.

Do not reveal The Fading as common knowledge.

Do not reduce the mystery to “Spell Cards are broken.”

Multiple casting media should eventually fail, proving a deeper common dependency.

---

## Prologue Requirements

The prologue may establish:

- public Astraea worldview
- magic as infrastructure
- Aberrations as danger
- protagonist childhood rescue
- Professor Tachibana
- “別怕。待在我身後。”
- protagonist belief: “魔法可以保護人。”
- Academy arrival

The prologue should not explain:

- Reality Cost
- The Fading
- Mio's plan
- Institute Zero's full knowledge

---

## Character Canon

### Hero

- player-named
- childhood survivor of an Aberration event
- saved by a mage later known as Professor Tachibana
- core belief: magic can protect people
- flexible personality
- no fixed class/build

Part 1 arc:

```text
saved by magic
→ believes in magic
→ studies magic
→ witnesses disability
→ investigates
→ learns the cost
→ confronts Mio
```

Do not resolve the arc as:

> “Magic is simply evil.”

### Saeki Yuma

- male friend/classmate
- practical
- reliable
- teasing but kind
- knows Hero's childhood
- Space / Mobility / Support identity

### Kamiya Rio

- female
- glasses
- top student
- evidence / structure oriented
- rational but not emotionally cold
- Analysis / Information / Optimization / Function Graph
- later Counter-Function direction

She is a natural character to infer:

> the failure may be at the Human → Magic System interface rather than at one medium.

### Asakura Hina

- female
- ponytail
- energetic and direct
- practice-oriented, not foolish
- high Mana Capacity / Output
- Energy Magic
- Chantless specialist

Her eventual failure to cast is narratively useful because it proves:

> Chantless still depends on the same underlying connection.

### Professor Tachibana

- protagonist's childhood savior
- warm
- authoritative
- sincerely believes magic should be used to save people now
- not a fake villain

Ethical stance:

> If I do not use magic now, that person dies today.

### Mio

Must be written as a serious moral opponent, not a nihilistic villain.

Conflict:

```text
people who can be saved now
vs
world that may eventually reach The Fading
```

Hero:

> Magic can protect people.

Mio:

> I know. That is the problem.

---

## Scene Review Checklist

For every scene ask:

1. What changes because this scene exists?
2. Whose objective drives the scene?
3. What does the player learn?
4. What remains deliberately unknown?
5. Is the character behaving consistently?
6. Is exposition motivated?
7. Is there a gameplay or emotional payoff?
8. Does the scene reveal information too early?
9. Is the scene repeating a prior function?
10. Can one-third of the exposition be removed without losing meaning?

---

## Dialogue Direction

Dialogue should:

- sound character-specific
- avoid encyclopedic lore dumps
- allow subtext
- preserve uncertainty
- be concise enough for mobile presentation
- use choices when the choice expresses the Hero, not when a fake branch is unnecessary

Avoid AI-style dialogue where every character:

- speaks in the same polished cadence
- over-explains emotions
- restates lore
- agrees too easily
- summarizes the scene at the end

---

## Choice Design

Choices may alter:

- tone
- relationship
- optional information
- order of small objectives
- minor scene texture

Part 1 critical spine should remain stable unless an explicitly branching structure is approved.

Do not create meaningless choices merely to simulate agency.

---

## Narrative + Life Integration

Real-life activity may be acknowledged by the game, but avoid pretending that a real-world action literally occurred inside Astraea.

Good:

> “Your recent discipline has made advanced training available.”

Weak:

> “You ran 5 km in Astraea yesterday.”

If the meta-fictional explanation of Life → Hero growth is unresolved, preserve ambiguity instead of canonizing a mechanism silently.

---

## Spoiler Levels

### S0 — Public World Knowledge

Safe early:

- Academy
- magic
- Mana
- Functions
- Aberrations
- Spell Cards
- Full Chant / Chantless

### S1 — Suspicion

Safe mid-story:

- failures across media
- abnormal common cause
- secret research
- institutional inconsistencies

### S2 — Hidden Truth

Late:

- Reality Cost
- Entropy relationship
- Institute Zero knowledge
- future catastrophe evidence

### S3 — Mio Truth

Very late:

- Mio's origin
- The Fading future
- connection-cutting objective
- final ethical confrontation

---

## Output Format

```markdown
# Narrative Review — <scene / quest / feature>

## Canon Status
CONSISTENT | CONFLICT | UNRESOLVED

## Spoiler Level
S0 | S1 | S2 | S3

## Scene Function
...

## Character Checks
- Hero:
- Yuma:
- Rio:
- Hina:
- Tachibana:
- Mio:

## Reveal Check
PASS / WARN / FAIL

## Theme Check
PASS / WARN / FAIL

## Findings

### ND-01 — <title>
Severity:
Canon source:
Problem:
Why it matters:
Required change:

## Writer Direction
- objective:
- emotional beat:
- information revealed:
- information withheld:
- exit beat:
```

---

## Guardrails

Do not:

- invent canon to close a gap
- reveal Mio too early
- make Institute Zero equal Mio
- make Tachibana secretly evil merely for a twist
- make Hina “the dumb one”
- make Rio emotionless
- make Yuma comic relief only
- turn philosophical conflict into simple good vs evil
- explain the exact nature of the Magic System without approval

When canon is unresolved, mark it unresolved.