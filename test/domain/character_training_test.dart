import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/character/domain/training.dart';
import 'package:astraea_life_rpg/features/life_quest/domain/life_domain.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);
  final allocation = {for (final a in AttributeType.values) a: 4};

  test('initial allocation spends 32 points over eight attributes', () {
    final state = CharacterInitialAllocation(
      allocation,
    ).toAttributeState('hero');
    expect(
      state.values.values.map((value) => value.baseValue),
      everyElement(12),
    );
    expect(
      () => CharacterInitialAllocation({
        ...allocation,
        AttributeType.analysis: 3,
      }),
      throwsArgumentError,
    );
    expect(
      () => CharacterInitialAllocation({
        ...allocation,
        AttributeType.analysis: 8,
      }),
      throwsArgumentError,
    );
  });

  test(
    'training converts authored potential once and projects attribute growth',
    () {
      final definition = TrainingDefinition(
        id: 'analysis-drill',
        contentVersion: 'mvp-1',
        potentialCategory: GrowthPotentialCategory.cognitive,
        potentialCost: 10,
        attributeDeltas: {AttributeType.analysis: 1},
        efficiencyCurveId: 'curve-tbd',
      );
      TrainingConversion event(String id) => TrainingConversion(
        id: id,
        userId: 'u',
        characterId: 'hero',
        trainingDefinitionId: definition.id,
        trainingContentVersion: definition.contentVersion,
        potentialCategory: definition.potentialCategory,
        amountSpent: definition.potentialCost,
        attributeDeltas: definition.attributeDeltas,
        idempotencyKey: 'train:hero:1',
        createdAt: now,
      );
      const engine = TrainingEngine();
      final created = engine.convert(
        history: [],
        proposed: event('c1'),
        definition: definition,
        availablePotential: 10,
      );
      expect(created, isA<TrainingConverted>());
      final retry = engine.convert(
        history: [(created as TrainingConverted).conversion],
        proposed: event('c2'),
        definition: definition,
        availablePotential: 0,
      );
      expect(retry, isA<TrainingAlreadyConverted>());
      expect(
        () => engine.convert(
          history: [],
          proposed: event('c3'),
          definition: definition,
          availablePotential: 9,
        ),
        throwsA(isA<InsufficientGrowthPotential>()),
      );

      final base = CharacterInitialAllocation(
        allocation,
      ).toAttributeState('hero');
      final projected = projectAttributeState(
        characterId: 'hero',
        baseValues: base.values,
        conversions: [(created).conversion],
      );
      expect(projected.values[AttributeType.analysis]!.effectiveValue, 13);
      expect(projected.values[AttributeType.computation]!.effectiveValue, 12);
    },
  );
}
