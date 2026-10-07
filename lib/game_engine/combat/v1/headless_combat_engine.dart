import 'combat_actions.dart';
import 'combat_models.dart';

/// Pure Dart CTB combat core for Astraea combat milestones.
///
/// M1: Timeline, Move, Main Action, Mana, damage/resistance, Guard and KO.
/// M2: Full Chant / Chantless lifecycle and recovery.
/// M3: Quick Actions, Reaction charges and deterministic Interrupt/Stability.
/// M4: Analysis, Function Knowledge, Weak Nodes and active-Function Counter.
final class HeadlessCombatEngineV1 {
  const HeadlessCombatEngineV1();

  BattleStateV1 start({
    required Iterable<CombatantStateV1> combatants,
    required Map<String, int> initialTurnTimes,
    Iterable<FunctionKnowledgeV1> initialKnowledge = const [],
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
      functionKnowledge: initialKnowledge,
    );
  }

  BattleStateV1 scheduleEvent(
    BattleStateV1 state, {
    required String id,
    required TimelineEventType type,
    required int scheduledAt,
    String? actorId,
    String? functionId,
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
      functionId: functionId,
    );
    return BattleStateV1(
      combatants: state.combatants,
      timeline: [...state.timeline, event],
      activeFunctions: state.activeFunctions,
      functionKnowledge: state.functionKnowledge,
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
        if (!actor.isActive || state.castingFunctionFor(actor.id) != null) {
          continue;
        }

        final refreshedActor = actor.copyWith(
          guardDamageReductionPercent: 0,
          reactionAvailable: true,
        );
        final actors = _replaceActor(state.combatants, refreshedActor);
        final nextState = BattleStateV1(
          combatants: actors,
          timeline: remaining,
          activeFunctions: state.activeFunctions,
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
        activeFunctions: state.activeFunctions,
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
      activeFunctions: state.activeFunctions,
      functionKnowledge: state.functionKnowledge,
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
      _requireTarget(actor, target, action.targetZones);

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
      throw StateError('This action does not use a target');
    }

    if (action.kind == CombatActionKind.guard) {
      units[actor.id] = units[actor.id]!.copyWith(
        guardDamageReductionPercent: action.guardDamageReductionPercent,
      );
      log.add('guarded:${actor.id}:${action.guardDamageReductionPercent}');
    }

    return _finishMainAction(
      state,
      units: units,
      actionDelay: action.actionDelay,
      log: log,
    );
  }

  BattleStateV1 useQuickAction(
    BattleStateV1 state,
    UseQuickActionCommandV1 command,
  ) {
    final turn = _requireActorTurn(state, command.actorId);
    if (turn.quickUsed) {
      throw StateError('Quick Action is already spent for this turn');
    }
    final actor = state.actor(command.actorId);
    if (actor.mana < command.action.manaCost) {
      throw StateError('Insufficient Mana');
    }
    final paidActor = actor.copyWith(
      mana: actor.mana - command.action.manaCost,
    );
    return BattleStateV1(
      combatants: _replaceActor(state.combatants, paidActor),
      timeline: state.timeline,
      activeFunctions: state.activeFunctions,
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: state.nextSequence,
      revision: state.revision + 1,
      activeTurn: turn.copyWith(quickUsed: true),
      outcome: state.outcome,
      eventLog: [
        ...state.eventLog,
        'quickAction:${actor.id}:${command.action.id}',
      ],
    );
  }

  BattleStateV1 interruptFunction(
    BattleStateV1 state,
    InterruptFunctionCommandV1 command,
  ) {
    _ensureBattleActive(state);
    final function = state.function(command.functionId);
    if (function.status != ActiveFunctionStatusV1.casting ||
        state.currentTime >= function.resolveAt) {
      throw StateError('Interrupt window is closed');
    }

    final interrupter = state.actor(command.actorId);
    final caster = state.actor(function.casterId);
    if (!interrupter.isActive || interrupter.side == caster.side) {
      throw StateError('Interrupt must target an opposing casting Function');
    }
    if (interrupter.mana < command.interrupt.manaCost) {
      throw StateError('Insufficient Mana');
    }

    final units = {for (final unit in state.combatants) unit.id: unit};
    var functions = state.activeFunctions.toList();
    var timeline = state.timeline.toList();
    var nextSequence = state.nextSequence;
    ActiveTurnV1? activeTurn = state.activeTurn;

    if (command.asReaction) {
      if (!interrupter.reactionAvailable) {
        throw StateError('Reaction charge is not available');
      }
      if (function.reactionConsumed) {
        throw StateError(
          'This trigger window already resolved a Party Reaction',
        );
      }
      if (state.castingFunctionFor(interrupter.id) != null &&
          !command.interrupt.castingCompatible) {
        throw StateError('Reaction is not Casting-Compatible');
      }
      units[interrupter.id] = interrupter.copyWith(
        mana: interrupter.mana - command.interrupt.manaCost,
        reactionAvailable: false,
      );
      functions = [
        for (final candidate in functions)
          if (candidate.id == function.id)
            candidate.copyWith(reactionConsumed: true)
          else
            candidate,
      ];
    } else {
      _requireActorTurn(state, command.actorId);
      units[interrupter.id] = interrupter.copyWith(
        mana: interrupter.mana - command.interrupt.manaCost,
      );
      activeTurn = null;
    }

    var weakNodeBonus = 0;
    if (command.weakNodeId != null) {
      final knowledge = state.knowledgeFor(interrupter.id, function.actionId);
      if (knowledge == null ||
          !knowledge.revealedWeakNodeIds.contains(command.weakNodeId)) {
        throw StateError('Weak Node has not been revealed to this combatant');
      }
      final bonus = function.weakNodeInterruptBonuses[command.weakNodeId];
      if (bonus == null) {
        throw StateError('Weak Node is not valid for this Function');
      }
      weakNodeBonus = bonus;
    }
    final effectiveInterruptPower =
        command.interrupt.interruptPower + weakNodeBonus;
    final success = effectiveInterruptPower >= function.stability;
    final log = <String>[
      ...state.eventLog,
      'interruptAttempt:${interrupter.id}:${function.id}:ip=$effectiveInterruptPower',
    ];

    if (success) {
      final refund = function.manaCost ~/ 2;
      final currentCaster = units[caster.id]!;
      units[caster.id] = currentCaster.copyWith(
        mana: (currentCaster.mana + refund)
            .clamp(0, currentCaster.maxMana)
            .toInt(),
      );
      functions = functions
          .where((candidate) => candidate.id != function.id)
          .toList();
      timeline = timeline
          .where((event) => event.functionId != function.id)
          .toList();
      if (units[caster.id]!.isActive) {
        timeline.add(
          TimelineEventV1(
            id: 'turn:${caster.id}:$nextSequence',
            type: TimelineEventType.characterTurn,
            scheduledAt: state.currentTime + function.recoveryDelay,
            sequence: nextSequence,
            actorId: caster.id,
          ),
        );
        nextSequence++;
      }
      log
        ..add('interrupted:${interrupter.id}:${function.id}')
        ..add('manaRefund:${caster.id}:$refund');
    } else {
      final reducedStability =
          (function.stability - command.interrupt.stabilityDamage)
              .clamp(0, function.stability)
              .toInt();
      functions = [
        for (final candidate in functions)
          if (candidate.id == function.id)
            candidate.copyWith(
              stability: reducedStability,
              reactionConsumed: command.asReaction
                  ? true
                  : candidate.reactionConsumed,
            )
          else
            candidate,
      ];
      log.add(
        'interruptFailed:${interrupter.id}:${function.id}:stability=$reducedStability',
      );
    }

    if (!command.asReaction) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:${interrupter.id}:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + command.interrupt.actionDelay,
          sequence: nextSequence,
          actorId: interrupter.id,
        ),
      );
      nextSequence++;
    }

    return BattleStateV1(
      combatants: units.values,
      timeline: timeline,
      activeFunctions: functions,
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      activeTurn: activeTurn,
      outcome: _outcome(units.values, functions),
      eventLog: log,
    );
  }

  BattleStateV1 analyzeFunction(
    BattleStateV1 state,
    AnalyzeFunctionCommandV1 command,
  ) {
    _requireActorTurn(state, command.actorId);
    final analyst = state.actor(command.actorId);
    final function = state.function(command.functionId);
    final caster = state.actor(function.casterId);
    if (analyst.side == caster.side) {
      throw StateError('Analysis target must be an opposing Function');
    }
    if (analyst.mana < command.analysis.manaCost) {
      throw StateError('Insufficient Mana');
    }

    final existing =
        state.knowledgeFor(analyst.id, function.actionId) ??
        FunctionKnowledgeV1(
          observerId: analyst.id,
          signatureId: function.actionId,
        );
    var level = existing.level;
    if (command.analysis.revealLevel.index > level.index) {
      level = command.analysis.revealLevel;
    }
    if (command.analysis.revealWeakNodes &&
        FunctionKnowledgeLevelV1.weakNode.index > level.index) {
      level = FunctionKnowledgeLevelV1.weakNode;
    }
    if (command.analysis.revealCounterPath &&
        FunctionKnowledgeLevelV1.counterPath.index > level.index) {
      level = FunctionKnowledgeLevelV1.counterPath;
    }

    final updatedKnowledge = existing.copyWith(
      level: level,
      knownStability: command.analysis.revealStability
          ? function.stability
          : existing.knownStability,
      revealedWeakNodeIds: command.analysis.revealWeakNodes
          ? {
              ...existing.revealedWeakNodeIds,
              ...function.weakNodeInterruptBonuses.keys,
            }
          : existing.revealedWeakNodeIds,
      knownCounterTags: command.analysis.revealCounterPath
          ? {...existing.knownCounterTags, ...function.counterTags}
          : existing.knownCounterTags,
      reversibilityKnown: command.analysis.revealCounterPath
          ? function.reversible
          : existing.reversibilityKnown,
    );
    final knowledge = _upsertKnowledge(
      state.functionKnowledge,
      updatedKnowledge,
    );
    final units = {for (final unit in state.combatants) unit.id: unit};
    units[analyst.id] = analyst.copyWith(
      mana: analyst.mana - command.analysis.manaCost,
    );
    return _finishMainAction(
      state,
      units: units,
      actionDelay: command.analysis.actionDelay,
      log: [
        ...state.eventLog,
        'analysis:${analyst.id}:${function.id}:${level.name}',
      ],
      functionKnowledge: knowledge,
    );
  }

  BattleStateV1 counterFunction(
    BattleStateV1 state,
    CounterFunctionCommandV1 command,
  ) {
    _ensureBattleActive(state);
    final function = state.function(command.functionId);
    if (function.status != ActiveFunctionStatusV1.active ||
        state.currentTime >= function.resolveAt) {
      throw StateError('Counter window is closed');
    }

    final counterUser = state.actor(command.actorId);
    final caster = state.actor(function.casterId);
    if (!counterUser.isActive || counterUser.side == caster.side) {
      throw StateError('Counter must target an opposing active Function');
    }
    if (counterUser.mana < command.counter.manaCost) {
      throw StateError('Insufficient Mana');
    }
    if (command.counter.requiresReversibility && !function.reversible) {
      throw StateError('Function is not reversible');
    }
    if (command.counter.compatibleTags
        .intersection(function.counterTags)
        .isEmpty) {
      throw StateError('Counter is not compatible with this Function');
    }
    if (command.counter.requiresCounterPath) {
      final knowledge = state.knowledgeFor(counterUser.id, function.actionId);
      if (knowledge == null ||
          knowledge.level.index < FunctionKnowledgeLevelV1.counterPath.index ||
          knowledge.knownCounterTags
              .intersection(function.counterTags)
              .isEmpty) {
        throw StateError('Counter path has not been established');
      }
      if (command.counter.requiresReversibility &&
          !knowledge.reversibilityKnown) {
        throw StateError('Reversibility has not been established');
      }
    }

    final units = {for (final unit in state.combatants) unit.id: unit};
    var activeTurn = state.activeTurn;
    if (command.asReaction) {
      if (!counterUser.reactionAvailable) {
        throw StateError('Reaction charge is not available');
      }
      if (function.reactionConsumed) {
        throw StateError(
          'This trigger window already resolved a Party Reaction',
        );
      }
      if (state.castingFunctionFor(counterUser.id) != null &&
          !command.counter.castingCompatible) {
        throw StateError('Reaction is not Casting-Compatible');
      }
      units[counterUser.id] = counterUser.copyWith(
        mana: counterUser.mana - command.counter.manaCost,
        reactionAvailable: false,
      );
    } else {
      _requireActorTurn(state, command.actorId);
      units[counterUser.id] = counterUser.copyWith(
        mana: counterUser.mana - command.counter.manaCost,
      );
      activeTurn = null;
    }

    var timeline = state.timeline
        .where((event) => event.functionId != function.id)
        .toList();
    final functions = state.activeFunctions
        .where((candidate) => candidate.id != function.id)
        .toList();
    var nextSequence = state.nextSequence;
    if (!command.asReaction && units[counterUser.id]!.isActive) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:${counterUser.id}:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + command.counter.actionDelay,
          sequence: nextSequence,
          actorId: counterUser.id,
        ),
      );
      nextSequence++;
    }

    final outcome = _outcome(units.values, functions);
    return BattleStateV1(
      combatants: units.values,
      timeline: timeline,
      activeFunctions: functions,
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      activeTurn: activeTurn,
      outcome: outcome,
      eventLog: [
        ...state.eventLog,
        'countered:${counterUser.id}:${function.id}:${command.counter.id}',
      ],
    );
  }

  BattleStateV1 beginFullChant(
    BattleStateV1 state,
    BeginFullChantCommandV1 command,
  ) {
    _requireActorTurn(state, command.actorId);
    final actor = state.actor(command.actorId);
    final target = state.actor(command.targetId);
    final spell = command.spell;
    _requireTarget(actor, target, spell.targetZones);
    if (actor.mana < spell.manaCost) {
      throw StateError('Insufficient Mana');
    }
    if (state.castingFunctionFor(actor.id) != null) {
      throw StateError('Caster is already maintaining a Full Chant');
    }

    final functionId = 'function:${actor.id}:${state.nextSequence}';
    final resolveAt = state.currentTime + spell.castTime;
    final function = ActiveFunctionV1(
      id: functionId,
      actionId: spell.id,
      casterId: actor.id,
      targetId: target.id,
      status: ActiveFunctionStatusV1.casting,
      manaCost: spell.manaCost,
      rawDamage: spell.rawDamage,
      damageType: spell.damageType,
      targetZones: spell.targetZones,
      stability: spell.stability,
      startedAt: state.currentTime,
      resolveAt: resolveAt,
      recoveryDelay: spell.recoveryDelay,
      executionDelay: spell.executionDelay,
      weakNodeInterruptBonuses: spell.weakNodeInterruptBonuses,
      reversible: spell.reversible,
      counterTags: spell.counterTags,
    );
    final event = TimelineEventV1(
      id: 'resolve:$functionId',
      type: TimelineEventType.spellResolve,
      scheduledAt: resolveAt,
      sequence: state.nextSequence,
      actorId: actor.id,
      functionId: functionId,
    );
    final paidActor = actor.copyWith(mana: actor.mana - spell.manaCost);

    return BattleStateV1(
      combatants: _replaceActor(state.combatants, paidActor),
      timeline: [...state.timeline, event],
      activeFunctions: [...state.activeFunctions, function],
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: state.nextSequence + 1,
      revision: state.revision + 1,
      outcome: state.outcome,
      eventLog: [...state.eventLog, 'fullChantStarted:${actor.id}:${spell.id}'],
    );
  }

  BattleStateV1 cancelFullChant(
    BattleStateV1 state,
    CancelFullChantCommandV1 command,
  ) {
    _ensureBattleActive(state);
    final function = state.castingFunctionFor(command.actorId);
    if (function == null) {
      throw StateError('Caster is not in Full Chant');
    }
    final actor = state.actor(command.actorId);
    final refund = function.manaCost ~/ 2;
    final refundedActor = actor.copyWith(
      mana: (actor.mana + refund).clamp(0, actor.maxMana).toInt(),
    );
    final timeline = state.timeline
        .where((event) => event.functionId != function.id)
        .toList();
    final functions = state.activeFunctions
        .where((candidate) => candidate.id != function.id)
        .toList();
    var nextSequence = state.nextSequence;
    if (state.outcome == CombatOutcome.active && refundedActor.isActive) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:${actor.id}:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + function.recoveryDelay,
          sequence: nextSequence,
          actorId: actor.id,
        ),
      );
      nextSequence++;
    }

    return BattleStateV1(
      combatants: _replaceActor(state.combatants, refundedActor),
      timeline: timeline,
      activeFunctions: functions,
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      outcome: state.outcome,
      eventLog: [
        ...state.eventLog,
        'fullChantCancelled:${actor.id}:${function.actionId}',
        'manaRefund:${actor.id}:$refund',
      ],
    );
  }

  BattleStateV1 resolveTimelineEvent(
    BattleStateV1 state,
    TimelineEventV1 event,
  ) {
    _ensureBattleActive(state);
    if (state.activeTurn != null) {
      throw StateError(
        'Timeline events cannot resolve during a character turn',
      );
    }
    if (event.scheduledAt != state.currentTime) {
      throw StateError('Timeline event is not ready at the current time');
    }
    if (event.functionId == null) {
      return state;
    }

    final function = state.function(event.functionId!);
    if (event.type == TimelineEventType.spellResolve) {
      if (function.status != ActiveFunctionStatusV1.casting) {
        throw StateError('Only a casting Function can become established');
      }
      final caster = state.actor(function.casterId);
      final target = state.actor(function.targetId);
      if (!caster.isActive ||
          !target.isActive ||
          !_targetIsInRange(target, function.targetZones)) {
        return _finishFailedFunction(state, function);
      }

      if (function.executionDelay > 0) {
        final effectAt = state.currentTime + function.executionDelay;
        final established = function.copyWith(
          status: ActiveFunctionStatusV1.active,
          resolveAt: effectAt,
          reactionConsumed: false,
        );
        final functions = [
          for (final candidate in state.activeFunctions)
            if (candidate.id == function.id) established else candidate,
        ];
        final timeline = [
          ...state.timeline,
          TimelineEventV1(
            id: 'effect:${function.id}',
            type: TimelineEventType.battlefieldFunction,
            scheduledAt: effectAt,
            sequence: state.nextSequence,
            actorId: function.casterId,
            functionId: function.id,
          ),
        ];
        var nextSequence = state.nextSequence + 1;
        if (caster.isActive) {
          timeline.add(
            TimelineEventV1(
              id: 'turn:${caster.id}:$nextSequence',
              type: TimelineEventType.characterTurn,
              scheduledAt: state.currentTime + function.recoveryDelay,
              sequence: nextSequence,
              actorId: caster.id,
            ),
          );
          nextSequence++;
        }
        return BattleStateV1(
          combatants: state.combatants,
          timeline: timeline,
          activeFunctions: functions,
          functionKnowledge: state.functionKnowledge,
          currentTime: state.currentTime,
          nextSequence: nextSequence,
          revision: state.revision + 1,
          outcome: _outcome(state.combatants, functions),
          eventLog: [
            ...state.eventLog,
            'functionEstablished:${function.casterId}:${function.actionId}',
          ],
        );
      }
      return _resolveFunctionEffect(
        state,
        function,
        scheduleCasterRecovery: true,
      );
    }

    if (event.type == TimelineEventType.battlefieldFunction) {
      if (function.status != ActiveFunctionStatusV1.active) {
        throw StateError('Only an active Function can resolve its effect');
      }
      return _resolveFunctionEffect(
        state,
        function,
        scheduleCasterRecovery: false,
      );
    }
    return state;
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

  BattleStateV1 _finishMainAction(
    BattleStateV1 state, {
    required Map<String, CombatantStateV1> units,
    required int actionDelay,
    required List<String> log,
    Iterable<FunctionKnowledgeV1>? functionKnowledge,
  }) {
    final functions = state.activeFunctions.where((function) {
      final casterActive = units[function.casterId]?.isActive == true;
      return casterActive || function.status == ActiveFunctionStatusV1.active;
    }).toList();
    final validFunctionIds = functions.map((function) => function.id).toSet();
    var timeline = state.timeline
        .where(
          (event) =>
              (event.functionId == null ||
                  validFunctionIds.contains(event.functionId)) &&
              (event.type != TimelineEventType.characterTurn ||
                  event.actorId == null ||
                  units[event.actorId]?.isActive != false),
        )
        .toList();

    final actorId = state.activeTurn!.actorId;
    final outcome = _outcome(units.values, functions);
    var nextSequence = state.nextSequence;
    if (outcome == CombatOutcome.active && units[actorId]!.isActive) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:$actorId:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + actionDelay,
          sequence: nextSequence,
          actorId: actorId,
        ),
      );
      nextSequence++;
    }

    return BattleStateV1(
      combatants: units.values,
      timeline: timeline,
      activeFunctions: functions,
      functionKnowledge: functionKnowledge ?? state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      outcome: outcome,
      eventLog: log,
    );
  }

  BattleStateV1 _finishFailedFunction(
    BattleStateV1 state,
    ActiveFunctionV1 function,
  ) {
    final functions = state.activeFunctions
        .where((candidate) => candidate.id != function.id)
        .toList();
    final timeline = state.timeline
        .where((event) => event.functionId != function.id)
        .toList();
    var nextSequence = state.nextSequence;
    final caster = state.actor(function.casterId);
    if (caster.isActive) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:${caster.id}:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + function.recoveryDelay,
          sequence: nextSequence,
          actorId: caster.id,
        ),
      );
      nextSequence++;
    }
    return BattleStateV1(
      combatants: state.combatants,
      timeline: timeline,
      activeFunctions: functions,
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      outcome: _outcome(state.combatants, functions),
      eventLog: [
        ...state.eventLog,
        'functionFailed:${function.casterId}:${function.actionId}',
      ],
    );
  }

  BattleStateV1 _resolveFunctionEffect(
    BattleStateV1 state,
    ActiveFunctionV1 function, {
    required bool scheduleCasterRecovery,
  }) {
    final units = {for (final unit in state.combatants) unit.id: unit};
    final target = units[function.targetId]!;
    final caster = units[function.casterId]!;
    final log = <String>[...state.eventLog];

    if (target.isActive && _targetIsInRange(target, function.targetZones)) {
      final resisted = _applyResistance(
        function.rawDamage,
        function.damageType,
        target,
      );
      final damage = _applyGuard(resisted, target);
      final hpAfter = (target.hp - damage).clamp(0, target.maxHp).toInt();
      final defeated = hpAfter == 0;
      units[target.id] = target.copyWith(
        hp: hpAfter,
        condition: defeated ? CombatantCondition.defeated : target.condition,
      );
      log
        ..add('functionResolved:${caster.id}:${function.actionId}')
        ..add('damage:${caster.id}:${target.id}:$damage');
      if (defeated) {
        log.add('defeated:${target.id}');
      }
    } else {
      log.add('functionFailed:${caster.id}:${function.actionId}');
    }

    final functions = state.activeFunctions
        .where((candidate) => candidate.id != function.id)
        .toList();
    final outcome = _outcome(units.values, functions);
    final timeline = state.timeline
        .where(
          (pending) =>
              pending.functionId != function.id &&
              (pending.type != TimelineEventType.characterTurn ||
                  pending.actorId == null ||
                  units[pending.actorId]?.isActive != false),
        )
        .toList();
    var nextSequence = state.nextSequence;
    if (scheduleCasterRecovery &&
        outcome == CombatOutcome.active &&
        units[caster.id]!.isActive) {
      timeline.add(
        TimelineEventV1(
          id: 'turn:${caster.id}:$nextSequence',
          type: TimelineEventType.characterTurn,
          scheduledAt: state.currentTime + function.recoveryDelay,
          sequence: nextSequence,
          actorId: caster.id,
        ),
      );
      nextSequence++;
    }

    return BattleStateV1(
      combatants: units.values,
      timeline: timeline,
      activeFunctions: functions,
      functionKnowledge: state.functionKnowledge,
      currentTime: state.currentTime,
      nextSequence: nextSequence,
      revision: state.revision + 1,
      outcome: outcome,
      eventLog: log,
    );
  }

  static List<FunctionKnowledgeV1> _upsertKnowledge(
    Iterable<FunctionKnowledgeV1> entries,
    FunctionKnowledgeV1 updated,
  ) {
    final result = <FunctionKnowledgeV1>[];
    var replaced = false;
    for (final entry in entries) {
      if (entry.observerId == updated.observerId &&
          entry.signatureId == updated.signatureId) {
        result.add(updated);
        replaced = true;
      } else {
        result.add(entry);
      }
    }
    if (!replaced) {
      result.add(updated);
    }
    return result;
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

  static void _requireTarget(
    CombatantStateV1 actor,
    CombatantStateV1 target,
    Set<BattleZone> targetZones,
  ) {
    if (!target.isActive || target.side == actor.side) {
      throw StateError('Target must be an active opponent');
    }
    if (!_targetIsInRange(target, targetZones)) {
      throw StateError('Target is outside the action range');
    }
  }

  static bool _targetIsInRange(
    CombatantStateV1 target,
    Set<BattleZone> targetZones,
  ) {
    return targetZones.isEmpty || targetZones.contains(target.zone);
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

  static CombatOutcome _outcome(
    Iterable<CombatantStateV1> actors, [
    Iterable<ActiveFunctionV1> functions = const [],
  ]) {
    final actorList = actors.toList(growable: false);
    bool sideHasThreat(BattleSide side) {
      if (actorList.any((actor) => actor.side == side && actor.isActive)) {
        return true;
      }
      return functions.any((function) {
        if (function.status != ActiveFunctionStatusV1.active) {
          return false;
        }
        return actorList
                .firstWhere((actor) => actor.id == function.casterId)
                .side ==
            side;
      });
    }

    final playerThreat = sideHasThreat(BattleSide.player);
    final enemyThreat = sideHasThreat(BattleSide.enemy);
    if (!playerThreat) return CombatOutcome.defeat;
    if (!enemyThreat) return CombatOutcome.victory;
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
