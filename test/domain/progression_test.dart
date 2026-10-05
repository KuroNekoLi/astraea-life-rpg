import 'package:astraea_life_rpg/features/evidence/domain/evidence.dart';
import 'package:astraea_life_rpg/features/life_quest/domain/life_activity.dart';
import 'package:astraea_life_rpg/features/life_quest/domain/life_domain.dart';
import 'package:astraea_life_rpg/features/life_quest/domain/user_life_quest.dart';
import 'package:astraea_life_rpg/features/progression/domain/growth_potential_balance.dart';
import 'package:astraea_life_rpg/features/progression/domain/life_progression_engine.dart';
import 'package:astraea_life_rpg/features/progression/domain/reward.dart';
import 'package:astraea_life_rpg/features/progression/domain/reward_grant.dart';
import 'package:astraea_life_rpg/features/progression/domain/reward_ledger.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);

  test('MVP life domains map to their approved potential categories', () {
    expect(
      LifeDomain.fitness.growthPotentialCategory,
      GrowthPotentialCategory.physical,
    );
    expect(
      LifeDomain.learning.growthPotentialCategory,
      GrowthPotentialCategory.cognitive,
    );
    expect(
      LifeDomain.languages.growthPotentialCategory,
      GrowthPotentialCategory.communication,
    );
  });

  test(
    'quest and activity reject invalid duration and impossible time order',
    () {
      expect(
        () => UserLifeQuest(
          id: 'q',
          userId: 'u',
          domain: LifeDomain.learning,
          title: 'Read',
          type: LifeQuestType.quick,
          recurrence: LifeQuestRecurrence.once,
          difficulty: QuestDifficulty.normal,
          estimatedDuration: Duration.zero,
          activityGroup: 'reading',
          status: LifeQuestStatus.active,
          createdAt: now,
        ),
        throwsArgumentError,
      );
      expect(
        () => LifeActivity(
          id: 'a',
          userId: 'u',
          lifeQuestId: 'q',
          domain: LifeDomain.learning,
          startedAt: now,
          completedAt: now.subtract(const Duration(seconds: 1)),
          normalizedDuration: const Duration(minutes: 20),
          difficultySnapshot: QuestDifficulty.normal,
          activityGroup: 'reading',
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'reward preview applies only the explicitly authored formula policy',
    () {
      final quest = UserLifeQuest(
        id: 'q',
        userId: 'u',
        domain: LifeDomain.learning,
        title: 'Read 20 minutes',
        type: LifeQuestType.quick,
        recurrence: LifeQuestRecurrence.once,
        difficulty: QuestDifficulty.normal,
        estimatedDuration: const Duration(minutes: 20),
        activityGroup: 'reading',
        status: LifeQuestStatus.active,
        createdAt: now,
      );
      final activity = LifeActivity(
        id: 'a',
        userId: 'u',
        lifeQuestId: 'q',
        domain: LifeDomain.learning,
        startedAt: now,
        completedAt: now.add(const Duration(minutes: 20)),
        normalizedDuration: const Duration(minutes: 20),
        difficultySnapshot: QuestDifficulty.normal,
        activityGroup: 'reading',
      );
      final evidence = EvidenceSummary(
        activityId: 'a',
        highestLevel: EvidenceLevel.lightweight,
        evidenceBonusEligibility: true,
        competitiveEligible: false,
        verificationStatus: VerificationStatus.captured,
        updatedAt: now,
      );
      final policy = LifeProgressionPolicy(
        formulaVersion: 'fixture-v1',
        baseXpByActivityGroup: {'reading': 100},
        durationFactors: [
          const DurationFactor(
            upTo: Duration(minutes: 10),
            factorBasisPoints: 8000,
          ),
          const DurationFactor(upTo: null, factorBasisPoints: 12000),
        ],
        challengeFactors: {
          for (final d in QuestDifficulty.values) d: basisPoints,
        },
        evidenceFactors: {
          for (final e in EvidenceLevel.values)
            e: (e == EvidenceLevel.lightweight ? 10500 : basisPoints),
        },
        groupFactors: {},
        growthPotentialFactors: {for (final d in LifeDomain.values) d: 2500},
      );
      final preview = const LifeProgressionEngine().preview(
        activity: activity,
        quest: QuestSnapshot.fromQuest(quest),
        evidence: evidence,
        policy: policy,
      );
      expect(preview.formulaVersion, 'fixture-v1');
      expect(preview.rewards, [
        Reward(
          type: RewardType.lifeXp,
          domain: LifeDomain.learning,
          amount: 126,
        ),
        Reward(
          type: RewardType.growthPotential,
          potentialCategory: GrowthPotentialCategory.cognitive,
          amount: 31,
        ),
      ]);
      final selfReportedPreview = const LifeProgressionEngine().preview(
        activity: activity,
        quest: QuestSnapshot.fromQuest(quest),
        evidence: EvidenceSummary(
          activityId: 'a',
          highestLevel: EvidenceLevel.lightweight,
          evidenceBonusEligibility: false,
          competitiveEligible: false,
          verificationStatus: VerificationStatus.captured,
          updatedAt: now,
        ),
        policy: policy,
      );
      expect(selfReportedPreview.rewards.first.amount, 120);
    },
  );

  test('life progression rejects snapshots from another activity', () {
    final activity = LifeActivity(
      id: 'a',
      userId: 'u',
      lifeQuestId: 'q',
      domain: LifeDomain.learning,
      startedAt: now,
      completedAt: now,
      normalizedDuration: Duration.zero,
      difficultySnapshot: QuestDifficulty.normal,
      activityGroup: 'reading',
    );
    final evidence = EvidenceSummary(
      activityId: 'other',
      highestLevel: EvidenceLevel.selfReport,
      evidenceBonusEligibility: false,
      competitiveEligible: false,
      verificationStatus: VerificationStatus.selfReported,
      updatedAt: now,
    );
    final policy = LifeProgressionPolicy(
      formulaVersion: 'v1',
      baseXpByActivityGroup: {'reading': 1},
      durationFactors: [
        const DurationFactor(upTo: null, factorBasisPoints: basisPoints),
      ],
      challengeFactors: {
        for (final d in QuestDifficulty.values) d: basisPoints,
      },
      evidenceFactors: {for (final e in EvidenceLevel.values) e: basisPoints},
      groupFactors: {},
      growthPotentialFactors: {
        for (final d in LifeDomain.values) d: basisPoints,
      },
    );
    expect(
      () => const LifeProgressionEngine().preview(
        activity: activity,
        quest: QuestSnapshot(
          id: 'q',
          domain: LifeDomain.learning,
          difficulty: QuestDifficulty.normal,
          activityGroup: 'reading',
        ),
        evidence: evidence,
        policy: policy,
      ),
      throwsArgumentError,
    );
  });

  test(
    'reward ledger grants once and rejects reuse of a key for another payload',
    () {
      final reward = Reward(
        type: RewardType.lifeXp,
        domain: LifeDomain.learning,
        amount: 20,
      );
      RewardGrant grant(String id, Reward value) => RewardGrant(
        id: id,
        userId: 'u',
        sourceType: RewardSourceType.lifeActivity,
        sourceId: 'activity',
        rewards: [value],
        idempotencyKey: 'complete:activity',
        formulaVersion: 'v1',
        createdAt: now,
      );
      final first = grant('g1', reward);
      expect(recordRewardGrant([], first), isA<GrantAdded>());
      final retry = recordRewardGrant([first], grant('g2', reward));
      expect(retry, isA<GrantAlreadyRecorded>());
      expect((retry as GrantAlreadyRecorded).grant.id, 'g1');
      expect(
        () => recordRewardGrant(
          [first],
          grant(
            'g3',
            Reward(
              type: RewardType.lifeXp,
              domain: LifeDomain.learning,
              amount: 21,
            ),
          ),
        ),
        throwsA(isA<IdempotencyConflict>()),
      );
    },
  );

  test('growth balance is a projection of grants and training spend', () {
    final grant = RewardGrant(
      id: 'g',
      userId: 'u',
      sourceType: RewardSourceType.lifeActivity,
      sourceId: 'a',
      rewards: [
        Reward(
          type: RewardType.growthPotential,
          potentialCategory: GrowthPotentialCategory.cognitive,
          amount: 18,
        ),
      ],
      idempotencyKey: 'a',
      formulaVersion: 'v1',
      createdAt: now,
    );
    final balance = projectGrowthPotential(
      [grant],
      spent: {GrowthPotentialCategory.cognitive: 5},
    );
    final cognitive = balance.singleWhere(
      (item) => item.category == GrowthPotentialCategory.cognitive,
    );
    expect(cognitive.availableAmount, 13);
    expect(cognitive.lifetimeEarned, 18);
    expect(cognitive.lifetimeSpent, 5);
    expect(
      () => projectGrowthPotential(
        [grant],
        spent: {GrowthPotentialCategory.cognitive: 19},
      ),
      throwsStateError,
    );
  });
}
