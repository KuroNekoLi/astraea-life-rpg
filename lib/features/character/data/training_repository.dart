import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/persistence/app_database.dart';
import '../../life_quest/domain/life_domain.dart';
import '../domain/attribute.dart';
import '../domain/character_growth_policy.dart';
import '../domain/training.dart';

final class TrainingGoldenPathState {
  const TrainingGoldenPathState({
    required this.characterId,
    required this.balances,
    required this.effectiveAnalysis,
    required this.analysisPermanentGrowth,
    required this.analysisAptitude,
    required this.quote,
  });

  final String characterId;
  final Map<GrowthPotentialCategory, int> balances;
  final int effectiveAnalysis;
  final int analysisPermanentGrowth;
  final int analysisAptitude;
  final TrainingCostQuote quote;

  bool get canTrain =>
      (balances[GrowthPotentialCategory.cognitive] ?? 0) >= quote.potentialCost;
}

final class TrainingRepository {
  const TrainingRepository(this.database);

  final AppDatabase database;

  Future<CharacterGrowthPolicy> loadPolicy() async {
    final content =
        jsonDecode(
              await rootBundle.loadString(
                'assets/content/progression/character_growth_mvp_v1.json',
              ),
            )
            as Map<String, dynamic>;
    return CharacterGrowthPolicy.fromJson(content);
  }

  Future<TrainingGoldenPathState> goldenPathState() async {
    final policy = await loadPolicy();
    final character = await _activeCharacter();
    final characterId = character['id'] as String;
    final baseValues = _baseValues(character);
    final aptitude = _aptitude(character);
    final conversions = await _conversions();
    final projected = projectAttributeState(
      characterId: characterId,
      baseValues: baseValues,
      conversions: conversions,
    );
    final analysis = projected.values[AttributeType.analysis]!;
    final quote = policy.quoteTrainingCost(
      trainingDefinitionId: 'function-analysis-drill',
      aptitude: aptitude,
      currentPermanentGrowth: analysis.permanentGrowth,
    );
    return TrainingGoldenPathState(
      characterId: characterId,
      balances: await availablePotential(),
      effectiveAnalysis: analysis.effectiveValue,
      analysisPermanentGrowth: analysis.permanentGrowth,
      analysisAptitude: aptitude.ratings[AttributeType.analysis]!,
      quote: quote,
    );
  }

  Future<Map<GrowthPotentialCategory, int>> availablePotential() async {
    final rows = await database
        .customSelect(
          "SELECT payload FROM app_records WHERE kind = 'growthPotential'",
        )
        .get();
    final balances = {
      for (final category in GrowthPotentialCategory.values) category: 0,
    };
    for (final row in rows) {
      final payload =
          jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
      final category = GrowthPotentialCategory.values.firstWhere(
        (value) => value.name == payload['key'],
        orElse: () => throw FormatException(
          'Unknown Growth Potential category: ${payload['key']}',
        ),
      );
      final amount = payload['amount'];
      if (amount is! int || amount < 0) {
        throw const FormatException('Invalid Growth Potential balance');
      }
      balances[category] = amount;
    }
    return Map.unmodifiable(balances);
  }

  Future<TrainingResult> trainFunctionAnalysis({
    required String idempotencyKey,
  }) async {
    if (idempotencyKey.trim().isEmpty) {
      throw ArgumentError.value(idempotencyKey, 'idempotencyKey');
    }
    final policy = await loadPolicy();
    return database.transaction(() async {
      final character = await _activeCharacter();
      final characterId = character['id'] as String;
      final aptitude = _aptitude(character);
      final baseValues = _baseValues(character);
      final history = await _conversions();
      for (final prior in history) {
        if (prior.idempotencyKey == idempotencyKey) {
          return TrainingAlreadyConverted(prior);
        }
      }
      final projected = projectAttributeState(
        characterId: characterId,
        baseValues: baseValues,
        conversions: history,
      );
      final currentGrowth =
          projected.values[AttributeType.analysis]!.permanentGrowth;
      final quote = policy.quoteTrainingCost(
        trainingDefinitionId: 'function-analysis-drill',
        aptitude: aptitude,
        currentPermanentGrowth: currentGrowth,
      );
      final definition = TrainingDefinition(
        id: quote.trainingDefinitionId,
        contentVersion: quote.contentVersion,
        potentialCategory: quote.potentialCategory,
        potentialCost: quote.potentialCost,
        attributeDeltas: {quote.attribute: quote.attributeGrowth},
        efficiencyCurveId:
            '${quote.contentVersion}:tier-${quote.growthCostMultiplier}',
      );
      final now = DateTime.now();
      final proposed = TrainingConversion(
        id: 'training-$idempotencyKey',
        userId: 'local-player',
        characterId: characterId,
        trainingDefinitionId: definition.id,
        trainingContentVersion: definition.contentVersion,
        potentialCategory: definition.potentialCategory,
        amountSpent: definition.potentialCost,
        attributeDeltas: definition.attributeDeltas,
        idempotencyKey: idempotencyKey,
        createdAt: now,
      );
      final available =
          (await availablePotential())[definition.potentialCategory] ?? 0;
      final result = const TrainingEngine().convert(
        history: history,
        proposed: proposed,
        definition: definition,
        availablePotential: available,
      );
      if (result is TrainingConverted) {
        await database.putRecord(
          id: result.conversion.id,
          kind: 'trainingConversion',
          payload: jsonEncode(_conversionPayload(result.conversion)),
          createdAt: now,
        );
        await rebuildGrowthPotentialProjections(now);
      }
      return result;
    });
  }

  Future<int> effectiveAnalysis() async =>
      (await goldenPathState()).effectiveAnalysis;

  Future<void> rebuildGrowthPotentialProjections(DateTime now) async {
    final totals = {
      for (final category in GrowthPotentialCategory.values) category: 0,
    };
    final grantRows = await database.recordsOf('rewardGrant');
    for (final row in grantRows) {
      final grant =
          jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
      for (final raw in grant['rewards'] as List<dynamic>) {
        final reward = raw as Map<String, dynamic>;
        if (reward['type'] != 'growthPotential') continue;
        final category = GrowthPotentialCategory.values.byName(
          reward['category'] as String,
        );
        totals.update(category, (value) => value + reward['amount'] as int);
      }
    }
    for (final conversion in await _conversions()) {
      totals.update(
        conversion.potentialCategory,
        (value) => value - conversion.amountSpent,
      );
    }
    for (final entry in totals.entries) {
      if (entry.value < 0) {
        throw StateError(
          'Training conversions exceed granted ${entry.key.name} Potential',
        );
      }
      await database.customStatement(
        'INSERT OR REPLACE INTO app_records (id, kind, payload, created_at) VALUES (?, ?, ?, ?)',
        [
          'growthPotential-${entry.key.name}',
          'growthPotential',
          jsonEncode({
            'key': entry.key.name,
            'amount': entry.value,
            'projectionVersion': 2,
          }),
          now.millisecondsSinceEpoch ~/ 1000,
        ],
      );
    }
  }

  Future<Map<String, dynamic>> _activeCharacter() async {
    final rows = await database
        .customSelect(
          "SELECT payload FROM app_records WHERE kind = 'character' AND id = 'active-character'",
        )
        .get();
    if (rows.isEmpty) {
      throw StateError('Create a character before Training.');
    }
    return jsonDecode(rows.single.read<String>('payload'))
        as Map<String, dynamic>;
  }

  AptitudeProfile _aptitude(Map<String, dynamic> character) {
    final data = character['aptitude'];
    if (data is! Map<String, dynamic>) {
      throw StateError(
        'Active character has no persisted character-growth-mvp-1 Aptitude profile.',
      );
    }
    final ratings = data['ratings'] as Map<String, dynamic>;
    return AptitudeProfile(
      contentVersion: data['contentVersion'] as String,
      ratings: {
        for (final attribute in AttributeType.values)
          attribute: ratings[attribute.name] as int,
      },
      fateRerollUsed: data['fateRerollUsed'] as bool? ?? false,
    );
  }

  Map<AttributeType, AttributeValue> _baseValues(
    Map<String, dynamic> character,
  ) {
    final attributes = character['attributes'] as Map<String, dynamic>;
    return {
      for (final attribute in AttributeType.values)
        attribute: AttributeValue(baseValue: attributes[attribute.name] as int),
    };
  }

  Future<List<TrainingConversion>> _conversions() async {
    final rows = await database.recordsOf('trainingConversion');
    return rows
        .map((row) {
          final data =
              jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
          final deltas = data['attributeDeltas'] as Map<String, dynamic>;
          return TrainingConversion(
            id: data['id'] as String,
            userId: data['userId'] as String,
            characterId: data['characterId'] as String,
            trainingDefinitionId: data['trainingDefinitionId'] as String,
            trainingContentVersion: data['trainingContentVersion'] as String,
            potentialCategory: GrowthPotentialCategory.values.byName(
              data['potentialCategory'] as String,
            ),
            amountSpent: data['amountSpent'] as int,
            attributeDeltas: {
              for (final entry in deltas.entries)
                AttributeType.values.byName(entry.key): entry.value as int,
            },
            idempotencyKey: data['idempotencyKey'] as String,
            createdAt: DateTime.parse(data['createdAt'] as String),
            schemaVersion: data['schemaVersion'] as int? ?? 1,
          );
        })
        .toList(growable: false);
  }

  Map<String, dynamic> _conversionPayload(TrainingConversion conversion) => {
    'id': conversion.id,
    'userId': conversion.userId,
    'characterId': conversion.characterId,
    'trainingDefinitionId': conversion.trainingDefinitionId,
    'trainingContentVersion': conversion.trainingContentVersion,
    'potentialCategory': conversion.potentialCategory.name,
    'amountSpent': conversion.amountSpent,
    'attributeDeltas': {
      for (final entry in conversion.attributeDeltas.entries)
        entry.key.name: entry.value,
    },
    'idempotencyKey': conversion.idempotencyKey,
    'createdAt': conversion.createdAt.toIso8601String(),
    'schemaVersion': conversion.schemaVersion,
  };
}
