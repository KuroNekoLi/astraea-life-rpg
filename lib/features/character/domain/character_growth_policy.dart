import '../../../game_engine/rng/rng.dart';
import '../../life_quest/domain/life_domain.dart';
import 'attribute.dart';

/// Versioned MVP policy for Aptitude, Fate, and Growth Potential conversion.
/// All balance values are supplied by authored content, never guessed here.
final class CharacterGrowthPolicy {
  CharacterGrowthPolicy({
    required this.contentVersion,
    required this.aptitudeDieSides,
    required List<AptitudeCostBand> aptitudeCostBands,
    required this.directAttributeModifier,
    required this.fateRerollsPerCharacter,
    required this.fateDieSides,
    required this.mustAcceptFateReroll,
    required this.basePotentialCost,
    required this.attributeGrowthPerSession,
    required List<GrowthCostTier> growthCostTiers,
    required List<PolicyTrainingDefinition> definitions,
  }) : aptitudeCostBands = List.unmodifiable(aptitudeCostBands),
       growthCostTiers = List.unmodifiable(growthCostTiers),
       definitions = List.unmodifiable(definitions) {
    if (contentVersion.trim().isEmpty ||
        aptitudeDieSides < 2 ||
        fateDieSides < 2 ||
        fateRerollsPerCharacter != 1 ||
        !mustAcceptFateReroll ||
        basePotentialCost <= 0 ||
        attributeGrowthPerSession <= 0 ||
        directAttributeModifier != 0) {
      throw ArgumentError('Invalid MVP character-growth policy');
    }
    _validateBands(this.aptitudeCostBands, aptitudeDieSides);
    _validateTiers(this.growthCostTiers);
    final ids = this.definitions.map((definition) => definition.id).toSet();
    if (ids.length != this.definitions.length ||
        ids.isEmpty ||
        this.definitions.any((definition) => definition.id.trim().isEmpty)) {
      throw ArgumentError(
        'Training definition ids must be unique and nonempty',
      );
    }
  }

  factory CharacterGrowthPolicy.fromJson(Map<String, dynamic> json) {
    if (json['status'] != 'prototype-balance') {
      throw const FormatException(
        'Growth policy must identify prototype balance',
      );
    }
    final aptitude = json['aptitude'] as Map<String, dynamic>;
    final fate = json['fate'] as Map<String, dynamic>;
    final training = json['training'] as Map<String, dynamic>;
    final bands = (aptitude['trainingCostAdjustments'] as List<dynamic>).map((
      raw,
    ) {
      final band = raw as Map<String, dynamic>;
      return AptitudeCostBand(
        minimum: band['min'] as int,
        maximum: band['max'] as int,
        potentialDelta: band['potentialDelta'] as int,
      );
    }).toList();
    final tiers = (training['growthCostTiers'] as List<dynamic>).map((raw) {
      final tier = raw as Map<String, dynamic>;
      return GrowthCostTier(
        minimumPriorGrowth: tier['minPriorGrowth'] as int,
        maximumPriorGrowth: tier['maxPriorGrowth'] as int?,
        multiplier: tier['multiplier'] as int,
      );
    }).toList();
    final definitions = (training['definitions'] as List<dynamic>).map((raw) {
      final definition = raw as Map<String, dynamic>;
      return PolicyTrainingDefinition(
        id: definition['id'] as String,
        potentialCategory: GrowthPotentialCategory.values.byName(
          definition['potentialCategory'] as String,
        ),
        attribute: AttributeType.values.byName(
          definition['attribute'] as String,
        ),
      );
    }).toList();
    return CharacterGrowthPolicy(
      contentVersion: json['contentVersion'] as String,
      aptitudeDieSides: aptitude['dieSides'] as int,
      aptitudeCostBands: bands,
      directAttributeModifier: aptitude['directAttributeModifier'] as int,
      fateRerollsPerCharacter: fate['rerollsPerCharacter'] as int,
      fateDieSides: fate['dieSides'] as int,
      mustAcceptFateReroll: fate['mustAcceptNewResult'] as bool,
      basePotentialCost: training['basePotentialCost'] as int,
      attributeGrowthPerSession: training['attributeGrowthPerSession'] as int,
      growthCostTiers: tiers,
      definitions: definitions,
    );
  }

  final String contentVersion;
  final int aptitudeDieSides;
  final List<AptitudeCostBand> aptitudeCostBands;
  final int directAttributeModifier;
  final int fateRerollsPerCharacter;
  final int fateDieSides;
  final bool mustAcceptFateReroll;
  final int basePotentialCost;
  final int attributeGrowthPerSession;
  final List<GrowthCostTier> growthCostTiers;
  final List<PolicyTrainingDefinition> definitions;

  AptitudeProfile rollAptitudes(Rng rng) => AptitudeProfile(
    contentVersion: contentVersion,
    ratings: {
      for (final attribute in AttributeType.values)
        attribute: rng.nextInt(aptitudeDieSides) + 1,
    },
  );

  AptitudeReroll rerollOne({
    required AptitudeProfile profile,
    required AttributeType attribute,
    required Rng rng,
  }) {
    if (profile.contentVersion != contentVersion ||
        profile.ratings.length != AttributeType.values.length) {
      throw ArgumentError(
        'Aptitude profile belongs to another content version',
      );
    }
    if (fateRerollsPerCharacter != 1 || profile.fateRerollUsed) {
      throw StateError('Fate reroll has already been used or is unavailable');
    }
    final previous = profile.ratings[attribute];
    if (previous == null || !mustAcceptFateReroll) {
      throw StateError(
        'Fate policy must replace and accept one aptitude rating',
      );
    }
    final next = rng.nextInt(fateDieSides) + 1;
    return AptitudeReroll(
      profile: AptitudeProfile(
        contentVersion: contentVersion,
        ratings: {...profile.ratings, attribute: next},
        fateRerollUsed: true,
      ),
      attribute: attribute,
      previousRating: previous,
      newRating: next,
    );
  }

  TrainingCostQuote quoteTrainingCost({
    required String trainingDefinitionId,
    required AptitudeProfile aptitude,
    required int currentPermanentGrowth,
  }) {
    if (aptitude.contentVersion != contentVersion ||
        aptitude.ratings.length != AttributeType.values.length) {
      throw ArgumentError(
        'Aptitude profile belongs to another content version',
      );
    }
    if (currentPermanentGrowth < 0) {
      throw ArgumentError.value(
        currentPermanentGrowth,
        'currentPermanentGrowth',
      );
    }
    final definition = definitions.firstWhere(
      (item) => item.id == trainingDefinitionId,
      orElse: () => throw ArgumentError.value(
        trainingDefinitionId,
        'trainingDefinitionId',
      ),
    );
    final rating = aptitude.ratings[definition.attribute]!;
    final aptitudeBand = aptitudeCostBands.firstWhere(
      (band) => band.contains(rating),
    );
    final growthTier = growthCostTiers.firstWhere(
      (tier) => tier.contains(currentPermanentGrowth),
    );
    final adjustedBase = basePotentialCost + aptitudeBand.potentialDelta;
    if (adjustedBase <= 0) {
      throw StateError(
        'Authored aptitude adjustment creates a nonpositive cost',
      );
    }
    return TrainingCostQuote(
      contentVersion: contentVersion,
      trainingDefinitionId: definition.id,
      potentialCategory: definition.potentialCategory,
      attribute: definition.attribute,
      aptitudeRating: rating,
      aptitudeCostDelta: aptitudeBand.potentialDelta,
      basePotentialCost: basePotentialCost,
      growthCostMultiplier: growthTier.multiplier,
      potentialCost: adjustedBase * growthTier.multiplier,
      attributeGrowth: attributeGrowthPerSession,
    );
  }

  static void _validateBands(List<AptitudeCostBand> bands, int dieSides) {
    final coverage = <int>[];
    for (final band in bands) {
      if (band.minimum < 1 ||
          band.maximum < band.minimum ||
          band.maximum > dieSides) {
        throw ArgumentError('Invalid aptitude rating band');
      }
      coverage.addAll(
        List.generate(
          band.maximum - band.minimum + 1,
          (index) => band.minimum + index,
        ),
      );
    }
    if (coverage.toSet().length != dieSides || coverage.length != dieSides) {
      throw ArgumentError(
        'Aptitude cost bands must cover each roll exactly once',
      );
    }
  }

  static void _validateTiers(List<GrowthCostTier> tiers) {
    if (tiers.isEmpty || tiers.first.minimumPriorGrowth != 0) {
      throw ArgumentError('Growth cost tiers must start at zero growth');
    }
    for (var index = 0; index < tiers.length; index++) {
      final tier = tiers[index];
      if (tier.multiplier <= 0 ||
          tier.maximumPriorGrowth != null &&
              tier.maximumPriorGrowth! < tier.minimumPriorGrowth) {
        throw ArgumentError('Invalid growth cost tier');
      }
      if (index == tiers.length - 1) {
        if (tier.maximumPriorGrowth != null) {
          throw ArgumentError('Final growth cost tier must be open-ended');
        }
      } else {
        final next = tiers[index + 1];
        if (tier.maximumPriorGrowth == null ||
            next.minimumPriorGrowth != tier.maximumPriorGrowth! + 1) {
          throw ArgumentError('Growth cost tiers must be contiguous');
        }
      }
    }
  }
}

final class AptitudeCostBand {
  const AptitudeCostBand({
    required this.minimum,
    required this.maximum,
    required this.potentialDelta,
  });

  final int minimum;
  final int maximum;
  final int potentialDelta;

  bool contains(int rating) => rating >= minimum && rating <= maximum;
}

final class GrowthCostTier {
  const GrowthCostTier({
    required this.minimumPriorGrowth,
    required this.maximumPriorGrowth,
    required this.multiplier,
  });

  final int minimumPriorGrowth;
  final int? maximumPriorGrowth;
  final int multiplier;

  bool contains(int growth) =>
      growth >= minimumPriorGrowth &&
      (maximumPriorGrowth == null || growth <= maximumPriorGrowth!);
}

final class PolicyTrainingDefinition {
  const PolicyTrainingDefinition({
    required this.id,
    required this.potentialCategory,
    required this.attribute,
  });

  final String id;
  final GrowthPotentialCategory potentialCategory;
  final AttributeType attribute;
}

final class AptitudeProfile {
  AptitudeProfile({
    required this.contentVersion,
    required Map<AttributeType, int> ratings,
    this.fateRerollUsed = false,
  }) : ratings = Map.unmodifiable(ratings) {
    if (contentVersion.trim().isEmpty ||
        this.ratings.keys.length != AttributeType.values.length ||
        !this.ratings.keys.toSet().containsAll(AttributeType.values) ||
        this.ratings.values.any((rating) => rating < 1 || rating > 6)) {
      throw ArgumentError('Aptitude profile requires one rating per attribute');
    }
  }

  final String contentVersion;
  final Map<AttributeType, int> ratings;
  final bool fateRerollUsed;
}

final class AptitudeReroll {
  const AptitudeReroll({
    required this.profile,
    required this.attribute,
    required this.previousRating,
    required this.newRating,
  });

  final AptitudeProfile profile;
  final AttributeType attribute;
  final int previousRating;
  final int newRating;
}

final class TrainingCostQuote {
  const TrainingCostQuote({
    required this.contentVersion,
    required this.trainingDefinitionId,
    required this.potentialCategory,
    required this.attribute,
    required this.aptitudeRating,
    required this.aptitudeCostDelta,
    required this.basePotentialCost,
    required this.growthCostMultiplier,
    required this.potentialCost,
    required this.attributeGrowth,
  });

  final String contentVersion;
  final String trainingDefinitionId;
  final GrowthPotentialCategory potentialCategory;
  final AttributeType attribute;
  final int aptitudeRating;
  final int aptitudeCostDelta;
  final int basePotentialCost;
  final int growthCostMultiplier;
  final int potentialCost;
  final int attributeGrowth;
}
