import 'package:astraea_life_rpg/features/combat/presentation/widgets/combat_battle_stage.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CombatStageSnapshot', () {
    test('copies combatants into an immutable list', () {
      final combatants = <CombatStageCombatantView>[
        const CombatStageCombatantView(
          id: 'astra',
          side: CombatStageSide.player,
        ),
      ];
      final snapshot = CombatStageSnapshot(
        battleId: 'battle-1',
        revision: 1,
        combatants: combatants,
        activeCombatantId: 'astra',
        outcome: CombatStageOutcome.active,
      );

      combatants.clear();

      expect(snapshot.combatants, hasLength(1));
      expect(
        () => snapshot.combatants.add(
          const CombatStageCombatantView(
            id: 'ashfang',
            side: CombatStageSide.enemy,
          ),
        ),
        throwsUnsupportedError,
      );
    });

    test('rejects duplicate combatant ids', () {
      expect(
        () => CombatStageSnapshot(
          battleId: 'battle-1',
          revision: 1,
          combatants: const [
            CombatStageCombatantView(id: 'same', side: CombatStageSide.player),
            CombatStageCombatantView(id: 'same', side: CombatStageSide.enemy),
          ],
          activeCombatantId: null,
          outcome: CombatStageOutcome.active,
        ),
        throwsArgumentError,
      );
    });
  });

  testWidgets('mounts as a non-interactive Flame scene', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: CombatBattleStage(snapshot: _snapshot())),
              Align(
                alignment: Alignment.bottomCenter,
                child: Semantics(
                  label: 'Battle controls',
                  child: SizedBox(key: Key('flutter-controls'), height: 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 16));

    expect(
      find.byWidgetPredicate((widget) => widget is GameWidget),
      findsOneWidget,
    );
    final stageIgnorePointer = find.byWidgetPredicate(
      (widget) => widget is IgnorePointer && widget.ignoring,
    );
    expect(stageIgnorePointer, findsOneWidget);
    expect(find.byType(ExcludeSemantics), findsAtLeastNWidgets(1));
    expect(find.byKey(const Key('flutter-controls')), findsOneWidget);

    final ignorePointer = tester.widget<IgnorePointer>(stageIgnorePointer);
    expect(ignorePointer.ignoring, isTrue);
  });

  testWidgets('accepts resolved cues and animation preference updates', (
    tester,
  ) async {
    var widget = CombatBattleStage(snapshot: _snapshot());
    await tester.pumpWidget(MaterialApp(home: SizedBox.expand(child: widget)));
    await tester.pump(const Duration(milliseconds: 16));

    widget = CombatBattleStage(
      snapshot: _snapshot(revision: 2, outcome: CombatStageOutcome.victory),
      cue: const CombatStageCue(
        id: 'event-1',
        kind: CombatStageCueKind.victory,
        actorId: 'astra',
      ),
      reducedMotion: true,
    );
    await tester.pumpWidget(MaterialApp(home: SizedBox.expand(child: widget)));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pumpWidget(const SizedBox.shrink());

    expect(tester.takeException(), isNull);
  });
}

CombatStageSnapshot _snapshot({
  int revision = 1,
  CombatStageOutcome outcome = CombatStageOutcome.active,
}) => CombatStageSnapshot(
  battleId: 'battle-1',
  revision: revision,
  combatants: const [
    CombatStageCombatantView(id: 'astra', side: CombatStageSide.player),
    CombatStageCombatantView(id: 'ashfang', side: CombatStageSide.enemy),
  ],
  activeCombatantId: 'astra',
  outcome: outcome,
);
