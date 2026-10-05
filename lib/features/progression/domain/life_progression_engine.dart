import '../../evidence/domain/evidence.dart';
import '../../life_quest/domain/life_activity.dart';
import '../../life_quest/domain/life_domain.dart';
import '../../life_quest/domain/user_life_quest.dart';
import 'reward.dart';
import 'reward_grant.dart';

const int basisPoints = 10000;

final class QuestSnapshot {
  QuestSnapshot({
    required this.id,
    required this.domain,
    required this.difficulty,
    required this.activityGroup,
  }) {
    if (id.trim().isEmpty || activityGroup.trim().isEmpty) {
      throw ArgumentError('Snapshot identifiers are required');
    }
  }
  factory QuestSnapshot.fromQuest(UserLifeQuest quest) => QuestSnapshot(
    id: quest.id,
    domain: quest.domain,
    difficulty: quest.difficulty,
    activityGroup: quest.activityGroup,
  );
  final String id;
  final LifeDomain domain;
  final QuestDifficulty difficulty;
  final String activityGroup;
}

final class DurationFactor {
  const DurationFactor({required this.upTo, required this.factorBasisPoints});

  /// Null means this is the final open-ended duration band.
  final Duration? upTo;
  final int factorBasisPoints;
}

/// All balance-sensitive rates are explicit authored inputs; no guessed defaults.
final class LifeProgressionPolicy {
  LifeProgressionPolicy({
    required this.formulaVersion,
    required Map<String, int> baseXpByActivityGroup,
    required List<DurationFactor> durationFactors,
    required Map<QuestDifficulty, int> challengeFactors,
    required Map<EvidenceLevel, int> evidenceFactors,
    required Map<String, int> groupFactors,
    required Map<LifeDomain, int> growthPotentialFactors,
  }) : baseXpByActivityGroup = Map.unmodifiable(baseXpByActivityGroup),
       challengeFactors = Map.unmodifiable(challengeFactors),
       evidenceFactors = Map.unmodifiable(evidenceFactors),
       groupFactors = Map.unmodifiable(groupFactors),
       growthPotentialFactors = Map.unmodifiable(growthPotentialFactors),
       durationFactors = List.unmodifiable(durationFactors) {
    if (formulaVersion.trim().isEmpty) {
      throw ArgumentError.value(formulaVersion, 'formulaVersion');
    }
    if (this.baseXpByActivityGroup.isEmpty ||
        this.baseXpByActivityGroup.values.any((value) => value <= 0) ||
        this.growthPotentialFactors.length != LifeDomain.values.length ||
        this.growthPotentialFactors.values.any((value) => value <= 0)) {
      throw ArgumentError(
        'Base XP and one potential conversion rate per MVP domain are required',
      );
    }
    if (!this.challengeFactors.keys.toSet().containsAll(
          QuestDifficulty.values,
        ) ||
        !this.evidenceFactors.keys.toSet().containsAll(EvidenceLevel.values)) {
      throw ArgumentError(
        'Policy must define each MVP difficulty and evidence factor',
      );
    }
    for (final map in [
      this.baseXpByActivityGroup,
      this.challengeFactors,
      this.evidenceFactors,
      this.groupFactors,
      this.growthPotentialFactors,
    ]) {
      if (map.values.any((value) => value < 0)) {
        throw ArgumentError('Factors cannot be negative');
      }
    }
    if (this.challengeFactors.values.any((value) => value <= 0) ||
        this.evidenceFactors[EvidenceLevel.selfReport]! <= 0 ||
        this.durationFactors.isEmpty ||
        this.durationFactors.last.upTo != null ||
        this.durationFactors.any(
          (factor) =>
              factor.factorBasisPoints < 0 ||
              (factor.upTo != null && factor.upTo! <= Duration.zero),
        )) {
      throw ArgumentError('Duration bands must end in an open-ended factor');
    }
    for (var i = 1; i < this.durationFactors.length; i++) {
      final previous = this.durationFactors[i - 1].upTo;
      final current = this.durationFactors[i].upTo;
      if (previous == null || (current != null && current <= previous)) {
        throw ArgumentError('Duration bands must be strictly increasing');
      }
    }
  }

  final String formulaVersion;
  final Map<String, int> baseXpByActivityGroup;
  final List<DurationFactor> durationFactors;
  final Map<QuestDifficulty, int> challengeFactors;
  final Map<EvidenceLevel, int> evidenceFactors;
  final Map<String, int> groupFactors;
  final Map<LifeDomain, int> growthPotentialFactors;
}

/// Applies a supplied formula policy. It never persists or canonically grants rewards.
final class LifeProgressionEngine {
  const LifeProgressionEngine();

  RewardPreview preview({
    required LifeActivity activity,
    required QuestSnapshot quest,
    required EvidenceSummary evidence,
    required LifeProgressionPolicy policy,
  }) {
    if (activity.lifeQuestId != quest.id ||
        activity.domain != quest.domain ||
        activity.difficultySnapshot != quest.difficulty ||
        activity.activityGroup != quest.activityGroup ||
        evidence.activityId != activity.id) {
      throw ArgumentError(
        'Activity, quest snapshot and evidence summary must refer to the same completion',
      );
    }
    final base = policy.baseXpByActivityGroup[quest.activityGroup];
    if (base == null) {
      throw StateError('No base XP authored for ${quest.activityGroup}');
    }
    final band = policy.durationFactors.firstWhere(
      (factor) =>
          factor.upTo == null || activity.normalizedDuration <= factor.upTo!,
    );
    final groupFactor = policy.groupFactors[quest.activityGroup] ?? basisPoints;
    final evidenceLevel = evidence.evidenceBonusEligibility
        ? evidence.highestLevel
        : EvidenceLevel.selfReport;
    final xp =
        base *
        band.factorBasisPoints *
        policy.challengeFactors[quest.difficulty]! *
        policy.evidenceFactors[evidenceLevel]! *
        groupFactor ~/
        (basisPoints * basisPoints * basisPoints * basisPoints);
    final potential =
        xp * policy.growthPotentialFactors[quest.domain]! ~/ basisPoints;
    return RewardPreview(
      userId: activity.userId,
      sourceId: activity.id,
      formulaVersion: policy.formulaVersion,
      rewards: [
        Reward(type: RewardType.lifeXp, domain: activity.domain, amount: xp),
        Reward(
          type: RewardType.growthPotential,
          potentialCategory: activity.domain.growthPotentialCategory,
          amount: potential,
        ),
      ],
    );
  }
}
