import 'package:astraea_life_rpg/features/combat/presentation/v1/ashfang_combat_v1_screen.dart';
import 'package:astraea_life_rpg/features/combat/presentation/v1/ashfang_rematch_v1_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localized_test_app.dart';

void main() {
  const landscapeSizes = <Size>[
    Size(844, 390),
    Size(852, 393),
    Size(915, 412),
    Size(960, 432),
    Size(1200, 700),
  ];

  for (final size in landscapeSizes) {
    testWidgets('tutorial fits landscape viewport $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: localizedTestApp(home: const AshfangCombatV1Screen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cast Fireball I'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('free practice fits landscape viewport $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: localizedTestApp(home: const AshfangRematchV1Screen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Basic Attack'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('tutorial renders zh-TW on a narrow landscape phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 390);
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

    expect(find.text('施放 Fireball I'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('portrait combat asks the player to rotate', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestApp(home: const AshfangCombatV1Screen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Rotate your device to play the battle in landscape.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
