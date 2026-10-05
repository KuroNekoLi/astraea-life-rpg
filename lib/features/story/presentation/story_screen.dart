import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../app/app_providers.dart';
import '../../../core/persistence/app_database.dart';
import '../../../core/measurement/prototype_event_recorder.dart';
import '../domain/story_state.dart';
import '../../../game_engine/function_graph/function_graph.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  late Future<_StoryView> _story;
  final Set<String> _selectedSpells = {};

  @override
  void initState() {
    super.initState();
    _story = _load();
  }

  Future<_StoryView> _load() async {
    final database = await ref.read(databaseProvider.future);
    final scenes =
        (jsonDecode(
              await rootBundle.loadString(
                'assets/content/story/scene_1_5_v1.json',
              ),
            )
            as Map<String, dynamic>);
    final spells =
        (jsonDecode(
              await rootBundle.loadString(
                'assets/content/spells/mvp_pool_v1.json',
              ),
            )
            as Map<String, dynamic>);
    final rows = await database.recordsOf('storyState');
    final current = rows.isEmpty
        ? null
        : jsonDecode(rows.single.read<String>('payload'))
              as Map<String, dynamic>;
    return _StoryView(database, scenes, spells, current);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<_StoryView>(
    future: _story,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(child: Text('Could not load story: ${snapshot.error}')),
        );
      }
      if (!snapshot.hasData) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final view = snapshot.requireData;
      final sceneList = view.scenes['scenes'] as List<dynamic>;
      final state = view.state;
      final sceneIndex = state?['sceneIndex'] as int? ?? 0;
      if (sceneIndex >= sceneList.length) {
        return Scaffold(
          appBar: AppBar(title: const Text('Academy Story')),
          body: const Center(
            child: Text('Scene 1–5 complete. Your Prepared Deck is saved.'),
          ),
        );
      }
      final scene = sceneList[sceneIndex] as Map<String, dynamic>;
      final isDeck = scene['id'] == 'scene-5';
      return Scaffold(
        appBar: AppBar(title: Text(scene['title'] as String)),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            for (final beat in scene['beats'] as List<dynamic>)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  beat as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (sceneIndex == 2) _functionGraphCard(context),
            if (sceneIndex == 3) _castingMethodChoices(),
            if (isDeck) ...[
              Text('Prepared Deck: ${_selectedSpells.length} / 6'),
              for (final spell in view.spells['spells'] as List<dynamic>)
                CheckboxListTile(
                  value: _selectedSpells.contains(
                    (spell as Map<String, dynamic>)['id'],
                  ),
                  title: Text(spell['name'] as String),
                  subtitle: Text(spell['role'] as String),
                  onChanged: (selected) => setState(() {
                    final id = spell['id'] as String;
                    if (selected == true && _selectedSpells.length < 6) {
                      _selectedSpells.add(id);
                    }
                    if (selected != true) {
                      _selectedSpells.remove(id);
                    }
                  }),
                ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isDeck && _selectedSpells.length != 6
                  ? null
                  : () async {
                      await _advance(view, scene, sceneIndex);
                      if (mounted) {
                        setState(() {
                          _story = _load();
                        });
                      }
                    },
              child: Text(isDeck ? 'Confirm Prepared Deck' : 'Continue'),
            ),
          ],
        ),
      );
    },
  );

  Widget _functionGraphCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Function Graph',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final node in [
            'Gather · collect energy',
            'Shape · form a bolt',
            'Move · direct the result',
          ])
            ListTile(
              leading: const Icon(Icons.circle_outlined),
              title: Text(node),
            ),
        ],
      ),
    ),
  );

  Widget _castingMethodChoices() => const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Full Chant is slower and stable.'),
          SizedBox(height: 8),
          Text('Chantless is faster and requires internalized encoding.'),
          SizedBox(height: 8),
          Text('Both methods perform the Function processing.'),
        ],
      ),
    ),
  );

  Future<void> _advance(
    _StoryView view,
    Map<String, dynamic> scene,
    int index,
  ) async {
    final rows = await view.database.recordsOf('storyState');
    final current = rows.isEmpty
        ? null
        : jsonDecode(rows.single.read<String>('payload'))
              as Map<String, dynamic>;
    final revision = current?['storyRevision'] as int? ?? 0;
    final oldState = current == null
        ? StoryState(
            userId: 'local-player',
            chapterId: 'chapter-1',
            sceneId: 'scene-1',
            flags: {},
            choices: [],
            storyRevision: 0,
            contentVersion: view.scenes['contentVersion'] as String,
          )
        : _toDomain(current);
    final nextIndex = index + 1;
    final sceneList = view.scenes['scenes'] as List<dynamic>;
    final nextSceneId = nextIndex < sceneList.length
        ? (sceneList[nextIndex] as Map<String, dynamic>)['id'] as String
        : 'scene-1-5-complete';
    final transition = applyStoryTransition(
      oldState,
      StoryTransitionCommand(
        expectedStoryRevision: revision,
        chapterId: 'chapter-1',
        sceneId: nextSceneId,
        contentVersion: view.scenes['contentVersion'] as String,
        addFlags: (scene['flags'] as List<dynamic>).cast<String>().toSet(),
      ),
    );
    if (transition is! StoryTransitionApplied) {
      throw StateError('Story state changed. Reload before continuing.');
    }
    final updated = transition.state;
    await view.database.transaction(() async {
      await view.database.customStatement(
        'DELETE FROM app_records WHERE id = ?',
        ['active-story'],
      );
      await view.database.putRecord(
        id: 'active-story',
        kind: 'storyState',
        payload: jsonEncode(_toJson(updated, nextIndex)),
        createdAt: DateTime.now(),
      );
      if (scene['id'] == 'scene-5') {
        final deck = PreparedDeck(
          id: 'prepared-deck-main',
          characterId: 'active-character',
          spellIds: _selectedSpells,
          revision: 0,
          updatedAt: DateTime.now(),
        );
        await view.database.putRecord(
          id: 'prepared-deck-main',
          kind: 'preparedDeck',
          payload: jsonEncode({
            'characterId': deck.characterId,
            'spellIds': deck.spellIds,
            'slotLimit': 6,
            'revision': deck.revision,
            'contentVersion': view.spells['contentVersion'],
          }),
          createdAt: DateTime.now(),
        );
      }
    });
    if (scene['id'] == 'scene-5') {
      try {
        await PrototypeEventRecorder(view.database, DateTime.now).record(
          type: PrototypeEventType.deckConfirmed,
          properties: {
            'contentVersion': view.spells['contentVersion'] as String,
          },
          idempotencyKey: 'prepared-deck-main',
        );
      } catch (_) {
        // Measurement is optional and cannot block story progression.
      }
    }
  }
}

StoryState _toDomain(Map<String, dynamic> json) => StoryState(
  userId: json['userId'] as String,
  chapterId: json['chapterId'] as String,
  sceneId: json['sceneId'] as String,
  flags: (json['flags'] as List<dynamic>).cast<String>().toSet(),
  choices: (json['choices'] as List<dynamic>).cast<String>(),
  storyRevision: json['storyRevision'] as int,
  contentVersion: json['contentVersion'] as String,
);

Map<String, dynamic> _toJson(StoryState state, int sceneIndex) => {
  'userId': state.userId,
  'chapterId': state.chapterId,
  'sceneId': state.sceneId,
  'flags': state.flags.toList(),
  'choices': state.choices,
  'storyRevision': state.storyRevision,
  'contentVersion': state.contentVersion,
  'sceneIndex': sceneIndex,
  'schemaVersion': state.schemaVersion,
};

final class _StoryView {
  const _StoryView(this.database, this.scenes, this.spells, this.state);
  final AppDatabase database;
  final Map<String, dynamic> scenes;
  final Map<String, dynamic> spells;
  final Map<String, dynamic>? state;
}
