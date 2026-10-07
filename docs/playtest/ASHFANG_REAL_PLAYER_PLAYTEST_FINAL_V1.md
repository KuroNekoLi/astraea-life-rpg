# Ashfang Real Player Playtest — Final Pass v1

**Status:** CONDITIONAL PASS  
**Build scope:** CTB Tutorial + unguided Free Practice  
**Locales:** English + zh-TW  
**Physical-device verification:** PENDING  
**Simulator verification:** PENDING external execution

## Evidence Used

- Pure Dart CTB engine and session tests
- full Tutorial click-through widget tests
- unguided rematch session tests
- unguided rematch widget interaction tests
- landscape viewport matrix
- localization hardcode gate
- Flutter analyzer / test CI
- Visual Asset Director review
- UI/UX Director + Vision Guardian review

## Final Player Read

The battle now communicates a real tactical loop:

```text
read intent
→ choose whether to spend Reaction
→ Analyze when information is worth the action
→ exploit revealed structure when useful
→ manage Mana / Full Chant timing
→ observe consequence
```

The Tutorial teaches the grammar. Free Practice removes the single highlighted answer and exposes multiple legal actions.

## Tutorial Result

PASS for the intended learning path:

- Chantless resolves immediately
- known Full Chant exposes Interrupt
- modified Function creates an information problem
- Analysis reveals authored information
- Weak Node is discovered, not assumed
- Full Chant remains visibly pending on the Timeline
- Hold Formation makes the waiting period legible
- lower-tier Fireball remains useful as a finisher

## Free Practice Result

PASS for the current independence gate:

Hero can choose among:

- Basic Attack
- Guard
- Fireball I Chantless
- Fireball II Full Chant

Reaction allows:

- Interrupt
- Save Reaction

Rio can later choose Analysis when a Function remains active, and Weak Node exploitation is only offered after the knowledge state supports it.

This is materially stronger evidence of understanding than the Tutorial alone.

## Visual Identity Result

The runtime now uses:

- Astraea Training Hall environment artwork
- isolated single-subject Ashfang artwork
- native Flutter Timeline / HUD / localization
- native dynamic Function / Weak Node overlays
- native casting pulse and interrupt flash VFX

This preserves the correct separation:

```text
generated content art
+
native interactive UI
```

rather than shipping a generated screenshot as the interface.

## Todo-App Risk

**Combat surface: 0 / 4**

The player is reading enemy intent, spell construction, Timeline events, Reaction windows, and Function knowledge. No productivity framing dominates the battle.

## Remaining Findings

### RP-FINAL-01 — Simulator / real safe-area evidence is still required

**Severity:** P1 release gate  
Automated viewport tests cannot prove notch, gesture bar, real font metrics, OS rotation behavior, GPU/image decode behavior, or thumb ergonomics.

Use:

```text
docs/qa/COMBAT_SIMULATOR_TEST_PROMPT.md
```

### RP-FINAL-02 — Ashfang art uses a neutral dark matte rather than true alpha transparency

**Severity:** P2 visual polish  
The runtime asset is isolated to a single Ashfang subject and contains no HUD/text, but the current compact WebP retains a dark matte. It is acceptable for the current dark combat panel, but a true transparent master remains desirable for later animation/compositing.

### RP-FINAL-03 — Free Practice is a first independence test, not final encounter balance

**Severity:** P2  
It proves that the player can make multiple legal choices. It does not yet prove long-term dominant-strategy balance, enemy variety, or difficulty curve.

## Final Decision

### Interaction / combat comprehension

**PASS**

### Bilingual UI contract

**PASS in automated coverage**

### Runtime visual integration

**PASS for first playable**

### Physical-device QA

**NOT VERIFIED**

### Simulator QA

**NOT VERIFIED in this execution environment**

### Overall

**CONDITIONAL PASS**

The Ashfang first playable is ready for simulator/device QA and a small external player cohort. Do not call the combat slice release-ready until the external QA prompt has been executed and any P0/P1 findings are closed.
