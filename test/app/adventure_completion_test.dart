import 'dart:convert';

import 'package:astraea_life_rpg/app/app.dart';
import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/app/router.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/combat/presentation/ashfang_battle_screen.dart';
import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/story/presentation/function_lab_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('completed academy story offers the playable Ashfang battle', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWith((ref) async => database)],
    );
    addTearDown(container.dispose);
    await database.putRecord(
      id: 'active-story',
      kind: 'storyState',
      payload: jsonEncode({'sceneIndex': 5}),
      createdAt: DateTime.utc(2026),
    );
    await database.putRecord(
      id: 'active-character',
      kind: 'character',
      payload: jsonEncode({
        'id': 'hero',
        'name': 'Hero',
        'weaponId': 'standard_staff',
        'attributes': {for (final value in AttributeType.values) value.name: 8},
        'aptitude': {
          'contentVersion': 'character-growth-mvp-1',
          'ratings': {for (final value in AttributeType.values) value.name: 3},
          'fateRerollUsed': false,
          'rngSeed': 1,
          'rngState': 2,
        },
        'schemaVersion': 2,
      }),
      createdAt: DateTime.utc(2026),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AstraeaApp(),
      ),
    );
    await tester.pumpAndSettle();

    container.read(routerProvider).go('/adventure');
    await tester.pumpAndSettle();
    expect(find.text('Chapter One complete'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Start Ashfang Training Battle'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Ashfang Training Battle'));
    await tester.pumpAndSettle();
    expect(find.byType(AshfangBattleScreen), findsOneWidget);
    expect(find.text('ASHFANG TRAINING CONSTRUCT'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    container.read(routerProvider).go('/adventure');
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Practice Function Analysis'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Practice Function Analysis'));
    await tester.pumpAndSettle();
    expect(find.byType(FunctionLabScreen), findsOneWidget);
    expect(find.text('Observe next Function node'), findsOneWidget);

    container.read(routerProvider).go('/story');
    await tester.pumpAndSettle();
    expect(find.text('Chapter One complete'), findsOneWidget);
    expect(find.text('Start Ashfang Training Battle'), findsOneWidget);
    expect(find.text('Practice Function Analysis'), findsOneWidget);
    expect(find.text('Return to Adventure'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
