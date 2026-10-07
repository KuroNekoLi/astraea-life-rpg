import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game_engine/combat/v1/combat_models.dart';
import 'ashfang_rematch_v1_session.dart';

final ashfangRematchV1Provider =
    NotifierProvider<AshfangRematchV1Controller, AshfangRematchV1ViewState>(
      AshfangRematchV1Controller.new,
    );

final class AshfangRematchV1ViewState {
  const AshfangRematchV1ViewState({required this.battle, required this.phase});

  factory AshfangRematchV1ViewState.fromSession(
    AshfangRematchV1Session session,
  ) {
    return AshfangRematchV1ViewState(
      battle: session.state,
      phase: session.phase,
    );
  }

  final BattleStateV1 battle;
  final AshfangRematchPhaseV1 phase;

  String? get activePlayerId {
    final id = battle.activeTurn?.actorId;
    if (id == null) return null;
    return battle.actor(id).side == BattleSide.player ? id : null;
  }

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

final class AshfangRematchV1Controller
    extends Notifier<AshfangRematchV1ViewState> {
  late AshfangRematchV1Session _session;

  @override
  AshfangRematchV1ViewState build() {
    _session = AshfangRematchV1Session();
    return AshfangRematchV1ViewState.fromSession(_session);
  }

  void reset() {
    _session.reset();
    _sync();
  }

  void basicAttack() {
    _session.basicAttack();
    _sync();
  }

  void guard() {
    _session.guard();
    _sync();
  }

  void castHeroFireballI() {
    _session.castHeroFireballI();
    _sync();
  }

  void beginHeroFireballIIFullChant() {
    _session.beginHeroFireballIIFullChant();
    _sync();
  }

  void analyzeEnemyFunction() {
    _session.analyzeEnemyFunction();
    _sync();
  }

  void interruptEnemyFunction({bool exploitWeakNode = false}) {
    _session.interruptEnemyFunction(exploitWeakNode: exploitWeakNode);
    _sync();
  }

  void saveReaction() {
    _session.saveReaction();
    _sync();
  }

  void _sync() {
    state = AshfangRematchV1ViewState.fromSession(_session);
  }
}
