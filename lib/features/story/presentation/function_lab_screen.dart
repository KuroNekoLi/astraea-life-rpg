import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../app/app_providers.dart';
import '../../../core/measurement/prototype_event_recorder.dart';
import '../../character/data/training_repository.dart';
import '../../../game_engine/function_graph/function_graph.dart';
import '../../../game_engine/function_graph/function_runtime.dart';
import '../../../game_engine/rng/rng.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class FunctionLabScreen extends ConsumerStatefulWidget {
  const FunctionLabScreen({super.key});

  @override
  ConsumerState<FunctionLabScreen> createState() => _FunctionLabScreenState();
}

class _FunctionLabScreenState extends ConsumerState<FunctionLabScreen> {
  late Future<_AshfangData> _data;
  FunctionKnowledge _knowledge = FunctionKnowledge();
  ActiveFunctionState? _function;
  String _feedbackCode = 'preparingPounce';
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
                'assets/content/encounters/ashfang_training_v2.json',
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
    var effectiveAnalysis = 8;
    try {
      final database = await ref.read(databaseProvider.future);
      effectiveAnalysis = await TrainingRepository(
        database,
      ).effectiveAnalysis();
    } catch (_) {
      // The standalone tutorial remains usable before character creation.
    }
    final analysisModifier = (effectiveAnalysis - 8).clamp(0, 99).toInt();
    return _AshfangData(
      content['enemy'] as String,
      graph,
      rules,
      content['balanceStatus'] as String,
      content['analysisDifficulty'] as int,
      content['tutorialSeed'] as int,
      effectiveAnalysis,
      analysisModifier,
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<_AshfangData>(
    future: _data,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text(context.l10n.couldNotLoadFunction('${snapshot.error}')),
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
        appBar: AppBar(title: Text(context.l10n.functionAnalysis)),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(context.l10n.ashfangTrainingConstruct, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(context.l10n.enemyFunctionPath),
            const SizedBox(height: 8),
            Text(
              context.l10n.characterAnalysisModifier(
                data.effectiveAnalysis,
                data.analysisModifier,
              ),
            ),
            const SizedBox(height: 16),
            for (final node in data.graph.nodes)
              Semantics(
                label: context.l10n.functionNodeSemantics(
                  localizedFunctionNodeType(context.l10n, node.type),
                  _nodeState(context, node.id),
                ),
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
                    title: Text(localizedFunctionNodeType(context.l10n, node.type)),
                    subtitle: Text(_nodeState(context, node.id)),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(_feedbackText(context), style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            if (_function!.activeNodeId == 'lock-target' &&
                !_knowledge.revealedWeakNodeIds.contains('lock-target'))
              FilledButton(
                onPressed: () => _analyze(data),
                child: Text(context.l10n.analyzeActiveFunction),
              ),
            if (_function!.activeNodeId == 'lock-target' &&
                _knowledge.revealedWeakNodeIds.contains('lock-target'))
              FilledButton(
                onPressed: () => _interrupt(data),
                child: Text(context.l10n.interruptLockTarget),
              ),
            if (_function!.activeNodeId == 'detect-target')
              FilledButton(
                onPressed: () => _advanceToLock(data),
                child: Text(context.l10n.observeNextFunctionNode),
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
                  _feedbackCode = 'preparingAgain';
                }),
                child: Text(context.l10n.resetTutorialPattern),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                context.l10n.contentBalance(
                  localizedBalanceStatus(context.l10n, data.balanceStatus),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    },
  );

  String _nodeState(BuildContext context, String id) {
    if (_function?.cancelledNodeIds.contains(id) ?? false) {
      return context.l10n.nodeStateCancelled;
    }
    if (_knowledge.revealedWeakNodeIds.contains(id)) {
      return context.l10n.nodeStateWeak;
    }
    if (_function?.activeNodeId == id) {
      return context.l10n.nodeStateActive;
    }
    return context.l10n.nodeStateAwaiting;
  }

  String _feedbackText(BuildContext context) => switch (_feedbackCode) {
    'preparingAgain' => context.l10n.feedbackPreparingAgain,
    'lockActive' => context.l10n.feedbackLockActive,
    'weakFound' => context.l10n.feedbackWeakFound,
    'analysisMiss' => context.l10n.feedbackAnalysisMiss,
    'interrupted' => context.l10n.feedbackInterrupted,
    'interruptFailed' => context.l10n.feedbackInterruptFailed,
    _ => context.l10n.feedbackPreparingPounce,
  };

  void _advanceToLock(_AshfangData data) => setState(() {
    _function = const FunctionRuntimeEngine().resolveNext(
      graph: data.graph,
      function: _function!,
      nextNodeId: 'lock-target',
    );
    _feedbackCode = 'lockActive';
  });

  void _analyze(_AshfangData data) {
    var revealed = false;
    setState(() {
      final result = const FunctionRuntimeEngine().analyze(
        graph: data.graph,
        nodeId: 'lock-target',
        analysisRoll:
            SeededRng(data.tutorialSeed + _analysisAttempt++).nextInt(20) + 1,
        analysisModifier: data.analysisModifier,
        difficulty: data.analysisDifficulty,
        knowledge: _knowledge,
        rules: data.rules,
      );
      _knowledge = result.knowledge;
      revealed = result.revealed;
      _feedbackCode = result.revealed ? 'weakFound' : 'analysisMiss';
    });
    if (revealed) {
      unawaited(
        _record(PrototypeEventType.functionRevealed, 'ashfang-lock-target'),
      );
    }
  }

  void _interrupt(_AshfangData data) {
    var exploited = false;
    setState(() {
      final result = const FunctionRuntimeEngine().interrupt(
        graph: data.graph,
        function: _function!,
        nodeId: 'lock-target',
        knowledge: _knowledge,
        rules: data.rules,
      );
      _function = result.function;
      exploited = result.success;
      _feedbackCode = result.success ? 'interrupted' : 'interruptFailed';
    });
    if (exploited) {
      unawaited(
        _record(PrototypeEventType.weakNodeExploited, 'ashfang-lock-target'),
      );
    }
  }

  Future<void> _record(PrototypeEventType type, String key) async {
    try {
      final database = await ref.read(databaseProvider.future);
      await PrototypeEventRecorder(database, DateTime.now).record(
        type: type,
        properties: {
          'encounterId': 'ashfang-training',
          'contentVersion': 'ashfang-training-1',
        },
        idempotencyKey: key,
      );
    } catch (_) {
      // Optional local measurement must not interrupt the tutorial.
    }
  }
}

final class _AshfangData {
  const _AshfangData(
    this.enemy,
    this.graph,
    this.rules,
    this.balanceStatus,
    this.analysisDifficulty,
    this.tutorialSeed,
    this.effectiveAnalysis,
    this.analysisModifier,
  );
  final String enemy;
  final FunctionGraph graph;
  final List<FunctionWeakNodeRule> rules;
  final String balanceStatus;
  final int analysisDifficulty;
  final int tutorialSeed;
  final int effectiveAnalysis;
  final int analysisModifier;
}
