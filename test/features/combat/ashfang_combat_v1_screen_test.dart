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

  testWidgets('guided player flow reaches victory through visible CTB states', (
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

    await tester.tap(find.text('Cast Fireball I'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Interrupt'));
    await tester.pumpAndSettle();

    expect(find.text('Analyze Modified Function'), findsOneWidget);
    await tester.tap(find.text('Analyze Modified Function'));
    await tester.pumpAndSettle();

    expect(find.text('Weak Node: Stabilization'), findsOneWidget);
    await tester.tap(find.text('Interrupt'));
    await tester.pumpAndSettle();

    expect(find.text('Begin Fireball II · Full Chant'), findsOneWidget);
    await tester.tap(find.text('Begin Fireball II · Full Chant'));
    await tester.pumpAndSettle();

    expect(find.text('Full Chant is constructing'), findsOneWidget);
    expect(find.textContaining('Fireball II Resolve'), findsOneWidget);

    await tester.tap(find.text('Hold Formation'));
    await tester.pumpAndSettle();

    expect(find.text('Finish with Fireball I'), findsOneWidget);
    await tester.tap(find.text('Finish with Fireball I'));
    await tester.pumpAndSettle();

    expect(find.text('Training battle complete'), findsOneWidget);
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

    await tester.tap(find.text('施放 Fireball I'));
    await tester.pumpAndSettle();
    expect(find.text('保留 Reaction'), findsOneWidget);
  });
}
