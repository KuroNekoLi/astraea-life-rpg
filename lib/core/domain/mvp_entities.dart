import '../../features/character/domain/attribute.dart';
import '../../features/life_quest/domain/life_domain.dart';

/// Source-of-truth and projection records shared by M1 features.
final class User {
  const User({
    required this.id,
    required this.accountType,
    required this.createdAt,
    required this.locale,
    required this.timezone,
    required this.schemaVersion,
  });
  final String id;
  final String accountType;
  final DateTime createdAt;
  final String locale;
  final String timezone;
  final int schemaVersion;
}

final class PlayerProfile {
  PlayerProfile({
    required this.userId,
    required this.displayName,
    required this.onboardingState,
    required Set<String> activeLifeDomainIds,
    required Map<String, String> privacyDefaults,
  }) : activeLifeDomainIds = Set.unmodifiable(activeLifeDomainIds),
       privacyDefaults = Map.unmodifiable(privacyDefaults);
  final String userId;
  final String displayName;
  final Map<String, String> privacyDefaults;
  final String onboardingState;
  final Set<String> activeLifeDomainIds;
}

final class Character {
  Character({
    required this.id,
    required this.userId,
    required this.name,
    required this.weaponId,
    required this.preparedDeckId,
    required this.revision,
    this.characterLevel,
    Map<String, String> appearance = const {},
    this.schemaVersion = 1,
  }) : appearance = Map.unmodifiable(appearance);
  final String id;
  final String userId;
  final String name;
  final int? characterLevel;
  final String weaponId;
  final Map<String, String> appearance;
  final String preparedDeckId;
  final int schemaVersion;
  final int revision;
}

final class LifeDomainDefinition {
  const LifeDomainDefinition({
    required this.id,
    required this.nameKey,
    required this.schemaVersion,
    required this.contentVersion,
    this.parentId,
    this.icon,
  });
  final String id;
  final String? parentId;
  final String nameKey;
  final String? icon;
  final int schemaVersion;
  final String contentVersion;
}

final class UserLifeDomain {
  const UserLifeDomain({
    required this.userId,
    required this.domainId,
    required this.active,
    required this.privacy,
    required this.revision,
  });
  final String userId;
  final String domainId;
  final bool active;
  final String privacy;
  final int revision;
}

final class QuestTemplate {
  const QuestTemplate({
    required this.id,
    required this.domainId,
    required this.titleKey,
    required this.defaultRecurrence,
    required this.defaultDuration,
    required this.defaultDifficulty,
    required this.verificationPolicy,
    required this.schemaVersion,
    required this.contentVersion,
  });
  final String id;
  final String domainId;
  final String titleKey;
  final LifeQuestRecurrence defaultRecurrence;
  final Duration defaultDuration;
  final QuestDifficulty defaultDifficulty;
  final String verificationPolicy;
  final int schemaVersion;
  final String contentVersion;
}

final class LifeProgress {
  const LifeProgress({
    required this.userId,
    required this.domain,
    required this.totalXp,
    required this.level,
    required this.momentum7d,
    required this.momentum28d,
    required this.evidenceCoverage,
    required this.projectionVersion,
    required this.updatedAt,
  });
  final String userId;
  final LifeDomain domain;
  final int totalXp;
  final int level;
  final int momentum7d;
  final int momentum28d;
  final double evidenceCoverage;
  final int projectionVersion;
  final DateTime updatedAt;
}

final class StoryQuestDefinition {
  StoryQuestDefinition({
    required this.id,
    required this.chapterId,
    required this.titleKey,
    required this.descriptionKey,
    required Iterable<String> objectives,
    required Iterable<String> rewards,
    required Iterable<String> unlockConditions,
    required this.schemaVersion,
    required this.contentVersion,
  }) : objectives = List.unmodifiable(objectives),
       rewards = List.unmodifiable(rewards),
       unlockConditions = List.unmodifiable(unlockConditions);
  final String id;
  final String chapterId;
  final String titleKey;
  final String descriptionKey;
  final List<String> objectives;
  final List<String> rewards;
  final List<String> unlockConditions;
  final int schemaVersion;
  final String contentVersion;
}

enum StoryQuestStatus { locked, available, active, completed }

final class StoryQuestState {
  StoryQuestState({
    required this.userId,
    required this.questId,
    required this.status,
    required Map<String, bool> objectiveStates,
    required this.revision,
    this.startedAt,
    this.completedAt,
  }) : objectiveStates = Map.unmodifiable(objectiveStates);
  final String userId;
  final String questId;
  final StoryQuestStatus status;
  final Map<String, bool> objectiveStates;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int revision;
}

final class CharacterRelationship {
  CharacterRelationship({
    required this.userId,
    required this.characterId,
    required this.trust,
    required this.affinity,
    required Set<String> sharedHistoryFlags,
    required this.tacticalSynergy,
    required this.revision,
    required this.schemaVersion,
  }) : sharedHistoryFlags = Set.unmodifiable(sharedHistoryFlags);
  final String userId;
  final String characterId;
  final int trust;
  final int affinity;
  final Set<String> sharedHistoryFlags;
  final int tacticalSynergy;
  final int revision;
  final int schemaVersion;
}

final class BattleDefinition {
  BattleDefinition({
    required this.id,
    required this.encounterId,
    required this.battlefieldId,
    required Iterable<String> enemies,
    required this.partyRules,
    required this.seedPolicy,
    required Iterable<String> victoryConditions,
    required Set<String> tutorialFlags,
    required this.schemaVersion,
    required this.contentVersion,
  }) : enemies = List.unmodifiable(enemies),
       victoryConditions = List.unmodifiable(victoryConditions),
       tutorialFlags = Set.unmodifiable(tutorialFlags);
  final String id;
  final String encounterId;
  final String battlefieldId;
  final List<String> enemies;
  final String partyRules;
  final String seedPolicy;
  final List<String> victoryConditions;
  final Set<String> tutorialFlags;
  final int schemaVersion;
  final String contentVersion;
}

/// Exposes values without introducing another mutable owner.
Map<AttributeType, int> effectiveAttributeValues(AttributeState state) =>
    Map.unmodifiable({
      for (final entry in state.values.entries)
        entry.key: entry.value.effectiveValue,
    });
