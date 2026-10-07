# Ashfang Balance Test Sheet v0.1

**Status:** Provisional sandbox input; not a locked rule, canon fact, or playtest result
**Purpose:** Give the first combat prototype a small, hand-checkable set of values.
**Related baseline:** [`COMBAT_RULES_V1_BASELINE.md`](COMBAT_RULES_V1_BASELINE.md)

All numbers below are starting hypotheses. Replace them after observing actual play. They are intended to test action choice, Mana rhythm, Timeline readability, and a single telegraphed enemy spell—not to represent final character progression.

## Encounter goal

| Item | Initial target |
|---|---|
| Party | Hero, Yuma, Rio |
| Enemy | Ashfang Training Construct |
| Expected duration | 2–4 minutes |
| Party Main Actions | 8–15 |
| Main tactical question | Respond to Ashfang's Full Chant Fireball while keeping useful damage pressure. |
| Intended lesson | Interrupt, Guard, or reposition can each be reasonable; no single response is mandatory every time. |

The encounter should not require the player to use every combat system. Analysis may reveal an advantage, but Ashfang's known standard Fireball should be recognizable without Analysis.

## Shared first-pass scale

| Quantity | Starting value |
|---|---:|
| Normal Action Delay | 100 units |
| Max Mana reference | 100 |
| Physical / Magic Resistance | 0 unless noted |
| Control Resistance | 0 unless noted |
| Damage multiplier candidate | `100 / (100 + Resistance)` |
| Basic Attack Mana recovery | +10 |
| Guard Mana recovery | +6 |

The unit values are internal prototype aids. Player-facing UI should show event order and relative time, not raw Action Values.

## Combatants

| Combatant | HP | Mana | Initial Function Stability / Interrupt Power | Notes |
|---|---:|---:|---:|---|
| Hero | 240 | 100 | IP 38 with Interrupt Shot | Generalist; has Analysis and basic Guard. |
| Yuma | 280 | 70 | IP 34 with a disruptive Technique | Physical pressure; can deal 8 Stability Damage on a dedicated disruption. |
| Rio | 210 | 120 | IP 42 with Interrupt Shot | Caster/support; has Barrier and Analysis. |
| Ashfang | 500 | 80 | Stability 42 while Full Chanting | Primary Aggressor, Secondary Caster. |

These HP values are scaffolding, not derived from progression formulas. For the first run, avoid additional resistance modifiers so it is easy to attribute outcomes to actions and timing.

## Initial action and SC sheet

Damage is listed before resistance and other situational modifiers. “Delay” is the recovery/action delay used for the next relevant Timeline Event; cast time is listed separately. Costs and recovery are paid at the timing defined in the locked baseline.

| Action / SC | Type | Damage / effect | Mana | Action Delay | Cast Time | Initial note |
|---|---|---:|---:|---:|---:|---|
| Basic Attack | Main | 55 Physical | +10 | 100 | — | Baseline damage and primary Mana recovery. |
| Quick Strike | Technique | 65 Physical | 0 | 80 | — | Fast option; test whether the shorter delay offsets modest output. |
| Heavy Technique | Technique | 100 Physical | 5 | 130 | — | Slower burst; can deal 8 Stability Damage when tagged Disruptive. |
| Fireball I — Chantless | SC | 75 Magic | 15 | 85 | — | Lower Tier remains useful as a faster, cheaper option. |
| Fireball I — Full Chant | SC | 100 Magic | 15 | 100 | 50 | Stable, interruptible cast; target one Zone. |
| Fireball II — Chantless | SC | 80 Magic | 18 | 90 | — | More parameter control; not a strict damage upgrade. |
| Fireball II — Full Chant | SC | 110 Magic | 18 | 100 | 90 | Higher output and Stability; compare tactical value with Chantless. |
| Force Bolt | SC | 85 Magic | 15 | 90 | 35 | Single-target, short cast. |
| Barrier | SC | — | 18 | 100 | 45 | Prevent 70 damage to one ally; test against Guard's lower cost and Mana recovery. |
| Blink | SC | — | 12 | 80 | 20 | Move one Zone; does not grant an extra Main Action. |
| Position Swap | SC | — | 20 | 110 | 45 | Exchange two units' Zones; test only if needed to create a meaningful range choice. |
| Analysis | Main | Reveal current Stability and one dependency | 0 | 100 | — | Information only; does not guarantee a Weak Node. |
| Interrupt Shot | Reaction or Technique per actor kit | — | 12 | 100 | — | IP 38 (Hero), 42 (Rio); succeeds at Stability 42 only for Rio in this sample. |
| Guard | Main | Reduce incoming damage by 40% until next formal Turn; +6 Mana | 0 | 100 | — | Candidate defensive value and lower Mana recovery. |

**Interpretation note:** The Full Chant damage values are deliberately around 1.3–1.5× same-SC Chantless damage in this sample. The broader 2.0–3.0× baseline range in the framework refers to possible output relative to a Basic Attack baseline for heavy Full Chant SCs, not a required ratio between two modes of the same SC. Adjust if actual play shows Full Chant is not worth its cast time and interruption exposure.

## Ashfang pattern

Ashfang uses **Pattern + Conditions**, with visible Intent:

1. If Far, advance toward Mid (one Zone) rather than attack out of range.
2. If it has enough Mana and no active cast, telegraph **Full Chant Fireball I** targeting the party member with the highest current Mana.
3. On cast start, pay the full 15 Mana, insert the Resolve Event, and show Stability 42 if known/revealed.
4. Resolve 50 Magic damage to the target Zone after 80 Timeline units. If interrupted, remove the Resolve Event and enter 100 units of recovery; refund 7.5 Mana (half the 15 base cost).
5. If it has insufficient Mana or is recovering, use a 45 Physical claw attack at Near; otherwise advance or Guard according to range.

The values are chosen to produce a visible response window. If the Resolve Event arrives before any plausible party response, lengthen Cast Time or adjust encounter ordering. Do not silently grant extra player turns to force a tutorial outcome.

## What to observe

- Can players read the Fireball's target and resolve timing from the Timeline?
- Do players recognize a known Signature without first spending Main Action on Analysis?
- Are Interrupt Shot, Guard, and positional response all plausible choices in different states?
- Does a Stability 42 cast create meaningful cases for IP 38, IP 42, and Stability Damage?
- Do characters use SCs without exhausting Mana after only a couple of casts? Do they still Basic Attack or Guard for understandable reasons?
- Is Full Chant attractive when the caster can protect the cast, while Chantless remains useful under pressure?
- Does Quick Strike's delay advantage matter enough to justify its lower damage?
- Does the party occupy Near, Mid, and Far for different tactical reasons, or does one Zone dominate?
- Can the party defeat Ashfang in approximately 8–15 Main Actions without a single action dominating every attempt?

Record battle duration, Main Actions, actions per character, damage by action, Mana spent/recovered/remaining, casts started/resolved/interrupted, Interrupt attempts and success, Guard use, Zone occupancy, and player deaths/wipes.

## Iteration log template

| Run | Observed problem | One primary axis changed | Result | Keep / revert / next question |
|---|---|---|---|---|
| 0.1 | Baseline hand-check / first prototype | None | Not playtested yet | Collect first observations before tuning. |

Change one major axis per iteration when possible. For example, if Full Chant is underused, first adjust Cast Time or resolve reward—not damage, Mana cost, Stability, and recovery all at once.
