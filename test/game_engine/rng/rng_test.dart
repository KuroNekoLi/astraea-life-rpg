import 'package:astraea_life_rpg/game_engine/rng/rng.dart';
import 'package:test/test.dart';

void main() {
  test('same seed reproduces a sequence within the requested range', () {
    final first = SeededRng(42);
    final replay = SeededRng(42);
    final rolls = List.generate(100, (_) => first.nextInt(20));
    expect(rolls, List.generate(100, (_) => replay.nextInt(20)));
    expect(rolls, everyElement(inInclusiveRange(0, 19)));
  });

  test('invalid random bounds are rejected', () {
    expect(() => SeededRng(42).nextInt(0), throwsRangeError);
    expect(() => SeededRng(42).nextInt(-1), throwsRangeError);
  });
}
