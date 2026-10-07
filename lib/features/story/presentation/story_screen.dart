import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../core/persistence/app_database.dart';
import '../../../core/measurement/prototype_event_recorder.dart';
import '../domain/story_state.dart';
import '../../../game_engine/function_graph/function_graph.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  late Future<_StoryView> _story;
  final Set<String> _selectedSpells = {};
  int _selectedFunctionNode = 0;
  int? _functionAnswer;

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
          body: Center(child: Text(context.l10n.couldNotLoadStory('${snapshot.error}'))),
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
          appBar: AppBar(title: Text(context.l10n.academyStory)),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: FilledButton.icon(
                onPressed: () => context.push('/battle/ashfang'),
                icon: const Icon(Icons.sports_martial_arts),
                label: Text(context.l10n.startAshfangBattle),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Text(
                context.l10n.chapterOneComplete,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(context.l10n.preparedDeckSavedNext),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => context.push('/function-lab'),
                icon: const Icon(Icons.account_tree_outlined),
                label: Text(context.l10n.practiceFunctionAnalysis),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/adventure'),
                icon: const Icon(Icons.map_outlined),
                label: Text(context.l10n.returnToAdventure),
              ),
            ],
          ),
        );
      }
      final scene = sceneList[sceneIndex] as Map<String, dynamic>;
      final isDeck = scene['id'] == 'scene-5';
      return Scaffold(
        appBar: AppBar(
          title: Text(localizedSceneTitle(context.l10n, scene['id'] as String)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 104),
          children: [
            for (final beat in localizedSceneBeats(context.l10n, scene['id'] as String))
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  beat,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (sceneIndex == 2) _functionGraphCard(context),
            if (sceneIndex == 3) _castingMethodChoices(context),
            if (isDeck) ...[
              Text(context.l10n.preparedDeckCount(_selectedSpells.length)),
              for (final spell in view.spells['spells'] as List<dynamic>)
                CheckboxListTile(
                  value: _selectedSpells.contains(
                    (spell as Map<String, dynamic>)['id'],
                  ),
                  title: Text(localizedSpellName(context.l10n, spell['id'] as String)),
                  subtitle: Text(localizedSpellRole(context.l10n, spell['role'] as String)),
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
              child: Text(
                isDeck ? context.l10n.confirmPreparedDeck : context.l10n.commonContinue,
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget _functionGraphCard(BuildContext context) {
    final nodes = [
      (
        context.l10n.graphGather,
        context.l10n.graphGatherDescription,
        context.l10n.graphGatherSummary,
      ),
      (
        context.l10n.graphShape,
        context.l10n.graphShapeDescription,
        context.l10n.graphShapeSummary,
      ),
      (
        context.l10n.graphMove,
        context.l10n.graphMoveDescription,
        context.l10n.graphMoveSummary,
      ),
    ];
    final selected = nodes[_selectedFunctionNode];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.functionGraph,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(context.l10n.tapStepRole),
            for (var index = 0; index < nodes.length; index++)
              ListTile(
                selected: _selectedFunctionNode == index,
                leading: Icon(
                  _selectedFunctionNode == index
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(
                  context.l10n.graphNodeSummary(
                    nodes[index].$1,
                    nodes[index].$3,
                  ),
                ),
                onTap: () => setState(() => _selectedFunctionNode = index),
              ),
            const Divider(),
            Text(selected.$1, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(selected.$2),
            const SizedBox(height: 16),
            Text(
              context.l10n.quickCheck,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            RadioGroup<int>(
              groupValue: _functionAnswer,
              onChanged: (value) => setState(() => _functionAnswer = value),
              child: Column(
                children: [
                  for (var index = 0; index < nodes.length; index++)
                    RadioListTile<int>(
                      value: index,
                      title: Text(nodes[index].$1),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            if (_functionAnswer != null)
              Text(
                _functionAnswer == 2
                    ? context.l10n.graphCorrectMove
                    : context.l10n.graphWrongMove,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _functionAnswer == 2
                      ? const Color(0xFF9EE3B7)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _castingMethodChoices(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.fullChantSlowerStable),
          const SizedBox(height: 8),
          Text(context.l10n.chantlessFasterInternal),
          const SizedBox(height: 8),
          Text(context.l10n.bothPerformProcessing),
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
