import 'package:astraea_life_rpg/game_engine/function_graph/function_graph.dart';
import 'package:astraea_life_rpg/game_engine/function_graph/function_runtime.dart';
import 'package:test/test.dart';

final graph = FunctionGraph(
  id: 'ashfang.pounce.v1',
  nodes: [
    FunctionNode(
      id: 'detect-target',
      type: 'DetectTarget',
      parameters: {},
      complexity: 1,
      interruptible: false,
      reversible: false,
    ),
    FunctionNode(
      id: 'lock-target',
      type: 'LockTarget',
      parameters: {},
      complexity: 1,
      interruptible: true,
      reversible: false,
    ),
    FunctionNode(
      id: 'pounce',
      type: 'Pounce',
      parameters: {},
      complexity: 2,
      interruptible: false,
      reversible: false,
    ),
  ],
  edges: const [
    FunctionEdge(fromNodeId: 'detect-target', toNodeId: 'lock-target'),
    FunctionEdge(fromNodeId: 'lock-target', toNodeId: 'pounce'),
  ],
  entryNodeIds: {'detect-target'},
  outputNodeIds: {'pounce'},
  weakNodeRuleIds: {'weak-lock-target'},
  schemaVersion: 1,
  contentVersion: 'ashfang-training-1',
);
final rules = [
  FunctionWeakNodeRule(
    id: 'weak-lock-target',
    nodeId: 'lock-target',
    downstreamNodeIds: {'pounce'},
  ),
];

void main() {
  test(
    'analysing LockTarget reveals the Weak Node and interrupt cancels Pounce',
    () {
      const engine = FunctionRuntimeEngine();
      final knowledge = engine
          .analyze(
            graph: graph,
            nodeId: 'lock-target',
            analysisRoll: 15,
            analysisModifier: 1,
            difficulty: 12,
            knowledge: FunctionKnowledge(),
            rules: rules,
          )
          .knowledge;
      expect(knowledge.revealedWeakNodeIds, contains('lock-target'));
      final active = ActiveFunctionState(
        id: 'ashfang-pounce',
        graphId: graph.id,
        activeNodeId: 'lock-target',
        status: FunctionRuntimeStatus.active,
      );
      final interrupted = engine.interrupt(
        graph: graph,
        function: active,
        nodeId: 'lock-target',
        knowledge: knowledge,
        rules: rules,
      );
      expect(interrupted.success, isTrue);
      expect(interrupted.function.cancelledNodeIds, contains('pounce'));
      expect(
        engine
            .resolveNext(
              graph: graph,
              function: interrupted.function,
              nextNodeId: 'pounce',
            )
            .status,
        FunctionRuntimeStatus.interrupted,
      );
    },
  );

  test('unknown Weak Node cannot be interrupted before analysis', () {
    final result = const FunctionRuntimeEngine().interrupt(
      graph: graph,
      function: ActiveFunctionState(
        id: 'f',
        graphId: graph.id,
        activeNodeId: 'lock-target',
        status: FunctionRuntimeStatus.active,
      ),
      nodeId: 'lock-target',
      knowledge: FunctionKnowledge(),
      rules: rules,
    );
    expect(result.success, isFalse);
    expect(result.function.status, FunctionRuntimeStatus.active);
  });
}
