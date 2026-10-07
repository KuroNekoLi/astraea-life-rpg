import 'package:astraea_life_rpg/game_engine/combat/v1/combat_actions.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/headless_combat_engine.dart';
import 'package:test/test.dart';

CombatantStateV1 actor(
  String id,
  BattleSide side, {
  int mana = 100,
}) {
  return CombatantStateV1(
    id: id,
    side: side,
    hp: 200,
    maxHp: 200,
    mana: mana,
    maxMana: 100,
    physicalResistance: 20,
    magicResistance: 20,
    controlResistance: 20,
    zone: BattleZone.mid,
  );
}

FullChantDefinitionV1 spell() => FullChantDefinitionV1(
  id: 'modified-fireball',
  manaCost: 22,
  rawDamage: 100,
  damageType: DamageType.magic,
  castTime: 100,
  stability: 58,
  recoveryDelay: 100,
  targetZones: const {BattleZone.mid},
);

InterruptDefinitionV1 interrupt({
  int power = 50,
  int stabilityDamage = 0,
  int actionDelay = 80,
}) => InterruptDefinitionV1(
  id: 'interrupt-shot',
  interruptPower: power,
  stabilityDamage: stabilityDamage,
  actionDelay: actionDelay,
);

void main() {
  const engine = HeadlessCombatEngineV1();

  test('Quick Action is optional, once per turn, and does not end the turn', () {
    var state = engine.start(
      combatants: [actor('hero', BattleSide.player), actor('enemy', BattleSide.enemy)],
      initialTurnTimes: const {'hero': 0, 'enemy': 20},
    );
    state = engine.advance(state).state;
    state = engine.useQuickAction(
      state,
      UseQuickActionCommandV1(
        'hero',
        action: QuickActionDefinitionV1(id: 'mark-target', manaCost: 3),
      ),
    );

    expect(state.actor('hero').mana, 97);
    expect(state.activeTurn?.actorId, 'hero');
    expect(state.activeTurn?.quickUsed, isTrue);
    expect(
      () => engine.useQuickAction(
        state,
        UseQuickActionCommandV1(
          'hero',
          action: QuickActionDefinitionV1(id: 'stance'),
        ),
      ),
      throwsStateError,
    );
  });

  test('successful Reaction Interrupt is deterministic and refunds half Mana', () {
    var state = engine.start(
      combatants: [actor('enemy', BattleSide.enemy), actor('rio', BattleSide.player)],
      initialTurnTimes: const {'enemy': 0, 'rio': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: spell(),
        targetId: 'rio',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'rio',
        functionId: functionId,
        interrupt: interrupt(power: 60),
      ),
    );

    expect(state.castingFunctionFor('enemy'), isNull);
    expect(state.actor('enemy').mana, 89);
    expect(state.actor('rio').reactionAvailable, isFalse);
    expect(
      state.timeline.where((event) => event.functionId == functionId),
      isEmpty,
    );
    expect(
      state.timeline.firstWhere((event) => event.actorId == 'enemy').scheduledAt,
      100,
    );
  });

  test('failed Reaction Interrupt reduces Stability but consumes trigger window', () {
    var state = engine.start(
      combatants: [
        actor('enemy', BattleSide.enemy),
        actor('rio', BattleSide.player),
        actor('hero', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'rio': 10, 'hero': 20},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: spell(),
        targetId: 'rio',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'rio',
        functionId: functionId,
        interrupt: interrupt(power: 40, stabilityDamage: 8),
      ),
    );

    expect(state.function(functionId).stability, 50);
    expect(state.function(functionId).reactionConsumed, isTrue);
    expect(
      () => engine.interruptFunction(
        state,
        InterruptFunctionCommandV1(
          'hero',
          functionId: functionId,
          interrupt: interrupt(power: 60),
        ),
      ),
      throwsStateError,
    );
  });

  test('Main Action Interrupt can exploit reduced Stability later', () {
    var state = engine.start(
      combatants: [actor('enemy', BattleSide.enemy), actor('hero', BattleSide.player)],
      initialTurnTimes: const {'enemy': 0, 'hero': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: spell(),
        targetId: 'hero',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'hero',
        functionId: functionId,
        interrupt: interrupt(power: 40, stabilityDamage: 8),
      ),
    );
    state = engine.advance(state).state;
    expect(state.activeTurn?.actorId, 'hero');

    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'hero',
        functionId: functionId,
        interrupt: interrupt(power: 50, actionDelay: 80),
        asReaction: false,
      ),
    );

    expect(state.castingFunctionFor('enemy'), isNull);
    expect(state.activeTurn, isNull);
    expect(
      state.timeline.firstWhere((event) => event.actorId == 'hero').scheduledAt,
      90,
    );
  });

  test('Reaction charge refreshes at the start of the formal Turn', () {
    var state = engine.start(
      combatants: [actor('enemy', BattleSide.enemy), actor('rio', BattleSide.player)],
      initialTurnTimes: const {'enemy': 0, 'rio': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: spell(),
        targetId: 'rio',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;
    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'rio',
        functionId: functionId,
        interrupt: interrupt(power: 40),
      ),
    );
    expect(state.actor('rio').reactionAvailable, isFalse);

    state = engine.advance(state).state;
    expect(state.activeTurn?.actorId, 'rio');
    expect(state.actor('rio').reactionAvailable, isTrue);
  });
}
