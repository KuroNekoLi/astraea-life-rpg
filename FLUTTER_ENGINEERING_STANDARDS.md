# Astraea Flutter Engineering Standards

**Status:** Required for MVP implementation  
**Applies to:** Dart / Flutter code, tests, assets, PRs, agent-generated code

---

# 1. Quality Gate

Before a task is considered complete:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

For affected end-to-end flows:

```bash
flutter test integration_test
```

No agent may claim completion if required gates were not run.

If a gate cannot run, report:

```text
NOT_VERIFIED
```

with the blocker.

---

# 2. Formatting and Lints

Use:

```text
dart format
flutter analyze
```

as mandatory mechanical authority.

Project rules belong in:

```text
analysis_options.yaml
```

Do not rely on reviewer taste for mechanically enforceable conventions.

---

# 3. Naming

Follow Dart conventions.

## Files

```text
snake_case.dart
```

## Types

```text
UpperCamelCase
```

## Variables / methods

```text
lowerCamelCase
```

## Constants

Use normal Dart lowerCamelCase unless framework/API semantics strongly justify another pattern.

Names should express domain meaning:

Good:

```dart
grantLifeQuestReward()
resolveCombatCommand()
growthPotential
preparedDeck
```

Weak:

```dart
processData()
manager
handler2
doThing()
```

---

# 4. Widget Rules

Prefer small composable Widgets.

A screen should coordinate layout, not contain all behavior.

Extract a Widget when it has:

- independent meaning
- repeated use
- independent state
- complex rendering
- independent test value

Do not extract every 5-line layout fragment automatically.

---

# 5. Build Methods

`build()` should be:

- side-effect free
- readable
- focused on rendering

Do not:

- write database records
- trigger reward grants
- mutate domain state
- run combat simulation
- perform network requests directly

inside `build()`.

---

# 6. Async UI

Every async flow must consider:

```text
loading
success
empty
error
retry
```

Do not assume only success.

Use `AsyncValue` or equivalent UI-state modeling consistently.

---

# 7. State Management

Riverpod is the default.

Rules:

- business logic does not live in Widgets
- business rules do not live as anonymous provider expressions
- one authoritative owner per state
- avoid global mutable singleton state
- avoid huge monolithic Notifiers
- providers are composition/state tools, not domain models

---

# 8. Immutability

Prefer immutable domain entities and UI states.

State updates should be explicit.

Avoid mutation that makes replay/test behavior unclear.

---

# 9. Domain Purity

Domain and game-engine code must not import:

```dart
package:flutter/...
package:flutter_riverpod/...
```

unless the file belongs to presentation/application composition.

Pure rule code should be runnable with:

```bash
dart test
```

where practical.

---

# 10. Nullability

Use Dart null safety intentionally.

Do not use `!` to silence uncertainty unless the invariant is proven locally.

Bad:

```dart
user!.profile!.name!
```

Prefer explicit validation/state modeling.

---

# 11. Exceptions

Do not use exceptions for ordinary domain outcomes.

Examples of ordinary outcomes:

- insufficient Mana
- card on cooldown
- invalid target
- quest already completed
- reward already granted

Represent these explicitly.

Exceptions are appropriate for exceptional infrastructure failures.

---

# 12. IDs

Do not use display names as persistent identity.

Every persistent entity should have a stable ID.

Examples:

```text
questId
activityId
rewardGrantId
spellId
encounterId
sceneId
```

---

# 13. Time

Do not call `DateTime.now()` throughout domain logic.

Use a clock abstraction where deterministic behavior matters.

This is required for:

- recurrence
- streak/momentum windows
- reward timing
- timers
- tests

---

# 14. Randomness

Do not instantiate `Random()` inside combat rules.

Inject RNG.

Seeded tests are required for random combat outcomes.

---

# 15. Logging

Logs must be:

- structured enough to diagnose
- free of secrets
- free of sensitive user content unless explicitly allowed
- tagged by feature when useful

Never log:

- auth tokens
- private evidence photos
- financial details
- sensitive health data

---

# 16. Privacy

Life data is user data.

Treat:

- health
- finance
- personal notes
- evidence
- daily routines

as privacy-sensitive.

Store the minimum necessary.

Do not create analytics events containing raw private content.

---

# 17. Assets

Asset naming:

```text
env_<name>.webp
portrait_<character>_<state>.webp
enemy_<name>.webp
weapon_<name>.webp
spell_<name>.webp
icon_<name>.svg
```

Examples:

```text
env_academy_gate.webp
portrait_rio_analysis.webp
enemy_arcane_sentry.webp
spell_interrupt_pulse.webp
```

Keep an asset manifest.

---

# 18. UI Tokens

Do not hardcode arbitrary UI constants repeatedly.

Use Design System tokens for:

- colors
- typography
- spacing
- radius
- elevation/effects
- animation durations where standardized

---

# 19. Accessibility

Minimum expectations:

- meaningful semantic labels
- touch targets suitable for mobile
- contrast review
- no critical information conveyed only by color
- text scaling does not catastrophically break primary flows
- Function Graph states need shape/icon/label support, not only color

---

# 20. Localization

Do not concatenate translated sentences.

Use localization resources for user-visible strings.

Avoid hardcoded user-facing strings in reusable widgets.

MVP may ship one locale, but code should not make future localization unnecessarily expensive.

---

# 21. Testing Rules

Test behavior, not implementation trivia.

## Unit test

Use for:

- rules
- transforms
- reducers
- calculations
- validators

## Widget test

Use for:

- screen behavior
- interactions
- visible state

## Integration test

Use for:

- cross-feature critical journeys

Avoid excessive mocking.

Prefer real domain objects.

Mock/stub only at real I/O boundaries.

---

# 22. Test Naming

Tests should describe observable behavior.

Good:

```dart
test('completing the same quest twice grants reward only once', ...)
```

Weak:

```dart
test('test reward service', ...)
```

---

# 23. TDD Guidance

For bugs:

1. reproduce
2. write failing regression test
3. fix
4. rerun tests
5. review

For deterministic domain/game logic, TDD is strongly preferred.

---

# 24. Code Review Severity

Use:

- Critical — can ship corruption/security/major incorrect behavior
- Major — likely user-visible bug or architecture damage
- Minor — maintainability/polish

Every finding must include:

```text
location
problem
impact
recommended fix
```

---

# 25. PR / Task Size

Prefer changes that can be independently reviewed.

Split work when one task mixes:

- schema migration
- combat redesign
- UI redesign
- unrelated cleanup

Avoid giant “implement MVP” diffs.

---

# 26. Comments

Comments should explain:

> why

not restate:

> what

Bad:

```dart
// Increment count
count++;
```

Good:

```dart
// Reward grants are idempotent because timer completion may be retried
// after process restoration.
```

---

# 27. Generated Code

Do not manually edit generated files.

Generated artifacts should be reproducible.

Document the generation command.

---

# 28. Dependencies

Before adding a package:

- confirm the problem cannot be solved cleanly with existing dependencies
- check maintenance/activity
- check license
- check platform compatibility
- consider binary/build impact

Foundational dependency changes require Architect review.

---

# 29. Performance

Do not optimize blindly.

Measure first.

High-priority risks for Astraea:

- large artwork memory usage
- image decoding
- animation overdraw
- excessive rebuilds
- battle-state copies
- database queries on main UI paths

Use profiling evidence before major optimization.

---

# 30. Definition of Done

A Flutter implementation is complete only when:

- acceptance criteria pass
- architecture rules are respected
- format passes
- analyze passes
- tests pass
- relevant visual state is reviewed
- relevant first-player flow is validated
- no unresolved product/canon decision is hidden