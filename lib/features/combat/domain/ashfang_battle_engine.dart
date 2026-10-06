import '../../../game_engine/combat/combat_engine.dart';
import '../../../game_engine/function_graph/function_graph.dart';
import '../../../game_engine/function_graph/function_runtime.dart';
import '../../../game_engine/rng/rng.dart';

/// First playable adapter: all numeric inputs come from versioned encounter content.
final class AshfangBattleEngine {
  AshfangBattleEngine({
    required this.graph,
    required this.rules,
    required this.analysisDifficulty,
    required this.analysisModifier,
    required this.seed,
    required int playerHp,
    required int playerMana,
    required int playerAttackBonus,
    required int playerDefense,
    required int playerProcessing,
    required this.playerDamage,
    required this.playerCriticalDamage,
    required int enemyHp,
    required int enemyMana,
    required int enemyAttackBonus,
    required int enemyDefense,
    required int enemyProcessing,
    required this.enemyDamage,
    required this.enemyCriticalDamage,
  }) : state = CombatState(
         combatants: [
           CombatantState(
             id: 'player',
             side: CombatSide.player,
             hp: playerHp,
             maxHp: playerHp,
             mana: playerMana,
             maxMana: playerMana,
             attackBonus: playerAttackBonus,
             defense: playerDefense,
             processingModifier: playerProcessing,
             zone: 'near',
             reactionAvailable: true,
           ),
           CombatantState(
             id: 'ashfang',
             side: CombatSide.enemy,
             hp: enemyHp,
             maxHp: enemyHp,
             mana: enemyMana,
             maxMana: enemyMana,
             attackBonus: enemyAttackBonus,
             defense: enemyDefense,
             processingModifier: enemyProcessing,
             zone: 'near',
             reactionAvailable: true,
           ),
         ],
         initiativeOrder: const ['player', 'ashfang'],
         activeCombatantId: 'player',
         round: 1,
         revision: 0,
         seed: seed,
       );

  final FunctionGraph graph;
  final List<FunctionWeakNodeRule> rules;
  final int analysisDifficulty;
  final int analysisModifier;
  final int seed;
  final int playerDamage;
  final int playerCriticalDamage;
  final int enemyDamage;
  final int enemyCriticalDamage;
  final CombatEngine _combat = const CombatEngine();
  final FunctionRuntimeEngine _functionRuntime = const FunctionRuntimeEngine();
  CombatState state;
  FunctionKnowledge knowledge = FunctionKnowledge();
  ActiveFunctionState? activeFunction;
  int analysisAttempts = 0;
  bool enemyActionPending = false;
  String feedback = 'Ashfang is guarding the training arena.';

  void attack() {
    final result = _combat.resolve(
      state,
      AttackCommand(
        'player',
        targetId: 'ashfang',
        damage: playerDamage,
        criticalDamage: playerCriticalDamage,
      ),
    );
    state = result.state;
    feedback = state.outcome == CombatOutcome.victory
        ? 'Ashfang is defeated. The Weak Node changed the battle.'
        : 'Attack resolved through the combat engine.';
  }

  void endPlayerTurn() {
    state = _combat.resolve(state, EndTurnCommand('player')).state;
    _startEnemyFunction();
  }

  void _startEnemyFunction() {
    enemyActionPending = true;
    activeFunction = ActiveFunctionState(
      id: 'ashfang-function-${state.round}',
      graphId: graph.id,
      activeNodeId: 'detect-target',
      status: FunctionRuntimeStatus.active,
    );
    activeFunction = _functionRuntime.resolveNext(
      graph: graph,
      function: activeFunction!,
      nextNodeId: 'lock-target',
    );
    feedback = 'Ashfang begins DetectTarget → LockTarget → Pounce.';
  }

  bool analyzeWeakNode() {
    if (!enemyActionPending || activeFunction?.activeNodeId != 'lock-target') {
      return false;
    }
    final rng = SeededRng(seed + state.round * 7919 + analysisAttempts++);
    final result = _functionRuntime.analyze(
      graph: graph,
      nodeId: 'lock-target',
      analysisRoll: rng.nextInt(20) + 1,
      analysisModifier: analysisModifier,
      difficulty: analysisDifficulty,
      knowledge: knowledge,
      rules: rules,
    );
    knowledge = result.knowledge;
    feedback = result.revealed
        ? 'Weak Node found. Interrupt LockTarget to cancel Pounce.'
        : 'Weak Node not revealed this time. Ashfang resolves Pounce.';
    if (!result.revealed) resolveEnemyAction();
    return result.revealed;
  }

  bool interruptWeakNode() {
    final function = activeFunction;
    if (function == null) return false;
    final result = _functionRuntime.interrupt(
      graph: graph,
      function: function,
      nodeId: 'lock-target',
      knowledge: knowledge,
      rules: rules,
    );
    if (!result.success) return false;
    activeFunction = result.function;
    feedback = 'LockTarget interrupted. Downstream Pounce was cancelled.';
    _finishEnemyTurn();
    return true;
  }

  void resolveEnemyAction() {
    if (!enemyActionPending) return;
    final result = _combat.resolve(
      state,
      AttackCommand(
        'ashfang',
        targetId: 'player',
        damage: enemyDamage,
        criticalDamage: enemyCriticalDamage,
      ),
    );
    state = result.state;
    feedback = 'Pounce resolved through the combat engine.';
    _finishEnemyTurn();
  }

  void _finishEnemyTurn() {
    enemyActionPending = false;
    if (state.outcome == CombatOutcome.active) {
      state = _combat.resolve(state, EndTurnCommand('ashfang')).state;
    }
  }
}
