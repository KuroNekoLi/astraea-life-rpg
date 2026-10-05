import 'dart:convert';

import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/data/training_repository.dart';
import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/character/domain/training.dart';
import 'package:astraea_life_rpg/features/life_quest/domain/life_domain.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Training spends Potential once and rebuilds Analysis projection', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database.putRecord(
      id: 'active-character',
      kind: 'character',
      payload: jsonEncode({
        'id': 'hero',
        'name': 'Hero',
        'weaponId': 'standard_staff',
        'attributes': {
          for (final attribute in AttributeType.values) attribute.name: 12,
        },
        'aptitude': {
          'contentVersion': 'character-growth-mvp-1',
          'ratings': {
            for (final attribute in AttributeType.values) attribute.name: 3,
          },
          'fateRerollUsed': false,
          'rngSeed': 10,
          'rngState': 20,
        },
        'schemaVersion': 2,
      }),
      createdAt: DateTime.utc(2026),
    );
    await database.putRecord(
      id: 'grant-activity-1',
      kind: 'rewardGrant',
      payload: jsonEncode({
        'sourceId': 'activity-1',
        'idempotencyKey': 'life-activity:activity-1',
        'formulaVersion': 'mvp-prototype-1',
        'rewards': [
          {'type': 'lifeXp', 'domain': 'learning', 'amount': 18},
          {'type': 'growthPotential', 'category': 'cognitive', 'amount': 18},
        ],
      }),
      createdAt: DateTime.utc(2026),
    );
    await database.putRecord(
      id: 'growthPotential-cognitive',
      kind: 'growthPotential',
      payload: jsonEncode({
        'key': 'cognitive',
        'amount': 18,
        'projectionVersion': 1,
      }),
      createdAt: DateTime.utc(2026),
    );

    final repository = TrainingRepository(database);
    final before = await repository.goldenPathState();
    expect(before.effectiveAnalysis, 12);
    expect(before.analysisAptitude, 3);
    expect(before.quote.potentialCost, 18);
    expect(before.canTrain, isTrue);

    final created = await repository.trainFunctionAnalysis(
      idempotencyKey: 'train:hero:analysis:1',
    );
    expect(created, isA<TrainingConverted>());

    final after = await repository.goldenPathState();
    expect(after.effectiveAnalysis, 13);
    expect(after.analysisPermanentGrowth, 1);
    expect(after.balances[GrowthPotentialCategory.cognitive], 0);

    final retry = await repository.trainFunctionAnalysis(
      idempotencyKey: 'train:hero:analysis:1',
    );
    expect(retry, isA<TrainingAlreadyConverted>());
    expect((await database.recordsOf('trainingConversion')).length, 1);

    final character = jsonDecode(
      (await database.recordsOf('character')).single.read<String>('payload'),
    ) as Map<String, dynamic>;
    expect(
      (character['attributes'] as Map<String, dynamic>)['analysis'],
      12,
    );
  });
}
