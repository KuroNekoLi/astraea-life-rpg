import 'reward_grant.dart';

sealed class GrantResult {
  const GrantResult(this.grant);
  final RewardGrant grant;
}

final class GrantAdded extends GrantResult {
  const GrantAdded(super.grant);
}

final class GrantAlreadyRecorded extends GrantResult {
  const GrantAlreadyRecorded(super.grant);
}

/// Reusing an idempotency key for a different transaction is data corruption.
final class IdempotencyConflict implements Exception {
  const IdempotencyConflict(this.key);
  final String key;

  @override
  String toString() => 'IdempotencyConflict($key)';
}

/// Pure append operation. A repository will persist the same check atomically.
GrantResult recordRewardGrant(List<RewardGrant> ledger, RewardGrant candidate) {
  for (final grant in ledger) {
    if (grant.idempotencyKey != candidate.idempotencyKey) continue;
    final identical =
        grant.userId == candidate.userId &&
        grant.sourceType == candidate.sourceType &&
        grant.sourceId == candidate.sourceId &&
        grant.formulaVersion == candidate.formulaVersion &&
        _sameRewards(grant.rewards, candidate.rewards);
    if (!identical) throw IdempotencyConflict(candidate.idempotencyKey);
    return GrantAlreadyRecorded(grant);
  }
  return GrantAdded(candidate);
}

bool _sameRewards(List a, List b) =>
    a.length == b.length &&
    List.generate(a.length, (i) => a[i] == b[i]).every((v) => v);
