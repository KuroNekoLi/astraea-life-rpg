import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/app/app_shell.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/combat/presentation/ashfang_battle_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('portrait battle route shows rotate gate without commands', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWith((ref) async => database)],
        child: const MaterialApp(home: AshfangBattleScreen()),
      ),
    );

    expect(find.text('請旋轉裝置至橫向'), findsOneWidget);
    expect(find.text('Attack'), findsNothing);
    expect(find.text('End Turn'), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('battle shell hides global navigation only on battle route', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(location: '/battle/ashfang', child: Text('Battle')),
      ),
    );

    expect(find.text('Battle'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(location: '/adventure', child: Text('Adventure')),
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
