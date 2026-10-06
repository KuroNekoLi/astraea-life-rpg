import 'package:astraea_life_rpg/app/app.dart';
import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/app/router.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/home/presentation/home_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('launch flow enters the five-tab Astraea app shell', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWith((ref) async => database)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AstraeaApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ASTRAEA'), findsOneWidget);
    await tester.tap(find.text('Tap to start'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Astraea'), findsOneWidget);
    await tester.ensureVisible(find.text('Enter Astraea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter Astraea'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(
      container.read(routerProvider).routeInformationProvider.value.uri.path,
      '/home',
    );
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Choose a Life Quest'), findsOneWidget);
    expect(find.text('Adventure'), findsWidgets);
    for (final destination in [
      ('Life', '/life'),
      ('Adventure', '/adventure'),
      ('Deck', '/deck'),
      ('Character', '/character'),
      ('Home', '/home'),
    ]) {
      await tester.tap(find.text(destination.$1).last);
      await tester.pumpAndSettle();
      expect(
        container.read(routerProvider).routeInformationProvider.value.uri.path,
        destination.$2,
      );
    }
    container.read(routerProvider).go('/training');
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      4,
    );
    expect(tester.takeException(), isNull);
  });
}
