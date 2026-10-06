import 'package:astraea_combat/astraea_combat.dart';
import 'package:test/test.dart';

final class _FixedRng implements Rng {
  _FixedRng(this.roll);
  final int roll;

  @override
  int nextInt(int max) => roll;
}

CombatState _battle() => CombatState(
  combatants: [
    CombatantState(
      id: 'hero',
      side: CombatSide.player,
      hp: 20,
      maxHp: 20,
      mana: 8,
      maxMana: 8,
      attackBonus: 4,
      defense: 12,
      processingModifier: 2,
      zone: 'near',
      reactionAvailable: true,
    ),
    CombatantState(
      id: 'enemy',
      side: CombatSide.enemy,
      hp: 10,
      maxHp: 10,
      mana: 0,
      maxMana: 0,
      attackBonus: 2,
      defense: 10,
      processingModifier: 1,
      zone: 'near',
      reactionAvailable: true,
    ),
  ],
  initiativeOrder: const ['hero', 'enemy'],
  activeCombatantId: 'hero',
  round: 1,
  revision: 0,
);

void main() {
  group('public pure Dart combat API', () {
    test('command resolution returns state and presentation-ready events', () {
      final result = const CombatEngine().resolve(
        _battle(),
        const AttackCommand(
          'hero',
          targetId: 'enemy',
          damage: 3,
          criticalDamage: 6,
        ),
        _FixedRng(19),
      );

      expect(result.state.unit('enemy').hp, 4);
      expect(result.state.unit('enemy').condition, CombatantCondition.active);
      expect(result.events.map((event) => event.type), contains('criticalHit'));
      expect(result.state.revision, 1);
    });

    test('seeded RNG replay produces the same combat resolution', () {
      CombatResolution resolve() => const CombatEngine().resolve(
        _battle(),
        const AttackCommand(
          'hero',
          targetId: 'enemy',
          damage: 3,
          criticalDamage: 6,
        ),
        SeededRng(81),
      );

      expect(resolve().state.eventLog, resolve().state.eventLog);
      expect(resolve().state.rngState, resolve().state.rngState);
    });

    test('Function Weak Node analysis and interruption use authored rules', () {
      final graph = FunctionGraph(
        id: 'test-function',
        nodes: [
          FunctionNode(
            id: 'lock',
            type: 'LockTarget',
            parameters: const {},
            complexity: 1,
            interruptible: true,
            reversible: false,
          ),
          FunctionNode(
            id: 'strike',
            type: 'Strike',
            parameters: const {},
            complexity: 1,
            interruptible: false,
            reversible: false,
          ),
        ],
        edges: const [FunctionEdge(fromNodeId: 'lock', toNodeId: 'strike')],
        entryNodeIds: const {'lock'},
        outputNodeIds: const {'strike'},
        weakNodeRuleIds: const {'weak-lock'},
        schemaVersion: 1,
        contentVersion: 'test-v1',
      );
      final rule = FunctionWeakNodeRule(
        id: 'weak-lock',
        nodeId: 'lock',
        downstreamNodeIds: const {'strike'},
      );
      const runtime = FunctionRuntimeEngine();
      final knowledge = runtime
          .analyze(
            graph: graph,
            nodeId: 'lock',
            analysisRoll: 12,
            analysisModifier: 0,
            difficulty: 12,
            knowledge: FunctionKnowledge(),
            rules: [rule],
          )
          .knowledge;
      final result = runtime.interrupt(
        graph: graph,
        function: ActiveFunctionState(
          id: 'active-function',
          graphId: graph.id,
          activeNodeId: 'lock',
          status: FunctionRuntimeStatus.active,
        ),
        nodeId: 'lock',
        knowledge: knowledge,
        rules: [rule],
      );

      expect(result.success, isTrue);
      expect(result.function.cancelledNodeIds, contains('strike'));
    });
  });
}
