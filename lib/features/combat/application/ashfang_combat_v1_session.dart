import '../../../game_engine/combat/v1/combat_actions.dart';
import '../../../game_engine/combat/v1/combat_models.dart';
import '../../../game_engine/combat/v1/headless_combat_engine.dart';

enum AshfangTutorialStageV1 {
  heroChantless,
  knownReaction,
  modifiedAnalysis,
  modifiedInterrupt,
  heroFullChant,
  heroFinisher,
  victory,
  defeat,
}

enum AshfangTutorialFeedbackV1 {
  opening,
  heroChantlessResolved,
  knownFireballCasting,
  knownFireballInterrupted,
  knownFireballResolved,
  modifiedFireballCasting,
  analysisRevealedWeakNode,
  modifiedFireballInterrupted,
  modifiedFireballResolved,
  heroFullChantCasting,
  heroFullChantResolved,
  victory,
  defeat,
}

final class AshfangCombatV1Session {
  AshfangCombatV1Session() {
    reset();
  }

  static const engine = HeadlessCombatEngineV1();

  late BattleStateV1 state;
  late AshfangTutorialStageV1 stage;
  late AshfangTutorialFeedbackV1 feedback;

  String? get castingFunctionId => state.castingFunctionFor('ashfang')?.id;

  ActiveFunctionV1? get enemyCastingFunction =>
      state.castingFunctionFor('ashfang');

  FunctionKnowledgeV1? get rioKnowledge {
    final function = enemyCastingFunction;
    if (function == null) return null;
    return state.knowledgeFor('rio', function.actionId);
  }

  bool get canUseWeakNode {
    final function = enemyCastingFunction;
    final knowledge = rioKnowledge;
    return function != null &&
        knowledge != null &&
        knowledge.revealedWeakNodeIds.contains('stabilization');
  }

  void reset() {
    state = engine.start(
      combatants: [
        _actor(
          'hero',
          BattleSide.player,
          hp: 220,
          maxHp: 220,
          mana: 100,
          maxMana: 100,
          physicalResistance: 20,
          magicResistance: 18,
        ),
        _actor(
          'rio',
          BattleSide.player,
          hp: 180,
          maxHp: 180,
          mana: 120,
          maxMana: 120,
          physicalResistance: 18,
          magicResistance: 22,
        ),
        _actor(
          'yuma',
          BattleSide.player,
          hp: 210,
          maxHp: 210,
          mana: 80,
          maxMana: 80,
          physicalResistance: 24,
          magicResistance: 18,
        ),
        _actor(
          'ashfang',
          BattleSide.enemy,
          hp: 240,
          maxHp: 240,
          mana: 100,
          maxMana: 100,
          physicalResistance: 28,
          magicResistance: 20,
        ),
      ],
      initialTurnTimes: const {'hero': 0, 'ashfang': 40, 'rio': 60, 'yuma': 80},
    );
    state = engine.advance(state).state;
    stage = AshfangTutorialStageV1.heroChantless;
    feedback = AshfangTutorialFeedbackV1.opening;
  }

  void heroFireballIChantless() {
    _requireStage(AshfangTutorialStageV1.heroChantless);
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'hero',
        targetId: 'ashfang',
        action: _fireballIChantless,
      ),
    );
    feedback = AshfangTutorialFeedbackV1.heroChantlessResolved;
    _beginNextAshfangCast(known: true);
  }

  void interruptKnownFireball() {
    _requireStage(AshfangTutorialStageV1.knownReaction);
    final function = enemyCastingFunction!;
    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'rio',
        functionId: function.id,
        interrupt: _interruptShot,
      ),
    );
    feedback = AshfangTutorialFeedbackV1.knownFireballInterrupted;
    _beginNextAshfangCast(known: false);
  }

  void saveKnownReaction() {
    _requireStage(AshfangTutorialStageV1.knownReaction);
    _resolveEnemyCastingFunction();
    feedback = AshfangTutorialFeedbackV1.knownFireballResolved;
    if (state.outcome != CombatOutcome.active) {
      _finishFromOutcome();
      return;
    }
    _beginNextAshfangCast(known: false);
  }

  void analyzeModifiedFireball() {
    _requireStage(AshfangTutorialStageV1.modifiedAnalysis);
    final function = enemyCastingFunction!;
    state = engine.analyzeFunction(
      state,
      AnalyzeFunctionCommandV1(
        'rio',
        functionId: function.id,
        analysis: AnalysisDefinitionV1(
          id: 'analysis-i',
          actionDelay: 80,
          manaCost: 10,
          revealStability: true,
          revealWeakNodes: true,
        ),
      ),
    );
    stage = AshfangTutorialStageV1.modifiedInterrupt;
    feedback = AshfangTutorialFeedbackV1.analysisRevealedWeakNode;
  }

  void interruptModifiedWeakNode() {
    _requireStage(AshfangTutorialStageV1.modifiedInterrupt);
    final function = enemyCastingFunction!;
    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'rio',
        functionId: function.id,
        interrupt: _arcaneInterference,
        weakNodeId: 'stabilization',
      ),
    );
    feedback = AshfangTutorialFeedbackV1.modifiedFireballInterrupted;
    _advanceToActor('hero');
    stage = AshfangTutorialStageV1.heroFullChant;
  }

  void allowModifiedFireballToResolve() {
    _requireStage(AshfangTutorialStageV1.modifiedInterrupt);
    _resolveEnemyCastingFunction();
    feedback = AshfangTutorialFeedbackV1.modifiedFireballResolved;
    if (state.outcome != CombatOutcome.active) {
      _finishFromOutcome();
      return;
    }
    _advanceToActor('hero');
    stage = AshfangTutorialStageV1.heroFullChant;
  }

  void beginHeroFireballIIFullChant() {
    _requireStage(AshfangTutorialStageV1.heroFullChant);
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'hero',
        spell: _fireballIIFullChant,
        targetId: 'ashfang',
      ),
    );
    feedback = AshfangTutorialFeedbackV1.heroFullChantCasting;
    _resolveHeroFullChant();
    if (state.outcome != CombatOutcome.active) {
      _finishFromOutcome();
      return;
    }
    _advanceToActor('hero');
    stage = AshfangTutorialStageV1.heroFinisher;
    feedback = AshfangTutorialFeedbackV1.heroFullChantResolved;
  }

  void finishWithFireballI() {
    _requireStage(AshfangTutorialStageV1.heroFinisher);
    state = engine.useAction(
      state,
      UseActionCommandV1(
        'hero',
        targetId: 'ashfang',
        action: _fireballIChantless,
      ),
    );
    _finishFromOutcome();
  }

  void _beginNextAshfangCast({required bool known}) {
    _advanceToActor('ashfang');
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'ashfang',
        spell: known ? _knownFireball : _modifiedFireball,
        targetId: 'hero',
      ),
    );

    if (known) {
      stage = AshfangTutorialStageV1.knownReaction;
      feedback = AshfangTutorialFeedbackV1.knownFireballCasting;
      return;
    }

    _advanceToActor('rio');
    stage = AshfangTutorialStageV1.modifiedAnalysis;
    feedback = AshfangTutorialFeedbackV1.modifiedFireballCasting;
  }

  void _resolveEnemyCastingFunction() {
    final functionId = enemyCastingFunction!.id;
    while (state.outcome == CombatOutcome.active) {
      final next = engine.advance(state);
      state = next.state;

      if (next.event.functionId == functionId) {
        state = engine.resolveTimelineEvent(state, next.event);
        return;
      }

      if (next.event.type == TimelineEventType.characterTurn) {
        state = engine.useAction(
          state,
          UseActionCommandV1(next.event.actorId!, action: _waitAction),
        );
      } else {
        state = engine.resolveTimelineEvent(state, next.event);
      }
    }
  }

  void _resolveHeroFullChant() {
    final heroFunction = state.castingFunctionFor('hero');
    if (heroFunction == null) {
      throw StateError('Hero Full Chant was not created');
    }

    while (state.outcome == CombatOutcome.active) {
      final next = engine.advance(state);
      state = next.state;

      if (next.event.functionId == heroFunction.id) {
        state = engine.resolveTimelineEvent(state, next.event);
        return;
      }

      if (next.event.type == TimelineEventType.characterTurn) {
        if (next.event.actorId == 'ashfang') {
          state = engine.useAction(
            state,
            UseActionCommandV1(
              'ashfang',
              targetId: 'hero',
              action: _ashfangClaw,
            ),
          );
        } else {
          state = engine.useAction(
            state,
            UseActionCommandV1(next.event.actorId!, action: _waitAction),
          );
        }
      } else {
        state = engine.resolveTimelineEvent(state, next.event);
      }
    }
  }

  void _advanceToActor(String actorId) {
    while (state.outcome == CombatOutcome.active) {
      final next = engine.advance(state);
      state = next.state;

      if (next.event.type != TimelineEventType.characterTurn) {
        state = engine.resolveTimelineEvent(state, next.event);
        continue;
      }

      if (next.event.actorId == actorId) return;

      state = engine.useAction(
        state,
        UseActionCommandV1(next.event.actorId!, action: _waitAction),
      );
    }

    _finishFromOutcome();
  }

  void _finishFromOutcome() {
    if (state.outcome == CombatOutcome.victory) {
      stage = AshfangTutorialStageV1.victory;
      feedback = AshfangTutorialFeedbackV1.victory;
    } else if (state.outcome == CombatOutcome.defeat) {
      stage = AshfangTutorialStageV1.defeat;
      feedback = AshfangTutorialFeedbackV1.defeat;
    }
  }

  void _requireStage(AshfangTutorialStageV1 expected) {
    if (stage != expected) {
      throw StateError('Expected $expected but was $stage');
    }
  }

  static CombatantStateV1 _actor(
    String id,
    BattleSide side, {
    required int hp,
    required int maxHp,
    required int mana,
    required int maxMana,
    required int physicalResistance,
    required int magicResistance,
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

  static final _fireballIChantless = CombatActionDefinitionV1(
    id: 'fireball-i',
    kind: CombatActionKind.spell,
    actionDelay: 95,
    manaCost: 14,
    rawDamage: 90,
    damageType: DamageType.magic,
    targetZones: const {BattleZone.mid, BattleZone.far},
  );

  static final _knownFireball = FullChantDefinitionV1(
    id: 'known-fireball',
    manaCost: 16,
    rawDamage: 90,
    damageType: DamageType.magic,
    castTime: 60,
    stability: 42,
    recoveryDelay: 100,
    targetZones: const {BattleZone.mid},
  );

  static final _modifiedFireball = FullChantDefinitionV1(
    id: 'modified-fireball',
    manaCost: 22,
    rawDamage: 118,
    damageType: DamageType.magic,
    castTime: 100,
    stability: 58,
    recoveryDelay: 100,
    weakNodeInterruptBonuses: const {'stabilization': 15},
    targetZones: const {BattleZone.mid},
  );

  static final _fireballIIFullChant = FullChantDefinitionV1(
    id: 'fireball-ii',
    manaCost: 24,
    rawDamage: 180,
    damageType: DamageType.magic,
    castTime: 80,
    stability: 54,
    recoveryDelay: 100,
    targetZones: const {BattleZone.mid, BattleZone.far},
  );

  static final _interruptShot = InterruptDefinitionV1(
    id: 'interrupt-shot',
    interruptPower: 50,
    actionDelay: 80,
  );

  static final _arcaneInterference = InterruptDefinitionV1(
    id: 'arcane-interference',
    interruptPower: 45,
    actionDelay: 80,
  );

  static final _ashfangClaw = CombatActionDefinitionV1(
    id: 'ashfang-claw',
    kind: CombatActionKind.basicAttack,
    actionDelay: 90,
    rawDamage: 40,
    damageType: DamageType.physical,
    targetZones: const {BattleZone.mid},
  );

  static final _waitAction = CombatActionDefinitionV1(
    id: 'wait',
    kind: CombatActionKind.wait,
    actionDelay: 100,
  );
}
