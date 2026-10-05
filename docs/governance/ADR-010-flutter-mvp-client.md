# ADR-010 — Flutter for the MVP Client

## Status

Accepted.

## Context

Earlier technical material explored a Kotlin Multiplatform implementation. The current product decision is to build the Astraea MVP client with Flutter.

## Decision

The MVP application client will use Flutter/Dart.

The engineering baseline is defined by:

- `FLUTTER_ARCHITECTURE.md`
- `FLUTTER_ENGINEERING_STANDARDS.md`

Where older technical documents conflict with this decision, this ADR and the Flutter baseline take precedence for client implementation.

## Consequences

Positive:

- one Flutter mobile UI codebase
- pure Dart game/domain rules are straightforward to unit test
- broad ecosystem for mobile UI, routing, persistence, animation, and tooling

Negative:

- prior KMP-oriented implementation plans may require translation
- platform-specific Kotlin/Swift integration must happen through Flutter platform boundaries when needed

## Non-decision

This ADR does not choose the long-term backend architecture and does not rewrite gameplay, progression, or narrative specifications.
