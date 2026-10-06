import 'dart:convert';

import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/character/presentation/training_preview_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('physical quest Potential can be spent on a matching drill', (
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
      id: 'growthPotential-physical',
      kind: 'growthPotential',
      payload: '{"key":"physical","amount":30,"projectionVersion":1}',
      createdAt: DateTime.utc(2026),
    );
    await database.putRecord(
      id: 'grant-physical-1',
      kind: 'rewardGrant',
      payload: jsonEncode({
        'sourceId': 'activity-physical-1',
        'idempotencyKey': 'life-activity:physical-1',
        'formulaVersion': 'mvp-prototype-1',
        'rewards': [
          {'type': 'growthPotential', 'category': 'physical', 'amount': 30},
        ],
      }),
      createdAt: DateTime.utc(2026),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
        child: const MaterialApp(home: TrainingPreviewScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Train Processing'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Reaction Drill'), findsOneWidget);
    expect(find.textContaining('Processing 12 → 13'), findsOneWidget);
    await tester.tap(find.text('Train Processing'));
    await tester.pumpAndSettle();

    final conversions = await database.recordsOf('trainingConversion');
    expect(conversions, hasLength(1));
    final conversion =
        jsonDecode(conversions.single.read<String>('payload'))
            as Map<String, dynamic>;
    expect(conversion['trainingDefinitionId'], 'reaction-drill');
    expect(conversion['potentialCategory'], 'physical');
    expect(conversion['amountSpent'], 18);
    expect(conversion['attributeDeltas'], {'processing': 1});
    expect(tester.takeException(), isNull);
  });
}
