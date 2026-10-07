import 'package:astraea_life_rpg/game_engine/combat/v1/combat_actions.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/headless_combat_engine.dart';
import 'package:test/test.dart';

CombatantStateV1 m4Actor(
  String id,
  BattleSide side, {
  int hp = 200,
  int mana = 100,
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
    zone: BattleZone.mid,
  );
}

FullChantDefinitionV1 modifiedFireball({
  String id = 'modified-fireball',
  int castTime = 100,
  int executionDelay = 0,
  Map<String, int> weakNodes = const {'stabilization': 15},
  bool reversible = false,
  Iterable<String> counterTags = const ['thermal-projectile'],
}) {
  return FullChantDefinitionV1(
    id: id,
    manaCost: 22,
    rawDamage: 120,
    damageType: DamageType.magic,
    castTime: castTime,
    stability: 58,
    recoveryDelay: 100,
    executionDelay: executionDelay,
    weakNodeInterruptBonuses: weakNodes,
    reversible: reversible,
    counterTags: counterTags,
    targetZones: const {BattleZone.mid},
  );
}

InterruptDefinitionV1 m4Interrupt({int power = 45}) {
  return InterruptDefinitionV1(
    id: 'arcane-interference',
    interruptPower: power,
    actionDelay: 80,
  );
}

AnalysisDefinitionV1 deepAnalysis() {
  return AnalysisDefinitionV1(
    id: 'analysis-i',
    actionDelay: 80,
    manaCost: 10,
    revealStability: true,
    revealWeakNodes: true,
    revealCounterPath: true,
  );
}

void main() {
  const engine = HeadlessCombatEngineV1();

  test('Analysis reveals information but does not invent a Weak Node', () {
    var state = engine.start(
      combatants: [
        m4Actor('enemy', BattleSide.enemy),
        m4Actor('rio', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'rio': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: modifiedFireball(weakNodes: const {}),
        targetId: 'rio',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.advance(state).state;
    state = engine.analyzeFunction(
      state,
      AnalyzeFunctionCommandV1(
        'rio',
        functionId: functionId,
        analysis: deepAnalysis(),
      ),
    );

    final knowledge = state.knowledgeFor('rio', 'modified-fireball')!;
    expect(knowledge.level, FunctionKnowledgeLevelV1.counterPath);
    expect(knowledge.knownStability, 58);
    expect(knowledge.revealedWeakNodeIds, isEmpty);
  });

  test('hidden Weak Node cannot be exploited before Analysis', () {
    var state = engine.start(
      combatants: [
        m4Actor('enemy', BattleSide.enemy),
        m4Actor('rio', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'rio': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: modifiedFireball(),
        targetId: 'rio',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    expect(
      () => engine.interruptFunction(
        state,
        InterruptFunctionCommandV1(
          'rio',
          functionId: functionId,
          interrupt: m4Interrupt(),
          weakNodeId: 'stabilization',
        ),
      ),
      throwsStateError,
    );
  });

  test(
    'Analysis exposes a real Weak Node that can change Interrupt outcome',
    () {
      var state = engine.start(
        combatants: [
          m4Actor('enemy', BattleSide.enemy),
          m4Actor('rio', BattleSide.player),
        ],
        initialTurnTimes: const {'enemy': 0, 'rio': 10},
      );
      state = engine.advance(state).state;
      state = engine.beginFullChant(
        state,
        BeginFullChantCommandV1(
          'enemy',
          spell: modifiedFireball(),
          targetId: 'rio',
        ),
      );
      final functionId = state.castingFunctionFor('enemy')!.id;

      state = engine.advance(state).state;
      state = engine.analyzeFunction(
        state,
        AnalyzeFunctionCommandV1(
          'rio',
          functionId: functionId,
          analysis: deepAnalysis(),
        ),
      );
      final knowledge = state.knowledgeFor('rio', 'modified-fireball')!;
      expect(knowledge.revealedWeakNodeIds, contains('stabilization'));

      state = engine.advance(state).state;
      state = engine.interruptFunction(
        state,
        InterruptFunctionCommandV1(
          'rio',
          functionId: functionId,
          interrupt: m4Interrupt(power: 45),
          weakNodeId: 'stabilization',
          asReaction: false,
        ),
      );

      expect(state.castingFunctionFor('enemy'), isNull);
      expect(
        state.eventLog,
        contains('interruptAttempt:rio:$functionId:ip=60'),
      );
    },
  );

  test('Counter is rejected while a spell is still only casting', () {
    var state = engine.start(
      combatants: [
        m4Actor('enemy', BattleSide.enemy),
        m4Actor('hero', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'hero': 10},
      initialKnowledge: [
        FunctionKnowledgeV1(
          observerId: 'hero',
          signatureId: 'known-fireball',
          level: FunctionKnowledgeLevelV1.counterPath,
          knownCounterTags: const {'thermal-projectile'},
          reversibilityKnown: true,
        ),
      ],
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: modifiedFireball(
          id: 'known-fireball',
          castTime: 20,
          executionDelay: 30,
          reversible: true,
        ),
        targetId: 'hero',
      ),
    );

    expect(
      () => engine.counterFunction(
        state,
        CounterFunctionCommandV1(
          'hero',
          functionId: state.castingFunctionFor('enemy')!.id,
          counter: CounterDefinitionV1(
            id: 'thermal-collapse',
            actionDelay: 90,
            compatibleTags: const {'thermal-projectile'},
            requiresReversibility: true,
          ),
        ),
      ),
      throwsStateError,
    );
  });

  test('known Counter can cancel an established Function without Analysis', () {
    var state = engine.start(
      combatants: [
        m4Actor('enemy', BattleSide.enemy),
        m4Actor('hero', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'hero': 10},
      initialKnowledge: [
        FunctionKnowledgeV1(
          observerId: 'hero',
          signatureId: 'known-fireball',
          level: FunctionKnowledgeLevelV1.counterPath,
          knownCounterTags: const {'thermal-projectile'},
          reversibilityKnown: true,
        ),
      ],
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: modifiedFireball(
          id: 'known-fireball',
          castTime: 20,
          executionDelay: 30,
          reversible: true,
        ),
        targetId: 'hero',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.advance(state).state;
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'hero',
        targetId: 'enemy',
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
    final establish = engine.advance(state);
    expect(establish.event.type, TimelineEventType.spellResolve);
    state = engine.resolveTimelineEvent(establish.state, establish.event);
    expect(state.function(functionId).status, ActiveFunctionStatusV1.active);

    state = engine.counterFunction(
      state,
      CounterFunctionCommandV1(
        'hero',
        functionId: functionId,
        counter: CounterDefinitionV1(
          id: 'thermal-collapse',
          actionDelay: 90,
          compatibleTags: const {'thermal-projectile'},
          requiresReversibility: true,
        ),
      ),
    );

    expect(state.activeFunctions, isEmpty);
    expect(
      state.timeline.where((event) => event.functionId == functionId),
      isEmpty,
    );
    expect(state.actor('hero').hp, 200);
  });

  test('unknown Counter path must be learned before use', () {
    var state = engine.start(
      combatants: [
        m4Actor('enemy', BattleSide.enemy),
        m4Actor('hero', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'hero': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: modifiedFireball(castTime: 20, executionDelay: 30),
        targetId: 'hero',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.advance(state).state;
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'hero',
        targetId: 'enemy',
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
    final establish = engine.advance(state);
    state = engine.resolveTimelineEvent(establish.state, establish.event);

    expect(
      () => engine.counterFunction(
        state,
        CounterFunctionCommandV1(
          'hero',
          functionId: functionId,
          counter: CounterDefinitionV1(
            id: 'thermal-collapse',
            actionDelay: 90,
            compatibleTags: const {'thermal-projectile'},
          ),
        ),
      ),
      throwsStateError,
    );
  });

  test('established Function survives caster defeat and still resolves', () {
    var state = engine.start(
      combatants: [
        m4Actor('enemy', BattleSide.enemy, hp: 40),
        m4Actor('hero', BattleSide.player),
      ],
      initialTurnTimes: const {'enemy': 0, 'hero': 10},
    );
    state = engine.advance(state).state;
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'enemy',
        spell: modifiedFireball(castTime: 20, executionDelay: 30),
        targetId: 'hero',
      ),
    );
    final functionId = state.castingFunctionFor('enemy')!.id;

    state = engine.advance(state).state;
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'hero',
        targetId: 'enemy',
        action: CombatActionDefinitionV1(
          id: 'setup-hit',
          kind: CombatActionKind.technique,
          actionDelay: 20,
          rawDamage: 1,
          damageType: DamageType.physical,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );
    final establish = engine.advance(state);
    state = engine.resolveTimelineEvent(establish.state, establish.event);
    expect(state.function(functionId).status, ActiveFunctionStatusV1.active);

    state = engine.advance(state).state;
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'hero',
        targetId: 'enemy',
        action: CombatActionDefinitionV1(
          id: 'finisher',
          kind: CombatActionKind.technique,
          actionDelay: 100,
          rawDamage: 100,
          damageType: DamageType.physical,
          targetZones: const {BattleZone.mid},
        ),
      ),
    );
    expect(state.actor('enemy').condition, CombatantCondition.defeated);
    expect(state.outcome, CombatOutcome.active);
    expect(state.function(functionId).status, ActiveFunctionStatusV1.active);

    final effect = engine.advance(state);
    expect(effect.event.type, TimelineEventType.battlefieldFunction);
    state = engine.resolveTimelineEvent(effect.state, effect.event);

    expect(state.actor('hero').hp, 100);
    expect(state.outcome, CombatOutcome.victory);
  });
}
