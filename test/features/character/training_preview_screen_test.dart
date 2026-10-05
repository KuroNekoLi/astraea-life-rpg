import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/presentation/training_preview_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows saved potential and explains that no conversion is made', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.putRecord(
      id: 'growthPotential-cognitive',
      kind: 'growthPotential',
      payload: '{"key":"cognitive","amount":12,"projectionVersion":1}',
      createdAt: DateTime.utc(2026),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
        child: const MaterialApp(home: TrainingPreviewScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cognitive Potential'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Physical Potential'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
    expect(
      find.text('Training conversion is not available yet'),
      findsOneWidget,
    );
    expect(find.textContaining('no points are spent'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
