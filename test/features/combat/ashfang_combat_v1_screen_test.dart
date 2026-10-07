import 'package:astraea_life_rpg/features/combat/presentation/v1/ashfang_combat_v1_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localized_test_app.dart';

void main() {
  testWidgets('renders the CTB combat shell and opens the first Reaction', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestApp(home: const AshfangCombatV1Screen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ACTION TIMELINE'), findsOneWidget);
    expect(find.text('Cast Fireball I'), findsOneWidget);

    await tester.tap(find.text('Cast Fireball I'));
    await tester.pumpAndSettle();

    expect(find.text('REACTION'), findsOneWidget);
    expect(find.text('Interrupt'), findsOneWidget);
  });

  testWidgets('renders core combat chrome in zh-TW', (tester) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestApp(
          locale: const Locale('zh', 'TW'),
          home: const AshfangCombatV1Screen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('行動時間軸'), findsOneWidget);
    expect(find.text('施放 Fireball I'), findsOneWidget);
  });
}
