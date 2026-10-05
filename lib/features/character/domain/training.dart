import '../../life_quest/domain/life_domain.dart';
import 'attribute.dart';

final class TrainingDefinition {
  TrainingDefinition({
    required this.id,
    required this.contentVersion,
    required this.potentialCategory,
    required this.potentialCost,
    required Map<AttributeType, int> attributeDeltas,
    required this.efficiencyCurveId,
  }) : attributeDeltas = Map.unmodifiable(attributeDeltas) {
    if (id.trim().isEmpty ||
        contentVersion.trim().isEmpty ||
        efficiencyCurveId.trim().isEmpty) {
      throw ArgumentError(
        'Training identifiers and content version are required',
      );
    }
    if (potentialCost <= 0 ||
        this.attributeDeltas.isEmpty ||
        this.attributeDeltas.values.any((delta) => delta <= 0)) {
      throw ArgumentError(
        'Training requires a positive cost and positive authored attribute deltas',
      );
    }
  }
  final String id;
  final String contentVersion;
  final GrowthPotentialCategory potentialCategory;
  final int potentialCost;
  final Map<AttributeType, int> attributeDeltas;
  final String efficiencyCurveId;
}

final class TrainingConversion {
  TrainingConversion({
    required this.id,
    required this.userId,
    required this.characterId,
    required this.trainingDefinitionId,
    required this.trainingContentVersion,
    required this.potentialCategory,
    required this.amountSpent,
    required Map<AttributeType, int> attributeDeltas,
    required this.idempotencyKey,
    required this.createdAt,
    this.schemaVersion = 1,
  }) : attributeDeltas = Map.unmodifiable(attributeDeltas) {
    for (final value in [
      id,
      userId,
      characterId,
      trainingDefinitionId,
      trainingContentVersion,
      idempotencyKey,
    ]) {
      if (value.trim().isEmpty) {
        throw ArgumentError('Conversion identifiers are required');
      }
    }
    if (amountSpent <= 0 ||
        this.attributeDeltas.isEmpty ||
        this.attributeDeltas.values.any((delta) => delta <= 0) ||
        schemaVersion < 1) {
      throw ArgumentError('Conversion values must be positive');
    }
  }
  final String id;
  final String userId;
  final String characterId;
  final String trainingDefinitionId;
  final String trainingContentVersion;
  final GrowthPotentialCategory potentialCategory;
  final int amountSpent;
  final Map<AttributeType, int> attributeDeltas;
  final String idempotencyKey;
  final DateTime createdAt;
  final int schemaVersion;
}

sealed class TrainingResult {
  const TrainingResult(this.conversion);
  final TrainingConversion conversion;
}

final class TrainingConverted extends TrainingResult {
  const TrainingConverted(super.conversion);
}

final class TrainingAlreadyConverted extends TrainingResult {
  const TrainingAlreadyConverted(super.conversion);
}

final class InsufficientGrowthPotential implements Exception {
  const InsufficientGrowthPotential(this.available, this.required);
  final int available;
  final int required;
}

final class TrainingEngine {
  const TrainingEngine();

  TrainingResult convert({
    required List<TrainingConversion> history,
    required TrainingConversion proposed,
    required TrainingDefinition definition,
    required int availablePotential,
  }) {
    if (proposed.trainingDefinitionId != definition.id ||
        proposed.trainingContentVersion != definition.contentVersion ||
        proposed.potentialCategory != definition.potentialCategory ||
        proposed.amountSpent != definition.potentialCost ||
        !_sameDeltas(proposed.attributeDeltas, definition.attributeDeltas)) {
      throw ArgumentError(
        'Conversion must match its authored TrainingDefinition',
      );
    }
    for (final prior in history) {
      if (prior.idempotencyKey != proposed.idempotencyKey) continue;
      if (prior.userId != proposed.userId ||
          prior.characterId != proposed.characterId ||
          prior.trainingDefinitionId != proposed.trainingDefinitionId ||
          prior.trainingContentVersion != proposed.trainingContentVersion ||
          prior.potentialCategory != proposed.potentialCategory ||
          prior.amountSpent != proposed.amountSpent ||
          !_sameDeltas(prior.attributeDeltas, proposed.attributeDeltas)) {
        throw StateError(
          'Training idempotency key conflicts with a previous conversion',
        );
      }
      return TrainingAlreadyConverted(prior);
    }
    if (availablePotential < definition.potentialCost) {
      throw InsufficientGrowthPotential(
        availablePotential,
        definition.potentialCost,
      );
    }
    return TrainingConverted(proposed);
  }
}

bool _sameDeltas(Map<AttributeType, int> a, Map<AttributeType, int> b) =>
    a.length == b.length &&
    a.entries.every((entry) => b[entry.key] == entry.value);

AttributeState projectAttributeState({
  required String characterId,
  required Map<AttributeType, AttributeValue> baseValues,
  required Iterable<TrainingConversion> conversions,
}) {
  if (!baseValues.keys.toSet().containsAll(AttributeType.values)) {
    throw ArgumentError('Base values must include all eight attributes');
  }
  final totals = {for (final attribute in AttributeType.values) attribute: 0};
  for (final conversion in conversions.where(
    (event) => event.characterId == characterId,
  )) {
    for (final entry in conversion.attributeDeltas.entries) {
      totals.update(entry.key, (current) => current + entry.value);
    }
  }
  return AttributeState(
    characterId: characterId,
    values: {
      for (final attribute in AttributeType.values)
        attribute: AttributeValue(
          baseValue: baseValues[attribute]!.baseValue,
          aptitudeModifier: baseValues[attribute]!.aptitudeModifier,
          temporaryModifier: baseValues[attribute]!.temporaryModifier,
          permanentGrowth:
              baseValues[attribute]!.permanentGrowth + totals[attribute]!,
        ),
    },
  );
}
