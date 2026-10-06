import 'dart:convert';

import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/data/training_repository.dart';
import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/life_quest/data/life_quest_repository.dart';
import 'package:astraea_life_rpg/game_engine/function_graph/function_graph.dart';
import 'package:astraea_life_rpg/game_engine/function_graph/function_runtime.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Life Quest reward becomes Analysis growth that changes Ashfang reveal outcome',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime.utc(2026, 10, 5, 12);

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
            'rngSeed': 1,
            'rngState': 2,
          },
          'schemaVersion': 2,
        }),
        createdAt: now,
      );

      final life = LifeQuestRepository(database, () => now);
      final read = (await life.templates()).firstWhere(
        (template) => template.id == 'learning.read20',
      );
      await life.addQuest(read);
      final quest = (await life.quests()).single;
      await life.complete(
        quest: quest,
        completionId: 'golden-path-1',
        duration: const Duration(minutes: 20),
        timerEvidence: false,
        confirmReward: true,
      );

      final training = TrainingRepository(database);
      final before = await training.goldenPathState();
      expect(before.balances.values, contains(18));
      expect(before.effectiveAnalysis, 12);
      expect(before.quote.potentialCost, 18);

      final encounter =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/content/encounters/ashfang_training_v1.json',
                ),
              )
              as Map<String, dynamic>;
      final graphJson = encounter['functionGraph'] as Map<String, dynamic>;
      final graph = FunctionGraph(
        id: graphJson['id'] as String,
        nodes: (graphJson['nodes'] as List<dynamic>)
            .map(
              (raw) => FunctionNode(
                id: (raw as Map<String, dynamic>)['id'] as String,
                type: raw['type'] as String,
                parameters: const {},
                complexity: 1,
                interruptible: raw['interruptible'] as bool,
                reversible: false,
              ),
            )
            .toList(),
        edges: (graphJson['edges'] as List<dynamic>)
            .map(
              (raw) => FunctionEdge(
                fromNodeId: (raw as List<dynamic>)[0] as String,
                toNodeId: raw[1] as String,
              ),
            )
            .toList(),
        entryNodeIds: const {'detect-target'},
        outputNodeIds: const {'pounce'},
        weakNodeRuleIds: const {'lock-target-weak-node'},
        schemaVersion: 1,
        contentVersion: encounter['contentVersion'] as String,
      );
      final rules = [
        FunctionWeakNodeRule(
          id: 'lock-target-weak-node',
          nodeId: 'lock-target',
          downstreamNodeIds: const {'pounce'},
        ),
      ];

      const engine = FunctionRuntimeEngine();
      final beforeReveal = engine.analyze(
        graph: graph,
        nodeId: 'lock-target',
        analysisRoll: 7,
        analysisModifier: before.effectiveAnalysis - 8,
        difficulty: encounter['analysisDifficulty'] as int,
        knowledge: FunctionKnowledge(),
        rules: rules,
      );
      expect(beforeReveal.revealed, isFalse);

      await training.trainFunctionAnalysis(
        idempotencyKey: 'golden-path-training-1',
      );
      final after = await training.goldenPathState();
      expect(after.effectiveAnalysis, 13);
      expect(after.analysisPermanentGrowth, 1);

      final afterReveal = engine.analyze(
        graph: graph,
        nodeId: 'lock-target',
        analysisRoll: 7,
        analysisModifier: after.effectiveAnalysis - 8,
        difficulty: encounter['analysisDifficulty'] as int,
        knowledge: FunctionKnowledge(),
        rules: rules,
      );
      expect(afterReveal.revealed, isTrue);

      final active = ActiveFunctionState(
        id: 'ashfang-pounce',
        graphId: graph.id,
        activeNodeId: 'lock-target',
        status: FunctionRuntimeStatus.active,
      );
      final interrupted = engine.interrupt(
        graph: graph,
        function: active,
        nodeId: 'lock-target',
        knowledge: afterReveal.knowledge,
        rules: rules,
      );
      expect(interrupted.success, isTrue);
      expect(interrupted.function.cancelledNodeIds, contains('pounce'));
    },
  );
}
