import 'function_graph.dart';

enum FunctionRuntimeStatus { active, resolved, interrupted }

final class FunctionWeakNodeRule {
  FunctionWeakNodeRule({
    required this.id,
    required this.nodeId,
    required Set<String> downstreamNodeIds,
  }) : downstreamNodeIds = Set.unmodifiable(downstreamNodeIds) {
    if (id.trim().isEmpty ||
        nodeId.trim().isEmpty ||
        this.downstreamNodeIds.isEmpty) {
      throw ArgumentError('Weak Node rule must identify downstream behavior');
    }
  }
  final String id;
  final String nodeId;
  final Set<String> downstreamNodeIds;
}

final class ActiveFunctionState {
  ActiveFunctionState({
    required this.id,
    required this.graphId,
    required this.activeNodeId,
    required this.status,
    Iterable<String> completedNodeIds = const [],
    Iterable<String> cancelledNodeIds = const [],
  }) : completedNodeIds = Set.unmodifiable(completedNodeIds),
       cancelledNodeIds = Set.unmodifiable(cancelledNodeIds) {
    if (id.trim().isEmpty ||
        graphId.trim().isEmpty ||
        activeNodeId.trim().isEmpty) {
      throw ArgumentError('Active Function identifiers are required');
    }
  }
  final String id;
  final String graphId;
  final String activeNodeId;
  final FunctionRuntimeStatus status;
  final Set<String> completedNodeIds;
  final Set<String> cancelledNodeIds;
}

final class FunctionKnowledge {
  FunctionKnowledge({
    Iterable<String> analysedNodeIds = const [],
    Iterable<String> revealedWeakNodeIds = const [],
  }) : analysedNodeIds = Set.unmodifiable(analysedNodeIds),
       revealedWeakNodeIds = Set.unmodifiable(revealedWeakNodeIds);
  final Set<String> analysedNodeIds;
  final Set<String> revealedWeakNodeIds;
}

final class FunctionAnalysisResult {
  const FunctionAnalysisResult(this.knowledge, this.revealed);
  final FunctionKnowledge knowledge;
  final bool revealed;
}

final class FunctionInterruptResult {
  const FunctionInterruptResult(this.function, this.success);
  final ActiveFunctionState function;
  final bool success;
}

/// Keeps analysis visibility separate from graph content and runtime execution.
final class FunctionRuntimeEngine {
  const FunctionRuntimeEngine();

  FunctionAnalysisResult analyze({
    required FunctionGraph graph,
    required String nodeId,
    required int analysisRoll,
    required int analysisModifier,
    required int difficulty,
    required FunctionKnowledge knowledge,
    required Iterable<FunctionWeakNodeRule> rules,
  }) {
    if (!graph.nodes.any((candidate) => candidate.id == nodeId)) {
      throw ArgumentError.value(nodeId, 'nodeId');
    }
    if (difficulty < 0) {
      throw ArgumentError.value(difficulty, 'difficulty');
    }
    final isWeakNode = rules.any(
      (rule) =>
          rule.nodeId == nodeId && graph.weakNodeRuleIds.contains(rule.id),
    );
    final revealed =
        analysisRoll + analysisModifier >= difficulty && isWeakNode;
    return FunctionAnalysisResult(
      FunctionKnowledge(
        analysedNodeIds: {...knowledge.analysedNodeIds, nodeId},
        revealedWeakNodeIds: revealed
            ? {...knowledge.revealedWeakNodeIds, nodeId}
            : knowledge.revealedWeakNodeIds,
      ),
      revealed,
    );
  }

  FunctionInterruptResult interrupt({
    required FunctionGraph graph,
    required ActiveFunctionState function,
    required String nodeId,
    required FunctionKnowledge knowledge,
    required Iterable<FunctionWeakNodeRule> rules,
  }) {
    final node = graph.nodes.firstWhere((candidate) => candidate.id == nodeId);
    if (function.status != FunctionRuntimeStatus.active ||
        function.activeNodeId != nodeId ||
        !node.interruptible ||
        !knowledge.revealedWeakNodeIds.contains(nodeId)) {
      return FunctionInterruptResult(function, false);
    }
    final rule = rules
        .where((candidate) => candidate.nodeId == nodeId)
        .firstOrNull;
    if (rule == null || !graph.weakNodeRuleIds.contains(rule.id)) {
      return FunctionInterruptResult(function, false);
    }
    return FunctionInterruptResult(
      ActiveFunctionState(
        id: function.id,
        graphId: function.graphId,
        activeNodeId: nodeId,
        status: FunctionRuntimeStatus.interrupted,
        completedNodeIds: function.completedNodeIds,
        cancelledNodeIds: {
          ...function.cancelledNodeIds,
          ...rule.downstreamNodeIds,
        },
      ),
      true,
    );
  }

  ActiveFunctionState resolveNext({
    required FunctionGraph graph,
    required ActiveFunctionState function,
    required String nextNodeId,
  }) {
    if (!graph.nodes.any((node) => node.id == function.activeNodeId)) {
      throw StateError('Active node does not exist in the graph');
    }
    final edgeExists = graph.edges.any(
      (edge) =>
          edge.fromNodeId == function.activeNodeId &&
          edge.toNodeId == nextNodeId,
    );
    if (!edgeExists) {
      throw StateError('Next node must follow an authored graph edge');
    }
    final cancelled = function.cancelledNodeIds.contains(nextNodeId);
    if (function.status != FunctionRuntimeStatus.active || cancelled) {
      return ActiveFunctionState(
        id: function.id,
        graphId: function.graphId,
        activeNodeId: nextNodeId,
        status: FunctionRuntimeStatus.interrupted,
        completedNodeIds: function.completedNodeIds,
        cancelledNodeIds: function.cancelledNodeIds,
      );
    }
    final isOutput = graph.outputNodeIds.contains(nextNodeId);
    return ActiveFunctionState(
      id: function.id,
      graphId: function.graphId,
      activeNodeId: nextNodeId,
      status: isOutput
          ? FunctionRuntimeStatus.resolved
          : FunctionRuntimeStatus.active,
      completedNodeIds: {...function.completedNodeIds, function.activeNodeId},
      cancelledNodeIds: function.cancelledNodeIds,
    );
  }
}
