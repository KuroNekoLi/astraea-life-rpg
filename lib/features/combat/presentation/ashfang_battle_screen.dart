import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../game_engine/function_graph/function_graph.dart';
import '../../../game_engine/function_graph/function_runtime.dart';
import '../../character/data/training_repository.dart';
import '../data/ashfang_battle_repository.dart';
import '../domain/ashfang_battle_engine.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class AshfangBattleScreen extends ConsumerStatefulWidget {
  const AshfangBattleScreen({super.key});
  @override
  ConsumerState<AshfangBattleScreen> createState() =>
      _AshfangBattleScreenState();
}

class _AshfangBattleScreenState extends ConsumerState<AshfangBattleScreen> {
  late Future<_BattleData> _data;
  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_BattleData> _load() async {
    final json =
        jsonDecode(
              await rootBundle.loadString(
                'assets/content/encounters/ashfang_training_v2.json',
              ),
            )
            as Map<String, dynamic>;
    final graphData = json['functionGraph'] as Map<String, dynamic>;
    final nodes = (graphData['nodes'] as List<dynamic>).map((raw) {
      final node = raw as Map<String, dynamic>;
      return FunctionNode(
        id: node['id'] as String,
        type: node['type'] as String,
        parameters: const {},
        complexity: 1,
        interruptible: node['interruptible'] as bool,
        reversible: false,
      );
    }).toList();
    final edges = (graphData['edges'] as List<dynamic>).map((raw) {
      final edge = raw as List<dynamic>;
      return FunctionEdge(
        fromNodeId: edge[0] as String,
        toNodeId: edge[1] as String,
      );
    }).toList();
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
      entryNodeIds: const {'detect-target'},
      outputNodeIds: const {'pounce'},
      weakNodeRuleIds: rules.map((item) => item.id).toSet(),
      schemaVersion: 1,
      contentVersion: json['contentVersion'] as String,
    );
    final db = await ref.read(databaseProvider.future);
    final repo = AshfangBattleRepository(db);
    final inputs = json['combatInputs'] as Map<String, dynamic>;
    final player = inputs['player'] as Map<String, dynamic>;
    final enemy = inputs['enemy'] as Map<String, dynamic>;
    final session = AshfangBattleEngine(
      graph: graph,
      rules: rules,
      analysisDifficulty: json['analysisDifficulty'] as int,
      analysisModifier: (await TrainingRepository(db).effectiveAnalysis() - 8)
          .clamp(0, 99)
          .toInt(),
      seed: inputs['seed'] as int,
      playerHp: player['hp'] as int,
      playerMana: player['mana'] as int,
      playerAttackBonus: player['attackBonus'] as int,
      playerDefense: player['defense'] as int,
      playerProcessing: player['processingModifier'] as int,
      playerDamage: player['attackDamage'] as int,
      playerCriticalDamage: player['criticalDamage'] as int,
      enemyHp: enemy['hp'] as int,
      enemyMana: enemy['mana'] as int,
      enemyAttackBonus: enemy['attackBonus'] as int,
      enemyDefense: enemy['defense'] as int,
      enemyProcessing: enemy['processingModifier'] as int,
      enemyDamage: enemy['pounceDamage'] as int,
      enemyCriticalDamage: enemy['criticalDamage'] as int,
    );
    final saved = await repo.load();
    if (saved != null && saved['contentVersion'] == json['contentVersion']) {
      AshfangBattleRepository.restore(session, saved);
    }
    return _BattleData(json, inputs['status'] as String, session, repo);
  }

  Future<void> _act(_BattleData data, VoidCallback action) async {
    setState(action);
    await data.repository.save(
      data.session,
      DateTime.now(),
      contentVersion: data.content['contentVersion'] as String,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<_BattleData>(
    future: _data,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.ashfangEncounter)),
          body: snapshot.hasError
              ? Center(child: Text(context.l10n.battleUnavailable('${snapshot.error}')))
              : const Center(child: CircularProgressIndicator()),
        );
      }
      final data = snapshot.requireData;
      final battle = data.session;
      final player = battle.state.unit('player');
      final enemy = battle.state.unit('ashfang');
      final playerTurn =
          battle.state.activeCombatantId == 'player' &&
          battle.state.outcome.name == 'active';
      final isLock =
          battle.state.outcome.name == 'active' &&
          battle.activeFunction?.activeNodeId == 'lock-target';
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.ashfangEncounter)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: Text(context.l10n.prototypeEncounterInputs),
                subtitle: Text(
                  context.l10n.contentVersionStatus(
                    data.content['contentVersion'] as String,
                    localizedBalanceStatus(context.l10n, data.balanceStatus),
                  ),
                ),
              ),
            ),
            Text(
              context.l10n.battleRoundStatus(
                battle.state.round,
                _outcomeLabel(context, battle.state.outcome.name),
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _UnitCard(
              name: context.l10n.battleHeroName,
              hp: player.hp,
              maxHp: player.maxHp,
              detail: context.l10n.analysisModifierLabel(battle.analysisModifier),
            ),
            _UnitCard(
              name: context.l10n.ashfangTrainingConstruct,
              hp: enemy.hp,
              maxHp: enemy.maxHp,
              detail: context.l10n.functionPathLabel,
            ),
            const SizedBox(height: 12),
            Text(_feedbackLabel(context, battle.feedbackCode), style: Theme.of(context).textTheme.bodyLarge),
            if (battle.knowledge.revealedWeakNodeIds.contains('lock-target'))
              Card(
                child: ListTile(
                  leading: const Icon(Icons.visibility),
                  title: Text(context.l10n.weakNodeRevealed),
                  subtitle: Text(context.l10n.weakNodeCancelsPounce),
                ),
              ),
            const SizedBox(height: 12),
            if (battle.state.outcome.name == 'victory')
              Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text(context.l10n.trainingEncounterComplete),
                  subtitle: Text(context.l10n.trainingAnalysisSaved),
                ),
              )
            else if (battle.state.outcome.name == 'defeat')
              Card(
                child: ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: Text(context.l10n.encounterEnded),
                  subtitle: Text(context.l10n.ashfangOverwhelmed),
                ),
              )
            else if (playerTurn) ...[
              FilledButton.icon(
                onPressed: !battle.state.unit('player').mainActionUsed
                    ? () => _act(data, battle.attack)
                    : null,
                icon: const Icon(Icons.gps_fixed),
                label: Text(context.l10n.attackAshfang),
              ),
              FilledButton.tonal(
                onPressed: () => _act(data, battle.endPlayerTurn),
                child: Text(context.l10n.endTurn),
              ),
            ] else if (isLock) ...[
              FilledButton.icon(
                onPressed:
                    !battle.knowledge.analysedNodeIds.contains('lock-target')
                    ? () => _act(data, battle.analyzeWeakNode)
                    : null,
                icon: const Icon(Icons.search),
                label: Text(context.l10n.analyzeWeakNode),
              ),
              FilledButton.icon(
                onPressed:
                    battle.knowledge.revealedWeakNodeIds.contains('lock-target')
                    ? () => _act(data, battle.interruptWeakNode)
                    : null,
                icon: const Icon(Icons.bolt),
                label: Text(context.l10n.interruptLockTarget),
              ),
              if (!battle.knowledge.revealedWeakNodeIds.contains('lock-target'))
                FilledButton.tonal(
                  onPressed: () => _act(data, battle.resolveEnemyAction),
                  child: Text(context.l10n.resolvePounce),
                ),
            ],
          ],
        ),
      );
    },
  );
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.name,
    required this.hp,
    required this.maxHp,
    required this.detail,
  });
  final String name;
  final int hp;
  final int maxHp;
  final String detail;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(name),
      subtitle: Text(context.l10n.unitHpDetail(detail, hp, maxHp)),
      trailing: SizedBox(
        width: 70,
        child: LinearProgressIndicator(value: hp / maxHp),
      ),
    ),
  );
}

String _outcomeLabel(BuildContext context, String outcome) => switch (outcome) {
  'victory' => context.l10n.battleOutcomeVictory,
  'defeat' => context.l10n.battleOutcomeDefeat,
  _ => context.l10n.battleOutcomeActive,
};

String _feedbackLabel(
  BuildContext context,
  AshfangFeedbackCode code,
) => switch (code) {
  AshfangFeedbackCode.guarding => context.l10n.feedbackGuarding,
  AshfangFeedbackCode.ashfangDefeated => context.l10n.feedbackAshfangDefeated,
  AshfangFeedbackCode.attackResolved => context.l10n.feedbackAttackResolved,
  AshfangFeedbackCode.enemyFunctionBegins =>
    context.l10n.feedbackEnemyFunctionBegins,
  AshfangFeedbackCode.weakNodeFound =>
    context.l10n.feedbackWeakNodeFoundLegacy,
  AshfangFeedbackCode.weakNodeMiss => context.l10n.feedbackWeakNodeMissLegacy,
  AshfangFeedbackCode.interrupted => context.l10n.feedbackInterruptedLegacy,
  AshfangFeedbackCode.pounceResolved => context.l10n.feedbackPounceResolved,
};

final class _BattleData {
  const _BattleData(
    this.content,
    this.balanceStatus,
    this.session,
    this.repository,
  );
  final Map<String, dynamic> content;
  final String balanceStatus;
  final AshfangBattleEngine session;
  final AshfangBattleRepository repository;
}
