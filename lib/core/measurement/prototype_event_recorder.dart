import 'dart:convert';

import 'package:drift/drift.dart';

import '../persistence/app_database.dart';

enum PrototypeEventType {
  characterCreated,
  lifeQuestCompleted,
  rewardGranted,
  trainingConverted,
  deckConfirmed,
  functionRevealed,
  weakNodeExploited,
  battleCompleted,
  prototypeCompleted,
}

/// Local-only, opt-in milestone recorder. It has no network/export path.
final class PrototypeEventRecorder {
  PrototypeEventRecorder(this.database, this.clock);

  final AppDatabase database;
  final DateTime Function() clock;

  static const allowedProperties = <String>{
    'lifeDomain',
    'questTemplateId',
    'trainingDefinitionId',
    'spellId',
    'encounterId',
    'result',
    'contentVersion',
  };

  Future<void> setOptIn(bool enabled) async {
    final now = clock();
    await database.transaction(() async {
      await database.customStatement('DELETE FROM app_records WHERE id = ?', [
        'pilot-measurement-consent',
      ]);
      await database.putRecord(
        id: 'pilot-measurement-consent',
        kind: 'setting',
        payload: jsonEncode({'enabled': enabled, 'schemaVersion': 1}),
        createdAt: now,
      );
      if (!enabled) {
        await database.customStatement(
          "DELETE FROM app_records WHERE kind = 'pilotEvent'",
        );
      }
    });
  }

  Future<bool> get optedIn async {
    final rows = await database.recordsOf('setting');
    final consent = rows
        .where((row) => row.read<String>('id') == 'pilot-measurement-consent')
        .firstOrNull;
    if (consent == null) return false;
    return (jsonDecode(consent.read<String>('payload'))
            as Map<String, dynamic>)['enabled'] ==
        true;
  }

  bool _validProperty(String key, Object? value) => switch (key) {
    'lifeDomain' =>
      value is String &&
          const {'fitness', 'learning', 'languages'}.contains(value),
    'questTemplateId' =>
      value is String &&
          const {
            'fitness.walk10',
            'fitness.exercise20',
            'learning.read20',
            'learning.study20',
            'languages.practice15',
          }.contains(value),
    'trainingDefinitionId' =>
      value is String &&
          const {
            'function-analysis-drill',
            'complexity-exercise',
            'reaction-drill',
            'precision-movement',
            'intent-encoding-drill',
            'mana-control-drill',
          }.contains(value),
    'spellId' =>
      value is String &&
          const {
            'arc_bolt',
            'focused_shot',
            'energy_burst',
            'barrier',
            'deflect',
            'step_shift',
            'weak_node_scan',
            'mana_stabilize',
            'interrupt_pulse',
          }.contains(value),
    'encounterId' =>
      value is String &&
          const {'ashfang-training', 'arcane-sentry-training'}.contains(value),
    'result' =>
      value is String &&
          const {
            'success',
            'failed',
            'victory',
            'defeat',
            'interrupted',
          }.contains(value),
    'contentVersion' =>
      value is String && RegExp(r'^[a-zA-Z0-9._-]{1,80}$').hasMatch(value),
    _ => false,
  };

  Future<void> record({
    required PrototypeEventType type,
    required Map<String, Object?> properties,
    String? idempotencyKey,
  }) async {
    if (!await optedIn) return;
    if (!allowedProperties.containsAll(properties.keys)) {
      throw ArgumentError(
        'Prototype event includes a property outside the privacy allowlist',
      );
    }
    for (final entry in properties.entries) {
      if (!_validProperty(entry.key, entry.value)) {
        throw ArgumentError(
          'Prototype event property is outside its approved value set',
        );
      }
    }
    if (idempotencyKey != null &&
        !RegExp(r'^[a-zA-Z0-9._-]{1,120}$').hasMatch(idempotencyKey)) {
      throw ArgumentError(
        'Event idempotency key must be a bounded opaque identifier',
      );
    }
    final now = clock();
    final eventId = idempotencyKey == null
        ? 'pilot-event-${now.microsecondsSinceEpoch}'
        : 'pilot-event-${type.name}-$idempotencyKey';
    final existing = await database
        .customSelect(
          'SELECT id FROM app_records WHERE id = ?',
          variables: [Variable.withString(eventId)],
        )
        .get();
    if (existing.isNotEmpty) return;
    await database.putRecord(
      id: eventId,
      kind: 'pilotEvent',
      payload: jsonEncode({
        'eventName': type.name,
        'occurredAt': now.toUtc().toIso8601String(),
        'schemaVersion': 1,
        'properties': properties,
      }),
      createdAt: now,
    );
  }
}
