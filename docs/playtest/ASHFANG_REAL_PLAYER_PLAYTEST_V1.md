# Real Player Playtest — Ashfang CTB v1

**Build:** master after CTB landscape tutorial integration  
**Test mode:** Combat-focused first-time player simulation  
**DEVICE_VERIFICATION:** UNAVAILABLE  
**Evidence available:** Pure Dart combat tests, Flutter widget interaction tests at 1200×700 landscape, English/zh-TW render paths, code/state inspection.

This is not a physical-device playtest. Findings below are limited to what can be observed through the implemented interaction flow and automated Flutter rendering.

## Test Context

- platform: Flutter widget test environment
- viewport: 1200×700 landscape
- clean combat session: yes
- prior product knowledge for evaluation persona: none
- internal design docs used only after the player-flow pass to classify findings

## First Impression

**I think this product is:** a tactical fantasy RPG where I read enemy magic structure and choose how to respond.

The combat surface does not resemble a Life Quest / productivity screen. The left Timeline, central battlefield, enemy intent, Reaction overlay, and right command context establish a game-first identity.

## Core Loop Understanding

- **Combat identity:** Clear
- **Interrupt timing:** Clear
- **Analysis purpose:** Clear
- **Weak Node purpose:** Clear
- **Full Chant delay:** Clear after the visible casting-state fix
- **Counter vs Interrupt:** Not taught in this encounter
- **Position / Near-Mid-Far:** Present in the engine but not meaningfully taught in this encounter

## Todo-App Risk

**Score: 0 / 4 for this combat surface**

Evidence:

- no real-life logging appears inside combat
- decisions are framed around spell construction, Timeline, Reaction, Analysis, and Weak Nodes
- the battle has its own game-state and tactical language

This score applies to the battle surface only, not the complete product loop.

## Critical Journey

| Step | Expected | Observed | Emotion | Severity |
|---|---|---|---|---|
| Enter battle | Understand what to do first | Fireball I / Chantless is the single clear teaching action | Curiosity | PASS |
| Known enemy Full Chant | Notice a response window | Reaction overlay explains Interrupt before establishment | Tactical attention | PASS |
| Modified Function | Realize prior knowledge is insufficient | Analysis becomes the highlighted next action | Curiosity | PASS |
| Analysis result | Learn something actionable | Stability and the authored Stabilization Weak Node become visible | Aha / satisfaction | PASS |
| Weak Node Interrupt | Connect understanding to action | The revealed Weak Node changes the Interrupt outcome | Tactical satisfaction | PASS |
| Hero Full Chant | Understand delayed casting | Fireball II remains pending on the Timeline before Resolve | Anticipation | PASS |
| Waiting period | Feel that time matters | Player chooses “Hold Formation”; Ashfang may act before Resolve | Tension | P2 |
| Finish | See low-tier usefulness | Fireball I Chantless remains the efficient finishing action | Understanding | PASS |
| Victory | Understand why the battle was won | End panel summarizes the taught mechanics | Satisfaction | PASS |

## Findings

### RP-01 — Runtime visual identity is still placeholder-level

**Severity:** P1  
**Where:** Battlefield  
**What I saw:** The battle uses native Flutter gradients, icons, actor tokens, and arcane geometry rather than final environment/enemy art.  
**What I concluded:** The mechanics read as a real game, but the visual fantasy is not yet at consumer JRPG quality.  
**Player impact:** The system feels more advanced than a prototype, but the emotional impact is below the intended product identity.  
**Suggested outcome:** Integrate isolated, approved Training Hall and Ashfang content assets after they pass the Visual Asset Director runtime-asset gate.

### RP-02 — Tutorial is intentionally railroaded

**Severity:** P2  
**Where:** Root commands / tutorial progression  
**What I tried:** Look for alternate tactical actions.  
**What happened:** The tutorial emphasizes the one action relevant to each teaching beat and disables unrelated commands.  
**What I concluded:** I understand the mechanic, but I cannot yet prove that I would choose it without guidance.  
**Player impact:** Strong first teaching pass; weaker evidence of independent tactical understanding.  
**Suggested outcome:** Follow the tutorial with a short unguided Ashfang rematch where several legal actions remain available.

### RP-03 — Full Chant protection is represented, not yet a full tactical choice

**Severity:** P2  
**Where:** Hero Fireball II Full Chant  
**What I did:** Began Full Chant, saw the pending Resolve event, then chose “Hold Formation.”  
**What happened:** The Timeline advances and Ashfang can act before Fireball II resolves.  
**What I concluded:** I understand that Full Chant takes time, but “protect the caster” is still a guided bridge rather than a party-action decision.  
**Player impact:** The timing lesson lands; the teamwork fantasy is only partial.  
**Suggested outcome:** A later encounter should expose an actual Guard / Barrier / positioning decision during another caster’s Full Chant.

### RP-04 — Physical-device visual QA remains unverified

**Severity:** P2  
**Where:** landscape layout / safe areas / text scale  
**Evidence:** Widget viewport tests only.  
**Player impact:** Real notches, rounded corners, system bars, device text scaling, and touch ergonomics may reveal issues not visible in widget tests.  
**Suggested outcome:** Run the same flow on at least one representative iPhone and one Android device/simulator before declaring combat visual polish complete.

## Best Moment

The strongest moment is:

```text
Unknown Modified Fireball
→ Analysis
→ Stability revealed
→ Stabilization Weak Node revealed
→ Weak Node changes Interrupt outcome
```

This demonstrates Astraea’s combat identity without asking the player to solve a math puzzle.

## Weakest Moment

The current battlefield art layer is still visibly placeholder-level compared with the quality of the combat rules and interaction design.

## What caused me to win?

I used information correctly:

- interrupted a known unfinished Function
- analyzed an unknown/modified Function
- exploited a real Weak Node
- committed to a delayed Full Chant when the window was safe enough
- used a cheaper low-tier Chantless spell to finish

The win is not explained as “click the largest damage number.”

## Would I Return for a Second Encounter?

**MAYBE → likely YES after visual asset integration and one unguided rematch**

Reason:

The Analysis → Weak Node → tactical response loop creates a distinct reason to see another enemy Function. The largest remaining issue is not rule clarity; it is whether subsequent encounters provide enough unguided decisions and visual fantasy payoff.

## Top 3 Next Fixes

1. Integrate approved isolated Training Hall and Ashfang runtime art.
2. Add one unguided Ashfang rematch / sandbox beat after the tutorial.
3. Run physical-device landscape QA with English and zh-TW.
