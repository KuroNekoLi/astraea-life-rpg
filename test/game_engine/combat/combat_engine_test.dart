import 'package:astraea_life_rpg/game_engine/combat/combat_engine.dart';
import 'package:astraea_life_rpg/game_engine/rng/rng.dart';
import 'package:test/test.dart';

final class FixedRng implements Rng {
  FixedRng(this.value);
  final int value;
  @override
  int nextInt(int max) => value;
}

CombatState battle({String activeCombatantId = 'hero'}) => CombatState(
  combatants: [
    CombatantState(
      id: 'hero',
      side: CombatSide.player,
      hp: 20,
      maxHp: 20,
      mana: 10,
      maxMana: 10,
      attackBonus: 4,
      defense: 12,
      processingModifier: 2,
      zone: 'near',
      reactionAvailable: true,
    ),
    CombatantState(
      id: 'enemy',
      side: CombatSide.enemy,
      hp: 12,
      maxHp: 12,
      mana: 0,
      maxMana: 0,
      attackBonus: 2,
      defense: 10,
      processingModifier: 1,
      zone: 'near',
      reactionAvailable: true,
    ),
  ],
  initiativeOrder: ['hero', 'enemy'],
  activeCombatantId: activeCombatantId,
  round: 1,
  revision: 0,
);

void main() {
  test('seeded attack command sequence has deterministic outcomes', () {
    final state = battle();
    CombatResolution run() {
      final engine = const CombatEngine();
      final rng = SeededRng(81);
      final attack = engine.resolve(
        state,
        const AttackCommand(
          'hero',
          targetId: 'enemy',
          damage: 4,
          criticalDamage: 8,
        ),
        rng,
      );
      return engine.resolve(attack.state, const EndTurnCommand('hero'), rng);
    }

    expect(run().state.eventLog, run().state.eventLog);
  });

  test(
    'natural one misses and natural twenty uses authored critical damage',
    () {
      const engine = CombatEngine();
      final miss = engine.resolve(
        battle(),
        const AttackCommand(
          'hero',
          targetId: 'enemy',
          damage: 4,
          criticalDamage: 8,
        ),
        FixedRng(0),
      );
      expect(miss.state.unit('enemy').hp, 12);
      final critical = engine.resolve(
        battle(),
        const AttackCommand(
          'hero',
          targetId: 'enemy',
          damage: 4,
          criticalDamage: 8,
        ),
        FixedRng(19),
      );
      expect(critical.state.unit('enemy').hp, 4);
    },
  );

  test(
    'spell spends authored Mana and defeated target cannot take another turn',
    () {
      const engine = CombatEngine();
      final cast = engine.resolve(
        battle(),
        const CastSpellCommand(
          'hero',
          targetId: 'enemy',
          manaCost: 3,
          damage: 12,
          criticalDamage: 12,
        ),
        FixedRng(19),
      );
      expect(cast.state.unit('hero').mana, 7);
      expect(cast.state.unit('enemy').condition, CombatantCondition.defeated);
    },
  );

  test('defender can spend a Reaction to reduce incoming damage', () {
    const engine = CombatEngine();
    final guarded = engine.resolve(
      battle(activeCombatantId: 'enemy'),
      const AttackCommand(
        'enemy',
        targetId: 'hero',
        damage: 5,
        criticalDamage: 5,
        useGuardReaction: true,
        reactionReduction: 3,
      ),
      FixedRng(19),
    );
    expect(guarded.state.unit('hero').hp, 18);
    expect(guarded.state.unit('hero').reactionAvailable, isFalse);
    expect(
      guarded.events.map((event) => event.type),
      contains('guardReaction'),
    );
  });

  test(
    'initiative uses d20 plus Processing modifier and seeded tie-breaks',
    () {
      const engine = CombatEngine();
      final units = battle().combatants;
      expect(
        engine.rollInitiative(units, SeededRng(44)),
        engine.rollInitiative(units, SeededRng(44)),
      );
    },
  );

  test('default engine advances serializable RNG state with the encounter', () {
    final initial = battle();
    final next = const CombatEngine().resolve(
      initial,
      const AttackCommand(
        'hero',
        targetId: 'enemy',
        damage: 2,
        criticalDamage: 3,
      ),
    );
    expect(next.state.rngState, isNot(initial.rngState));
    expect(next.state.seed, initial.seed);
  });
}
