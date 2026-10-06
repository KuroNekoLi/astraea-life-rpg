import 'package:astraea_combat/astraea_combat.dart';
import 'package:test/test.dart';

CombatantState _unit(
  String id,
  CombatSide side, {
  bool defeated = false,
  bool actionUsed = false,
  bool reactionAvailable = true,
}) => CombatantState(
  id: id,
  side: side,
  hp: defeated ? 0 : 20,
  maxHp: 20,
  mana: 0,
  maxMana: 0,
  attackBonus: 0,
  defense: 10,
  processingModifier: 0,
  zone: 'near',
  reactionAvailable: reactionAvailable,
  condition: defeated ? CombatantCondition.defeated : CombatantCondition.active,
  mainActionUsed: actionUsed,
);

CombatState _partyBattle({
  String active = 'hero',
  int round = 1,
  bool heroActionUsed = false,
  bool allyActionUsed = false,
  bool heroReaction = true,
  bool allyReaction = true,
  bool bossReaction = true,
}) => CombatState(
  combatants: [
    _unit(
      'hero',
      CombatSide.player,
      actionUsed: heroActionUsed,
      reactionAvailable: heroReaction,
    ),
    _unit(
      'ally',
      CombatSide.player,
      actionUsed: allyActionUsed,
      reactionAvailable: allyReaction,
    ),
    _unit('boss', CombatSide.enemy, reactionAvailable: bossReaction),
  ],
  initiativeOrder: const ['hero', 'ally', 'boss'],
  activeCombatantId: active,
  round: round,
  revision: 4,
  seed: 91,
  eventLog: const ['battleStarted'],
);

void _expectSameState(CombatState actual, CombatState expected) {
  expect(
    actual.combatants.map(
      (u) => (
        u.id,
        u.hp,
        u.mana,
        u.zone,
        u.condition,
        u.mainActionUsed,
        u.reactionAvailable,
      ),
    ),
    expected.combatants.map(
      (u) => (
        u.id,
        u.hp,
        u.mana,
        u.zone,
        u.condition,
        u.mainActionUsed,
        u.reactionAvailable,
      ),
    ),
  );
  expect(actual.initiativeOrder, expected.initiativeOrder);
  expect(actual.activeCombatantId, expected.activeCombatantId);
  expect(actual.round, expected.round);
  expect(actual.revision, expected.revision);
  expect(actual.eventLog, expected.eventLog);
  expect(actual.outcome, expected.outcome);
  expect(actual.seed, expected.seed);
  expect(actual.rngState, expected.rngState);
}

void main() {
  const engine = CombatEngine();

  group('initiative queue invariants', () {
    test('accepts a complete unique queue for multiple allies and a boss', () {
      final state = _partyBattle();
      expect(state.initiativeOrder, ['hero', 'ally', 'boss']);
    });

    test('rejects duplicate initiative IDs', () {
      expect(
        () => CombatState(
          combatants: [
            _unit('hero', CombatSide.player),
            _unit('boss', CombatSide.enemy),
          ],
          initiativeOrder: const ['hero', 'hero'],
          activeCombatantId: 'hero',
          round: 1,
          revision: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects incomplete, extra, and unknown initiative IDs', () {
      final combatants = [
        _unit('hero', CombatSide.player),
        _unit('ally', CombatSide.player),
        _unit('boss', CombatSide.enemy),
      ];
      for (final order in [
        const ['hero', 'boss'],
        const ['hero', 'ally', 'boss', 'extra'],
        const ['hero', 'ally', 'stranger'],
      ]) {
        expect(
          () => CombatState(
            combatants: combatants,
            initiativeOrder: order,
            activeCombatantId: 'hero',
            round: 1,
            revision: 0,
          ),
          throwsArgumentError,
        );
      }
    });

    test('rejects an active combatant missing from the combat roster', () {
      expect(
        () => CombatState(
          combatants: [_unit('hero', CombatSide.player)],
          initiativeOrder: const ['hero'],
          activeCombatantId: 'missing',
          round: 1,
          revision: 0,
        ),
        throwsArgumentError,
      );
    });
  });

  group('authored multi-unit turn progression', () {
    test('skips defeated actors and preserves the remaining queue order', () {
      final state = CombatState(
        combatants: [
          _unit('hero', CombatSide.player),
          _unit('fallenAlly', CombatSide.player, defeated: true),
          _unit('boss', CombatSide.enemy),
          _unit('ally', CombatSide.player),
        ],
        initiativeOrder: const ['hero', 'fallenAlly', 'boss', 'ally'],
        activeCombatantId: 'hero',
        round: 1,
        revision: 0,
      );

      final afterHero = engine
          .resolve(state, const EndTurnCommand('hero'))
          .state;
      final afterBoss = engine
          .resolve(afterHero, const EndTurnCommand('boss'))
          .state;
      final afterAlly = engine
          .resolve(afterBoss, const EndTurnCommand('ally'))
          .state;

      expect(afterHero.activeCombatantId, 'boss');
      expect(afterHero.round, 1);
      expect(afterBoss.activeCombatantId, 'ally');
      expect(afterBoss.round, 1);
      expect(afterAlly.activeCombatantId, 'hero');
      expect(afterAlly.round, 2);
    });

    test('wraps one round and resets the incoming actor main action', () {
      final state = _partyBattle(
        active: 'boss',
        heroActionUsed: true,
        allyActionUsed: true,
      );
      final next = engine.resolve(state, const EndTurnCommand('boss')).state;

      expect(next.activeCombatantId, 'hero');
      expect(next.round, 2);
      expect(next.unit('hero').mainActionUsed, isFalse);
      expect(next.unit('ally').mainActionUsed, isTrue);
      expect(next.unit('boss').mainActionUsed, isFalse);
    });

    test('resets reactions only at the round wrap boundary', () {
      final state = _partyBattle(
        active: 'ally',
        heroReaction: false,
        allyReaction: false,
        bossReaction: false,
      );

      final nextWithinRound = engine
          .resolve(state, const EndTurnCommand('ally'))
          .state;
      expect(nextWithinRound.activeCombatantId, 'boss');
      expect(nextWithinRound.round, 1);
      expect(
        nextWithinRound.combatants.every((u) => !u.reactionAvailable),
        isTrue,
      );

      final nextRound = engine
          .resolve(nextWithinRound, const EndTurnCommand('boss'))
          .state;
      expect(nextRound.activeCombatantId, 'hero');
      expect(nextRound.round, 2);
      expect(nextRound.combatants.every((u) => u.reactionAvailable), isTrue);
    });
  });

  group('atomic validation failures', () {
    test('wrong actor fails without changing state', () {
      final state = _partyBattle();
      expect(
        () => engine.resolve(state, const EndTurnCommand('ally')),
        throwsStateError,
      );
      _expectSameState(state, _partyBattle());
    });

    test('invalid target fails without changing state', () {
      final state = _partyBattle();
      expect(
        () => engine.resolve(
          state,
          const AttackCommand(
            'hero',
            targetId: 'ally',
            damage: 3,
            criticalDamage: 6,
          ),
        ),
        throwsStateError,
      );
      _expectSameState(state, _partyBattle());
    });
  });

  test('seeded command sequence reproduces full state and event sequence', () {
    CombatResolution run() {
      var state = _partyBattle();
      final allEvents = <CombatEvent>[];
      for (final command in <CombatCommand>[
        const AttackCommand(
          'hero',
          targetId: 'boss',
          damage: 2,
          criticalDamage: 4,
        ),
        const EndTurnCommand('hero'),
        const EndTurnCommand('ally'),
        const AttackCommand(
          'boss',
          targetId: 'hero',
          damage: 1,
          criticalDamage: 2,
        ),
        const EndTurnCommand('boss'),
      ]) {
        final result = engine.resolve(state, command);
        state = result.state;
        allEvents.addAll(result.events);
      }
      return CombatResolution(state, allEvents);
    }

    final first = run();
    final replay = run();
    _expectSameState(first.state, replay.state);
    expect(
      first.events.map(
        (event) => (event.type, event.actorId, event.targetId, event.value),
      ),
      replay.events.map(
        (event) => (event.type, event.actorId, event.targetId, event.value),
      ),
    );
  });
}
