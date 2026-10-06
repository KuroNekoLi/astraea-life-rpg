import 'package:astraea_life_rpg/features/combat/domain/ashfang_battle_engine.dart';
import 'package:astraea_life_rpg/features/combat/data/ashfang_battle_repository.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/game_engine/combat/combat_engine.dart';
import 'package:astraea_life_rpg/game_engine/function_graph/function_graph.dart';
import 'package:astraea_life_rpg/game_engine/function_graph/function_runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

void main() {
  test(
    'trained Analysis reveals LockTarget, interrupt cancels Pounce, and combat resolves',
    () {
      final graph = FunctionGraph(
        id: 'ashfang.pounce.v2',
        contentVersion: 'ashfang-training-2',
        schemaVersion: 1,
        entryNodeIds: const {'detect-target'},
        outputNodeIds: const {'pounce'},
        weakNodeRuleIds: const {'lock-target-weak-node'},
        nodes: [
          FunctionNode(
            id: 'detect-target',
            type: 'DetectTarget',
            parameters: const {},
            complexity: 1,
            interruptible: false,
            reversible: false,
          ),
          FunctionNode(
            id: 'lock-target',
            type: 'LockTarget',
            parameters: const {},
            complexity: 1,
            interruptible: true,
            reversible: false,
          ),
          FunctionNode(
            id: 'pounce',
            type: 'Pounce',
            parameters: const {},
            complexity: 1,
            interruptible: false,
            reversible: false,
          ),
        ],
        edges: const [
          FunctionEdge(fromNodeId: 'detect-target', toNodeId: 'lock-target'),
          FunctionEdge(fromNodeId: 'lock-target', toNodeId: 'pounce'),
        ],
      );
      final battle = AshfangBattleEngine(
        graph: graph,
        rules: [
          FunctionWeakNodeRule(
            id: 'lock-target-weak-node',
            nodeId: 'lock-target',
            downstreamNodeIds: {'pounce'},
          ),
        ],
        analysisDifficulty: 12,
        analysisModifier: 1,
        seed: 417,
        playerHp: 24,
        playerMana: 12,
        playerAttackBonus: 8,
        playerDefense: 12,
        playerProcessing: 2,
        playerDamage: 8,
        playerCriticalDamage: 12,
        enemyHp: 16,
        enemyMana: 0,
        enemyAttackBonus: 6,
        enemyDefense: 12,
        enemyProcessing: 0,
        enemyDamage: 5,
        enemyCriticalDamage: 8,
      );
      battle.attack();
      battle.endPlayerTurn();
      expect(battle.activeFunction?.activeNodeId, 'lock-target');
      expect(battle.analyzeWeakNode(), isTrue);
      expect(battle.interruptWeakNode(), isTrue);
      expect(battle.activeFunction?.cancelledNodeIds, contains('pounce'));
      expect(battle.state.activeCombatantId, 'player');
      battle.attack();
      expect(battle.state.outcome, CombatOutcome.victory);
    },
  );

  test(
    'battle checkpoint restores combat turn and revealed Function knowledge',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final graph = _graph();
      final battle = _battle(graph);
      battle.endPlayerTurn();
      expect(battle.analyzeWeakNode(), isTrue);
      final repo = AshfangBattleRepository(db);
      await repo.save(
        battle,
        DateTime.utc(2026),
        contentVersion: 'ashfang-training-2',
      );
      final restored = _battle(graph);
      AshfangBattleRepository.restore(restored, (await repo.load())!);
      expect(restored.state.activeCombatantId, 'ashfang');
      expect(restored.knowledge.revealedWeakNodeIds, contains('lock-target'));
      expect(restored.interruptWeakNode(), isTrue);
      expect(restored.state.activeCombatantId, 'player');
    },
  );
}

FunctionGraph _graph() => FunctionGraph(
  id: 'ashfang.pounce.v2',
  contentVersion: 'ashfang-training-2',
  schemaVersion: 1,
  entryNodeIds: const {'detect-target'},
  outputNodeIds: const {'pounce'},
  weakNodeRuleIds: const {'lock-target-weak-node'},
  nodes: [
    FunctionNode(
      id: 'detect-target',
      type: 'DetectTarget',
      parameters: const {},
      complexity: 1,
      interruptible: false,
      reversible: false,
    ),
    FunctionNode(
      id: 'lock-target',
      type: 'LockTarget',
      parameters: const {},
      complexity: 1,
      interruptible: true,
      reversible: false,
    ),
    FunctionNode(
      id: 'pounce',
      type: 'Pounce',
      parameters: const {},
      complexity: 1,
      interruptible: false,
      reversible: false,
    ),
  ],
  edges: const [
    FunctionEdge(fromNodeId: 'detect-target', toNodeId: 'lock-target'),
    FunctionEdge(fromNodeId: 'lock-target', toNodeId: 'pounce'),
  ],
);

AshfangBattleEngine _battle(FunctionGraph graph) => AshfangBattleEngine(
  graph: graph,
  rules: [
    FunctionWeakNodeRule(
      id: 'lock-target-weak-node',
      nodeId: 'lock-target',
      downstreamNodeIds: {'pounce'},
    ),
  ],
  analysisDifficulty: 12,
  analysisModifier: 1,
  seed: 417,
  playerHp: 24,
  playerMana: 12,
  playerAttackBonus: 8,
  playerDefense: 12,
  playerProcessing: 2,
  playerDamage: 8,
  playerCriticalDamage: 12,
  enemyHp: 16,
  enemyMana: 0,
  enemyAttackBonus: 6,
  enemyDefense: 12,
  enemyProcessing: 0,
  enemyDamage: 5,
  enemyCriticalDamage: 8,
);
