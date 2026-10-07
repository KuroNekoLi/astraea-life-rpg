# Clean-room Runtime Asset Review Checklist

Use this immediately after each isolated image worker returns an asset.

## Context provenance

- [ ] Generated/edited in a fresh isolated image context
- [ ] Worker received one Asset Brief only
- [ ] No long development / QA / CI conversation was supplied
- [ ] Reference edit was used when a canonical visual existed

## Runtime separation

- [ ] No baked HUD
- [ ] No localized text
- [ ] No progress/status dashboard
- [ ] No presentation sheet
- [ ] No collage
- [ ] No multiple variants
- [ ] No watermark

## Asset-specific

### Background

- [ ] Environment only
- [ ] No characters/enemy
- [ ] Center remains gameplay-readable
- [ ] Crop-safe for landscape phones

### Enemy / character cutout

- [ ] One subject only
- [ ] Full silhouette readable
- [ ] Background requirement satisfied
- [ ] No target / Weak Node marker unless explicitly required

## Decision

```text
PASS_RUNTIME
REJECT_RUNTIME
REFERENCE_ONLY
```

Only `PASS_RUNTIME` may enter Flutter runtime assets.
