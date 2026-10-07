import 'combat_models.dart';

enum CombatActionKind { basicAttack, guard, technique, spell, wait }

final class CombatActionDefinitionV1 {
  CombatActionDefinitionV1({
    required this.id,
    required this.kind,
    required this.actionDelay,
    this.manaCost = 0,
    this.manaRecovery = 0,
    this.rawDamage = 0,
    this.damageType,
    Iterable<BattleZone> targetZones = const [],
    this.guardDamageReductionPercent = 0,
  }) : targetZones = Set.unmodifiable(targetZones) {
    if (id.trim().isEmpty ||
        actionDelay < 1 ||
        manaCost < 0 ||
        manaRecovery < 0 ||
        rawDamage < 0 ||
        guardDamageReductionPercent < 0 ||
        guardDamageReductionPercent > 100) {
      throw ArgumentError('Invalid action definition');
    }
    if (rawDamage > 0 && damageType == null) {
      throw ArgumentError('Damaging actions require a damage type');
    }
    if (kind == CombatActionKind.guard && guardDamageReductionPercent == 0) {
      throw ArgumentError('Guard must provide damage reduction');
    }
  }

  final String id;
  final CombatActionKind kind;
  final int actionDelay;
  final int manaCost;
  final int manaRecovery;
  final int rawDamage;
  final DamageType? damageType;
  final Set<BattleZone> targetZones;
  final int guardDamageReductionPercent;

  bool get dealsDamage => rawDamage > 0;
}

final class QuickActionDefinitionV1 {
  QuickActionDefinitionV1({required this.id, this.manaCost = 0}) {
    if (id.trim().isEmpty || manaCost < 0) {
      throw ArgumentError('Invalid Quick Action definition');
    }
  }

  final String id;
  final int manaCost;
}

final class InterruptDefinitionV1 {
  InterruptDefinitionV1({
    required this.id,
    required this.interruptPower,
    required this.actionDelay,
    this.stabilityDamage = 0,
    this.manaCost = 0,
    this.castingCompatible = false,
  }) {
    if (id.trim().isEmpty ||
        interruptPower < 0 ||
        actionDelay < 1 ||
        stabilityDamage < 0 ||
        manaCost < 0) {
      throw ArgumentError('Invalid Interrupt definition');
    }
  }

  final String id;
  final int interruptPower;
  final int actionDelay;
  final int stabilityDamage;
  final int manaCost;
  final bool castingCompatible;
}

final class FullChantDefinitionV1 {
  FullChantDefinitionV1({
    required this.id,
    required this.manaCost,
    required this.rawDamage,
    required this.damageType,
    required this.castTime,
    required this.stability,
    required this.recoveryDelay,
    Iterable<BattleZone> targetZones = const [],
  }) : targetZones = Set.unmodifiable(targetZones) {
    if (id.trim().isEmpty ||
        manaCost < 0 ||
        rawDamage < 0 ||
        castTime < 1 ||
        stability < 0 ||
        recoveryDelay < 0) {
      throw ArgumentError('Invalid Full Chant definition');
    }
  }

  final String id;
  final int manaCost;
  final int rawDamage;
  final DamageType damageType;
  final int castTime;
  final int stability;
  final int recoveryDelay;
  final Set<BattleZone> targetZones;
}

sealed class CombatCommandV1 {
  const CombatCommandV1(this.actorId);

  final String actorId;
}

final class MoveCommandV1 extends CombatCommandV1 {
  const MoveCommandV1(super.actorId, {required this.destination});

  final BattleZone destination;
}

final class UseActionCommandV1 extends CombatCommandV1 {
  const UseActionCommandV1(
    super.actorId, {
    required this.action,
    this.targetId,
  });

  final CombatActionDefinitionV1 action;
  final String? targetId;
}

final class UseQuickActionCommandV1 extends CombatCommandV1 {
  const UseQuickActionCommandV1(super.actorId, {required this.action});

  final QuickActionDefinitionV1 action;
}

final class InterruptFunctionCommandV1 extends CombatCommandV1 {
  const InterruptFunctionCommandV1(
    super.actorId, {
    required this.functionId,
    required this.interrupt,
    this.asReaction = true,
  });

  final String functionId;
  final InterruptDefinitionV1 interrupt;
  final bool asReaction;
}

final class BeginFullChantCommandV1 extends CombatCommandV1 {
  const BeginFullChantCommandV1(
    super.actorId, {
    required this.spell,
    required this.targetId,
  });

  final FullChantDefinitionV1 spell;
  final String targetId;
}

final class CancelFullChantCommandV1 extends CombatCommandV1 {
  const CancelFullChantCommandV1(super.actorId);
}
