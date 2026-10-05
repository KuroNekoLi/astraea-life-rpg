import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../../core/persistence/app_database.dart';

final class QuestTemplateData {
  const QuestTemplateData({
    required this.id,
    required this.domain,
    required this.title,
    required this.durationMinutes,
    required this.activityGroup,
    required this.difficulty,
  });

  final String id;
  final String domain;
  final String title;
  final int durationMinutes;
  final String activityGroup;
  final String difficulty;

  factory QuestTemplateData.fromJson(Map<String, dynamic> json) =>
      QuestTemplateData(
        id: json['id'] as String,
        domain: json['domain'] as String,
        title: json['title'] as String,
        durationMinutes: json['durationMinutes'] as int,
        activityGroup: json['group'] as String,
        difficulty: json['difficulty'] as String,
      );
}

final class RewardQuote {
  const RewardQuote({required this.xp, required this.potential});
  final int xp;
  final int potential;
}

final class LifeQuestRepository {
  LifeQuestRepository(this.database, this.clock);

  final AppDatabase database;
  final DateTime Function() clock;

  Future<Map<String, dynamic>> get catalog async =>
      (jsonDecode(
            await rootBundle.loadString('assets/content/quests/mvp_v1.json'),
          )
          as Map<String, dynamic>);

  Future<List<QuestTemplateData>> templates() async =>
      ((await catalog)['templates'] as List<dynamic>)
          .map(
            (item) => QuestTemplateData.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false);

  Future<List<Map<String, dynamic>>> quests() async => _records('quest');

  Future<void> addQuest(QuestTemplateData template) async {
    final now = clock();
    await database.putRecord(
      id: template.id,
      kind: 'quest',
      payload: jsonEncode({
        'id': template.id,
        'domain': template.domain,
        'title': template.title,
        'durationMinutes': template.durationMinutes,
        'activityGroup': template.activityGroup,
        'difficulty': template.difficulty,
        'status': 'active',
        'contentVersion': (await catalog)['contentVersion'],
        'createdAt': now.toIso8601String(),
      }),
      createdAt: now,
    );
  }

  Future<Map<String, dynamic>?> activeTimer() async {
    final rows = await _records('timer');
    return rows.isEmpty ? null : rows.last;
  }

  Future<void> startTimer(String questId) async {
    final now = clock();
    await database.transaction(() async {
      final rows = await _records('timer');
      if (rows.isNotEmpty && rows.last['status'] == 'running') return;
      await database.customStatement('DELETE FROM app_records WHERE id = ?', [
        'timer-active',
      ]);
      await database.putRecord(
        id: 'timer-active',
        kind: 'timer',
        payload: jsonEncode({
          'questId': questId,
          'startedAt': now.toIso8601String(),
          'status': 'running',
        }),
        createdAt: now,
      );
    });
  }

  Future<void> pauseTimer() async {
    final current = await activeTimer();
    if (current == null || current['status'] != 'running') return;
    final now = clock();
    current['status'] = 'paused';
    current['pausedAt'] = now.toIso8601String();
    await database.customStatement(
      'UPDATE app_records SET payload = ? WHERE id = ?',
      [jsonEncode(current), 'timer-active'],
    );
  }

  Future<void> resumeTimer() async {
    final current = await activeTimer();
    if (current == null || current['status'] != 'paused') return;
    final pausedAt = DateTime.parse(current.remove('pausedAt') as String);
    final startedAt = DateTime.parse(current['startedAt'] as String);
    current['startedAt'] = startedAt
        .add(clock().difference(pausedAt))
        .toIso8601String();
    current['status'] = 'running';
    await database.customStatement(
      'UPDATE app_records SET payload = ? WHERE id = ?',
      [jsonEncode(current), 'timer-active'],
    );
  }

  Future<RewardQuote> quote({
    required int durationMinutes,
    required bool timerEvidence,
    required String domain,
  }) async {
    // The versioned content asset is the single source for prototype balance.
    final data = await catalog;
    final anchors = data['durationAnchors'] as List<dynamic>;
    var previousMinute = 0;
    var previousFactor = 0;
    var factor = 55000;
    for (final raw in anchors) {
      final anchor = raw as List<dynamic>;
      final minute = anchor[0] as int;
      final value = anchor[1] as int;
      if (durationMinutes <= minute) {
        factor =
            previousFactor +
            (value - previousFactor) *
                (durationMinutes - previousMinute) ~/
                (minute - previousMinute);
        break;
      }
      previousMinute = minute;
      previousFactor = value;
    }
    final xp = 10 * factor * (timerEvidence ? 10500 : 10000) ~/ 100000000;
    final potentialFactor =
        (data['growthPotentialFactors'] as Map<String, dynamic>)[domain] as int;
    return RewardQuote(xp: xp, potential: xp * potentialFactor ~/ 10000);
  }

  Future<void> complete({
    required Map<String, dynamic> quest,
    required String completionId,
    required Duration duration,
    required bool timerEvidence,
    required bool confirmReward,
  }) async {
    final now = clock();
    if (completionId.trim().isEmpty) {
      throw ArgumentError.value(completionId, 'completionId');
    }
    final activityId = 'activity-$completionId';
    final catalogData = await catalog;
    final quote = await this.quote(
      durationMinutes: (duration.inSeconds / 60).round().clamp(1, 10080),
      timerEvidence: timerEvidence,
      domain: quest['domain'] as String,
    );
    await database.transaction(() async {
      final existing = await database
          .customSelect(
            'SELECT id FROM app_records WHERE id = ?',
            variables: [Variable.withString(activityId)],
          )
          .get();
      if (existing.isNotEmpty) return;
      await database.putRecord(
        id: activityId,
        kind: 'activity',
        payload: jsonEncode({
          'id': activityId,
          'questId': quest['id'],
          'domain': quest['domain'],
          'startedAt': now.subtract(duration).toIso8601String(),
          'completedAt': now.toIso8601String(),
          'normalizedDurationSeconds': duration.inSeconds,
          'schemaVersion': 1,
        }),
        createdAt: now,
      );
      await database.putRecord(
        id: 'evidence-$activityId',
        kind: 'evidence',
        payload: jsonEncode({
          'activityId': activityId,
          'level': timerEvidence ? 'lightweight' : 'selfReport',
          'type': timerEvidence ? 'timer' : 'selfReport',
          'privacy': 'private',
          'verificationVersion': 1,
        }),
        createdAt: now,
      );
      if (confirmReward) {
        final domain = quest['domain'] as String;
        await database.putRecord(
          id: 'grant-$activityId',
          kind: 'rewardGrant',
          payload: jsonEncode({
            'sourceId': activityId,
            'idempotencyKey': 'life-activity:$activityId',
            'formulaVersion': catalogData['formulaVersion'],
            'rewards': [
              {'type': 'lifeXp', 'domain': domain, 'amount': quote.xp},
              {
                'type': 'growthPotential',
                'category': _potential(domain),
                'amount': quote.potential,
              },
            ],
          }),
          createdAt: now,
        );
        await _rebuildProjections(now);
      }
      await database.customStatement('DELETE FROM app_records WHERE id = ?', [
        'timer-active',
      ]);
    });
  }

  Future<void> _rebuildProjections(DateTime now) async {
    final grants = await _records('rewardGrant');
    final xp = <String, int>{};
    final gp = <String, int>{};
    for (final grant in grants) {
      for (final reward in grant['rewards'] as List<dynamic>) {
        final item = reward as Map<String, dynamic>;
        final target = item['type'] == 'lifeXp' ? xp : gp;
        final key = item['domain'] as String? ?? item['category'] as String;
        target.update(
          key,
          (value) => value + item['amount'] as int,
          ifAbsent: () => item['amount'] as int,
        );
      }
    }
    for (final entry in xp.entries) {
      await _putProjection('lifeProgress', entry.key, entry.value, now);
    }
    for (final entry in gp.entries) {
      await _putProjection('growthPotential', entry.key, entry.value, now);
    }
  }

  Future<void> _putProjection(
    String kind,
    String key,
    int amount,
    DateTime now,
  ) async {
    final id = '$kind-$key';
    await database.customStatement(
      'INSERT OR REPLACE INTO app_records (id, kind, payload, created_at) VALUES (?, ?, ?, ?)',
      [
        id,
        kind,
        jsonEncode({'key': key, 'amount': amount, 'projectionVersion': 1}),
        now.millisecondsSinceEpoch ~/ 1000,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _records(String kind) async {
    final rows = await database
        .customSelect(
          'SELECT id, payload FROM app_records WHERE kind = ? ORDER BY created_at',
          variables: [Variable.withString(kind)],
        )
        .get();
    return rows
        .map(
          (row) => {
            'id': row.read<String>('id'),
            ...jsonDecode(row.read<String>('payload')) as Map<String, dynamic>,
          },
        )
        .toList();
  }

  String _potential(String domain) => switch (domain) {
    'fitness' => 'physical',
    'learning' => 'cognitive',
    'languages' => 'communication',
    _ => throw ArgumentError.value(domain, 'domain'),
  };
}
