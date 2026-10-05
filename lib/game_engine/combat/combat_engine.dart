import '../rng/rng.dart';

enum CombatSide { player, enemy }

enum CombatantCondition { active, defeated }

enum CombatOutcome { active, victory, defeat }

enum CombatActionKind { weaponAttack, spell, movement, reaction, wait }

final class CombatantState {
  CombatantState({
    required this.id,
    required this.side,
    required this.hp,
    required this.maxHp,
    required this.mana,
    required this.maxMana,
    required this.attackBonus,
    required this.defense,
    required this.processingModifier,
    required this.zone,
    required this.reactionAvailable,
    this.condition = CombatantCondition.active,
    this.mainActionUsed = false,
  }) {
    if (id.trim().isEmpty ||
        hp < 0 ||
        maxHp < 1 ||
        hp > maxHp ||
        mana < 0 ||
        maxMana < mana ||
        defense < 0) {
      throw ArgumentError('Invalid combatant state');
    }
  }

  final String id;
  final CombatSide side;
  final int hp;
  final int maxHp;
  final int mana;
  final int maxMana;
  final int attackBonus;
  final int defense;
  final int processingModifier;
  final String zone;
  final bool reactionAvailable;
  final CombatantCondition condition;
  final bool mainActionUsed;

  CombatantState copyWith({
    int? hp,
    int? mana,
    String? zone,
    bool? reactionAvailable,
    CombatantCondition? condition,
    bool? mainActionUsed,
  }) => CombatantState(
    id: id,
    side: side,
    hp: hp ?? this.hp,
    maxHp: maxHp,
    mana: mana ?? this.mana,
    maxMana: maxMana,
    attackBonus: attackBonus,
    defense: defense,
    processingModifier: processingModifier,
    zone: zone ?? this.zone,
    reactionAvailable: reactionAvailable ?? this.reactionAvailable,
    condition: condition ?? this.condition,
    mainActionUsed: mainActionUsed ?? this.mainActionUsed,
  );
}

final class CombatState {
  CombatState({
    required Iterable<CombatantState> combatants,
    required Iterable<String> initiativeOrder,
    required this.activeCombatantId,
    required this.round,
    required this.revision,
    Iterable<String> eventLog = const [],
    this.outcome = CombatOutcome.active,
    this.seed = 1,
    int? rngState,
  }) : combatants = List.unmodifiable(combatants),
       initiativeOrder = List.unmodifiable(initiativeOrder),
       eventLog = List.unmodifiable(eventLog),
       rngState = rngState ?? seed {
    if (this.combatants.map((unit) => unit.id).toSet().length !=
            this.combatants.length ||
        this.combatants.isEmpty ||
        !this.initiativeOrder.contains(activeCombatantId) ||
        round < 1 ||
        revision < 0 ||
        seed < 0 ||
        this.rngState < 0) {
      throw ArgumentError('Invalid battle state');
    }
  }
  final List<CombatantState> combatants;
  final List<String> initiativeOrder;
  final String activeCombatantId;
  final int round;
  final int revision;
  final List<String> eventLog;
  final CombatOutcome outcome;
  final int seed;
  final int rngState;

  CombatantState unit(String id) =>
      combatants.firstWhere((unit) => unit.id == id);
}

sealed class CombatCommand {
  const CombatCommand(this.actorId);
  final String actorId;
}

final class AttackCommand extends CombatCommand {
  const AttackCommand(
    super.actorId, {
    required this.targetId,
    required this.damage,
    required this.criticalDamage,
    this.useGuardReaction = false,
    this.reactionReduction = 0,
  });
  final String targetId;
  final int damage;
  final int criticalDamage;
  final bool useGuardReaction;
  final int reactionReduction;
}

final class CastSpellCommand extends CombatCommand {
  const CastSpellCommand(
    super.actorId, {
    required this.targetId,
    required this.manaCost,
    required this.damage,
    required this.criticalDamage,
    this.useGuardReaction = false,
    this.reactionReduction = 0,
  });
  final String targetId;
  final int manaCost;
  final int damage;
  final int criticalDamage;
  final bool useGuardReaction;
  final int reactionReduction;
}

final class MoveCommand extends CombatCommand {
  const MoveCommand(super.actorId, {required this.destination});
  final String destination;
}

final class EndTurnCommand extends CombatCommand {
  const EndTurnCommand(super.actorId);
}

final class CombatEvent {
  const CombatEvent(this.type, this.actorId, {this.targetId, this.value});
  final String type;
  final String actorId;
  final String? targetId;
  final int? value;
}

final class CombatResolution {
  const CombatResolution(this.state, this.events);
  final CombatState state;
  final List<CombatEvent> events;
}

/// Deterministic combat reducer. Balance inputs belong to authored encounters.
final class CombatEngine {
  const CombatEngine();

  List<String> rollInitiative(Iterable<CombatantState> combatants, Rng rng) {
    final order = combatants
        .map(
          (unit) => (
            unit: unit,
            score: rng.nextInt(20) + 1 + unit.processingModifier,
            tie: rng.nextInt(1 << 20),
          ),
        )
        .toList();
    order.sort((a, b) {
      final score = b.score.compareTo(a.score);
      if (score != 0) return score;
      final tie = b.tie.compareTo(a.tie);
      return tie != 0 ? tie : a.unit.id.compareTo(b.unit.id);
    });
    return List.unmodifiable(order.map((entry) => entry.unit.id));
  }

  CombatResolution resolve(
    CombatState state,
    CombatCommand command, [
    Rng? suppliedRng,
  ]) {
    final rng = suppliedRng ?? SeededRng.fromState(state.rngState);
    if (state.outcome != CombatOutcome.active) {
      throw StateError('Battle is already complete');
    }
    if (command.actorId != state.activeCombatantId) {
      throw StateError('It is not this combatant’s turn');
    }
    final actor = state.unit(command.actorId);
    if (actor.condition != CombatantCondition.active) {
      throw StateError('Defeated units cannot act');
    }
    final units = {for (final unit in state.combatants) unit.id: unit};
    final events = <CombatEvent>[];
    var round = state.round;
    var nextActorId = state.activeCombatantId;
    var outcome = state.outcome;
    if (command is AttackCommand || command is CastSpellCommand) {
      if (actor.mainActionUsed) throw StateError('Main Action already spent');
      final targetId = command is AttackCommand
          ? command.targetId
          : (command as CastSpellCommand).targetId;
      final target = state.unit(targetId);
      if (target.condition != CombatantCondition.active ||
          target.side == actor.side) {
        throw StateError('Target must be an active opponent');
      }
      if (command is CastSpellCommand) {
        if (command.manaCost < 0 || actor.mana < command.manaCost) {
          throw StateError('Insufficient Mana');
        }
        units[actor.id] = actor.copyWith(mana: actor.mana - command.manaCost);
      }
      units[actor.id] = units[actor.id]!.copyWith(mainActionUsed: true);
      final roll = rng.nextInt(20) + 1;
      final hit =
          roll == 20 ||
          (roll != 1 && roll + actor.attackBonus >= target.defense);
      final critical = roll == 20;
      final normalDamage = switch (command) {
        AttackCommand(:final damage) => damage,
        CastSpellCommand(:final damage) => damage,
        _ => throw StateError('Unsupported attack command'),
      };
      final criticalDamage = switch (command) {
        AttackCommand(:final criticalDamage) => criticalDamage,
        CastSpellCommand(:final criticalDamage) => criticalDamage,
        _ => throw StateError('Unsupported attack command'),
      };
      if (normalDamage < 0 || criticalDamage < 0) {
        throw ArgumentError('Authored damage cannot be negative');
      }
      final int rawDamage = hit
          ? (critical ? criticalDamage : normalDamage)
          : 0;
      final useGuard = switch (command) {
        AttackCommand(:final useGuardReaction) => useGuardReaction,
        CastSpellCommand(:final useGuardReaction) => useGuardReaction,
        _ => false,
      };
      final reduction = switch (command) {
        AttackCommand(:final reactionReduction) => reactionReduction,
        CastSpellCommand(:final reactionReduction) => reactionReduction,
        _ => 0,
      };
      if (reduction < 0 || (useGuard && !target.reactionAvailable)) {
        throw StateError('Defender cannot use the requested Reaction');
      }
      final int damage = useGuard
          ? (rawDamage - reduction).clamp(0, rawDamage).toInt()
          : rawDamage;
      final hp = (target.hp - damage).clamp(0, target.maxHp).toInt();
      units[target.id] = target.copyWith(
        hp: hp,
        reactionAvailable: useGuard ? false : target.reactionAvailable,
        condition: hp == 0 ? CombatantCondition.defeated : target.condition,
      );
      events.add(
        CombatEvent(
          'attackResolved',
          actor.id,
          targetId: target.id,
          value: roll,
        ),
      );
      if (useGuard) {
        events.add(
          CombatEvent(
            'guardReaction',
            target.id,
            targetId: actor.id,
            value: rawDamage - damage,
          ),
        );
      }
      events.add(
        CombatEvent(
          hit ? (critical ? 'criticalHit' : 'hit') : 'miss',
          actor.id,
          targetId: target.id,
          value: damage,
        ),
      );
      if (hp == 0) {
        events.add(CombatEvent('defeated', actor.id, targetId: target.id));
      }
      final playerAlive = units.values.any(
        (unit) =>
            unit.side == CombatSide.player &&
            unit.condition == CombatantCondition.active,
      );
      final enemyAlive = units.values.any(
        (unit) =>
            unit.side == CombatSide.enemy &&
            unit.condition == CombatantCondition.active,
      );
      if (!enemyAlive) {
        outcome = CombatOutcome.victory;
      }
      if (!playerAlive) {
        outcome = CombatOutcome.defeat;
      }
    } else if (command is MoveCommand) {
      if (command.destination.trim().isEmpty ||
          command.destination == actor.zone) {
        throw StateError('Choose a different valid zone');
      }
      units[actor.id] = actor.copyWith(zone: command.destination);
      events.add(CombatEvent('moved', actor.id));
    } else if (command is EndTurnCommand) {
      var nextIndex = state.initiativeOrder.indexOf(actor.id);
      var searched = 0;
      do {
        nextIndex = (nextIndex + 1) % state.initiativeOrder.length;
        searched++;
        if (nextIndex == 0) round++;
      } while (units[state.initiativeOrder[nextIndex]]!.condition ==
              CombatantCondition.defeated &&
          searched < state.initiativeOrder.length);
      nextActorId = state.initiativeOrder[nextIndex];
      units[nextActorId] = units[nextActorId]!.copyWith(mainActionUsed: false);
      if (nextIndex == 0) {
        for (final entry in units.entries.toList()) {
          units[entry.key] = entry.value.copyWith(
            reactionAvailable:
                entry.value.condition == CombatantCondition.active,
          );
        }
      }
      events.add(CombatEvent('turnEnded', actor.id));
    }
    final result = CombatState(
      combatants: units.values,
      initiativeOrder: state.initiativeOrder,
      activeCombatantId: nextActorId,
      round: round,
      revision: state.revision + 1,
      eventLog: [...state.eventLog, ...events.map((event) => event.type)],
      outcome: outcome,
      seed: state.seed,
      rngState: rng is SeededRng ? rng.state : state.rngState,
    );
    return CombatResolution(result, List.unmodifiable(events));
  }
}
