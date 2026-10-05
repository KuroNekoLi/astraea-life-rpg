import '../../life_quest/domain/life_domain.dart';

enum RewardType { lifeXp, growthPotential, gold }

/// A non-negative immutable reward entry in the canonical ledger.
final class Reward {
  Reward({
    required this.type,
    required this.amount,
    this.domain,
    this.potentialCategory,
  }) {
    if (amount < 0) throw ArgumentError.value(amount, 'amount');
    if ((type == RewardType.lifeXp) != (domain != null)) {
      throw ArgumentError('Life XP requires exactly one life domain');
    }
    if ((type == RewardType.growthPotential) != (potentialCategory != null)) {
      throw ArgumentError('Growth Potential requires exactly one category');
    }
  }

  final RewardType type;
  final int amount;
  final LifeDomain? domain;
  final GrowthPotentialCategory? potentialCategory;

  @override
  bool operator ==(Object other) =>
      other is Reward &&
      other.type == type &&
      other.amount == amount &&
      other.domain == domain &&
      other.potentialCategory == potentialCategory;

  @override
  int get hashCode => Object.hash(type, amount, domain, potentialCategory);
}
