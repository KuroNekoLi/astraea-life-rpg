import 'package:astraea_life_rpg/app/app_providers.dart';
import 'package:astraea_life_rpg/app/app.dart';
import 'package:astraea_life_rpg/app/router.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/story/presentation/function_lab_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'tutorial shows Weak Node analysis and cancelled Pounce outcome',
    (tester) async {
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
      container.read(routerProvider).go('/function-lab');
      await tester.pumpAndSettle();
      expect(find.byType(FunctionLabScreen), findsOneWidget);

      await tester.tap(find.text('Observe next Function node'));
      await tester.pumpAndSettle();
      for (
        var attempt = 0;
        attempt < 5 && find.text('Interrupt LockTarget').evaluate().isEmpty;
        attempt++
      ) {
        await tester.tap(find.text('Analyze active Function'));
        await tester.pumpAndSettle();
      }
      expect(find.text('Interrupt LockTarget'), findsOneWidget);
      await tester.tap(find.text('Interrupt LockTarget'));
      await tester.pumpAndSettle();
      expect(
        find.text('LockTarget interrupted. Pounce is cancelled.'),
        findsOneWidget,
      );
      expect(find.text('Cancelled by Weak Node interruption'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
