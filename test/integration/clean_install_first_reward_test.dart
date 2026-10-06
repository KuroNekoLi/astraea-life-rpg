import 'dart:convert';

import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/data/training_repository.dart';
import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/character/domain/training.dart';
import 'package:astraea_life_rpg/features/life_quest/data/life_quest_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'clean install first Walk reward is 10 Physical and cannot yet train',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime.utc(2026, 10, 6);
      await db.putRecord(
        id: 'active-character',
        kind: 'character',
        createdAt: now,
        payload: jsonEncode({
          'id': 'fresh-hero',
          'name': 'Hero',
          'weaponId': 'standard_staff',
          'attributes': {
            for (final value in AttributeType.values) value.name: 8,
          },
          'aptitude': {
            'contentVersion': 'character-growth-mvp-1',
            'ratings': {
              for (final value in AttributeType.values) value.name: 5,
            },
            'fateRerollUsed': false,
            'rngSeed': 1,
            'rngState': 2,
          },
          'schemaVersion': 2,
        }),
      );
      final quests = LifeQuestRepository(db, () => now);
      final walk = (await quests.templates()).firstWhere(
        (q) => q.id == 'fitness.walk10',
      );
      await quests.addQuest(walk);
      await quests.complete(
        quest: (await quests.quests()).single,
        completionId: 'fresh-walk-1',
        duration: const Duration(minutes: 10),
        timerEvidence: false,
        confirmReward: true,
      );

      final balances = await TrainingRepository(db).availablePotential();
      expect(balances.values.fold<int>(0, (sum, value) => sum + value), 10);
      expect(
        balances.entries
            .singleWhere((entry) => entry.key.name == 'physical')
            .value,
        10,
      );
      await expectLater(
        TrainingRepository(db).train(
          trainingDefinitionId: 'reaction-drill',
          idempotencyKey: 'first-training',
        ),
        throwsA(
          isA<InsufficientGrowthPotential>().having(
            (e) => e.required,
            'required',
            16,
          ),
        ),
      );
      expect(await db.recordsOf('trainingConversion'), isEmpty);
    },
  );
}
