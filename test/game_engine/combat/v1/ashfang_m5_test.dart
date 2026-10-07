import 'package:astraea_life_rpg/game_engine/combat/v1/combat_actions.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_report.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/enemy_pattern.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/headless_combat_engine.dart';
import 'package:test/test.dart';

CombatantStateV1 scenarioActor(
  String id,
  BattleSide side, {
  int hp = 200,
  int maxHp = 200,
  int mana = 100,
  int maxMana = 100,
  int physicalResistance = 20,
  int magicResistance = 20,
}) {
  return CombatantStateV1(
    id: id,
    side: side,
    hp: hp,
    maxHp: maxHp,
    mana: mana,
    maxMana: maxMana,
    physicalResistance: physicalResistance,
    magicResistance: magicResistance,
    controlResistance: 20,
    zone: BattleZone.mid,
  );
}

EnemyPatternV1 ashfangPattern() {
  return EnemyPatternV1(
    rules: [
      EnemyPatternRuleV1(
        id: 'modified-after-known',
        priority: 100,
        intentId: 'modified-fireball',
        condition: EnemyPatternConditionV1(
          minTurnIndex: 1,
          minMana: 22,
          requiredPreviousIntentId: 'known-fireball',
          requiresNoCastingFunction: true,
        ),
      ),
      EnemyPatternRuleV1(
        id: 'open-known-fireball',
        priority: 50,
        intentId: 'known-fireball',
        condition: EnemyPatternConditionV1(
          minMana: 16,
          requiresNoCastingFunction: true,
        ),
      ),
      EnemyPatternRuleV1(
        id: 'fallback-claw',
        priority: 0,
        intentId: 'claw',
        condition: EnemyPatternConditionV1(),
      ),
    ],
  );
}

FullChantDefinitionV1 ashfangSpell(String intentId) {
  return switch (intentId) {
    'known-fireball' => FullChantDefinitionV1(
      id: 'known-fireball',
      manaCost: 16,
      rawDamage: 90,
      damageType: DamageType.magic,
      castTime: 60,
      stability: 42,
      recoveryDelay: 100,
      targetZones: const {BattleZone.mid},
    ),
    'modified-fireball' => FullChantDefinitionV1(
      id: 'modified-fireball',
      manaCost: 22,
      rawDamage: 118,
      damageType: DamageType.magic,
      castTime: 100,
      stability: 58,
      recoveryDelay: 100,
      weakNodeInterruptBonuses: const {'stabilization': 15},
      targetZones: const {BattleZone.mid},
    ),
    _ => throw ArgumentError('Unknown Ashfang spell intent: $intentId'),
  };
}

CombatActionDefinitionV1 waitAction({int delay = 100}) {
  return CombatActionDefinitionV1(
    id: 'wait',
    kind: CombatActionKind.wait,
    actionDelay: delay,
  );
}

BattleStateV1 _advancePlayersUntil(
  HeadlessCombatEngineV1 engine,
  BattleStateV1 state,
  String actorId,
) {
  var current = state;
  while (current.outcome == CombatOutcome.active) {
    final next = engine.advance(current);
    current = next.state;
    if (next.event.type != TimelineEventType.characterTurn) {
      current = engine.resolveTimelineEvent(current, next.event);
      continue;
    }
    if (next.event.actorId == actorId) {
      return current;
    }
    current = engine.useAction(
      current,
      UseActionCommandV1(next.event.actorId!, action: waitAction()),
    );
  }
  throw StateError('Battle ended before $actorId received a Turn');
}

BattleStateV1 runAshfangHeadlessScenario() {
  const engine = HeadlessCombatEngineV1();
  final pattern = ashfangPattern();
  final history = <String>[];
  var enemyTurnIndex = 0;

  var state = engine.start(
    combatants: [
      scenarioActor(
        'ashfang',
        BattleSide.enemy,
        hp: 510,
        maxHp: 510,
        physicalResistance: 28,
        magicResistance: 20,
      ),
      scenarioActor('rio', BattleSide.player, mana: 120, maxMana: 120),
      scenarioActor('hero', BattleSide.player),
    ],
    initialTurnTimes: const {'ashfang': 0, 'rio': 10, 'hero': 20},
  );

  state = engine.advance(state).state;
  var intent = pattern.choose(
    state: state,
    actorId: 'ashfang',
    targetId: 'hero',
    context: EnemyPatternContextV1(
      turnIndex: enemyTurnIndex++,
      previousIntentIds: history,
    ),
  );
  history.add(intent.intentId);
  state = engine.beginFullChant(
    state,
    BeginFullChantCommandV1(
      'ashfang',
      spell: ashfangSpell(intent.intentId),
      targetId: 'hero',
    ),
  );
  var functionId = state.castingFunctionFor('ashfang')!.id;

  state = engine.interruptFunction(
    state,
    InterruptFunctionCommandV1(
      'rio',
      functionId: functionId,
      interrupt: InterruptDefinitionV1(
        id: 'interrupt-shot',
        interruptPower: 50,
        actionDelay: 80,
      ),
    ),
  );

  state = _advancePlayersUntil(engine, state, 'ashfang');
  intent = pattern.choose(
    state: state,
    actorId: 'ashfang',
    targetId: 'hero',
    context: EnemyPatternContextV1(
      turnIndex: enemyTurnIndex++,
      previousIntentIds: history,
    ),
  );
  history.add(intent.intentId);
  state = engine.beginFullChant(
    state,
    BeginFullChantCommandV1(
      'ashfang',
      spell: ashfangSpell(intent.intentId),
      targetId: 'hero',
    ),
  );
  functionId = state.castingFunctionFor('ashfang')!.id;

  state = _advancePlayersUntil(engine, state, 'rio');
  state = engine.analyzeFunction(
    state,
    AnalyzeFunctionCommandV1(
      'rio',
      functionId: functionId,
      analysis: AnalysisDefinitionV1(
        id: 'analysis-i',
        actionDelay: 80,
        manaCost: 10,
        revealStability: true,
        revealWeakNodes: true,
      ),
    ),
  );

  state = _advancePlayersUntil(engine, state, 'rio');
  state = engine.interruptFunction(
    state,
    InterruptFunctionCommandV1(
      'rio',
      functionId: functionId,
      interrupt: InterruptDefinitionV1(
        id: 'arcane-interference',
        interruptPower: 45,
        actionDelay: 80,
      ),
      weakNodeId: 'stabilization',
      asReaction: false,
    ),
  );

  state = _advancePlayersUntil(engine, state, 'hero');
  state = engine.useAction(
    state,
    UseActionCommandV1(
      'hero',
      targetId: 'ashfang',
      action: CombatActionDefinitionV1(
        id: 'training-finisher',
        kind: CombatActionKind.technique,
        actionDelay: 100,
        rawDamage: 1000,
        damageType: DamageType.physical,
        targetZones: const {BattleZone.mid},
      ),
    ),
  );

  return state;
}

void main() {
  test(
    'enemy Pattern selects authored intents from deterministic conditions',
    () {
      const engine = HeadlessCombatEngineV1();
      final state = engine.start(
        combatants: [
          scenarioActor('ashfang', BattleSide.enemy),
          scenarioActor('hero', BattleSide.player),
        ],
        initialTurnTimes: const {'ashfang': 0, 'hero': 10},
      );
      final pattern = ashfangPattern();

      final first = pattern.choose(
        state: state,
        actorId: 'ashfang',
        targetId: 'hero',
        context: EnemyPatternContextV1(turnIndex: 0),
      );
      final second = pattern.choose(
        state: state,
        actorId: 'ashfang',
        targetId: 'hero',
        context: EnemyPatternContextV1(
          turnIndex: 1,
          previousIntentIds: const ['known-fireball'],
        ),
      );

      expect(first.intentId, 'known-fireball');
      expect(second.intentId, 'modified-fireball');
    },
  );

  test('same Pattern state and context always choose the same Intent', () {
    const engine = HeadlessCombatEngineV1();
    final state = engine.start(
      combatants: [
        scenarioActor('ashfang', BattleSide.enemy),
        scenarioActor('hero', BattleSide.player),
      ],
      initialTurnTimes: const {'ashfang': 0, 'hero': 10},
    );
    final pattern = ashfangPattern();
    final context = EnemyPatternContextV1(
      turnIndex: 1,
      previousIntentIds: const ['known-fireball'],
    );

    expect(
      pattern
          .choose(
            state: state,
            actorId: 'ashfang',
            targetId: 'hero',
            context: context,
          )
          .intentId,
      pattern
          .choose(
            state: state,
            actorId: 'ashfang',
            targetId: 'hero',
            context: context,
          )
          .intentId,
    );
  });

  test('Ashfang headless scenario is deterministic and produces a report', () {
    final first = runAshfangHeadlessScenario();
    final second = runAshfangHeadlessScenario();

    expect(first.outcome, CombatOutcome.victory);
    expect(
      CombatStateFingerprintV1.compute(first),
      CombatStateFingerprintV1.compute(second),
    );

    final report = CombatReportV1.fromState(first);
    expect(report.fullChantsStarted, 2);
    expect(report.interruptAttempts, 2);
    expect(report.interruptSuccesses, 2);
    expect(report.analysisUses, 1);
    expect(report.outcome, CombatOutcome.victory);
    expect(report.canonical(), CombatReportV1.fromState(second).canonical());
  });
}
