enum AttributeType {
  manaCapacity,
  manaOutput,
  computation,
  processing,
  precision,
  efficiency,
  ambientSync,
  analysis,
}

final class AttributeState {
  AttributeState({
    required this.characterId,
    required Map<AttributeType, AttributeValue> values,
    this.projectionVersion = 1,
  }) : values = Map.unmodifiable(values) {
    if (characterId.trim().isEmpty) {
      throw ArgumentError.value(characterId, 'characterId');
    }
    if (!this.values.keys.toSet().containsAll(AttributeType.values)) {
      throw ArgumentError('All eight canonical attributes are required');
    }
  }
  final String characterId;
  final Map<AttributeType, AttributeValue> values;
  final int projectionVersion;
}

final class AttributeValue {
  const AttributeValue({
    required this.baseValue,
    this.aptitudeModifier = 0,
    this.permanentGrowth = 0,
    this.temporaryModifier = 0,
  });
  final int baseValue;
  final int aptitudeModifier;
  final int permanentGrowth;
  final int temporaryModifier;
  int get effectiveValue =>
      baseValue + aptitudeModifier + permanentGrowth + temporaryModifier;
}

const int baseAttributeValue = 8;
const int initialAllocationBudget = 32;
const int initialAttributeCap = 15;

final class CharacterInitialAllocation {
  CharacterInitialAllocation(Map<AttributeType, int> allocation)
    : allocation = Map.unmodifiable(allocation) {
    if (!this.allocation.keys.toSet().containsAll(AttributeType.values)) {
      throw ArgumentError(
        'Allocation must include all eight canonical attributes',
      );
    }
    if (this.allocation.values.any(
      (points) =>
          points < 0 || points > initialAttributeCap - baseAttributeValue,
    )) {
      throw ArgumentError(
        'Each initial allocation must fit the base value and cap',
      );
    }
    if (this.allocation.values.fold<int>(0, (sum, points) => sum + points) !=
        initialAllocationBudget) {
      throw ArgumentError(
        'Initial allocation must spend exactly $initialAllocationBudget points',
      );
    }
  }
  final Map<AttributeType, int> allocation;

  AttributeState toAttributeState(String characterId) => AttributeState(
    characterId: characterId,
    values: {
      for (final attribute in AttributeType.values)
        attribute: AttributeValue(
          baseValue: baseAttributeValue + allocation[attribute]!,
        ),
    },
  );
}
