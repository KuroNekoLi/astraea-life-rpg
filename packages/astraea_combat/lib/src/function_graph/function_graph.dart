/// Content value objects; graph execution is implemented in the combat milestones.
enum CastingMethod { fullChant, chantless }

final class FunctionNode {
  FunctionNode({
    required this.id,
    required this.type,
    required Map<String, Object?> parameters,
    required this.complexity,
    required this.interruptible,
    required this.reversible,
    Set<String> tags = const {},
  }) : parameters = Map.unmodifiable(parameters),
       tags = Set.unmodifiable(tags) {
    if (id.trim().isEmpty || type.trim().isEmpty || complexity < 0) {
      throw ArgumentError('Invalid Function node');
    }
  }
  final String id;
  final String type;
  final Map<String, Object?> parameters;
  final int complexity;
  final bool interruptible;
  final bool reversible;
  final Set<String> tags;
}

final class FunctionEdge {
  const FunctionEdge({required this.fromNodeId, required this.toNodeId});
  final String fromNodeId;
  final String toNodeId;
}

final class FunctionGraph {
  FunctionGraph({
    required this.id,
    required Iterable<FunctionNode> nodes,
    required Iterable<FunctionEdge> edges,
    required Set<String> entryNodeIds,
    required Set<String> outputNodeIds,
    required Set<String> weakNodeRuleIds,
    required this.schemaVersion,
    required this.contentVersion,
  }) : nodes = List.unmodifiable(nodes),
       edges = List.unmodifiable(edges),
       entryNodeIds = Set.unmodifiable(entryNodeIds),
       outputNodeIds = Set.unmodifiable(outputNodeIds),
       weakNodeRuleIds = Set.unmodifiable(weakNodeRuleIds) {
    if (id.trim().isEmpty ||
        contentVersion.trim().isEmpty ||
        schemaVersion < 1) {
      throw ArgumentError('Invalid FunctionGraph identity/version');
    }
    final ids = this.nodes.map((node) => node.id).toList();
    if (ids.toSet().length != ids.length || ids.isEmpty) {
      throw ArgumentError('Node IDs must be unique');
    }
    final known = ids.toSet();
    if (!known.containsAll(this.entryNodeIds) ||
        !known.containsAll(this.outputNodeIds) ||
        this.entryNodeIds.isEmpty ||
        this.outputNodeIds.isEmpty ||
        this.edges.any(
          (edge) =>
              !known.contains(edge.fromNodeId) ||
              !known.contains(edge.toNodeId),
        )) {
      throw ArgumentError(
        'Graph entries, outputs and edges must reference known nodes',
      );
    }
  }
  final String id;
  final List<FunctionNode> nodes;
  final List<FunctionEdge> edges;
  final Set<String> entryNodeIds;
  final Set<String> outputNodeIds;
  final Set<String> weakNodeRuleIds;
  final int schemaVersion;
  final String contentVersion;
}

final class SpellDefinition {
  SpellDefinition({
    required this.id,
    required this.nameKey,
    required this.graphId,
    required this.category,
    required Set<CastingMethod> castingMethods,
    required this.baseManaCost,
    required this.complexity,
    required this.schemaVersion,
    required this.contentVersion,
    Map<String, Object?> requirements = const {},
    Set<String> tags = const {},
    this.cooldownRule,
  }) : castingMethods = Set.unmodifiable(castingMethods),
       requirements = Map.unmodifiable(requirements),
       tags = Set.unmodifiable(tags) {
    if (id.trim().isEmpty ||
        nameKey.trim().isEmpty ||
        graphId.trim().isEmpty ||
        contentVersion.trim().isEmpty ||
        category.trim().isEmpty ||
        baseManaCost < 0 ||
        complexity < 0 ||
        schemaVersion < 1 ||
        this.castingMethods.isEmpty) {
      throw ArgumentError('Invalid SpellDefinition');
    }
  }
  final String id;
  final String nameKey;
  final String graphId;
  final String category;
  final Set<CastingMethod> castingMethods;
  final int baseManaCost;
  final int complexity;
  final Map<String, Object?> requirements;
  final String? cooldownRule;
  final Set<String> tags;
  final int schemaVersion;
  final String contentVersion;
}

final class PreparedDeck {
  PreparedDeck({
    required this.id,
    required this.characterId,
    required Iterable<String> spellIds,
    required this.revision,
    required this.updatedAt,
    this.slotLimit = 6,
    this.schemaVersion = 1,
  }) : spellIds = List.unmodifiable(spellIds) {
    if (id.trim().isEmpty ||
        characterId.trim().isEmpty ||
        revision < 0 ||
        schemaVersion < 1) {
      throw ArgumentError('Invalid PreparedDeck identity/revision');
    }
    if (slotLimit != 6 ||
        this.spellIds.length > slotLimit ||
        this.spellIds.toSet().length != this.spellIds.length) {
      throw ArgumentError(
        'MVP decks have six slots, no more than six unique spells',
      );
    }
  }
  final String id;
  final String characterId;
  final int slotLimit;
  final List<String> spellIds;
  final int revision;
  final int schemaVersion;
  final DateTime updatedAt;
}
