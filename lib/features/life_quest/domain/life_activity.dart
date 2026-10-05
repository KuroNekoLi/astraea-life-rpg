import 'life_domain.dart';

/// A completed real-world activity. Final XP belongs to LifeProgressionEngine.
final class LifeActivity {
  LifeActivity({
    required this.id,
    required this.userId,
    required this.lifeQuestId,
    required this.domain,
    required this.startedAt,
    required this.completedAt,
    required this.normalizedDuration,
    required this.difficultySnapshot,
    required this.activityGroup,
    this.evidenceSummaryId,
    this.createdOffline = false,
    this.schemaVersion = 1,
  }) {
    for (final entry in {
      'id': id,
      'userId': userId,
      'lifeQuestId': lifeQuestId,
      'activityGroup': activityGroup,
    }.entries) {
      if (entry.value.trim().isEmpty) {
        throw ArgumentError.value(entry.value, entry.key);
      }
    }
    if (completedAt.isBefore(startedAt)) {
      throw ArgumentError('completedAt cannot precede startedAt');
    }
    if (normalizedDuration < Duration.zero) {
      throw ArgumentError.value(normalizedDuration, 'normalizedDuration');
    }
    if (schemaVersion < 1) {
      throw ArgumentError.value(schemaVersion, 'schemaVersion');
    }
  }

  final String id;
  final String userId;
  final String lifeQuestId;
  final LifeDomain domain;
  final DateTime startedAt;
  final DateTime completedAt;
  final Duration normalizedDuration;
  final QuestDifficulty difficultySnapshot;
  final String activityGroup;
  final String? evidenceSummaryId;
  final bool createdOffline;
  final int schemaVersion;

  Duration get rawDuration => completedAt.difference(startedAt);
}
