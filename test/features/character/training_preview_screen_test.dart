import 'dart:convert';

import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/character/presentation/training_preview_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localized_test_app.dart';

void main() {
  testWidgets('shows authored Analysis quote and commits Training', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
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
      createdAt: DateTime.utc(2026),
    );
    await database.putRecord(
      id: 'grant-1',
      kind: 'rewardGrant',
      payload: jsonEncode({
        'sourceId': 'activity-1',
        'idempotencyKey': 'life-activity:1',
        'formulaVersion': 'mvp-prototype-1',
        'rewards': [
          {'type': 'growthPotential', 'category': 'cognitive', 'amount': 18},
        ],
      }),
      createdAt: DateTime.utc(2026),
    );
    await database.putRecord(
      id: 'growthPotential-cognitive',
      kind: 'growthPotential',
      payload: '{"key":"cognitive","amount":18,"projectionVersion":1}',
      createdAt: DateTime.utc(2026),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
        child: localizedTestApp(home: const TrainingPreviewScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Train Analysis'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Function Analysis Drill'), findsOneWidget);
    expect(find.textContaining('Analysis 12 → 13'), findsOneWidget);

    await tester.ensureVisible(find.text('Train Analysis'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Train Analysis'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(
      find.text('Training complete. Your attribute grew permanently.'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Analysis growth is active'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Analysis growth is active'), findsOneWidget);
    expect(find.text('+1 permanent Analysis from Training'), findsOneWidget);
    expect((await database.recordsOf('trainingConversion')).length, 1);
    expect(tester.takeException(), isNull);
  });
}
