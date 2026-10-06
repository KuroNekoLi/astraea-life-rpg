import 'dart:convert';

import 'package:astraea_life_rpg/app/app.dart';
import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/app/router.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/presentation/character_creation_screen.dart';
import 'package:astraea_life_rpg/features/character/data/training_repository.dart';
import 'package:astraea_life_rpg/features/life_quest/presentation/life_screen.dart';
import 'package:astraea_life_rpg/features/life_quest/data/life_quest_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'player creates a character, grants Life progress and saves a six-spell deck',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const AstraeaApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tap to start'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Enter Astraea'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enter Astraea'));
      await tester.pumpAndSettle();
      container.read(routerProvider).go('/character');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create Character'));
      await tester.pumpAndSettle();
      expect(find.byType(CharacterCreationScreen), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Astraea Hero');
      await tester.pump();
      expect(find.text('32 / 32 points'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton).last).onPressed,
        isNotNull,
      );
      await tester.scrollUntilVisible(
        find.text('Continue'),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect((await database.recordsOf('character')).length, 1);
      expect(
        container.read(routerProvider).routeInformationProvider.value.uri.path,
        '/life',
      );
      expect(find.byType(LifeScreen), findsOneWidget);

      await tester.tap(find.text('Add a Life Quest'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Read 20 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Read 20 minutes').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Complete with self-report'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm reward'));
      await tester.pumpAndSettle();
      expect((await database.recordsOf('rewardGrant')).length, 1);
      final potentialRows = await database.recordsOf('growthPotential');
      expect(potentialRows, hasLength(3));
      expect(
        {
          for (final row in potentialRows)
            (jsonDecode(row.read<String>('payload'))
                    as Map<String, dynamic>)['key']:
                (jsonDecode(row.read<String>('payload'))
                    as Map<String, dynamic>)['amount'],
        },
        {'physical': 0, 'cognitive': 18, 'communication': 0},
      );

      final lifeRepository = LifeQuestRepository(database, DateTime.now);
      await lifeRepository.complete(
        quest: (await lifeRepository.quests()).single,
        completionId: 'integration-second-learning',
        duration: const Duration(minutes: 30),
        timerEvidence: false,
        confirmReward: true,
      );
      final trainingRepository = TrainingRepository(database);
      final trainingPreview = await trainingRepository.goldenPathState();
      final analysisOption = trainingPreview.options.singleWhere(
        (option) => option.definitionId == 'function-analysis-drill',
      );
      expect(analysisOption.canTrain, isTrue);
      await trainingRepository.trainFunctionAnalysis(
        idempotencyKey: 'integration-analysis-training',
      );
      expect(await database.recordsOf('trainingConversion'), hasLength(1));

      container.read(routerProvider).go('/story');
      await tester.pumpAndSettle();
      for (var scene = 0; scene < 4; scene++) {
        await tester.scrollUntilVisible(
          find.text('Continue'),
          180,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }
      for (final spellName in [
        'Arc Bolt',
        'Focused Shot',
        'Energy Burst',
        'Barrier',
        'Deflect',
        'Step Shift',
      ]) {
        await tester.scrollUntilVisible(
          find.text(spellName),
          180,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        final tile = find.ancestor(
          of: find.text(spellName),
          matching: find.byType(CheckboxListTile),
        );
        await tester.ensureVisible(tile);
        await tester.pumpAndSettle();
        await tester.tap(tile);
        await tester.pumpAndSettle();
      }
      await tester.scrollUntilVisible(
        find.text('Confirm Prepared Deck'),
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Confirm Prepared Deck'));
      await tester.pumpAndSettle();
      expect((await database.recordsOf('preparedDeck')).length, 1);
      expect(tester.takeException(), isNull);

      container.dispose();
      final resumedContainer = ProviderContainer(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: resumedContainer,
          child: const AstraeaApp(),
        ),
      );
      await tester.pumpAndSettle();
      resumedContainer.read(routerProvider).go('/story');
      await tester.pumpAndSettle();
      expect(find.text('Chapter One complete'), findsOneWidget);
      expect(find.text('Start Ashfang Training Battle'), findsOneWidget);
      expect(find.text('Practice Function Analysis'), findsOneWidget);
      expect(find.text('Return to Adventure'), findsOneWidget);
      expect(
        (await database.recordsOf(
          'preparedDeck',
        )).single.read<String>('payload'),
        contains('spellIds'),
      );
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      resumedContainer.read(routerProvider).go('/battle/ashfang');
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      for (var frame = 0; frame < 20; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('請旋轉裝置至橫向'), findsNothing);
      await _attackAshfang(tester);
      await _pumpBattle(tester);
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pump(const Duration(milliseconds: 100));
      }
      final endTurnButton = find.ancestor(
        of: find.text('End Turn'),
        matching: find.byType(FilledButton),
      );
      expect(tester.widget<FilledButton>(endTurnButton).onPressed, isNotNull);
      await tester.tap(endTurnButton);
      await _pumpBattle(tester);
      await tester.tap(find.text('Function'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Analyze current node'));
      await _pumpBattle(tester);
      expect(find.textContaining('Weak Node found'), findsOneWidget);
      await tester.tap(find.text('Interrupt LockTarget'));
      await _pumpBattle(tester);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump(const Duration(milliseconds: 100));
      await _attackAshfang(tester);
      expect(find.text('VICTORY'), findsOneWidget);
      expect(await database.recordsOf('ashfangBattle'), hasLength(1));
      resumedContainer.dispose();
    },
  );
}

Future<void> _attackAshfang(WidgetTester tester) async {
  expect(find.text('Attack'), findsOneWidget);
  final attackButton = find.ancestor(
    of: find.text('Attack'),
    matching: find.byType(FilledButton),
  );
  expect(tester.widget<FilledButton>(attackButton).onPressed, isNotNull);
  await tester.tap(find.text('Attack'));
  await tester.pump(const Duration(milliseconds: 100));
  expect(find.textContaining('TARGET'), findsOneWidget);
  expect(
    tester.widget<ChoiceChip>(find.byType(ChoiceChip)).onSelected,
    isNotNull,
  );
  await tester.tap(find.byType(ChoiceChip));
  await tester.pump(const Duration(milliseconds: 100));
  expect(tester.widget<ChoiceChip>(find.byType(ChoiceChip)).selected, isTrue);
  final confirmButton = find.ancestor(
    of: find.text('Confirm Attack'),
    matching: find.byType(FilledButton),
  );
  expect(tester.widget<FilledButton>(confirmButton).onPressed, isNotNull);
  await tester.tap(find.text('Confirm Attack'));
  await _pumpBattle(tester);
  expect(find.text('TARGET'), findsNothing);
}

Future<void> _pumpBattle(WidgetTester tester) async {
  for (var frame = 0; frame < 4; frame++) {
    await tester.pump(const Duration(milliseconds: 400));
  }
}
