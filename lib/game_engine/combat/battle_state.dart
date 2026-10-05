/// M1 runtime envelope only; deterministic commands/resolution are M5 scope.
enum BattleStatus { active, victory, defeat, abandoned }

final class BattleState {
  BattleState({
    required this.id,
    required this.userId,
    required this.definitionId,
    required this.seed,
    required this.round,
    required Iterable<String> initiativeOrder,
    required this.status,
    required this.revision,
    Iterable<String> activeFunctionIds = const [],
    Iterable<String> eventLog = const [],
    this.schemaVersion = 1,
  }) : initiativeOrder = List.unmodifiable(initiativeOrder),
       activeFunctionIds = List.unmodifiable(activeFunctionIds),
       eventLog = List.unmodifiable(eventLog) {
    for (final value in [id, userId, definitionId]) {
      if (value.trim().isEmpty) {
        throw ArgumentError('Battle identifiers are required');
      }
    }
    if (round < 0 || revision < 0 || schemaVersion < 1) {
      throw ArgumentError('Invalid battle state');
    }
  }
  final String id;
  final String userId;
  final String definitionId;
  final int seed;
  final int round;
  final List<String> initiativeOrder;
  final List<String> activeFunctionIds;
  final List<String> eventLog;
  final BattleStatus status;
  final int revision;
  final int schemaVersion;
}
