import 'combat_models.dart';

final class EnemyPatternContextV1 {
  EnemyPatternContextV1({
    required this.turnIndex,
    Iterable<String> previousIntentIds = const [],
  }) : previousIntentIds = List.unmodifiable(previousIntentIds) {
    if (turnIndex < 0) {
      throw ArgumentError('Enemy turn index cannot be negative');
    }
  }

  final int turnIndex;
  final List<String> previousIntentIds;
}

final class EnemyPatternConditionV1 {
  EnemyPatternConditionV1({
    this.minTurnIndex,
    this.maxTurnIndex,
    this.minMana,
    this.maxHpPercent,
    Iterable<BattleZone> targetZones = const [],
    this.requiredPreviousIntentId,
    this.requiresNoCastingFunction = false,
  }) : targetZones = Set.unmodifiable(targetZones) {
    if ((minTurnIndex != null && minTurnIndex! < 0) ||
        (maxTurnIndex != null && maxTurnIndex! < 0) ||
        (minTurnIndex != null &&
            maxTurnIndex != null &&
            minTurnIndex! > maxTurnIndex!) ||
        (minMana != null && minMana! < 0) ||
        (maxHpPercent != null &&
            (maxHpPercent! < 0 || maxHpPercent! > 100)) ||
        (requiredPreviousIntentId != null &&
            requiredPreviousIntentId!.trim().isEmpty)) {
      throw ArgumentError('Invalid enemy Pattern condition');
    }
  }

  final int? minTurnIndex;
  final int? maxTurnIndex;
  final int? minMana;
  final int? maxHpPercent;
  final Set<BattleZone> targetZones;
  final String? requiredPreviousIntentId;
  final bool requiresNoCastingFunction;

  bool matches({
    required BattleStateV1 state,
    required CombatantStateV1 actor,
    required CombatantStateV1 target,
    required EnemyPatternContextV1 context,
  }) {
    if (minTurnIndex != null && context.turnIndex < minTurnIndex!) {
      return false;
    }
    if (maxTurnIndex != null && context.turnIndex > maxTurnIndex!) {
      return false;
    }
    if (minMana != null && actor.mana < minMana!) {
      return false;
    }
    if (maxHpPercent != null &&
        actor.hp * 100 > actor.maxHp * maxHpPercent!) {
      return false;
    }
    if (targetZones.isNotEmpty && !targetZones.contains(target.zone)) {
      return false;
    }
    if (requiredPreviousIntentId != null &&
        !context.previousIntentIds.contains(requiredPreviousIntentId)) {
      return false;
    }
    if (requiresNoCastingFunction &&
        state.castingFunctionFor(actor.id) != null) {
      return false;
    }
    return true;
  }
}

final class EnemyPatternRuleV1 {
  EnemyPatternRuleV1({
    required this.id,
    required this.priority,
    required this.intentId,
    required this.condition,
  }) {
    if (id.trim().isEmpty || intentId.trim().isEmpty) {
      throw ArgumentError('Enemy Pattern rule identifiers are required');
    }
  }

  final String id;
  final int priority;
  final String intentId;
  final EnemyPatternConditionV1 condition;
}

final class EnemyIntentV1 {
  const EnemyIntentV1({
    required this.ruleId,
    required this.intentId,
    required this.actorId,
    required this.targetId,
  });

  final String ruleId;
  final String intentId;
  final String actorId;
  final String targetId;
}

/// Deterministic Pattern + Conditions selector.
///
/// The selector only chooses an authored intent. Encounter content remains
/// responsible for mapping that intent to a concrete combat command.
final class EnemyPatternV1 {
  EnemyPatternV1({required Iterable<EnemyPatternRuleV1> rules})
    : rules = List.unmodifiable(rules) {
    if (this.rules.isEmpty ||
        this.rules.map((rule) => rule.id).toSet().length !=
            this.rules.length) {
      throw ArgumentError('Enemy Pattern needs unique authored rules');
    }
  }

  final List<EnemyPatternRuleV1> rules;

  EnemyIntentV1 choose({
    required BattleStateV1 state,
    required String actorId,
    required String targetId,
    required EnemyPatternContextV1 context,
  }) {
    final actor = state.actor(actorId);
    final target = state.actor(targetId);
    if (!actor.isActive ||
        !target.isActive ||
        actor.side == target.side) {
      throw StateError('Enemy Pattern requires active opposing actors');
    }

    final ordered = [
      for (var index = 0; index < rules.length; index++)
        (rule: rules[index], index: index),
    ]..sort((a, b) {
      final byPriority = b.rule.priority.compareTo(a.rule.priority);
      return byPriority != 0 ? byPriority : a.index.compareTo(b.index);
    });

    for (final entry in ordered) {
      if (entry.rule.condition.matches(
        state: state,
        actor: actor,
        target: target,
        context: context,
      )) {
        return EnemyIntentV1(
          ruleId: entry.rule.id,
          intentId: entry.rule.intentId,
          actorId: actor.id,
          targetId: target.id,
        );
      }
    }
    throw StateError('No authored enemy Pattern rule matches this state');
  }
}
