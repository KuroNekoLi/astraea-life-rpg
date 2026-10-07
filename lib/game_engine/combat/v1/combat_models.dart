enum BattleSide { player, enemy }

enum BattleZone { near, mid, far }

enum CombatantCondition { active, defeated }

enum CombatOutcome { active, victory, defeat }

enum DamageType { physical, magic }

enum TimelineEventType { characterTurn, spellResolve, battlefieldFunction }

final class CombatantStateV1 {
  CombatantStateV1({
    required this.id,
    required this.side,
    required this.hp,
    required this.maxHp,
    required this.mana,
    required this.maxMana,
    required this.physicalResistance,
    required this.magicResistance,
    required this.controlResistance,
    required this.zone,
    this.condition = CombatantCondition.active,
    this.guardDamageReductionPercent = 0,
  }) {
    if (id.trim().isEmpty ||
        maxHp < 1 ||
        hp < 0 ||
        hp > maxHp ||
        maxMana < 0 ||
        mana < 0 ||
        mana > maxMana ||
        physicalResistance < 0 ||
        magicResistance < 0 ||
        controlResistance < 0 ||
        guardDamageReductionPercent < 0 ||
        guardDamageReductionPercent > 100) {
      throw ArgumentError('Invalid combatant state');
    }
    if (condition == CombatantCondition.defeated && hp != 0) {
      throw ArgumentError('Defeated combatants must have zero HP');
    }
  }

  final String id;
  final BattleSide side;
  final int hp;
  final int maxHp;
  final int mana;
  final int maxMana;
  final int physicalResistance;
  final int magicResistance;
  final int controlResistance;
  final BattleZone zone;
  final CombatantCondition condition;
  final int guardDamageReductionPercent;

  bool get isActive => condition == CombatantCondition.active;

  CombatantStateV1 copyWith({
    int? hp,
    int? mana,
    BattleZone? zone,
    CombatantCondition? condition,
    int? guardDamageReductionPercent,
  }) {
    return CombatantStateV1(
      id: id,
      side: side,
      hp: hp ?? this.hp,
      maxHp: maxHp,
      mana: mana ?? this.mana,
      maxMana: maxMana,
      physicalResistance: physicalResistance,
      magicResistance: magicResistance,
      controlResistance: controlResistance,
      zone: zone ?? this.zone,
      condition: condition ?? this.condition,
      guardDamageReductionPercent:
          guardDamageReductionPercent ?? this.guardDamageReductionPercent,
    );
  }
}

final class TimelineEventV1 {
  TimelineEventV1({
    required this.id,
    required this.type,
    required this.scheduledAt,
    required this.sequence,
    this.actorId,
  }) {
    if (id.trim().isEmpty || scheduledAt < 0 || sequence < 0) {
      throw ArgumentError('Invalid timeline event');
    }
    if (type == TimelineEventType.characterTurn &&
        (actorId == null || actorId!.trim().isEmpty)) {
      throw ArgumentError('Character turns require an actor');
    }
  }

  final String id;
  final TimelineEventType type;
  final int scheduledAt;
  final int sequence;
  final String? actorId;
}

final class ActiveTurnV1 {
  const ActiveTurnV1({required this.actorId, this.moveUsed = false});

  final String actorId;
  final bool moveUsed;

  ActiveTurnV1 copyWith({bool? moveUsed}) {
    return ActiveTurnV1(
      actorId: actorId,
      moveUsed: moveUsed ?? this.moveUsed,
    );
  }
}

final class BattleStateV1 {
  BattleStateV1({
    required Iterable<CombatantStateV1> combatants,
    required Iterable<TimelineEventV1> timeline,
    required this.currentTime,
    required this.nextSequence,
    required this.revision,
    this.activeTurn,
    this.outcome = CombatOutcome.active,
    Iterable<String> eventLog = const [],
  }) : combatants = List.unmodifiable(combatants),
       timeline = List.unmodifiable(_sorted(timeline)),
       eventLog = List.unmodifiable(eventLog) {
    if (this.combatants.isEmpty ||
        this.combatants.map((actor) => actor.id).toSet().length !=
            this.combatants.length ||
        currentTime < 0 ||
        nextSequence < 0 ||
        revision < 0) {
      throw ArgumentError('Invalid battle state');
    }
    if (activeTurn != null &&
        !this.combatants.any(
          (actor) => actor.id == activeTurn!.actorId && actor.isActive,
        )) {
      throw ArgumentError('Active turn must belong to an active combatant');
    }
  }

  final List<CombatantStateV1> combatants;
  final List<TimelineEventV1> timeline;
  final int currentTime;
  final int nextSequence;
  final int revision;
  final ActiveTurnV1? activeTurn;
  final CombatOutcome outcome;
  final List<String> eventLog;

  CombatantStateV1 actor(String id) {
    return combatants.firstWhere((actor) => actor.id == id);
  }

  static List<TimelineEventV1> _sorted(
    Iterable<TimelineEventV1> events,
  ) {
    final sorted = events.toList()
      ..sort((a, b) {
        final byTime = a.scheduledAt.compareTo(b.scheduledAt);
        return byTime != 0 ? byTime : a.sequence.compareTo(b.sequence);
      });
    return sorted;
  }
}

final class TimelineAdvanceV1 {
  const TimelineAdvanceV1({required this.state, required this.event});

  final BattleStateV1 state;
  final TimelineEventV1 event;
}
