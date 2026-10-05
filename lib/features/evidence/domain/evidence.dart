enum EvidenceLevel { selfReport, lightweight, connected, outcome }

enum EvidenceType { selfReport, timer, note }

enum VerificationStatus { selfReported, captured, verified }

/// Evidence metadata and provenance only; evidence does not calculate rewards.
final class Evidence {
  Evidence({
    required this.id,
    required this.activityId,
    required this.type,
    required this.level,
    required this.sourceProvider,
    required this.capturedAt,
    required this.privacy,
    this.sourceRecordId,
    this.verifiedAt,
    this.confidence,
    this.verificationVersion = 1,
    this.schemaVersion = 1,
  }) {
    for (final entry in {
      'id': id,
      'activityId': activityId,
      'sourceProvider': sourceProvider,
      'privacy': privacy,
    }.entries) {
      if (entry.value.trim().isEmpty) {
        throw ArgumentError.value(entry.value, entry.key);
      }
    }
    if (confidence != null && (confidence! < 0 || confidence! > 1)) {
      throw ArgumentError.value(
        confidence,
        'confidence',
        'Must be between 0 and 1',
      );
    }
    if (verifiedAt != null && verifiedAt!.isBefore(capturedAt)) {
      throw ArgumentError('verifiedAt cannot precede capturedAt');
    }
    if (verificationVersion < 1 || schemaVersion < 1) {
      throw ArgumentError('Version fields must be positive');
    }
  }

  final String id;
  final String activityId;
  final EvidenceType type;
  final EvidenceLevel level;
  final String sourceProvider;
  final String? sourceRecordId;
  final DateTime capturedAt;
  final DateTime? verifiedAt;
  final double? confidence;
  final String privacy;
  final int verificationVersion;
  final int schemaVersion;
}

/// Read-only projection supplied to progression rules; never stored as evidence.
final class EvidenceSummary {
  EvidenceSummary({
    required this.activityId,
    required this.highestLevel,
    required this.evidenceBonusEligibility,
    required this.competitiveEligible,
    required this.verificationStatus,
    this.projectionVersion = 1,
    required this.updatedAt,
  }) {
    if (activityId.trim().isEmpty) {
      throw ArgumentError.value(activityId, 'activityId');
    }
    if (projectionVersion < 1) {
      throw ArgumentError.value(projectionVersion, 'projectionVersion');
    }
  }

  final String activityId;
  final EvidenceLevel highestLevel;
  final bool evidenceBonusEligibility;
  final bool competitiveEligible;
  final VerificationStatus verificationStatus;
  final int projectionVersion;
  final DateTime updatedAt;
}
