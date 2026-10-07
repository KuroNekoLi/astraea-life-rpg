import 'combat_actions.dart';
import 'combat_models.dart';

/// Pure Dart CTB combat core for Combat M1.
///
/// M1 intentionally covers Timeline, one free adjacent-Zone move, Main Actions,
/// Mana, resistance-based damage, Guard, KO, and battle outcome only.
/// Full Chant, Quick Actions, Reactions, Interrupt, Analysis, and AI are later
/// milestones.
final class HeadlessCombatEngineV1 {
  const HeadlessCombatEngineV1();

  BattleStateV1 start({
    required Iterable<CombatantStateV1> combatants,
    required Map<String, int> initialTurnTimes,
  }) {
    final actors = combatants.toList(growable: false);
    final ids = actors.map((actor) => actor.id).toSet();
    if (ids.length != actors.length ||
        initialTurnTimes.keys.toSet().difference(ids).isNotEmpty ||
        ids.difference(initialTurnTimes.keys.toSet()).isNotEmpty ||
        initialTurnTimes.values.any((time) => time < 0)) {
      throw ArgumentError('Initial timeline must cover each combatant once');
    }

    var sequence = 0;
    final timeline = <TimelineEventV1>[
      for (final actor in actors)
        TimelineEventV1(
          id: 'turn:${actor.id}:0',
          type: TimelineEventType.characterTurn,
          scheduledAt: initialTurnTimes[actor.id]!,
          sequence: sequence++,
          actorId: actor.id,
        ),
    ];

    return BattleStateV1(
      combatants: actors,
      timeline: timeline,
      currentTime: 0,
      nextSequence: sequence,
      revision: 0,
    );
  }

  BattleStateV1 scheduleEvent(
    BattleStateV1 state, {
    required String id,
    required TimelineEventType type,
    required int scheduledAt,
    String? actorId,
  }) {
    _ensureBattleActive(state);
    if (scheduledAt < state.currentTime) {
      throw StateError('Cannot schedule an event in the past');
    }
    if (state.timeline.any((event) => event.id == id)) {
      throw StateError('Timeline event ids must be unique');
    }
    final event = TimelineEventV1(
      id: id,
      type: type,
      scheduledAt: scheduledAt,
      sequence: state.nextSequence,
      actorId: actorId,
    );
    return BattleStateV1(
      combatants: state.combatants,
      timeline: [...state.timeline, event],
      currentTime: state.currentTime,
      nextSequence: state.nextSequence + 1,
      revision: state.revision + 1,
      activeTurn: state.activeTurn,
      outcome: state.outcome,
      eventLog: [...state.eventLog, 'scheduled:$id'],
    );
  }

  TimelineAdvanceV1 advance(BattleStateV1 state) {
    _ensureBattleActive(state);
    if (state.activeTurn != null) {
      throw StateError('Resolve the active character turn before advancing');
    }

    final remaining = state.timeline.toList();
    while (remaining.isNotEmpty) {
      final event = remaining.removeAt(0);
      if (event.type == TimelineEventType.characterTurn) {
        final actor = state.actor(event.actorId!);
        if (!actor.isActive) {
          continue;
        }

        final refreshedActor = actor.copyWith(guardDamageReductionPercent: 0);
        final actors = _replaceActor(state.combatants, refreshedActor);
        final nextState = BattleStateV1(
          combatants: actors,
          timeline: remaining,
          currentTime: event.scheduledAt,
          nextSequence: state.nextSequence,
          revision: state.revision + 1,
          activeTurn: ActiveTurnV1(actorId: actor.id),
          outcome: state.outcome,
          eventLog: [...state.eventLog, 'turnStarted:${actor.id}'],
        );
        return TimelineAdvanceV1(state: nextState, event: event);
      }

      final nextState = BattleStateV1(
        combatants: state.combatants,
        timeline: remaining,
        currentTime: event.scheduledAt,
        nextSequence: state.nextSequence,
        revision: state.revision + 1,
        outcome: state.outcome,
        eventLog: [...state.eventLog, 'eventReady:${event.id}'],
      );
      return TimelineAdvanceV1(state: nextState, event: event);
    }

    throw StateError('No timeline events remain');
  }

  BattleStateV1 move(BattleStateV1 state, MoveCommandV1 command) {
    final turn = _requireActorTurn(state, command.actorId);
    if (turn.moveUsed) {
      throw StateError('Normal Move is already spent for this turn');
    }

    final actor = state.actor(command.actorId);
    if (!_areAdjacent(actor.zone, command.destination)) {
      throw StateError('Normal Move can only enter an adjacent Zone');
    }

    final moved = actor.copyWith(zone: command.destination);
    return BattleStateV1(
      combatants: _replaceActor(state.combatants, moved),
      timeline: state.timeline,
      currentTime: state.currentTime,
      nextSequence: state.nextSequence,
      revision: state.revision + 1,
      activeTurn: turn.copyWith(moveUsed: true),
      outcome: state.outcome,
      eventLog: [
        ...state.eventLog,
        'moved:${actor.id}:${actor.zone.name}->${command.destination.name}',
      ],
    );
  }

  BattleStateV1 useAction(BattleStateV1 state, UseActionCommandV1 command) {
    _requireActorTurn(state, command.actorId);
    final action = command.action;
    final actor = state.actor(command.actorId);

    if (actor.mana < action.manaCost) {
      throw StateError('Insufficient Mana');
    }

    final units = {for (final unit in state.combatants) unit.id: unit};
    final manaAfterCost = actor.mana - action.manaCost;
    final manaAfterRecovery = (manaAfterCost + action.manaRecovery)
        .clamp(0, actor.maxMana)
        .toInt();
    units[actor.id] = actor.copyWith(mana: manaAfterRecovery);

    final log = <String>[...state.eventLog, 'action:${actor.id}:${action.id}'];

    if (action.dealsDamage) {
      final targetId = command.targetId;
      if (targetId == null) {
        throw StateError('Damaging actions require a target');
      }
      final target = state.actor(targetId);
      if (!target.isActive || target.side == actor.side) {
        throw StateError('Target must be an active opponent');
      }
      if (action.targetZones.isNotEmpty &&
          !action.targetZones.contains(target.zone)) {
        throw StateError('Target is outside the action range');
      }

      final resisted = _applyResistance(
        action.rawDamage,
        action.damageType!,
        target,
      );
      final finalDamage = _applyGuard(resisted, target);
      final hpAfter = (target.hp - finalDamage).clamp(0, target.maxHp).toInt();
      final defeated = hpAfter == 0;
      units[target.id] = target.copyWith(
        hp: hpAfter,
        condition: defeated ? CombatantCondition.defeated : target.condition,
      );
      log.add('damage:${actor.id}:${target.id}:$finalDamage');
      if (defeated) {
        log.add('defeated:${target.id}');
      }
    } else if (command.targetId != null) {
      throw StateError('This M1 action does not use a target');
    }

    if (action.kind == CombatActionKind.guard) {
      units[actor.id] = units[actor.id]!.copyWith(
        guardDamageReductionPercent: action.guardDamageReductionPercent,
      );
      log.add('guarded:${actor.id}:${action.guardDamageReductionPercent}');
    }

    var timeline = state.timeline
        .where(
          (event) =>
              event.type != TimelineEventType.characterTurn ||
              event.actorId == null ||
              units[event.actorId]?.isActive != false,
        )
        .toList();

    final outcome = _outcome(units.values);
    var nextSequence = state.nextSequence;
    if (outcome == CombatOutcome.active && units[actor.id]!.isActive) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:${actor.id}:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + action.actionDelay,
          sequence: nextSequence,
          actorId: actor.id,
        ),
      );
      nextSequence++;
    }

    return BattleStateV1(
      combatants: units.values,
      timeline: timeline,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      outcome: outcome,
      eventLog: log,
    );
  }

  int previewDamage({
    required CombatActionDefinitionV1 action,
    required CombatantStateV1 target,
  }) {
    if (!action.dealsDamage) return 0;
    return _applyGuard(
      _applyResistance(action.rawDamage, action.damageType!, target),
      target,
    );
  }

  ActiveTurnV1 _requireActorTurn(BattleStateV1 state, String actorId) {
    _ensureBattleActive(state);
    final turn = state.activeTurn;
    if (turn == null || turn.actorId != actorId) {
      throw StateError('It is not this combatant’s active turn');
    }
    if (!state.actor(actorId).isActive) {
      throw StateError('Defeated combatants cannot act');
    }
    return turn;
  }

  void _ensureBattleActive(BattleStateV1 state) {
    if (state.outcome != CombatOutcome.active) {
      throw StateError('Battle is already complete');
    }
  }

  static bool _areAdjacent(BattleZone from, BattleZone to) {
    return (from.index - to.index).abs() == 1;
  }

  static int _applyResistance(
    int rawDamage,
    DamageType damageType,
    CombatantStateV1 target,
  ) {
    final resistance = damageType == DamageType.physical
        ? target.physicalResistance
        : target.magicResistance;
    return (rawDamage * 100 / (100 + resistance)).round();
  }

  static int _applyGuard(int damage, CombatantStateV1 target) {
    if (target.guardDamageReductionPercent == 0) return damage;
    return (damage * (100 - target.guardDamageReductionPercent) / 100).round();
  }

  static CombatOutcome _outcome(Iterable<CombatantStateV1> actors) {
    final playerAlive = actors.any(
      (actor) => actor.side == BattleSide.player && actor.isActive,
    );
    final enemyAlive = actors.any(
      (actor) => actor.side == BattleSide.enemy && actor.isActive,
    );
    if (!enemyAlive) return CombatOutcome.victory;
    if (!playerAlive) return CombatOutcome.defeat;
    return CombatOutcome.active;
  }

  static List<CombatantStateV1> _replaceActor(
    Iterable<CombatantStateV1> actors,
    CombatantStateV1 replacement,
  ) {
    return [
      for (final actor in actors)
        if (actor.id == replacement.id) replacement else actor,
    ];
  }
}
