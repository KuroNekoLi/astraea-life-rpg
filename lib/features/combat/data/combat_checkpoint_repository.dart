import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/persistence/app_database.dart';
import '../../../game_engine/combat/combat_engine.dart';

final class CombatCheckpointRepository {
  const CombatCheckpointRepository(this.database);
  final AppDatabase database;

  Future<void> save(
    CombatState state, {
    required String battleId,
    required DateTime savedAt,
  }) async {
    if (battleId.trim().isEmpty) {
      throw ArgumentError.value(battleId, 'battleId');
    }
    final payload = jsonEncode({
      'schemaVersion': 1,
      'round': state.round,
      'revision': state.revision,
      'activeCombatantId': state.activeCombatantId,
      'outcome': state.outcome.name,
      'seed': state.seed,
      'rngState': state.rngState,
      'initiativeOrder': state.initiativeOrder,
      'eventLog': state.eventLog,
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
        'battle-$battleId-${state.revision.toString().padLeft(10, '0')}',
        'battleCheckpoint',
        payload,
        savedAt.millisecondsSinceEpoch ~/ 1000,
      ],
    );
  }

  Future<CombatState?> latest({required String battleId}) async {
    final row = await database
        .customSelect(
          "SELECT payload FROM app_records WHERE kind = 'battleCheckpoint' AND substr(id, 1, length(?)) = ? ORDER BY created_at DESC, id DESC LIMIT 1",
          variables: [
            Variable.withString('battle-$battleId-'),
            Variable.withString('battle-$battleId-'),
          ],
        )
        .getSingleOrNull();
    if (row == null) return null;
    final json =
        jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
    if (json['schemaVersion'] != 1) {
      throw FormatException('Unsupported combat checkpoint schema');
    }
    return CombatState(
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
  }
}
