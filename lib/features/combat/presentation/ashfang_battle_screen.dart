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
          appBar: AppBar(title: const Text('Ashfang Encounter')),
          body: snapshot.hasError
              ? Center(child: Text('Battle unavailable: ${snapshot.error}'))
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
        appBar: AppBar(title: const Text('Ashfang Encounter')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.science_outlined),
                title: const Text('Prototype encounter inputs'),
                subtitle: Text(
                  '${data.content['contentVersion']} · ${data.balanceStatus}',
                ),
              ),
            ),
            Text(
              'Round ${battle.state.round} · ${battle.state.outcome.name.toUpperCase()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _UnitCard(
              name: 'Astraea Hero',
              hp: player.hp,
              maxHp: player.maxHp,
              detail: 'Analysis modifier +${battle.analysisModifier}',
            ),
            _UnitCard(
              name: 'Ashfang Training Construct',
              hp: enemy.hp,
              maxHp: enemy.maxHp,
              detail: 'Function: DetectTarget → LockTarget → Pounce',
            ),
            const SizedBox(height: 12),
            Text(battle.feedback, style: Theme.of(context).textTheme.bodyLarge),
            if (battle.knowledge.revealedWeakNodeIds.contains('lock-target'))
              const Card(
                child: ListTile(
                  leading: Icon(Icons.visibility),
                  title: Text('Weak Node revealed: LockTarget'),
                  subtitle: Text(
                    'Interrupting this node cancels downstream Pounce.',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (battle.state.outcome.name == 'victory')
              const Card(
                child: ListTile(
                  leading: Icon(Icons.emoji_events),
                  title: Text('Training encounter complete'),
                  subtitle: Text(
                    'Your trained Analysis informed the Weak Node interaction. Battle state is saved.',
                  ),
                ),
              )
            else if (battle.state.outcome.name == 'defeat')
              const Card(
                child: ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text('Encounter ended'),
                  subtitle: Text(
                    'Ashfang overwhelmed your character. This result is saved.',
                  ),
                ),
              )
            else if (playerTurn) ...[
              FilledButton.icon(
                onPressed: !battle.state.unit('player').mainActionUsed
                    ? () => _act(data, battle.attack)
                    : null,
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Attack Ashfang'),
              ),
              FilledButton.tonal(
                onPressed: () => _act(data, battle.endPlayerTurn),
                child: const Text('End turn'),
              ),
            ] else if (isLock) ...[
              FilledButton.icon(
                onPressed:
                    !battle.knowledge.analysedNodeIds.contains('lock-target')
                    ? () => _act(data, battle.analyzeWeakNode)
                    : null,
                icon: const Icon(Icons.search),
                label: const Text('Analyze Weak Node'),
              ),
              FilledButton.icon(
                onPressed:
                    battle.knowledge.revealedWeakNodeIds.contains('lock-target')
                    ? () => _act(data, battle.interruptWeakNode)
                    : null,
                icon: const Icon(Icons.bolt),
                label: const Text('Interrupt LockTarget'),
              ),
              if (!battle.knowledge.revealedWeakNodeIds.contains('lock-target'))
                FilledButton.tonal(
                  onPressed: () => _act(data, battle.resolveEnemyAction),
                  child: const Text('Resolve Pounce'),
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
      subtitle: Text('$detail · HP $hp / $maxHp'),
      trailing: SizedBox(
        width: 70,
        child: LinearProgressIndicator(value: hp / maxHp),
      ),
    ),
  );
}

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
