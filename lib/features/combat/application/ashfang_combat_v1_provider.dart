import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game_engine/combat/v1/combat_models.dart';
import 'ashfang_combat_v1_session.dart';

final ashfangCombatV1Provider =
    NotifierProvider<AshfangCombatV1Controller, AshfangCombatV1ViewState>(
      AshfangCombatV1Controller.new,
    );

final class AshfangCombatV1ViewState {
  const AshfangCombatV1ViewState({
    required this.battle,
    required this.stage,
    required this.feedback,
  });

  factory AshfangCombatV1ViewState.fromSession(
    AshfangCombatV1Session session,
  ) {
    return AshfangCombatV1ViewState(
      battle: session.state,
      stage: session.stage,
      feedback: session.feedback,
    );
  }

  final BattleStateV1 battle;
  final AshfangTutorialStageV1 stage;
  final AshfangTutorialFeedbackV1 feedback;

  ActiveFunctionV1? get enemyCastingFunction =>
      battle.castingFunctionFor('ashfang');

  FunctionKnowledgeV1? get rioKnowledge {
    final function = enemyCastingFunction;
    if (function == null) return null;
    return battle.knowledgeFor('rio', function.actionId);
  }

  bool get weakNodeRevealed =>
      rioKnowledge?.revealedWeakNodeIds.contains('stabilization') ?? false;
}

final class AshfangCombatV1Controller
    extends Notifier<AshfangCombatV1ViewState> {
  late AshfangCombatV1Session _session;

  @override
  AshfangCombatV1ViewState build() {
    _session = AshfangCombatV1Session();
    return AshfangCombatV1ViewState.fromSession(_session);
  }

  void reset() {
    _session.reset();
    _sync();
  }

  void heroFireballIChantless() {
    _session.heroFireballIChantless();
    _sync();
  }

  void interruptKnownFireball() {
    _session.interruptKnownFireball();
    _sync();
  }

  void saveKnownReaction() {
    _session.saveKnownReaction();
    _sync();
  }

  void analyzeModifiedFireball() {
    _session.analyzeModifiedFireball();
    _sync();
  }

  void interruptModifiedWeakNode() {
    _session.interruptModifiedWeakNode();
    _sync();
  }

  void allowModifiedFireballToResolve() {
    _session.allowModifiedFireballToResolve();
    _sync();
  }

  void beginHeroFireballIIFullChant() {
    _session.beginHeroFireballIIFullChant();
    _sync();
  }

  void finishWithFireballI() {
    _session.finishWithFireballI();
    _sync();
  }

  void _sync() {
    state = AshfangCombatV1ViewState.fromSession(_session);
  }
}
