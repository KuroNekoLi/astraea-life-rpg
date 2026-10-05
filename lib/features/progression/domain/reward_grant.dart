import 'reward.dart';

enum RewardSourceType { lifeActivity, battle, achievement, other }

/// Append-only canonical reward transaction. Projections must derive from grants.
final class RewardGrant {
  RewardGrant({
    required this.id,
    required this.userId,
    required this.sourceType,
    required this.sourceId,
    required Iterable<Reward> rewards,
    required this.idempotencyKey,
    required this.formulaVersion,
    required this.createdAt,
    this.schemaVersion = 1,
  }) : rewards = List.unmodifiable(rewards) {
    for (final entry in {
      'id': id,
      'userId': userId,
      'sourceId': sourceId,
      'idempotencyKey': idempotencyKey,
      'formulaVersion': formulaVersion,
    }.entries) {
      if (entry.value.trim().isEmpty) {
        throw ArgumentError.value(entry.value, entry.key);
      }
    }
    if (this.rewards.isEmpty) {
      throw ArgumentError('A grant must contain a reward');
    }
    if (schemaVersion < 1) {
      throw ArgumentError.value(schemaVersion, 'schemaVersion');
    }
  }

  factory RewardGrant.confirm({
    required String id,
    required RewardPreview preview,
    required RewardSourceType sourceType,
    required String idempotencyKey,
    required DateTime createdAt,
  }) => RewardGrant(
    id: id,
    userId: preview.userId,
    sourceType: sourceType,
    sourceId: preview.sourceId,
    rewards: preview.rewards,
    idempotencyKey: idempotencyKey,
    formulaVersion: preview.formulaVersion,
    createdAt: createdAt,
  );

  final String id;
  final String userId;
  final RewardSourceType sourceType;
  final String sourceId;
  final List<Reward> rewards;
  final String idempotencyKey;
  final String formulaVersion;
  final DateTime createdAt;
  final int schemaVersion;
}

final class RewardPreview {
  RewardPreview({
    required this.userId,
    required this.sourceId,
    required Iterable<Reward> rewards,
    required this.formulaVersion,
  }) : rewards = List.unmodifiable(rewards) {
    if (userId.trim().isEmpty ||
        sourceId.trim().isEmpty ||
        formulaVersion.trim().isEmpty) {
      throw ArgumentError(
        'Preview identifiers and formulaVersion are required',
      );
    }
    if (this.rewards.isEmpty) {
      throw ArgumentError('A preview must contain a reward');
    }
  }

  final String userId;
  final String sourceId;
  final List<Reward> rewards;
  final String formulaVersion;
}
