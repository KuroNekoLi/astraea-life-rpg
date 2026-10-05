import 'package:astraea_life_rpg/game_engine/function_graph/function_graph.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);

  test(
    'FunctionGraph validates node references without imposing execution rules',
    () {
      final node = FunctionNode(
        id: 'gather',
        type: 'Gather',
        parameters: const {},
        complexity: 1,
        interruptible: true,
        reversible: false,
      );
      expect(
        () => FunctionGraph(
          id: 'graph',
          nodes: [node],
          edges: const [],
          entryNodeIds: {'missing'},
          outputNodeIds: {'gather'},
          weakNodeRuleIds: const {},
          schemaVersion: 1,
          contentVersion: 'v1',
        ),
        throwsArgumentError,
      );
      final graph = FunctionGraph(
        id: 'graph',
        nodes: [node],
        edges: const [],
        entryNodeIds: {'gather'},
        outputNodeIds: {'gather'},
        weakNodeRuleIds: const {},
        schemaVersion: 1,
        contentVersion: 'v1',
      );
      expect(graph.nodes.single.id, 'gather');
    },
  );

  test('PreparedDeck accepts no more than six unique spells', () {
    PreparedDeck(
      id: 'deck',
      characterId: 'hero',
      spellIds: ['a', 'b', 'c', 'd', 'e', 'f'],
      revision: 0,
      updatedAt: now,
    );
    expect(
      () => PreparedDeck(
        id: 'deck',
        characterId: 'hero',
        spellIds: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
        revision: 0,
        updatedAt: now,
      ),
      throwsArgumentError,
    );
    expect(
      () => PreparedDeck(
        id: 'deck',
        characterId: 'hero',
        spellIds: ['a', 'a'],
        revision: 0,
        updatedAt: now,
      ),
      throwsArgumentError,
    );
  });
}
