import 'package:astraea_life_rpg/game_engine/combat/v1/combat_actions.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/headless_combat_engine.dart';
import 'package:test/test.dart';

CombatantStateV1 unit({
  required String id,
  required BattleSide side,
  int hp = 200,
  int mana = 100,
  BattleZone zone = BattleZone.mid,
}) {
  return CombatantStateV1(
    id: id,
    side: side,
    hp: hp,
    maxHp: 200,
    mana: mana,
    maxMana: 100,
    physicalResistance: 20,
    magicResistance: 20,
    controlResistance: 20,
    zone: zone,
  );
}

BattleStateV1 startedBattle() {
  return const HeadlessCombatEngineV1().start(
    combatants: [
      unit(id: 'hero', side: BattleSide.player),
      unit(id: 'enemy', side: BattleSide.enemy),
    ],
    initialTurnTimes: const {'hero': 0, 'enemy': 40},
  );
}

FullChantDefinitionV1 fireball() {
  return FullChantDefinitionV1(
    id: 'fireball-ii-full',
    manaCost: 24,
    rawDamage: 120,
    damageType: DamageType.magic,
    castTime: 90,
    stability: 48,
    recoveryDelay: 100,
    targetZones: const {BattleZone.mid, BattleZone.far},
  );
}

void main() {
  const engine = HeadlessCombatEngineV1();

  test('Full Chant pays Mana and inserts one resolve event', () {
    final heroTurn = engine.advance(startedBattle()).state;
    final casting = engine.beginFullChant(
      heroTurn,
      BeginFullChantCommandV1(
        'hero',
        spell: fireball(),
        targetId: 'enemy',
      ),
    );

    expect(casting.actor('hero').mana, 76);
    expect(casting.activeTurn, isNull);
    expect(casting.castingFunctionFor('hero'), isNotNull);
    expect(
      casting.timeline.where((event) => event.type == TimelineEventType.spellResolve),
      hasLength(1),
    );
    expect(
      casting.timeline
          .firstWhere((event) => event.type == TimelineEventType.spellResolve)
          .scheduledAt,
      90,
    );
  });

  test('caster receives no normal Turn while Full Chant is pending', () {
    final heroTurn = engine.advance(startedBattle()).state;
    final casting = engine.beginFullChant(
      heroTurn,
      BeginFullChantCommandV1(
        'hero',
        spell: fireball(),
        targetId: 'enemy',
      ),
    );

    final enemyTurn = engine.advance(casting);
    expect(enemyTurn.event.actorId, 'enemy');

    final afterEnemy = engine.useAction(
      enemyTurn.state,
      UseActionCommandV1(
        'enemy',
        targetId: 'hero',
        action: CombatActionDefinitionV1(
          id: 'claw',
          kind: CombatActionKind.basicAttack,
          actionDelay: 40,
          rawDamage: 1,
          damageType: DamageType.physical,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );

    final enemyAgain = engine.advance(afterEnemy);
    expect(enemyAgain.event.actorId, 'enemy');
    expect(enemyAgain.state.currentTime, 80);

    final afterEnemyAgain = engine.useAction(
      enemyAgain.state,
      UseActionCommandV1(
        'enemy',
        targetId: 'hero',
        action: CombatActionDefinitionV1(
          id: 'claw',
          kind: CombatActionKind.basicAttack,
          actionDelay: 40,
          rawDamage: 1,
          damageType: DamageType.physical,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );

    final resolve = engine.advance(afterEnemyAgain);
    expect(resolve.event.type, TimelineEventType.spellResolve);
    expect(resolve.state.currentTime, 90);
  });

  test('resolve event applies spell and schedules recovery from resolve time', () {
    final heroTurn = engine.advance(startedBattle()).state;
    var state = engine.beginFullChant(
      heroTurn,
      BeginFullChantCommandV1(
        'hero',
        spell: fireball(),
        targetId: 'enemy',
      ),
    );

    final enemyTurn = engine.advance(state);
    state = engine.useAction(
      enemyTurn.state,
      UseActionCommandV1(
        'enemy',
        targetId: 'hero',
        action: CombatActionDefinitionV1(
          id: 'wait',
          kind: CombatActionKind.technique,
          actionDelay: 200,
          rawDamage: 1,
          damageType: DamageType.physical,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );

    final ready = engine.advance(state);
    expect(ready.event.type, TimelineEventType.spellResolve);
    state = engine.resolveTimelineEvent(ready.state, ready.event);

    expect(state.actor('enemy').hp, 100);
    expect(state.castingFunctionFor('hero'), isNull);
    expect(
      state.timeline
          .firstWhere((event) => event.actorId == 'hero')
          .scheduledAt,
      190,
    );
  });

  test('cancelling Full Chant refunds half base Mana and keeps recovery', () {
    final heroTurn = engine.advance(startedBattle()).state;
    var state = engine.beginFullChant(
      heroTurn,
      BeginFullChantCommandV1(
        'hero',
        spell: fireball(),
        targetId: 'enemy',
      ),
    );
    state = engine.cancelFullChant(
      state,
      const CancelFullChantCommandV1('hero'),
    );

    expect(state.actor('hero').mana, 88);
    expect(state.castingFunctionFor('hero'), isNull);
    expect(
      state.timeline.where((event) => event.type == TimelineEventType.spellResolve),
      isEmpty,
    );
    expect(
      state.timeline.firstWhere((event) => event.actorId == 'hero').scheduledAt,
      100,
    );
  });

  test('Full Chant fails cleanly if target leaves the required Zone', () {
    var state = const HeadlessCombatEngineV1().start(
      combatants: [
        unit(id: 'hero', side: BattleSide.player),
        unit(id: 'enemy', side: BattleSide.enemy),
      ],
      initialTurnTimes: const {'hero': 0, 'enemy': 20},
    );
    final heroTurn = engine.advance(state);
    state = engine.beginFullChant(
      heroTurn.state,
      BeginFullChantCommandV1(
        'hero',
        spell: fireball(),
        targetId: 'enemy',
      ),
    );

    final enemyTurn = engine.advance(state);
    state = engine.move(
      enemyTurn.state,
      const MoveCommandV1('enemy', destination: BattleZone.near),
    );
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'enemy',
        targetId: 'hero',
        action: CombatActionDefinitionV1(
          id: 'wait',
          kind: CombatActionKind.technique,
          actionDelay: 200,
          rawDamage: 1,
          damageType: DamageType.physical,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );

    final ready = engine.advance(state);
    state = engine.resolveTimelineEvent(ready.state, ready.event);

    expect(state.actor('enemy').hp, 200);
    expect(
      state.eventLog,
      contains('fullChantFailed:hero:fireball-ii-full'),
    );
  });
}
