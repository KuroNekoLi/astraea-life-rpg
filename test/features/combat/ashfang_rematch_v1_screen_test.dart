import 'package:astraea_life_rpg/features/combat/presentation/v1/ashfang_rematch_v1_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localized_test_app.dart';

void main() {
  testWidgets('free practice exposes multiple decisions without tutorial highlighting', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestApp(home: const AshfangRematchV1Screen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ashfang Free Practice'), findsOneWidget);
    expect(find.text('Basic Attack'), findsOneWidget);
    expect(find.text('Guard'), findsOneWidget);
    expect(find.text('Fireball I · Chantless'), findsOneWidget);
    expect(find.text('Fireball II · Full Chant'), findsOneWidget);
  });

  testWidgets('player can save reaction then discover Weak Node through Analysis', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestApp(home: const AshfangRematchV1Screen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fireball I · Chantless'));
    await tester.pumpAndSettle();

    expect(find.text('REACTION WINDOW'), findsOneWidget);
    await tester.tap(find.text('Save Reaction'));
    await tester.pumpAndSettle();

    expect(find.text('Analyze Function'), findsOneWidget);
    await tester.tap(find.text('Analyze Function'));
    await tester.pumpAndSettle();

    expect(find.text('Exploit Weak Node'), findsOneWidget);
  });

  testWidgets('free practice renders in zh-TW', (tester) async {
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestApp(
          locale: const Locale('zh', 'TW'),
          home: const AshfangRematchV1Screen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ashfang 自由練習'), findsOneWidget);
    expect(find.text('普通攻擊'), findsOneWidget);
    expect(find.text('防禦'), findsOneWidget);
  });
}
