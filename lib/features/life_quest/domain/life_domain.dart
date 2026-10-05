/// The three life domains approved for the MVP.
enum LifeDomain { fitness, learning, languages }

enum GrowthPotentialCategory { physical, cognitive, communication }

extension LifeDomainGrowth on LifeDomain {
  GrowthPotentialCategory get growthPotentialCategory => switch (this) {
    LifeDomain.fitness => GrowthPotentialCategory.physical,
    LifeDomain.learning => GrowthPotentialCategory.cognitive,
    LifeDomain.languages => GrowthPotentialCategory.communication,
  };
}

enum LifeQuestType { quick, habit, challenge, milestone }

enum LifeQuestStatus { active, paused, archived }

enum LifeQuestRecurrence { once, daily, weekly }

enum QuestDifficulty { easy, normal, hard, epic }
