import 'package:astraea_life_rpg/game_engine/combat/v1/combat_actions.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/headless_combat_engine.dart';
import 'package:test/test.dart';

CombatantStateV1 hero({
  int hp = 220,
  int mana = 80,
  BattleZone zone = BattleZone.mid,
}) {
  return CombatantStateV1(
    id: 'hero',
    side: BattleSide.player,
    hp: hp,
    maxHp: 220,
    mana: mana,
    maxMana: 100,
    physicalResistance: 20,
    magicResistance: 18,
    controlResistance: 20,
    zone: zone,
  );
}

CombatantStateV1 ashfang({
  int hp = 510,
  int mana = 100,
  BattleZone zone = BattleZone.mid,
}) {
  return CombatantStateV1(
    id: 'ashfang',
    side: BattleSide.enemy,
    hp: hp,
    maxHp: 510,
    mana: mana,
    maxMana: 100,
    physicalResistance: 28,
    magicResistance: 20,
    controlResistance: 22,
    zone: zone,
  );
}

BattleStateV1 battle({
  CombatantStateV1? player,
  CombatantStateV1? enemy,
  Map<String, int>? initialTurnTimes,
}) {
  return const HeadlessCombatEngineV1().start(
    combatants: [player ?? hero(), enemy ?? ashfang()],
    initialTurnTimes: initialTurnTimes ?? const {'hero': 0, 'ashfang': 20},
  );
}

void main() {
  const engine = HeadlessCombatEngineV1();

  group('CTB timeline', () {
    test('orders events by time and preserves insertion order for ties', () {
      final state = engine.start(
        combatants: [hero(), ashfang()],
        initialTurnTimes: const {'hero': 0, 'ashfang': 0},
      );

      expect(state.timeline.map((event) => event.actorId), ['hero', 'ashfang']);
    });

    test('Main Action ends the turn and reschedules by Action Delay', () {
      final started = engine.advance(battle()).state;
      final next = engine.useAction(
        started,
        UseActionCommandV1(
          'hero',
          targetId: 'ashfang',
          action: CombatActionDefinitionV1(
            id: 'basic-attack',
            kind: CombatActionKind.basicAttack,
            actionDelay: 100,
            manaRecovery: 10,
            rawDamage: 60,
            damageType: DamageType.physical,
            targetZones: const {BattleZone.near, BattleZone.mid},
          ),
        ),
      );

      expect(next.activeTurn, isNull);
      expect(
        next.timeline
            .firstWhere((event) => event.actorId == 'hero')
            .scheduledAt,
        100,
      );
      expect(engine.advance(next).event.actorId, 'ashfang');
    });

    test('spell resolve and battlefield events share the same timeline', () {
      var state = battle();
      state = engine.scheduleEvent(
        state,
        id: 'spell:fireball-1',
        type: TimelineEventType.spellResolve,
        scheduledAt: 10,
        actorId: 'hero',
      );

      final heroTurn = engine.advance(state).state;
      final afterHero = engine.useAction(
        heroTurn,
        UseActionCommandV1(
          'hero',
          targetId: 'ashfang',
          action: CombatActionDefinitionV1(
            id: 'wait-hit',
            kind: CombatActionKind.technique,
            actionDelay: 100,
            rawDamage: 1,
            damageType: DamageType.physical,
            targetZones: const {BattleZone.mid},
          ),
        ),
      );

      final next = engine.advance(afterHero);
      expect(next.event.type, TimelineEventType.spellResolve);
      expect(next.event.id, 'spell:fireball-1');
      expect(next.state.currentTime, 10);
    });
  });

  group('Mana and damage', () {
    test('Basic Attack restores Mana and uses Physical Resistance', () {
      final started = engine.advance(battle()).state;
      final result = engine.useAction(
        started,
        UseActionCommandV1(
          'hero',
          targetId: 'ashfang',
          action: CombatActionDefinitionV1(
            id: 'basic-attack',
            kind: CombatActionKind.basicAttack,
            actionDelay: 100,
            manaRecovery: 10,
            rawDamage: 60,
            damageType: DamageType.physical,
            targetZones: const {BattleZone.mid},
          ),
        ),
      );

      expect(result.actor('hero').mana, 90);
      expect(result.actor('ashfang').hp, 463);
    });

    test('Magic Damage uses Magic Resistance and pays Mana at Cast Start', () {
      final started = engine.advance(battle()).state;
      final result = engine.useAction(
        started,
        UseActionCommandV1(
          'hero',
          targetId: 'ashfang',
          action: CombatActionDefinitionV1(
            id: 'fireball-i-chantless',
            kind: CombatActionKind.spell,
            actionDelay: 95,
            manaCost: 14,
            rawDamage: 90,
            damageType: DamageType.magic,
            targetZones: const {BattleZone.mid, BattleZone.far},
          ),
        ),
      );

      expect(result.actor('hero').mana, 66);
      expect(result.actor('ashfang').hp, 435);
    });

    test('cannot start an action without its full Mana cost', () {
      final started = engine.advance(battle(player: hero(mana: 10))).state;

      expect(
        () => engine.useAction(
          started,
          UseActionCommandV1(
            'hero',
            targetId: 'ashfang',
            action: CombatActionDefinitionV1(
              id: 'fireball-i',
              kind: CombatActionKind.spell,
              actionDelay: 95,
              manaCost: 14,
              rawDamage: 90,
              damageType: DamageType.magic,
              targetZones: const {BattleZone.mid},
            ),
          ),
        ),
        throwsStateError,
      );
    });

    test('Guard restores less Mana and reduces incoming damage', () {
      var state = engine.advance(battle()).state;
      state = engine.useAction(
        state,
        UseActionCommandV1(
          'hero',
          action: CombatActionDefinitionV1(
            id: 'guard',
            kind: CombatActionKind.guard,
            actionDelay: 90,
            manaRecovery: 6,
            guardDamageReductionPercent: 25,
          ),
        ),
      );
      expect(state.actor('hero').mana, 86);

      state = engine.advance(state).state;
      state = engine.useAction(
        state,
        UseActionCommandV1(
          'ashfang',
          targetId: 'hero',
          action: CombatActionDefinitionV1(
            id: 'claw',
            kind: CombatActionKind.basicAttack,
            actionDelay: 90,
            rawDamage: 60,
            damageType: DamageType.physical,
            targetZones: const {BattleZone.mid},
          ),
        ),
      );

      // 60 -> 50 after Physical Resistance 20, then 25% Guard -> 38.
      expect(state.actor('hero').hp, 182);

      state = engine.advance(state).state;
      expect(state.actor('hero').guardDamageReductionPercent, 0);
    });
  });

  group('Near / Mid / Far movement', () {
    test('Normal Move allows one adjacent Zone and does not advance time', () {
      final started = engine
          .advance(battle(player: hero(zone: BattleZone.far)))
          .state;
      final moved = engine.move(
        started,
        const MoveCommandV1('hero', destination: BattleZone.mid),
      );

      expect(moved.actor('hero').zone, BattleZone.mid);
      expect(moved.currentTime, started.currentTime);
      expect(moved.activeTurn?.moveUsed, isTrue);
      expect(
        () => engine.move(
          moved,
          const MoveCommandV1('hero', destination: BattleZone.near),
        ),
        throwsStateError,
      );
    });

    test('Normal Move cannot cross two Zones at once', () {
      final started = engine
          .advance(battle(player: hero(zone: BattleZone.far)))
          .state;

      expect(
        () => engine.move(
          started,
          const MoveCommandV1('hero', destination: BattleZone.near),
        ),
        throwsStateError,
      );
    });

    test('action range rejects a target outside allowed Zones', () {
      final started = engine
          .advance(battle(enemy: ashfang(zone: BattleZone.far)))
          .state;

      expect(
        () => engine.useAction(
          started,
          UseActionCommandV1(
            'hero',
            targetId: 'ashfang',
            action: CombatActionDefinitionV1(
              id: 'sword-slash',
              kind: CombatActionKind.basicAttack,
              actionDelay: 100,
              rawDamage: 60,
              damageType: DamageType.physical,
              targetZones: const {BattleZone.near},
            ),
          ),
        ),
        throwsStateError,
      );
    });
  });

  test('defeating the final enemy removes its turns and ends battle', () {
    final started = engine.advance(battle(enemy: ashfang(hp: 30))).state;
    final result = engine.useAction(
      started,
      UseActionCommandV1(
        'hero',
        targetId: 'ashfang',
        action: CombatActionDefinitionV1(
          id: 'finisher',
          kind: CombatActionKind.technique,
          actionDelay: 120,
          rawDamage: 100,
          damageType: DamageType.magic,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );

    expect(result.actor('ashfang').condition, CombatantCondition.defeated);
    expect(result.outcome, CombatOutcome.victory);
    expect(
      result.timeline.where((event) => event.actorId == 'ashfang'),
      isEmpty,
    );
  });
}
