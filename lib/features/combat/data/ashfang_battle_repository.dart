import 'dart:convert';

import '../../../core/persistence/app_database.dart';
import '../../../game_engine/combat/combat_engine.dart';
import '../../../game_engine/function_graph/function_runtime.dart';
import '../domain/ashfang_battle_engine.dart';

final class AshfangBattleRepository {
  const AshfangBattleRepository(this.database);
  final AppDatabase database;
  static const battleId = 'ashfang-training';

  Future<void> save(
    AshfangBattleEngine engine,
    DateTime now, {
    required String contentVersion,
  }) async {
    final state = engine.state;
    final payload = jsonEncode({
      'schemaVersion': 1,
      'contentVersion': contentVersion,
      'round': state.round,
      'revision': state.revision,
      'activeCombatantId': state.activeCombatantId,
      'outcome': state.outcome.name,
      'seed': state.seed,
      'rngState': state.rngState,
      'initiativeOrder': state.initiativeOrder,
      'eventLog': state.eventLog,
      'enemyActionPending': engine.enemyActionPending,
      'analysisAttempts': engine.analysisAttempts,
      'feedbackCode': engine.feedbackCode.name,
      'analysedNodeIds': engine.knowledge.analysedNodeIds.toList(),
      'revealedWeakNodeIds': engine.knowledge.revealedWeakNodeIds.toList(),
      'activeFunction': engine.activeFunction == null
          ? null
          : {
              'id': engine.activeFunction!.id,
              'graphId': engine.activeFunction!.graphId,
              'activeNodeId': engine.activeFunction!.activeNodeId,
              'status': engine.activeFunction!.status.name,
              'completed': engine.activeFunction!.completedNodeIds.toList(),
              'cancelled': engine.activeFunction!.cancelledNodeIds.toList(),
            },
      'combatants': [
        for (final unit in state.combatants)
          {
            'id': unit.id,
            'side': unit.side.name,
            'hp': unit.hp,
            'maxHp': unit.maxHp,
            'mana': unit.mana,
            'maxMana': unit.maxMana,
            'attackBonus': unit.attackBonus,
            'defense': unit.defense,
            'processingModifier': unit.processingModifier,
            'zone': unit.zone,
            'reactionAvailable': unit.reactionAvailable,
            'condition': unit.condition.name,
            'mainActionUsed': unit.mainActionUsed,
          },
      ],
    });
    await database.customStatement(
      'INSERT OR REPLACE INTO app_records (id, kind, payload, created_at) VALUES (?, ?, ?, ?)',
      [
        'battle-$battleId',
        'ashfangBattle',
        payload,
        now.millisecondsSinceEpoch ~/ 1000,
      ],
    );
  }

  Future<Map<String, dynamic>?> load() async {
    final rows = await database.recordsOf('ashfangBattle');
    return rows.isEmpty
        ? null
        : jsonDecode(rows.last.read<String>('payload')) as Map<String, dynamic>;
  }

  static void restore(AshfangBattleEngine engine, Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const FormatException('Unsupported Ashfang battle save');
    }
    engine.state = CombatState(
      combatants: (json['combatants'] as List<dynamic>).map((raw) {
        final unit = raw as Map<String, dynamic>;
        return CombatantState(
          id: unit['id'] as String,
          side: CombatSide.values.byName(unit['side'] as String),
          hp: unit['hp'] as int,
          maxHp: unit['maxHp'] as int,
          mana: unit['mana'] as int,
          maxMana: unit['maxMana'] as int,
          attackBonus: unit['attackBonus'] as int,
          defense: unit['defense'] as int,
          processingModifier: unit['processingModifier'] as int,
          zone: unit['zone'] as String,
          reactionAvailable: unit['reactionAvailable'] as bool,
          condition: CombatantCondition.values.byName(
            unit['condition'] as String,
          ),
          mainActionUsed: unit['mainActionUsed'] as bool,
        );
      }),
      initiativeOrder: (json['initiativeOrder'] as List<dynamic>)
          .cast<String>(),
      activeCombatantId: json['activeCombatantId'] as String,
      round: json['round'] as int,
      revision: json['revision'] as int,
      outcome: CombatOutcome.values.byName(json['outcome'] as String),
      seed: json['seed'] as int,
      rngState: json['rngState'] as int,
      eventLog: (json['eventLog'] as List<dynamic>).cast<String>(),
    );
    engine.enemyActionPending = json['enemyActionPending'] as bool;
    engine.analysisAttempts = json['analysisAttempts'] as int;
    engine.feedbackCode = AshfangFeedbackCode.values.byName(
      json['feedbackCode'] as String? ?? 'guarding',
    );
    engine.knowledge = FunctionKnowledge(
      analysedNodeIds: (json['analysedNodeIds'] as List<dynamic>)
          .cast<String>(),
      revealedWeakNodeIds: (json['revealedWeakNodeIds'] as List<dynamic>)
          .cast<String>(),
    );
    final function = json['activeFunction'] as Map<String, dynamic>?;
    engine.activeFunction = function == null
        ? null
        : ActiveFunctionState(
            id: function['id'] as String,
            graphId: function['graphId'] as String,
            activeNodeId: function['activeNodeId'] as String,
            status: FunctionRuntimeStatus.values.byName(
              function['status'] as String,
            ),
            completedNodeIds: (function['completed'] as List<dynamic>)
                .cast<String>(),
            cancelledNodeIds: (function['cancelled'] as List<dynamic>)
                .cast<String>(),
          );
  }
}
