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

The clean-room replacement pass supplied two production assets that passed the runtime gate:

| Asset | Runtime spec | Decision |
| --- | --- | --- |
| `combat_bg_astraea_training_hall_v01.webp` | 960×540 RGB WebP · 80,840 bytes | PASS_RUNTIME |
| `enemy_ashfang_training_v01.webp` | 420×560 RGBA WebP · 62,028 bytes · alpha preserved | PASS_RUNTIME |

Canonical runtime paths:

```text
assets/images/combat/combat_bg_astraea_training_hall_v01.webp
assets/images/combat/enemy_ashfang_training_v01.webp
```

They are registered in `pubspec.yaml` and consumed by both:

```text
AshfangCombatV1Screen
AshfangRematchV1Screen
```

### Runtime composition decision

The Training Hall remains environment content only and renders with:

```text
BoxFit.cover
+ native Flutter darkening overlay
```

This allows 16:9–20:9 landscape cropping while keeping the battlefield readable.

Ashfang is a true-alpha isolated subject and renders with:

```text
BoxFit.contain
+ native Flutter actor frame / HP state
+ native casting / Function / Interrupt VFX
```

The transparent subject is never cropped with `BoxFit.cover`; the full silhouette, tail, halo, and limbs remain available to the battlefield composition.

### Interactive-layer separation

The following remain native Flutter rather than baked into generated art:

- Action Timeline
- HP / Mana
- Intent ribbon
- Reaction overlay
- Analysis / Weak Node state
- Function pulse
- casting glow
- Interrupt flash
- localized English / zh-TW text

### Final clean-room decision

```text
Training Hall clean-room runtime asset: PASS_RUNTIME
Ashfang transparent clean-room runtime asset: PASS_RUNTIME
Generated full battle screenshot as UI: REJECT_RUNTIME
```

The previous dark-matte Ashfang first-playable asset is superseded by the transparent clean-room replacement.
