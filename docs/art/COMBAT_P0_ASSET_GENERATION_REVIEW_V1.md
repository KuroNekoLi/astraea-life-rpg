# Combat P0 Asset Generation Review v1

**Status:** Superseded by approved first-playable runtime integration  
**Owner:** `astraea-visual-asset-director`

## Attempt Summary

Two image-generation passes were run after the Combat v1 component contract stabilized.

Both outputs captured useful high-level direction:

- strong Japanese fantasy RPG battle mood
- academy / arcane environment language
- readable hostile Ashfang-like silhouette
- midnight / starlight / warm fire contrast
- Timeline / Analysis / Reaction concepts felt visually compatible with a game

However, both outputs generated **full composite battle screenshots** containing:

- HUD
- text
- character art
- spell cards
- enemy panels
- Analysis panels
- baked combat values

This violates the runtime asset briefs for both P0 assets.

## Verdict

### Training Hall Battle Background

**Decision:** REJECT_AS_RUNTIME_ASSET  
**Reason:** UI, characters, enemy, and localized text are baked into the image.

The generated composition may be used only as non-binding mood/reference material.

### Ashfang Training Construct

**Decision:** REJECT_AS_RUNTIME_ASSET  
**Reason:** Ashfang is embedded inside a complete battle screenshot rather than delivered as an isolated transparent combat asset.

The generated creature direction may inform the next isolated-asset attempt, but must not be cropped and shipped as final art.

## Guardrail Confirmed

Do **not** lower the acceptance bar merely because generated art looks attractive.

The runtime architecture remains:

```text
generated content art
+
native Flutter interactive UI
```

not:

```text
generated screenshot used as game UI
```

## Next Generation Requirement

The next accepted P0 asset generation must produce:

### Background

```text
environment only
no characters
no enemy
no text
no HUD
no card frame
wide crop-safe composition
```

### Ashfang

```text
one isolated full-body training construct
no background scene
no HUD
no text
no Weak Node marker
transparent background preferred
```

Do not integrate generated output into `pubspec.yaml` until these conditions pass.


## Final Runtime Integration

The earlier rejected composite screenshots remain rejected and are not used as runtime UI.

A later asset pass produced two isolated runtime-ready crops that were reviewed and integrated:

```text
assets/images/combat/combat_bg_astraea_training_hall_v01.webp
assets/images/combat/enemy_ashfang_training_v01.webp
```

They are registered through `pubspec.yaml` and used by both:

```text
AshfangCombatV1Screen
AshfangRematchV1Screen
```

The interactive layer remains native Flutter:

- Action Timeline
- HP / Mana
- Intent ribbon
- Reaction overlay
- Analysis / Weak Node state
- Function VFX
- localized text

The Ashfang asset is isolated to one subject and contains no HUD or baked UI text. Its current first-playable master retains a dark matte rather than true alpha transparency; this is acceptable for the current dark battlefield but remains a P2 future polish item.

The Training Hall asset contains no runtime HUD/text and is darkened at render time so combat information remains readable.

### Final first-playable decision

```text
Training Hall runtime asset: ACCEPT
Ashfang runtime asset: ACCEPT WITH P2 TRANSPARENCY POLISH
Generated full battle screenshot as UI: REJECT
```
