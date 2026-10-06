import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/character/presentation/character_creation_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('character allocation explains each Attribute build focus', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
        child: const MaterialApp(home: CharacterCreationScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Choose your hero’s build focus'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.textContaining('Focus: Reveal enemy Weak Nodes and counters'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.textContaining('Focus: Reveal enemy Weak Nodes and counters'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
