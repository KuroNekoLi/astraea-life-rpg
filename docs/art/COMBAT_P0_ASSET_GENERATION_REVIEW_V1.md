# Combat P0 Asset Generation Review v1

**Status:** Generation attempted; runtime assets not yet approved  
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
