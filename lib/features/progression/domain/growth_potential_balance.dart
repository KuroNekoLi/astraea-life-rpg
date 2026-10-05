import 'reward_grant.dart';
import 'reward.dart';
import '../../life_quest/domain/life_domain.dart';

final class GrowthPotentialBalance {
  GrowthPotentialBalance({
    required this.category,
    required this.availableAmount,
    required this.lifetimeEarned,
    required this.lifetimeSpent,
    this.projectionVersion = 1,
  }) {
    if (availableAmount < 0 ||
        lifetimeEarned < 0 ||
        lifetimeSpent < 0 ||
        availableAmount != lifetimeEarned - lifetimeSpent) {
      throw ArgumentError('Growth Potential projection is inconsistent');
    }
  }
  final GrowthPotentialCategory category;
  final int availableAmount;
  final int lifetimeEarned;
  final int lifetimeSpent;
  final int projectionVersion;
}

List<GrowthPotentialBalance> projectGrowthPotential(
  List<RewardGrant> grants, {
  Map<GrowthPotentialCategory, int> spent = const {},
}) {
  return GrowthPotentialCategory.values
      .map((category) {
        var earned = 0;
        for (final grant in grants) {
          for (final reward in grant.rewards) {
            if (reward.type == RewardType.growthPotential &&
                reward.potentialCategory == category) {
              earned += reward.amount;
            }
          }
        }
        final used = spent[category] ?? 0;
        if (used > earned) {
          throw StateError(
            'Spent potential exceeds earned balance for $category',
          );
        }
        return GrowthPotentialBalance(
          category: category,
          lifetimeEarned: earned,
          lifetimeSpent: used,
          availableAmount: earned - used,
        );
      })
      .toList(growable: false);
}
