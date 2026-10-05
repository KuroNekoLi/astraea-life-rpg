import 'life_domain.dart';

final class UserLifeQuest {
  UserLifeQuest({
    required this.id,
    required this.userId,
    required this.domain,
    required this.title,
    required this.type,
    required this.recurrence,
    required this.difficulty,
    required this.estimatedDuration,
    required this.activityGroup,
    required this.status,
    required this.createdAt,
    this.archivedAt,
    this.revision = 0,
  }) {
    _requireText(id, 'id');
    _requireText(userId, 'userId');
    _requireText(title, 'title');
    _requireText(activityGroup, 'activityGroup');
    if (estimatedDuration <= Duration.zero) {
      throw ArgumentError.value(estimatedDuration, 'estimatedDuration');
    }
    if (revision < 0) throw ArgumentError.value(revision, 'revision');
    if ((status == LifeQuestStatus.archived) != (archivedAt != null)) {
      throw ArgumentError(
        'archivedAt must exist exactly when the quest is archived',
      );
    }
  }

  final String id;
  final String userId;
  final LifeDomain domain;
  final String title;
  final LifeQuestType type;
  final LifeQuestRecurrence recurrence;
  final QuestDifficulty difficulty;
  final Duration estimatedDuration;
  final String activityGroup;
  final LifeQuestStatus status;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final int revision;
}

void _requireText(String value, String name) {
  if (value.trim().isEmpty) throw ArgumentError.value(value, name);
}
