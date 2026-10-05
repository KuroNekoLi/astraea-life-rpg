import 'package:astraea_life_rpg/app/app.dart';
import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/app/router.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/presentation/character_creation_screen.dart';
import 'package:astraea_life_rpg/features/life_quest/presentation/life_screen.dart';
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
      expect((await database.recordsOf('growthPotential')).length, 1);

      container.read(routerProvider).go('/story');
      await tester.pumpAndSettle();
      for (var scene = 0; scene < 4; scene++) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }
      final visibleChecks = find.byType(CheckboxListTile);
      for (var index = 0; index < 5; index++) {
        await tester.tap(visibleChecks.at(index));
        await tester.pumpAndSettle();
      }
      await tester.scrollUntilVisible(
        find.text('Step Shift'),
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(
        find.ancestor(
          of: find.text('Step Shift'),
          matching: find.byType(CheckboxListTile),
        ),
      );
      await tester.pumpAndSettle();
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
      expect(
        find.text('Scene 1–5 complete. Your Prepared Deck is saved.'),
        findsOneWidget,
      );
      expect(
        (await database.recordsOf(
          'preparedDeck',
        )).single.read<String>('payload'),
        contains('spellIds'),
      );
      resumedContainer.dispose();
    },
  );
}
