# Astraea Custom Skills

Astraea-specific domain skills layered on top of generic PM / Architecture / Engineering / QA workflows.

| Skill | Responsibility |
|---|---|
| `astraea-orchestrator` | Dispatch, authority, workflow state, quality gates |
| `astraea-vision-guardian` | Product thesis and player-respect invariants |
| `astraea-game-director` | RPG direction, core loop, MVP system coherence |
| `astraea-combat-designer` | Combat / Function Graph / Weak Node / encounters |
| `astraea-narrative-director` | Canon / characters / reveal timing / story structure |
| `astraea-real-player-playtester` | First-player experiential validation |

## Default Flow

```text
Request
↓
astraea-orchestrator
↓
PM / Product Analyst
↓
Vision / Game / Narrative / Combat specialist as needed
↓
Technical Architect
↓
Flutter / Gameplay Engineer
↓
Code Reviewer
↓
QA
↓
Real Player Playtester
↓
Acceptance
```

## Flutter Engineering References

```text
AGENTS.md
FLUTTER_ARCHITECTURE.md
FLUTTER_ENGINEERING_STANDARDS.md
```

These should be placed at repository root or in a clearly linked docs location.
`AGENTS.md` is the intended first-read entry point.