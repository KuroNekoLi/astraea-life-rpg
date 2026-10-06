/// Inject into simulations; never create unseeded randomness inside game rules.
abstract interface class Rng {
  int nextInt(int max);
}

/// Serializable 32-bit LCG for deterministic same-seed replay across runtimes.
final class SeededRng implements Rng {
  SeededRng(int seed) : _state = seed & 0xffffffff;

  SeededRng.fromState(int state) : _state = state & 0xffffffff;

  int _state;
  int get state => _state;

  @override
  int nextInt(int max) {
    if (max <= 0) throw RangeError.value(max, 'max', 'Must be positive');
    _state = (1664525 * _state + 1013904223) & 0xffffffff;
    return _state % max;
  }
}
