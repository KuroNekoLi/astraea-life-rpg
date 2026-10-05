import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../data/life_quest_repository.dart';

final lifeQuestRepositoryProvider = FutureProvider<LifeQuestRepository>((
  ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  return LifeQuestRepository(database, DateTime.now);
});

final lifeQuestsProvider = FutureProvider<List<Map<String, dynamic>>>(
  (ref) async => (await ref.watch(lifeQuestRepositoryProvider.future)).quests(),
);
