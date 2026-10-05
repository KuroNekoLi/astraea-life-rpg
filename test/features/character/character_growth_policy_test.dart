import 'dart:convert';

import 'package:astraea_life_rpg/features/character/domain/attribute.dart';
import 'package:astraea_life_rpg/features/character/domain/character_growth_policy.dart';
import 'package:astraea_life_rpg/game_engine/rng/rng.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CharacterGrowthPolicy policy;

  setUp(() async {
    final content =
        jsonDecode(
              await rootBundle.loadString(
                'assets/content/progression/character_growth_mvp_v1.json',
              ),
            )
            as Map<String, dynamic>;
    policy = CharacterGrowthPolicy.fromJson(content);
  });

  test('loads a versioned, complete prototype policy', () {
    expect(policy.contentVersion, 'character-growth-mvp-1');
    expect(policy.definitions, hasLength(6));
    expect(policy.directAttributeModifier, 0);
    expect(policy.fateRerollsPerCharacter, 1);
    expect(policy.mustAcceptFateReroll, isTrue);
  });

  test(
    'aptitude adjusts cost and growth tiers provide diminishing returns',
    () {
      final ratings = {
        for (final attribute in AttributeType.values) attribute: 3,
        AttributeType.analysis: 1,
        AttributeType.computation: 6,
      };
      final profile = AptitudeProfile(
        contentVersion: policy.contentVersion,
        ratings: ratings,
      );

      final lowAptitude = policy.quoteTrainingCost(
        trainingDefinitionId: 'function-analysis-drill',
        aptitude: profile,
        currentPermanentGrowth: 0,
      );
      final highAptitude = policy.quoteTrainingCost(
        trainingDefinitionId: 'complexity-exercise',
        aptitude: profile,
        currentPermanentGrowth: 0,
      );
      final secondTier = policy.quoteTrainingCost(
        trainingDefinitionId: 'complexity-exercise',
        aptitude: profile,
        currentPermanentGrowth: 5,
      );
      final thirdTier = policy.quoteTrainingCost(
        trainingDefinitionId: 'mana-control-drill',
        aptitude: profile,
        currentPermanentGrowth: 10,
      );

      expect(lowAptitude.potentialCost, 20);
      expect(lowAptitude.attributeGrowth, 1);
      expect(highAptitude.potentialCost, 16);
      expect(secondTier.potentialCost, 32);
      expect(thirdTier.potentialCost, 54);
    },
  );

  test('rolls all attributes and Fate replaces one selected result once', () {
    final profile = policy.rollAptitudes(
      _SequenceRng(List.generate(8, (i) => i)),
    );
    expect(profile.ratings.values.toList(), [1, 2, 3, 4, 5, 6, 1, 2]);

    final reroll = policy.rerollOne(
      profile: profile,
      attribute: AttributeType.efficiency,
      rng: _SequenceRng([0]),
    );
    expect(reroll.previousRating, 6);
    expect(reroll.newRating, 1);
    expect(reroll.profile.ratings[AttributeType.efficiency], 1);
    expect(reroll.profile.fateRerollUsed, isTrue);
    expect(
      () => policy.rerollOne(
        profile: reroll.profile,
        attribute: AttributeType.analysis,
        rng: _SequenceRng([5]),
      ),
      throwsStateError,
    );
  });

  test(
    'rejects negative growth and an attribute profile from another version',
    () {
      final profile = AptitudeProfile(
        contentVersion: policy.contentVersion,
        ratings: {for (final attribute in AttributeType.values) attribute: 3},
      );
      expect(
        () => policy.quoteTrainingCost(
          trainingDefinitionId: 'function-analysis-drill',
          aptitude: profile,
          currentPermanentGrowth: -1,
        ),
        throwsArgumentError,
      );
      expect(
        () => policy.quoteTrainingCost(
          trainingDefinitionId: 'function-analysis-drill',
          aptitude: AptitudeProfile(
            contentVersion: 'old-policy',
            ratings: profile.ratings,
          ),
          currentPermanentGrowth: 0,
        ),
        throwsArgumentError,
      );
    },
  );
}

final class _SequenceRng implements Rng {
  _SequenceRng(this.values);

  final List<int> values;
  var _index = 0;

  @override
  int nextInt(int max) => values[_index++] % max;
}
