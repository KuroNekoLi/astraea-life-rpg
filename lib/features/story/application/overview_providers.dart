import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';

final adventureOverviewProvider = FutureProvider<AdventureOverview>((
  ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  final storyContent =
      jsonDecode(
            await rootBundle.loadString(
              'assets/content/story/scene_1_5_v1.json',
            ),
          )
          as Map<String, dynamic>;
  final scenes = storyContent['scenes'] as List<dynamic>;
  final rows = await database.recordsOf('storyState');
  final active = rows.where((row) => row.read<String>('id') == 'active-story');
  final saved = active.firstOrNull;
  final progress = saved == null
      ? null
      : jsonDecode(saved.read<String>('payload')) as Map<String, dynamic>;
  final sceneIndex = progress?['sceneIndex'] as int? ?? 0;
  return AdventureOverview(
    chapterTitle: scenes.first['title'] as String,
    currentSceneTitle: sceneIndex >= scenes.length
        ? 'Chapter One complete'
        : (scenes[sceneIndex] as Map<String, dynamic>)['title'] as String,
    completedScenes: sceneIndex.clamp(0, scenes.length),
    sceneCount: scenes.length,
    isComplete: sceneIndex >= scenes.length,
  );
});

final preparedDeckProvider = FutureProvider<PreparedDeckOverview>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  final pool =
      jsonDecode(
            await rootBundle.loadString(
              'assets/content/spells/mvp_pool_v1.json',
            ),
          )
          as Map<String, dynamic>;
  final rows = await database.recordsOf('preparedDeck');
  final active = rows.where(
    (row) => row.read<String>('id') == 'prepared-deck-main',
  );
  final row = active.firstOrNull;
  final payload = row == null
      ? null
      : jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
  return PreparedDeckOverview(
    allSpells: (pool['spells'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(SpellCardView.fromJson)
        .toList(growable: false),
    selectedSpellIds:
        (payload?['spellIds'] as List<dynamic>?)?.cast<String>().toSet() ??
        const {},
  );
});

final class AdventureOverview {
  const AdventureOverview({
    required this.chapterTitle,
    required this.currentSceneTitle,
    required this.completedScenes,
    required this.sceneCount,
    required this.isComplete,
  });

  final String chapterTitle;
  final String currentSceneTitle;
  final int completedScenes;
  final int sceneCount;
  final bool isComplete;
}

final class PreparedDeckOverview {
  const PreparedDeckOverview({
    required this.allSpells,
    required this.selectedSpellIds,
  });

  final List<SpellCardView> allSpells;
  final Set<String> selectedSpellIds;

  List<SpellCardView> get selectedSpells => allSpells
      .where((spell) => selectedSpellIds.contains(spell.id))
      .toList(growable: false);
}

final class SpellCardView {
  const SpellCardView({
    required this.id,
    required this.name,
    required this.role,
  });

  factory SpellCardView.fromJson(Map<String, dynamic> json) => SpellCardView(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
  );

  final String id;
  final String name;
  final String role;
}
