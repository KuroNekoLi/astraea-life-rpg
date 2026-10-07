import 'combat_models.dart';

final class CombatReportV1 {
  CombatReportV1({
    required this.outcome,
    required this.actionTime,
    required this.mainActions,
    required this.quickActions,
    required this.fullChantsStarted,
    required this.interruptAttempts,
    required this.interruptSuccesses,
    required this.analysisUses,
    required this.counters,
    required Map<String, int> endingHp,
    required Map<String, int> endingMana,
    required Map<String, BattleZone> endingZones,
  }) : endingHp = Map.unmodifiable(endingHp),
       endingMana = Map.unmodifiable(endingMana),
       endingZones = Map.unmodifiable(endingZones);

  final CombatOutcome outcome;
  final int actionTime;
  final int mainActions;
  final int quickActions;
  final int fullChantsStarted;
  final int interruptAttempts;
  final int interruptSuccesses;
  final int analysisUses;
  final int counters;
  final Map<String, int> endingHp;
  final Map<String, int> endingMana;
  final Map<String, BattleZone> endingZones;

  factory CombatReportV1.fromState(BattleStateV1 state) {
    int count(String prefix) =>
        state.eventLog.where((event) => event.startsWith(prefix)).length;

    return CombatReportV1(
      outcome: state.outcome,
      actionTime: state.currentTime,
      mainActions:
          count('action:') + count('fullChantStarted:') + count('analysis:'),
      quickActions: count('quickAction:'),
      fullChantsStarted: count('fullChantStarted:'),
      interruptAttempts: count('interruptAttempt:'),
      interruptSuccesses: count('interrupted:'),
      analysisUses: count('analysis:'),
      counters: count('countered:'),
      endingHp: {for (final actor in state.combatants) actor.id: actor.hp},
      endingMana: {for (final actor in state.combatants) actor.id: actor.mana},
      endingZones: {for (final actor in state.combatants) actor.id: actor.zone},
    );
  }

  String canonical() {
    final ids = endingHp.keys.toList()..sort();
    return [
      outcome.name,
      '$actionTime',
      '$mainActions',
      '$quickActions',
      '$fullChantsStarted',
      '$interruptAttempts',
      '$interruptSuccesses',
      '$analysisUses',
      '$counters',
      for (final id in ids)
        '$id:${endingHp[id]}:${endingMana[id]}:${endingZones[id]!.name}',
    ].join('|');
  }
}

final class CombatStateFingerprintV1 {
  const CombatStateFingerprintV1._();

  static String compute(BattleStateV1 state) {
    final actors = [...state.combatants]..sort((a, b) => a.id.compareTo(b.id));
    final functions = [...state.activeFunctions]
      ..sort((a, b) => a.id.compareTo(b.id));
    final knowledge = [...state.functionKnowledge]
      ..sort((a, b) {
        final byObserver = a.observerId.compareTo(b.observerId);
        return byObserver != 0
            ? byObserver
            : a.signatureId.compareTo(b.signatureId);
      });

    return [
      'time=${state.currentTime}',
      'rev=${state.revision}',
      'outcome=${state.outcome.name}',
      'turn=${state.activeTurn?.actorId ?? '-'}',
      for (final actor in actors)
        'actor=${actor.id},${actor.side.name},${actor.hp},${actor.mana},'
            '${actor.zone.name},${actor.condition.name},${actor.reactionAvailable}',
      for (final event in state.timeline)
        'event=${event.id},${event.type.name},${event.scheduledAt},'
            '${event.sequence},${event.actorId ?? '-'},${event.functionId ?? '-'}',
      for (final function in functions)
        'function=${function.id},${function.actionId},${function.status.name},'
            '${function.stability},${function.resolveAt}',
      for (final entry in knowledge)
        'knowledge=${entry.observerId},${entry.signatureId},'
            '${entry.level.name},${entry.knownStability ?? -1},'
            '${([...entry.revealedWeakNodeIds]..sort()).join(",")},'
            '${([...entry.knownCounterTags]..sort()).join(",")},'
            '${entry.reversibilityKnown}',
      for (final event in state.eventLog) 'log=$event',
    ].join('||');
  }
}
