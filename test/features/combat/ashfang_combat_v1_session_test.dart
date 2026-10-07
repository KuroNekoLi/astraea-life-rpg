import 'package:astraea_life_rpg/features/combat/application/ashfang_combat_v1_session.dart';
import 'package:astraea_life_rpg/game_engine/combat/v1/combat_models.dart';
import 'package:test/test.dart';

void main() {
  test(
    'guided Ashfang CTB path reaches victory through real engine states',
    () {
      final session = AshfangCombatV1Session();

      expect(session.stage, AshfangTutorialStageV1.heroChantless);
      expect(session.state.activeTurn?.actorId, 'hero');

      session.heroFireballIChantless();
      expect(session.stage, AshfangTutorialStageV1.knownReaction);
      expect(session.enemyCastingFunction?.actionId, 'known-fireball');

      session.interruptKnownFireball();
      expect(session.stage, AshfangTutorialStageV1.modifiedAnalysis);
      expect(session.state.activeTurn?.actorId, 'rio');
      expect(session.enemyCastingFunction?.actionId, 'modified-fireball');

      session.analyzeModifiedFireball();
      expect(session.stage, AshfangTutorialStageV1.modifiedInterrupt);
      expect(session.canUseWeakNode, isTrue);
      expect(session.rioKnowledge?.knownStability, 58);

      session.interruptModifiedWeakNode();
      expect(session.stage, AshfangTutorialStageV1.heroFullChant);
      expect(session.state.activeTurn?.actorId, 'hero');

      session.beginHeroFireballIIFullChant();
      expect(session.stage, AshfangTutorialStageV1.heroFinisher);
      expect(session.state.actor('ashfang').hp, 15);
      expect(session.state.activeTurn?.actorId, 'hero');

      session.finishWithFireballI();
      expect(session.stage, AshfangTutorialStageV1.victory);
      expect(session.state.outcome, CombatOutcome.victory);
      expect(session.state.actor('ashfang').hp, 0);
    },
  );

  test('saving the first reaction resolves the known spell then continues', () {
    final session = AshfangCombatV1Session()
      ..heroFireballIChantless()
      ..saveKnownReaction();

    expect(session.stage, AshfangTutorialStageV1.modifiedAnalysis);
    expect(session.state.actor('hero').hp, lessThan(220));
    expect(session.enemyCastingFunction?.actionId, 'modified-fireball');
  });

  test(
    'modified Function can resolve when player saves the weak-node reaction',
    () {
      final session = AshfangCombatV1Session()
        ..heroFireballIChantless()
        ..interruptKnownFireball()
        ..analyzeModifiedFireball()
        ..allowModifiedFireballToResolve();

      expect(session.stage, AshfangTutorialStageV1.heroFullChant);
      expect(session.state.actor('hero').hp, lessThan(220));
      expect(session.state.activeTurn?.actorId, 'hero');
    },
  );
}
