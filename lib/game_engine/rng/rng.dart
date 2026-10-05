import 'dart:math';

/// Inject into simulations; never create unseeded randomness inside game rules.
abstract interface class Rng {
  int nextInt(int max);
}

/// Repeatable for the same seed and calls on the pinned Dart runtime.
/// Cross-runtime replay stability is intentionally not promised by M0.
final class SeededRng implements Rng {
  SeededRng(int seed) : _random = Random(seed);

  final Random _random;

  @override
  int nextInt(int max) => _random.nextInt(max);
}
