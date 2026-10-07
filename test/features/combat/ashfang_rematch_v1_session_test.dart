import 'package:astraea_life_rpg/features/combat/application/ashfang_rematch_v1_session.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:test/test.dart';

void main() {
  test('rematch starts with a real player turn', () {
    final session = AshfangRematchV1Session();

    expect(session.phase, AshfangRematchPhaseV1.playerTurn);
    expect(session.activePlayerId, 'hero');
    expect(session.state.actor('ashfang').hp, 320);
  });

  test('player can decline the first reaction then analyze on Rio turn', () {
    final session = AshfangRematchV1Session();

    session.castHeroFireballI();

    expect(session.phase, AshfangRematchPhaseV1.reactionWindow);
    expect(session.enemyCastingFunction, isNotNull);
    expect(session.weakNodeRevealed, isFalse);

    session.saveReaction();

    expect(session.phase, AshfangRematchPhaseV1.playerTurn);
    expect(session.activePlayerId, 'rio');

    session.analyzeEnemyFunction();

    expect(session.phase, AshfangRematchPhaseV1.reactionWindow);
    expect(session.weakNodeRevealed, isTrue);
    expect(session.rioKnowledge?.knownStability, 58);

    session.interruptEnemyFunction(exploitWeakNode: true);

    expect(session.enemyCastingFunction, isNull);
    expect(session.state.actor('rio').reactionAvailable, isFalse);
  });

  test('player can choose a non-analysis interrupt path', () {
    final session = AshfangRematchV1Session();

    session.basicAttack();
    expect(session.phase, AshfangRematchPhaseV1.reactionWindow);

    session.interruptEnemyFunction();

    expect(session.state.outcome, CombatOutcome.active);
    expect(
      session.phase,
      anyOf(
        AshfangRematchPhaseV1.playerTurn,
        AshfangRematchPhaseV1.reactionWindow,
      ),
    );
  });

  test('guard is a legal independent decision', () {
    final session = AshfangRematchV1Session();

    session.guard();

    expect(session.phase, AshfangRematchPhaseV1.reactionWindow);
    expect(session.state.actor('hero').mana, 100);
  });
}
