import '../../../game_engine/combat/v1/combat_actions.dart';
import '../../../game_engine/combat/v1/combat_models.dart';
import '../../../game_engine/combat/v1/headless_combat_engine.dart';

enum AshfangRematchPhaseV1 { playerTurn, reactionWindow, victory, defeat }

final class AshfangRematchV1Session {
  AshfangRematchV1Session() {
    reset();
  }

  static const engine = HeadlessCombatEngineV1();

  late BattleStateV1 state;
  late AshfangRematchPhaseV1 phase;
  int _ashfangTurns = 0;

  String? get activePlayerId {
    final id = state.activeTurn?.actorId;
    if (id == null) return null;
    return state.actor(id).side == BattleSide.player ? id : null;
  }

  ActiveFunctionV1? get enemyCastingFunction =>
      state.castingFunctionFor('ashfang');

  FunctionKnowledgeV1? get rioKnowledge {
    final function = enemyCastingFunction;
    if (function == null) return null;
    return state.knowledgeFor('rio', function.actionId);
  }

  bool get weakNodeRevealed =>
      rioKnowledge?.revealedWeakNodeIds.contains('stabilization') ?? false;

  bool get canReact {
    final function = enemyCastingFunction;
    return phase == AshfangRematchPhaseV1.reactionWindow &&
        function != null &&
        !function.reactionConsumed &&
        state.actor('rio').isActive &&
        state.actor('rio').reactionAvailable;
  }

  void reset() {
    _ashfangTurns = 0;
    state = engine.start(
      combatants: [
        _actor('hero', BattleSide.player, hp: 220, mana: 100, physical: 20, magic: 18),
        _actor('rio', BattleSide.player, hp: 180, mana: 120, physical: 18, magic: 22),
        _actor('yuma', BattleSide.player, hp: 210, mana: 80, physical: 24, magic: 18),
        _actor('ashfang', BattleSide.enemy, hp: 320, mana: 100, physical: 28, magic: 20),
      ],
      initialTurnTimes: const {'hero': 0, 'ashfang': 40, 'rio': 60, 'yuma': 80},
    );
    _advanceUntilDecision();
  }

  void basicAttack() {
    final actorId = _requirePlayerTurn();
    final action = switch (actorId) {
      'hero' => _heroBasic,
      'rio' => _rioBasic,
      'yuma' => _yumaBasic,
      _ => throw StateError('Unknown player actor'),
    };
    state = engine.useAction(
      state,
      UseActionCommandV1(actorId, targetId: 'ashfang', action: action),
    );
    _advanceUntilDecision();
  }

  void guard() {
    final actorId = _requirePlayerTurn();
    state = engine.useAction(
      state,
      UseActionCommandV1(actorId, action: _guard),
    );
    _advanceUntilDecision();
  }

  void castHeroFireballI() {
    if (_requirePlayerTurn() != 'hero') {
      throw StateError('Only Hero can use Fireball I');
    }
    state = engine.useAction(
      state,
      UseActionCommandV1('hero', targetId: 'ashfang', action: _fireballI),
    );
    _advanceUntilDecision();
  }

  void beginHeroFireballIIFullChant() {
    if (_requirePlayerTurn() != 'hero') {
      throw StateError('Only Hero can begin Fireball II');
    }
    state = engine.beginFullChant(
      state,
      BeginFullChantCommandV1(
        'hero',
        spell: _fireballII,
        targetId: 'ashfang',
      ),
    );
    _advanceUntilDecision();
  }

  void analyzeEnemyFunction() {
    if (_requirePlayerTurn() != 'rio') {
      throw StateError('Rio performs Analysis');
    }
    final function = enemyCastingFunction;
    if (function == null) {
      throw StateError('No enemy Function to analyze');
    }
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
    final activeFunction = state.castingFunctionFor('ashfang');
    if (state.actor('rio').reactionAvailable &&
        activeFunction != null &&
        !activeFunction.reactionConsumed) {
      phase = AshfangRematchPhaseV1.reactionWindow;
      return;
    }
    _advanceUntilDecision();
  }

  void interruptEnemyFunction({bool exploitWeakNode = false}) {
    if (!canReact) {
      throw StateError('No Reaction window');
    }
    final function = enemyCastingFunction!;
    final weakNodeId =
        exploitWeakNode && weakNodeRevealed ? 'stabilization' : null;
    state = engine.interruptFunction(
      state,
      InterruptFunctionCommandV1(
        'rio',
        functionId: function.id,
        interrupt: weakNodeId == null ? _interruptShot : _arcaneInterference,
        weakNodeId: weakNodeId,
      ),
    );
    _updateOutcomeOrAdvance();
  }

  void saveReaction() {
    if (phase != AshfangRematchPhaseV1.reactionWindow) {
      throw StateError('No Reaction window');
    }
    _advanceUntilDecision();
  }

  void _advanceUntilDecision() {
    while (state.outcome == CombatOutcome.active) {
      if (state.activeTurn != null) {
        final actorId = state.activeTurn!.actorId;
        if (state.actor(actorId).side == BattleSide.player) {
          phase = AshfangRematchPhaseV1.playerTurn;
          return;
        }
        _runAshfangTurn();
        if (phase == AshfangRematchPhaseV1.reactionWindow) return;
        continue;
      }

      final next = engine.advance(state);
      state = next.state;

      if (next.event.type == TimelineEventType.characterTurn) {
        final actorId = next.event.actorId!;
        if (state.actor(actorId).side == BattleSide.player) {
          phase = AshfangRematchPhaseV1.playerTurn;
          return;
        }
        _runAshfangTurn();
        if (phase == AshfangRematchPhaseV1.reactionWindow) return;
      } else {
        state = engine.resolveTimelineEvent(state, next.event);
        _setTerminalPhaseIfNeeded();
      }
    }
    _setTerminalPhaseIfNeeded();
  }

  void _runAshfangTurn() {
    _ashfangTurns++;
    final ashfang = state.actor('ashfang');
    if (_ashfangTurns.isOdd && ashfang.mana >= _modifiedFireball.manaCost) {
      state = engine.beginFullChant(
        state,
        BeginFullChantCommandV1(
          'ashfang',
          spell: _modifiedFireball,
          targetId: 'hero',
        ),
      );
      if (state.actor('rio').reactionAvailable) {
        phase = AshfangRematchPhaseV1.reactionWindow;
      }
      return;
    }

    state = engine.useAction(
      state,
      UseActionCommandV1(
        'ashfang',
        targetId: 'hero',
        action: _ashfangClaw,
      ),
    );
    _setTerminalPhaseIfNeeded();
  }

  String _requirePlayerTurn() {
    if (phase != AshfangRematchPhaseV1.playerTurn) {
      throw StateError('A player Turn is not active');
    }
    final actorId = activePlayerId;
    if (actorId == null) throw StateError('A player Turn is not active');
    return actorId;
  }

  void _updateOutcomeOrAdvance() {
    _setTerminalPhaseIfNeeded();
    if (state.outcome == CombatOutcome.active) _advanceUntilDecision();
  }

  void _setTerminalPhaseIfNeeded() {
    if (state.outcome == CombatOutcome.victory) {
      phase = AshfangRematchPhaseV1.victory;
    } else if (state.outcome == CombatOutcome.defeat) {
      phase = AshfangRematchPhaseV1.defeat;
    }
  }

  static CombatantStateV1 _actor(
    String id,
    BattleSide side, {
    required int hp,
    required int mana,
    required int physical,
    required int magic,
  }) => CombatantStateV1(
    id: id,
    side: side,
    hp: hp,
    maxHp: hp,
    mana: mana,
    maxMana: mana,
    physicalResistance: physical,
    magicResistance: magic,
    controlResistance: 20,
    zone: BattleZone.mid,
  );

  static final _heroBasic = CombatActionDefinitionV1(
    id: 'hero-basic',
    kind: CombatActionKind.basicAttack,
    actionDelay: 100,
    manaRecovery: 10,
    rawDamage: 60,
    damageType: DamageType.physical,
    targetZones: const {BattleZone.mid},
  );
  static final _rioBasic = CombatActionDefinitionV1(
    id: 'rio-basic',
    kind: CombatActionKind.basicAttack,
    actionDelay: 90,
    manaRecovery: 10,
    rawDamage: 42,
    damageType: DamageType.physical,
    targetZones: const {BattleZone.mid},
  );
  static final _yumaBasic = CombatActionDefinitionV1(
    id: 'yuma-basic',
    kind: CombatActionKind.basicAttack,
    actionDelay: 95,
    manaRecovery: 10,
    rawDamage: 50,
    damageType: DamageType.physical,
    targetZones: const {BattleZone.mid},
  );
  static final _guard = CombatActionDefinitionV1(
    id: 'guard',
    kind: CombatActionKind.guard,
    actionDelay: 90,
    manaRecovery: 6,
    guardDamageReductionPercent: 35,
  );
  static final _fireballI = CombatActionDefinitionV1(
    id: 'fireball-i',
    kind: CombatActionKind.spell,
    actionDelay: 95,
    manaCost: 14,
    rawDamage: 90,
    damageType: DamageType.magic,
    targetZones: const {BattleZone.mid, BattleZone.far},
  );
  static final _fireballII = FullChantDefinitionV1(
    id: 'fireball-ii',
    manaCost: 24,
    rawDamage: 150,
    damageType: DamageType.magic,
    castTime: 90,
    stability: 48,
    recoveryDelay: 100,
    targetZones: const {BattleZone.mid, BattleZone.far},
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
  static final _interruptShot = InterruptDefinitionV1(
    id: 'interrupt-shot',
    interruptPower: 50,
    actionDelay: 80,
    stabilityDamage: 6,
  );
  static final _arcaneInterference = InterruptDefinitionV1(
    id: 'arcane-interference',
    interruptPower: 45,
    actionDelay: 80,
    stabilityDamage: 14,
  );
  static final _ashfangClaw = CombatActionDefinitionV1(
    id: 'ashfang-claw',
    kind: CombatActionKind.basicAttack,
    actionDelay: 90,
    rawDamage: 54,
    damageType: DamageType.physical,
    targetZones: const {BattleZone.mid},
  );
}
