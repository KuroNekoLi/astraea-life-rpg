import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../game_engine/function_graph/function_graph.dart';
import '../../../game_engine/function_graph/function_runtime.dart';
import '../../../game_engine/rng/rng.dart';

class FunctionLabScreen extends StatefulWidget {
  const FunctionLabScreen({super.key});

  @override
  State<FunctionLabScreen> createState() => _FunctionLabScreenState();
}

class _FunctionLabScreenState extends State<FunctionLabScreen> {
  late Future<_AshfangData> _data;
  FunctionKnowledge _knowledge = FunctionKnowledge();
  ActiveFunctionState? _function;
  String _feedback =
      'Ashfang is preparing Pounce. Inspect the Function before it resolves.';
  int _analysisAttempt = 0;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_AshfangData> _load() async {
    final content =
        jsonDecode(
              await rootBundle.loadString(
                'assets/content/encounters/ashfang_training_v1.json',
              ),
            )
            as Map<String, dynamic>;
    final graphData = content['functionGraph'] as Map<String, dynamic>;
    final nodes = (graphData['nodes'] as List<dynamic>).map((raw) {
      final node = raw as Map<String, dynamic>;
      return FunctionNode(
        id: node['id'] as String,
        type: node['type'] as String,
        parameters: {},
        complexity: 1,
        interruptible: node['interruptible'] as bool,
        reversible: false,
      );
    }).toList();
    final edges = (graphData['edges'] as List<dynamic>)
        .map(
          (raw) => FunctionEdge(
            fromNodeId: (raw as List<dynamic>)[0] as String,
            toNodeId: raw[1] as String,
          ),
        )
        .toList();
    final rawRules = graphData['weakNodeRules'] as List<dynamic>;
    final rules = rawRules.map((raw) {
      final item = raw as Map<String, dynamic>;
      return FunctionWeakNodeRule(
        id: item['id'] as String,
        nodeId: item['nodeId'] as String,
        downstreamNodeIds: (item['cancelNodes'] as List<dynamic>)
            .cast<String>()
            .toSet(),
      );
    }).toList();
    final graph = FunctionGraph(
      id: graphData['id'] as String,
      nodes: nodes,
      edges: edges,
      entryNodeIds: {'detect-target'},
      outputNodeIds: {'pounce'},
      weakNodeRuleIds: rules.map((rule) => rule.id).toSet(),
      schemaVersion: 1,
      contentVersion: content['contentVersion'] as String,
    );
    return _AshfangData(
      content['enemy'] as String,
      graph,
      rules,
      content['balanceStatus'] as String,
      content['analysisDifficulty'] as int,
      content['tutorialSeed'] as int,
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<_AshfangData>(
    future: _data,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text('Could not load Function: ${snapshot.error}'),
          ),
        );
      }
      if (!snapshot.hasData) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final data = snapshot.requireData;
      _function ??= ActiveFunctionState(
        id: 'ashfang-function-1',
        graphId: data.graph.id,
        activeNodeId: 'detect-target',
        status: FunctionRuntimeStatus.active,
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Function Analysis')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(data.enemy, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Enemy Function: DetectTarget → LockTarget → Pounce'),
            const SizedBox(height: 16),
            for (final node in data.graph.nodes)
              Semantics(
                label: '${node.type}, ${_nodeState(node.id, data)}',
                child: Card(
                  color: _knowledge.revealedWeakNodeIds.contains(node.id)
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : null,
                  child: ListTile(
                    leading: Icon(
                      _knowledge.revealedWeakNodeIds.contains(node.id)
                          ? Icons.visibility
                          : Icons.circle_outlined,
                    ),
                    title: Text(node.type),
                    subtitle: Text(_nodeState(node.id, data)),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(_feedback, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            if (_function!.activeNodeId == 'lock-target' &&
                !_knowledge.revealedWeakNodeIds.contains('lock-target'))
              FilledButton(
                onPressed: () => _analyze(data),
                child: const Text('Analyze active Function'),
              ),
            if (_function!.activeNodeId == 'lock-target' &&
                _knowledge.revealedWeakNodeIds.contains('lock-target'))
              FilledButton(
                onPressed: () => _interrupt(data),
                child: const Text('Interrupt LockTarget'),
              ),
            if (_function!.activeNodeId == 'detect-target')
              FilledButton(
                onPressed: () => _advanceToLock(data),
                child: const Text('Observe next Function node'),
              ),
            if (_function!.status != FunctionRuntimeStatus.active)
              OutlinedButton(
                onPressed: () => setState(() {
                  _function = ActiveFunctionState(
                    id: 'ashfang-function-retry',
                    graphId: data.graph.id,
                    activeNodeId: 'lock-target',
                    status: FunctionRuntimeStatus.active,
                  );
                  _knowledge = FunctionKnowledge();
                  _feedback = 'Ashfang is preparing Pounce again.';
                }),
                child: const Text('Reset tutorial pattern'),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Content balance: ${data.balanceStatus}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    },
  );

  String _nodeState(String id, _AshfangData data) {
    if (_function?.cancelledNodeIds.contains(id) ?? false) {
      return 'Cancelled by Weak Node interruption';
    }
    if (_knowledge.revealedWeakNodeIds.contains(id)) {
      return 'Weak Node revealed · interruptible';
    }
    if (_function?.activeNodeId == id) {
      return 'Active Function';
    }
    return 'Awaiting execution';
  }

  void _advanceToLock(_AshfangData data) => setState(() {
    _function = const FunctionRuntimeEngine().resolveNext(
      graph: data.graph,
      function: _function!,
      nextNodeId: 'lock-target',
    );
    _feedback =
        'LockTarget is active. It is interruptible, but its role is not yet analyzed.';
  });

  void _analyze(_AshfangData data) => setState(() {
    final result = const FunctionRuntimeEngine().analyze(
      graph: data.graph,
      nodeId: 'lock-target',
      analysisRoll:
          SeededRng(data.tutorialSeed + _analysisAttempt++).nextInt(20) + 1,
      analysisModifier: 0,
      difficulty: data.analysisDifficulty,
      knowledge: _knowledge,
      rules: data.rules,
    );
    _knowledge = result.knowledge;
    _feedback = result.revealed
        ? 'Weak Node found: interrupting LockTarget cancels downstream Pounce.'
        : 'Analysis did not reveal the node. Try again.';
  });

  void _interrupt(_AshfangData data) => setState(() {
    final result = const FunctionRuntimeEngine().interrupt(
      graph: data.graph,
      function: _function!,
      nodeId: 'lock-target',
      knowledge: _knowledge,
      rules: data.rules,
    );
    _function = result.function;
    _feedback = result.success
        ? 'LockTarget interrupted. Pounce is cancelled.'
        : 'This Function could not be interrupted.';
  });
}

final class _AshfangData {
  const _AshfangData(
    this.enemy,
    this.graph,
    this.rules,
    this.balanceStatus,
    this.analysisDifficulty,
    this.tutorialSeed,
  );
  final String enemy;
  final FunctionGraph graph;
  final List<FunctionWeakNodeRule> rules;
  final String balanceStatus;
  final int analysisDifficulty;
  final int tutorialSeed;
}
