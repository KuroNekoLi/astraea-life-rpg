# Astraea Combat Rules v1 Baseline

**Status:** Locked v1 baseline for combat design
**Scope:** Rules and player-facing implications; implementation and numerical tuning are out of scope.
**Companion UX specification:** [`ASTRAEA_COMBAT_UX_FLOW_V1.md`](ASTRAEA_COMBAT_UX_FLOW_V1.md)

This document consolidates combat decisions for v1. It complements, rather than silently rewrites, the combat, spell, progression, and world documents listed in [Source alignment](#source-alignment-and-precedence). “Locked” means the rule is the current design baseline; it does not claim that it has been implemented or validated through playtesting.

## Status labels

- **Locked v1 Rules** — normative rules for v1 combat design.
- **Derived UX Implications** — presentation requirements that follow from locked rules.
- **Open Balance Values/TBD** — formulas, tuning values, and outcomes that remain undecided.

## Locked v1 Rules

### 1. Action Timeline

- Combat uses a continuous, CTB-like Action Timeline.
- A character turn, a spell resolve, and any important battlefield Function may each appear as a Timeline Event.
- Attacks, Techniques, and SCs may have different Action Delay values.
- Temporal effects may advance or delay Timeline Events.
- The timeline represents event order and relative time; players are not expected to interpret raw Action Values.

### 2. Action Economy

On each formal character Turn, that character receives one Main Action, up to one Quick Action, and one free Normal Move of one adjacent Zone. The recommended sequence is:

```text
Optional Move → Optional Quick → Main → End Turn
```

The Main Action resolves before the character's Turn ends. A character may choose to omit optional actions. Main Actions include Attack, Technique, SC, Analyze, and Guard. Analyze and Guard each consume the Main Action.

Quick Actions are limited to setup, stance, marking, and minor utility. They do not provide damage, healing, or hard control on the same tier as a Main Action.

Reactions are triggered by events and are not actions taken during the reacting character's own Turn. Each character can hold at most one Reaction Charge; it refreshes at the start of that character's formal Turn. A normal Reaction does not change the reacting character's Timeline position. At most one Party Reaction may resolve in a single Trigger Window.

### 3. Full Chant Timing

- Full Chant consumes the current Main Action and places the caster in **Casting State**.
- A Spell Resolve Event is inserted into the Action Timeline. The cast resolves automatically at that event; resolving it is not a second player Turn.
- During Casting, the caster receives no normal Turn and cannot use Main, Quick, Move, or another SC. The caster may use only a Reaction explicitly marked **Casting-Compatible**, or actively cancel the cast.
- The caster's position is locked for the duration of Full Chant.
- Each SC defines its own Cast Time. After resolution, recovery and the caster's next action are calculated from the resolve time.
- Enemies and party members follow the same Full Chant rules. Any boss exception must be an explicit ability, such as **Parallel Casting**.

### 4. Interrupt

The default Interrupt check is deterministic:

```text
If Interrupt Power (IP) >= current Function Stability, the cast is interrupted immediately.
Otherwise, the cast is not interrupted by that check.
```

There is no default RNG roll. Function Stability can derive from spell base stability, caster Precision/Mastery, casting modifiers, and buffs/debuffs. Interrupt Power can derive from technique base power, relevant attributes, technique modifiers, and Weak Node bonuses.

Analysis may reveal Stability, Weak Nodes, or dependencies, but is not a prerequisite to attempt an Interrupt. Some Disruptive actions may deal Stability Damage even when their IP is insufficient, reducing the Function's later Stability. A Normal Attack does not necessarily deal Stability Damage.

A successful Interrupt removes the Spell Resolve Event and puts the caster into recovery. Chantless casts usually do not expose a conventional Interrupt Window. If a positional requirement is violated, the Function may collapse directly; that does not have to use the IP-versus-Stability check.

Interrupt applies before the cast completes. Counter and Reverse apply to a Function that is already active; these are separate timing windows.

### 5. Mana Economy

- Pay the full Mana Cost when casting starts. The caster must be able to pay the full cost at Cast Start.
- If a Full Chant is interrupted or actively canceled by the player, refund 50% of its base Mana Cost; the caster still incurs recovery.
- A successfully resolved cast does not pay its Mana Cost a second time.
- Characters have no default passive Mana regeneration during battle.
- Basic Attack is the primary Mana recovery source. Guard restores less Mana and also provides defensive value.
- Explicit Passives or SCs may override these baseline rules.
- Mana Capacity represents the size of the Mana pool; it does not directly increase damage.

### 6. Position and Range

Combat uses shared **Near / Mid / Far Zones**, not a grid. During a normal Turn, a character may make one free adjacent Zone move before its Main Action:

```text
Near ↔ Mid ↔ Far
```

Normal Move adds no Action Delay. Moving across two Zones or using special movement requires a Technique or SC. Characters cannot move during Full Chant.

Every Attack, Technique, and SC defines an effective Range (for example: Near, Near–Mid, Mid, Mid–Far, or Any). Knockback, Pull, Blink, and Position Swap directly change Zones. Area effects may specify one or more Zones. Analysis may have base Range Any, with distance affecting information resolution. Enemy Intent communicates required movement or position.

### 7. Damage and Defense

The two primary damage types are **Physical** and **Magic**. Characters and enemies have Physical Resistance, Magic Resistance, and Control Resistance. Each attack has one Primary Damage Type and may also carry Tags such as Fire, Ice, Kinetic, or Spatial.

Attribute roles:

- **Mana Output** primarily affects the raw output ceiling of a spell.
- **Efficiency** affects conversion of Mana into effective results and cost performance.
- **Precision** primarily affects Function control, Stability, Chantless, parameter tuning, Weak Nodes, and Counter. It is not a generic damage stat.
- **Mana Capacity** affects the Mana pool only.

Magic Resistance reduces Magic Damage; it does not grant blanket resistance to every magical effect. Non-damaging control is handled by Control Resistance and its applicable rules. Elemental/system affinity is a secondary modifier layer, not a proliferation of primary defense stats.

Guard reduces both Physical and Magic damage and increases resistance to Interrupt. Barrier is Function-based defense and remains distinct from Guard. Resistance uses a multiplier / diminishing-returns model, not simple linear Attack-minus-Defense subtraction. Exact curves remain open.

### 8. Status UX

The underlying model distinguishes character statuses from Function statuses. Player-facing labels remain intuitive and do not require players to learn that engineering distinction. The MVP keeps the status set small and retains only statuses that materially change play.

Candidate character statuses are Burn, Slow, Haste, Stun, Silence, Guarded, Marked, and Weakened. Function statuses focus on Casting and Unstable. Analyzed is primarily represented by increased information visibility rather than a status icon.

Locked behavior:

- Slow delays the affected Timeline Event; Haste advances it.
- Stun makes the affected character's next action fail.
- Silence disables SC use only; it does not disable Attack, Technique, Guard, or Move.

The UI should show no more than about four status icons at once; additional statuses collapse into `+N`.

### 9. Counter and Reverse

Counter handles an established or incoming Function and is commonly used as a Reaction. Its conceptual check may compare **Counter Power** against **Effect Integrity**.

Reverse is a higher-order operation that changes a Function's state or direction; it is not an enhanced Dispel. Success depends on both character capability and the Function's Reversibility. Known spells may be Countered directly. Analysis can help with unknown, modified, or composite spells. Players are not asked to perform inverse mathematics.

Reverse outcomes may include:

- Cancel / Collapse
- Partial Reverse
- State Restoration

Counter is common, fast, and reactive. Reverse is rare, costly, and understanding-driven. Most Reverse actions use a Main Action or an explicitly high-tier special Reaction. A Function that has substantially dispersed (for example, after an explosion) may have reduced or no reversibility.

### 10. Enemy AI

Enemy behavior uses six readable archetypes:

1. **Aggressor** — closes distance and applies pressure.
2. **Caster** — uses Full Chant and powerful SCs.
3. **Disruptor** — interrupts, destabilizes, or silences.
4. **Controller** — manipulates Timeline, Zones, or positioning.
5. **Defender / Support** — uses Barrier, healing, stabilization, and cleansing.
6. **Analyst / Adaptive** — observes or analyzes, then responds to repeated patterns without illicit access to player information.

AI follows **Pattern + Conditions**, not random skill selection or a global optimal-solver. Important behavior is telegraphed through Intent and Timeline Events. Ordinary enemies usually have one Primary archetype; elites may combine a Primary and Secondary; bosses may combine or switch archetypes by phase. The Ashfang Training Construct may begin as Aggressor + Caster.

### 11. Last Spell

Each character has one personal Last Spell. It does not count against the six-slot Prepared SC limit and is used through the normal SC interface. Last Spell has a fixed casting method; the player does not choose Full Chant or Chantless. Once confirmed, it cannot be interrupted.

The v1 activation threshold is at least 25% of Max Mana. Activation consumes all remaining Mana. Once the threshold is met, the Last Spell has its full defined effect; its power does not scale with the amount of Mana consumed. The 25% threshold remains subject to playtest tuning (see section 12).

After use, the character enters **Exhausted**. Ordinary healing cannot remove Exhausted. For the remainder of the battle, that character cannot take Main, Quick, Move, Reaction, or Cast actions and is removed from the normal Action Timeline. The character remains on the battlefield and can still be hit by damage or AoE. Future high-tier magic may restore the character, but that recovery mechanic is outside v1.

Last Spell can be used at low HP; only the Mana requirement gates activation. The UI must show a confirmation that clearly explains the irreversible in-battle consequence before the player commits.

### Baseline prerequisites

- Prepared SC limit is six.
- Lower Tiers remain available and may be prepared independently after higher Tiers are unlocked.
- Tiers within one Spell Family expose more parameters; they are not simply damage ranks. Tiers across different Families are not directly comparable.
- Full Chant and Chantless are casting modes for the same SC, not separate SCs.
- Known Spell Signatures are recognized directly. Analysis is encouraged for Unknown, Modified, or Composite spells.
- Interrupt occurs before cast completion. Counter and Reverse address an active Function.

## Derived UX Implications

These are consequences of the locked rules and should guide interface and encounter design:

- Show Timeline Event order and relative timing, including meaningful cast-resolution and battlefield events. Translate timing into readable order/progress rather than requiring raw Action Value interpretation.
- Make the current character's remaining Main, Quick, Move, and Reaction resources legible. Identify which action ends the Turn, and distinguish event-triggered Reactions from Turn actions.
- Keep a Full Chant's caster state, locked position, resolve event, and Interrupt window visible. Explain that resolve happens automatically and show the post-resolve recovery preview when known.
- Before cast start, show the full Mana cost and whether it is affordable. For interruption/cancellation, communicate the half-base-cost refund and remaining recovery.
- Show Zone and effective Range for actions; preview movement and area coverage. Make movement requirements in enemy Intent explicit.
- Present damage type and meaningful Tags separately. Tooltips state outcomes first; advanced players may expand tactical details and formulas.
- Keep status icons to about four plus a `+N` overflow. Explain effects in plain language; expose formulas only in optional tactical details.
- Separate the pre-completion Interrupt window from post-activation Counter / Reverse responses. Do not imply Analysis is required for known Signatures or for an Interrupt attempt.
- Communicate enemy Pattern + Conditions through readable Intent and Timeline telegraphs. Analyst/Adaptive enemies must telegraph observed patterns and cannot behave as if they know hidden player information.
- Place Last Spell in its own persistent area within the SC experience, outside the six prepared slots. Before confirmation, state Mana threshold, all-Mana consumption, full effect, Exhausted consequences, and the fact that damage/AoE can still affect the character.

## 12. Balance / Playtest — Not Locked Yet

The following values and formulas are explicitly open and require balance work or playtesting:

- Action Delay values for each Attack, Technique, SC, movement ability, and event type.
- Cast Times by SC and casting method; Timeline units and event insertion rules where numeric precision is needed.
- Recovery values, including after successful resolution, interruption, and cancellation.
- Mana costs, Basic Attack recovery, Guard recovery, and the exact interruption/cancellation refund interactions beyond the 50% base-cost rule.
- Exact Physical/Magic resistance curves, diminishing-returns behavior, and damage coefficients.
- Control Resistance formula and status application/resistance thresholds.
- Status durations, stacking, refresh, and expiration timing.
- Counter Power versus Effect Integrity formula and thresholds.
- Reverse eligibility, Reversibility thresholds, and outcome cutoffs.
- Whether the Last Spell 25% Max Mana activation threshold needs playtest adjustment.
- SC XP curves and any progression values that affect combat balance.
- Exact Stability / Interrupt Power derivation coefficients, Stability Damage amounts, and recovery effects.
- Enemy archetype patterns, condition priorities, and encounter-specific telegraph timing.

These open items must not be presented as settled numerical rules until separately resolved.

## Source alignment and precedence

This baseline was aligned against:

- [`COMBAT_SYSTEM.md`](COMBAT_SYSTEM.md) — combat vision, action types, Prepared Deck, Full Chant, Interrupt, and Counter / Reverse foundations.
- [`SPELL_FUNCTION_SYSTEM.md`](SPELL_FUNCTION_SYSTEM.md) — Spell Signature, Family and Tier semantics, casting modes, Stability, Analysis, and Function timing.
- [`CHARACTER_PROGRESSION_SYSTEM.md`](CHARACTER_PROGRESSION_SYSTEM.md) — attribute responsibilities and SC progression context.
- [`WORLD_BIBLE.md`](../world/WORLD_BIBLE.md) — magic, Full Chant / Chantless, Signature recognition, Analysis, and canon boundaries.
- [`ASTRAEA_COMBAT_UX_FLOW_V1.md`](ASTRAEA_COMBAT_UX_FLOW_V1.md) — combat HUD, Action Order, SC flow, Analysis UX, and Interrupt/Reverse timing presentation.

This document resolves combat-design choices that were previously proposals or TBDs in the companion system documents. It does not redefine established world canon or attribute identity. If a source describes an older proposal that differs from a Locked v1 Rule here, use this baseline for v1 combat rules and update that source in a later, explicit documentation pass. If a difference would alter world canon, stop and record a canon conflict rather than silently changing it.
