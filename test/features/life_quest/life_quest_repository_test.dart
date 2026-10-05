import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/life_quest/data/life_quest_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'template completion atomically records activity, evidence and one grant',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime.utc(2026, 1, 1);
      final repository = LifeQuestRepository(database, () => now);
      final template = (await repository.templates()).firstWhere(
        (item) => item.id == 'learning.read20',
      );
      await repository.addQuest(template);
      final quest = (await repository.quests()).single;

      await repository.complete(
        quest: quest,
        completionId: 'attempt-1',
        duration: const Duration(minutes: 20),
        timerEvidence: true,
        confirmReward: true,
      );
      await repository.complete(
        quest: quest,
        completionId: 'attempt-1',
        duration: const Duration(minutes: 20),
        timerEvidence: true,
        confirmReward: true,
      );

      expect((await repository.database.recordsOf('activity')).length, 1);
      expect((await repository.database.recordsOf('evidence')).length, 1);
      expect((await repository.database.recordsOf('rewardGrant')).length, 1);
      expect(
        (await repository.database.recordsOf(
          'lifeProgress',
        )).single.read<String>('payload'),
        contains('18'),
      );
    },
  );

  test('GDD example anchors produce the authored XP values', () async {
    final repository = LifeQuestRepository(
      AppDatabase(NativeDatabase.memory()),
      DateTime.now,
    );
    expect(
      (await repository.quote(
        durationMinutes: 10,
        timerEvidence: false,
        domain: 'fitness',
      )).xp,
      10,
    );
    expect(
      (await repository.quote(
        durationMinutes: 20,
        timerEvidence: false,
        domain: 'learning',
      )).xp,
      18,
    );
    expect(
      (await repository.quote(
        durationMinutes: 30,
        timerEvidence: false,
        domain: 'fitness',
      )).xp,
      25,
    );
    expect(
      (await repository.quote(
        durationMinutes: 60,
        timerEvidence: false,
        domain: 'learning',
      )).xp,
      40,
    );
    expect(
      (await repository.quote(
        durationMinutes: 120,
        timerEvidence: false,
        domain: 'learning',
      )).xp,
      55,
    );
  });
}
