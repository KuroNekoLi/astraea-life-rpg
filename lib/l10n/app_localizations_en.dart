// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Astraea';

  @override
  String get navHome => 'Home';

  @override
  String get navLife => 'Life';

  @override
  String get navAdventure => 'Adventure';

  @override
  String get navDeck => 'Deck';

  @override
  String get navCharacter => 'Character';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonStart => 'Start';

  @override
  String get commonFinish => 'Finish';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonResume => 'Resume';

  @override
  String get commonEnable => 'Enable';

  @override
  String get commonTurnOff => 'Turn off';

  @override
  String get splashTagline =>
      'Turn real-life effort into magic that changes the world.';

  @override
  String get tapToStart => 'Tap to start';

  @override
  String get welcomeToAstraea => 'Welcome to Astraea';

  @override
  String get onboardingHeadline =>
      'Your everyday effort can shape your Astraea self.';

  @override
  String get onboardingBody =>
      'Real life and the academy are connected, while your actions remain yours to choose.';

  @override
  String get enterAstraea => 'Enter Astraea';

  @override
  String get noStreakPenalty =>
      'No streak penalties. Progress waits whenever you do.';

  @override
  String get chooseLifeQuest => 'Choose a Life Quest';

  @override
  String get earnGrowthPotential => 'Earn Growth Potential';

  @override
  String get buildRpgSelf => 'Build your RPG self';

  @override
  String get chooseLifeQuestDescription =>
      'Pick a real-world action when it fits your day.';

  @override
  String get earnGrowthPotentialDescription =>
      'Your action creates an opportunity to grow in-game.';

  @override
  String get buildRpgSelfDescription =>
      'Train, prepare your deck, and explore the academy.';

  @override
  String get homeBrandSubtitle => 'LIFE × RPG';

  @override
  String get homeHeroEyebrow => 'Astraea Academy · Chapter 01';

  @override
  String get homeHeroTitle => 'One real action starts your journey.';

  @override
  String get homeHeroDescription =>
      'Choose a Life Quest, earn Growth Potential, and shape the hero who explores Astraea.';

  @override
  String get yourJourney => 'YOUR JOURNEY';

  @override
  String get continueYourJourney => 'Continue your journey';

  @override
  String get journeyLifeQuests => 'Life Quests';

  @override
  String get journeyLifeQuestsSubtitle => 'Start with one real action';

  @override
  String get journeyAdventure => 'Adventure';

  @override
  String get journeyAdventureSubtitle => 'Story & objectives';

  @override
  String get journeyCharacter => 'Character';

  @override
  String get journeyCharacterSubtitle => 'Your growing build';

  @override
  String get journeyPreparedDeck => 'Prepared Deck';

  @override
  String get journeyPreparedDeckSubtitle => 'Six spells';

  @override
  String get today => 'TODAY';

  @override
  String get allQuests => 'All Quests';

  @override
  String get lifeQuestsUnavailable =>
      'Life Quests are temporarily unavailable.';

  @override
  String get quietDayTitle => 'A quiet day is okay.';

  @override
  String get quietDaySubtitle => 'Choose a Life Quest whenever it fits.';

  @override
  String get growthPotentialReady => 'Growth Potential ready';

  @override
  String get characterProfileTooltip => 'Character profile';

  @override
  String get optionalPilotMeasurement => 'Optional pilot measurement';

  @override
  String get pilotOnLocalOnly => 'On · local only';

  @override
  String get pilotOffDefault => 'Off · default';

  @override
  String get pilotTurnOffTitle => 'Turn off pilot measurement?';

  @override
  String get pilotEnableTitle => 'Enable private pilot measurement?';

  @override
  String get pilotTurnOffBody =>
      'Turning this off deletes locally stored milestone events.';

  @override
  String get pilotEnableBody =>
      'This stores a small set of gameplay milestones on this device only. It does not collect names, notes, evidence, health data, or custom quest text. There is no upload. You can turn it off and delete the events at any time.';

  @override
  String potentialChooseHowToTrain(int amount) {
    return '$amount Potential · Choose how to train';
  }

  @override
  String get lifeQuest => 'Life Quest';

  @override
  String couldNotLoadQuests(String error) {
    return 'Could not load quests: $error';
  }

  @override
  String get chooseWhatFitsYourDay => 'Choose what fits your day.';

  @override
  String get progressAlwaysHere =>
      'Your progress is always here. There are no streak penalties.';

  @override
  String availableQuestCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count available quests',
      one: '1 available quest',
    );
    return '$_temp0';
  }

  @override
  String get domainAll => 'All';

  @override
  String get domainFitness => 'Fitness';

  @override
  String get domainLearning => 'Learning';

  @override
  String get domainLanguages => 'Languages';

  @override
  String get domainLife => 'Life';

  @override
  String get noQuestsCategory => 'No quests in this category yet.';

  @override
  String get addWhenReady => 'Add one when you are ready.';

  @override
  String get addLifeQuest => 'Add a Life Quest';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get questDetails => 'Quest details';

  @override
  String couldNotLoadQuest(String error) {
    return 'Could not load quest: $error';
  }

  @override
  String get questNotFound => 'Quest not found';

  @override
  String questAboutMinutes(String domain, int minutes) {
    return '$domain · about $minutes minutes';
  }

  @override
  String get selfReportTimerEvidence =>
      'Self-report is always available. A timer adds lightweight evidence.';

  @override
  String get startTimer => 'Start timer';

  @override
  String get completeSelfReport => 'Complete with self-report';

  @override
  String get questComplete => 'Quest complete';

  @override
  String lifeXpReward(int amount, String domain) {
    return '+$amount $domain Life XP';
  }

  @override
  String potentialReward(int amount, String category) {
    return '+$amount $category Potential';
  }

  @override
  String get timerEvidenceBonus => 'Timer evidence · bonus included';

  @override
  String get selfReportPrivate => 'Self-report · private';

  @override
  String get confirmReward => 'Confirm reward';

  @override
  String get questTimer => 'Quest timer';

  @override
  String get timerRunsAway => 'Timer runs while you are away.';

  @override
  String get potentialPhysical => 'Physical';

  @override
  String get potentialCognitive => 'Cognitive';

  @override
  String get potentialCommunication => 'Communication';

  @override
  String get potentialGrowth => 'Growth';

  @override
  String get questFitnessWalk10 => 'Walk 10 minutes';

  @override
  String get questFitnessExercise20 => 'Exercise 20 minutes';

  @override
  String get questLearningRead20 => 'Read 20 minutes';

  @override
  String get questLearningStudy20 => 'Study 20 minutes';

  @override
  String get questLanguagesPractice15 => 'Practice a language 15 minutes';

  @override
  String get createAstraeaSelf => 'Create your Astraea self';

  @override
  String get saving => 'Saving…';

  @override
  String get characterName => 'Character name';

  @override
  String get distributePoints => 'Distribute 32 points · Base 8 · Maximum 15';

  @override
  String get characterBuildFocusDescription =>
      'Choose your hero’s build focus. These Attributes are planned to shape combat options; no choice blocks the main story.';

  @override
  String pointsSpent(int spent, int budget) {
    return '$spent / $budget points';
  }

  @override
  String attributeAllocationSummary(
    int base,
    int allocated,
    int starting,
    String effect,
  ) {
    return 'Base $base + $allocated allocated = $starting starting value\n$effect';
  }

  @override
  String get initialWeapon => 'Initial weapon';

  @override
  String get weaponAstraeaLongsword => 'Astraea Longsword';

  @override
  String get weaponStandardSpear => 'Standard Spear';

  @override
  String get weaponTrainingArcaneGun => 'Training Arcane Gun';

  @override
  String get weaponStandardStaff => 'Standard Staff';

  @override
  String get attributeManaCapacity => 'Mana Capacity';

  @override
  String get attributeManaOutput => 'Mana Output';

  @override
  String get attributeComputation => 'Computation';

  @override
  String get attributeProcessing => 'Processing';

  @override
  String get attributePrecision => 'Precision';

  @override
  String get attributeEfficiency => 'Efficiency';

  @override
  String get attributeAmbientSync => 'Ambient Sync';

  @override
  String get attributeAnalysis => 'Analysis';

  @override
  String get attributeManaCapacityEffect =>
      'Focus: Mana limit and costly spell stamina';

  @override
  String get attributeManaOutputEffect =>
      'Focus: Safe output and burst spell size';

  @override
  String get attributeComputationEffect =>
      'Focus: Complex Functions and counter reasoning';

  @override
  String get attributeProcessingEffect =>
      'Focus: Initiative, reactions, and fast actions';

  @override
  String get attributePrecisionEffect =>
      'Focus: Targeting, interrupts, and control';

  @override
  String get attributeEfficiencyEffect =>
      'Focus: Mana use and resource efficiency';

  @override
  String get attributeAmbientSyncEffect =>
      'Focus: Environmental and support magic';

  @override
  String get attributeAnalysisEffect =>
      'Focus: Reveal enemy Weak Nodes and counters';

  @override
  String get character => 'Character';

  @override
  String get yourAstraeaSelf => 'Your Astraea self';

  @override
  String get characterAttributes => 'Character Attributes';

  @override
  String get trainingGrowsBuild =>
      'Training grows your chosen build over time.';

  @override
  String get attributesSection => 'ATTRIBUTES';

  @override
  String trainedDelta(int amount) {
    return '+$amount trained';
  }

  @override
  String get viewTraining => 'View Training';

  @override
  String get chooseStartingAttributesWeapon =>
      'Choose your starting Attributes and weapon to begin.';

  @override
  String get createCharacter => 'Create Character';

  @override
  String get couldNotLoadCharacter => 'Could not load your character.';

  @override
  String get training => 'Training';

  @override
  String get chooseTraining => 'Choose a Training';

  @override
  String get trainingDescription =>
      'Life Quest rewards become Growth Potential. Choose a matching drill to turn it into permanent character growth.';

  @override
  String get physicalPotential => 'Physical Potential';

  @override
  String get cognitivePotential => 'Cognitive Potential';

  @override
  String get communicationPotential => 'Communication Potential';

  @override
  String get potentialBuilding =>
      'Potential is building toward your next Training';

  @override
  String get potentialBuildingDescription =>
      'A new character starts with 0 Growth Potential. Your first Life Quest adds its authored reward to the matching category. Training stays locked until that category covers the quoted cost; no reward or cost is changed.';

  @override
  String trainingPotentialProgress(
    String category,
    int available,
    int cost,
    String attribute,
  ) {
    return '$category: $available / $cost · $attribute';
  }

  @override
  String get chooseAnotherLifeQuest => 'Choose another Life Quest';

  @override
  String get availableDrills => 'AVAILABLE DRILLS';

  @override
  String get analysisGrowthActive => 'Analysis growth is active';

  @override
  String permanentAnalysisGrowth(int amount) {
    return '+$amount permanent Analysis from Training';
  }

  @override
  String get keepJourneyMoving => 'Keep your journey moving';

  @override
  String get trainingPermanentDescription =>
      'Training changes your character permanently. Check the updated build, then return to the academy.';

  @override
  String get viewCharacter => 'View Character';

  @override
  String get continueAdventure => 'Continue Adventure';

  @override
  String get tryAnalysisAshfang => 'Try Analysis against Ashfang';

  @override
  String get trainingComplete =>
      'Training complete. Your attribute grew permanently.';

  @override
  String trainingPotentialToAttribute(String category, String attribute) {
    return '$category Potential → $attribute';
  }

  @override
  String trainingAttributeChange(String attribute, int before, int after) {
    return '$attribute $before → $after';
  }

  @override
  String aptitudeCost(int aptitude, int cost, String category) {
    return 'Aptitude $aptitude/6 · Cost $cost $category Potential';
  }

  @override
  String get trainingInProgress => 'Training…';

  @override
  String trainAttribute(String attribute) {
    return 'Train $attribute';
  }

  @override
  String needMorePotential(int amount, String category) {
    return 'Need $amount more $category Potential';
  }

  @override
  String get trainingReactionDrill => 'Reaction Drill';

  @override
  String get trainingPrecisionMovement => 'Precision Movement';

  @override
  String get trainingFunctionAnalysisDrill => 'Function Analysis Drill';

  @override
  String get trainingComplexityExercise => 'Complexity Exercise';

  @override
  String get trainingManaControlDrill => 'Mana Control Drill';

  @override
  String get trainingIntentEncodingDrill => 'Intent Encoding Drill';

  @override
  String get trainingReactionFocus =>
      'Build focus: initiative, reactions, and fast battle decisions.';

  @override
  String get trainingPrecisionFocus =>
      'Build focus: targeting, interrupts, and precise control.';

  @override
  String get trainingAnalysisFocus =>
      'Build focus: revealing enemy Function Weak Nodes.';

  @override
  String get trainingComplexityFocus =>
      'Build focus: complex Functions and counter reasoning.';

  @override
  String get trainingManaControlFocus =>
      'Build focus: Mana use and resource efficiency.';

  @override
  String get trainingIntentEncodingFocus =>
      'Build focus: safe output and burst spell capacity.';

  @override
  String get adventure => 'Adventure';

  @override
  String get startAshfangBattle => 'Start Ashfang Training Battle';

  @override
  String get couldNotLoadChapterRetry => 'Could not load chapter · Retry';

  @override
  String get chapter01 => 'Chapter 01';

  @override
  String get firstStepsAcademy => 'Your first steps into the Astraea Academy.';

  @override
  String get storyPath => 'STORY PATH';

  @override
  String get chapterOneComplete => 'Chapter One complete';

  @override
  String get nextPracticeFunction =>
      'Next, practice reading an enemy Function and finding its Weak Node.';

  @override
  String get practiceFunctionAnalysis => 'Practice Function Analysis';

  @override
  String get returnHome => 'Return Home';

  @override
  String get tryFunctionAnalysisTutorial => 'Try Function Analysis Tutorial';

  @override
  String get currentObjective => 'CURRENT OBJECTIVE';

  @override
  String chapterProgress(int completed, int total) {
    return 'Chapter progress · $completed of $total scenes';
  }

  @override
  String get sceneAcademyArrival => 'Academy Arrival';

  @override
  String get sceneAptitudeAssessment => 'Aptitude Assessment';

  @override
  String get sceneFunctionTheory => 'Function Theory';

  @override
  String get sceneChantAndChantless => 'Chant and Chantless';

  @override
  String get scenePreparedDeck => 'Prepared Deck';

  @override
  String get scene1Title => 'Astraea Academy';

  @override
  String get scene2Title => 'Aptitude Assessment';

  @override
  String get scene3Title => 'Function Theory';

  @override
  String get scene4Title => 'Full Chant and Chantless';

  @override
  String get scene5Title => 'Spell Cards and Prepared Deck';

  @override
  String get scene1Beat1 =>
      'Astraea Academy is one of the world\'s most important institutions for magical education, research, and Aberration response.';

  @override
  String get scene1Beat2 => '...Finally. I really made it here.';

  @override
  String get scene1Beat3 =>
      'Since that day, I have wanted to come here. Someday... I want to become someone who can use magic to protect others. First, I should report in.';

  @override
  String get scene1Beat4 =>
      'Objective: New student registration · Go to the academy gate and speak with Yuma Saeki.';

  @override
  String get scene2Beat1 =>
      'Create your Astraea self: allocate eight Attributes and choose a starting weapon.';

  @override
  String get scene2Beat2 =>
      'Each Attribute starts at Base 8; allocate 32 points; starting cap 15.';

  @override
  String get scene2Beat3 =>
      'Life Progress represents your history of investment, not a rating of your real-world ability.';

  @override
  String get scene3Beat1 =>
      'Magic is not a wish. Magic is a method of transforming World State A into B.';

  @override
  String get scene3Beat2 => 'f(S0)=S1';

  @override
  String get scene3Beat3 =>
      'Function Graph: Gather(Energy) → Shape(Bolt) → Move(Target). Tap a node to inspect its role in the spell sequence.';

  @override
  String get scene4Beat1 => 'Full Chant: Human → Chant → Magic System';

  @override
  String get scene4Beat2 => 'Chantless: Human → Mental Encoding → Magic System';

  @override
  String get scene4Beat3 =>
      'Chantless does not skip processing; the caster internalizes the encoding.';

  @override
  String get scene5Beat1 =>
      'Function Graph → Encode → Spell Card → Prepared Deck → Cast';

  @override
  String get scene5Beat2 =>
      'A Spell Card stores a constructed request structure; the Prepared Deck contains preloaded spells, not random draws.';

  @override
  String get scene5Beat3 => 'Choose six Spell Cards for the Prepared Deck.';

  @override
  String get preparedDeck => 'Prepared Deck';

  @override
  String get couldNotLoadDeckRetry => 'Could not load deck · Retry';

  @override
  String get spellCards => 'Spell Cards';

  @override
  String get buildPreparedDeck => 'Build your Prepared Deck';

  @override
  String get yourPreparedDeck => 'Your Prepared Deck';

  @override
  String get chooseSixFunctions =>
      'Choose six ready-to-cast Functions for your build.';

  @override
  String get noDeckPrepared => 'No deck prepared yet';

  @override
  String preparedCount(int selected) {
    return 'Prepared $selected / 6';
  }

  @override
  String cardsCount(int count) {
    return '$count cards';
  }

  @override
  String get readySection => 'READY';

  @override
  String get cardLibrary => 'CARD LIBRARY';

  @override
  String get continueDeckSetup => 'Continue to Deck Setup';

  @override
  String get spellArcBolt => 'Arc Bolt';

  @override
  String get spellFocusedShot => 'Focused Shot';

  @override
  String get spellEnergyBurst => 'Energy Burst';

  @override
  String get spellBarrier => 'Barrier';

  @override
  String get spellDeflect => 'Deflect';

  @override
  String get spellStepShift => 'Step Shift';

  @override
  String get spellWeakNodeScan => 'Weak Node Scan';

  @override
  String get spellManaStabilize => 'Mana Stabilize';

  @override
  String get spellInterruptPulse => 'Interrupt Pulse';

  @override
  String get roleAttack => 'Attack';

  @override
  String get roleDefense => 'Defense';

  @override
  String get roleMobility => 'Mobility';

  @override
  String get roleAnalysis => 'Analysis';

  @override
  String get roleSupport => 'Support';

  @override
  String get roleCounter => 'Counter';

  @override
  String couldNotLoadStory(String error) {
    return 'Could not load story: $error';
  }

  @override
  String get academyStory => 'Academy Story';

  @override
  String get preparedDeckSavedNext =>
      'Your Prepared Deck is saved. Continue by practicing how to read an enemy Function and discover its Weak Node.';

  @override
  String get returnToAdventure => 'Return to Adventure';

  @override
  String preparedDeckCount(int selected) {
    return 'Prepared Deck: $selected / 6';
  }

  @override
  String get functionGraph => 'Function Graph';

  @override
  String get tapStepRole => 'Tap a step to see what it contributes.';

  @override
  String get quickCheck =>
      'Quick check: Which step directs the formed effect toward its target?';

  @override
  String get fullChantSlowerStable => 'Full Chant is slower and stable.';

  @override
  String get chantlessFasterInternal =>
      'Chantless is faster and requires internalized encoding.';

  @override
  String get bothPerformProcessing =>
      'Both methods perform the Function processing.';

  @override
  String couldNotLoadFunction(String error) {
    return 'Could not load Function: $error';
  }

  @override
  String get functionAnalysis => 'Function Analysis';

  @override
  String get ashfangTrainingConstruct => 'Ashfang Training Construct';

  @override
  String get enemyFunctionPath =>
      'Enemy Function: DetectTarget → LockTarget → Pounce';

  @override
  String characterAnalysisModifier(int analysis, int modifier) {
    return 'Character Analysis: $analysis → +$modifier Function analysis modifier';
  }

  @override
  String get analyzeActiveFunction => 'Analyze active Function';

  @override
  String get interruptLockTarget => 'Interrupt LockTarget';

  @override
  String get observeNextFunctionNode => 'Observe next Function node';

  @override
  String get resetTutorialPattern => 'Reset tutorial pattern';

  @override
  String contentBalance(String status) {
    return 'Content balance: $status';
  }

  @override
  String get nodeStateCancelled => 'Cancelled by Weak Node interruption';

  @override
  String get nodeStateWeak => 'Weak Node revealed · interruptible';

  @override
  String get nodeStateActive => 'Active Function';

  @override
  String get nodeStateAwaiting => 'Awaiting execution';

  @override
  String get feedbackPreparingPounce =>
      'Ashfang is preparing Pounce. Inspect the Function before it resolves.';

  @override
  String get feedbackPreparingAgain => 'Ashfang is preparing Pounce again.';

  @override
  String get feedbackLockActive =>
      'LockTarget is active. It is interruptible, but its role is not yet analyzed.';

  @override
  String get feedbackWeakFound =>
      'Weak Node found: interrupting LockTarget cancels downstream Pounce.';

  @override
  String get feedbackAnalysisMiss =>
      'Analysis did not reveal the node. Try again.';

  @override
  String get feedbackInterrupted =>
      'LockTarget interrupted. Pounce is cancelled.';

  @override
  String get feedbackInterruptFailed =>
      'This Function could not be interrupted.';

  @override
  String get functionNodeDetectTarget => 'Detect Target';

  @override
  String get functionNodeLockTarget => 'Lock Target';

  @override
  String get functionNodePounce => 'Pounce';

  @override
  String get ashfangEncounter => 'Ashfang Encounter';

  @override
  String battleUnavailable(String error) {
    return 'Battle unavailable: $error';
  }

  @override
  String get prototypeEncounterInputs => 'Prototype encounter inputs';

  @override
  String battleRoundStatus(int round, String status) {
    return 'Round $round · $status';
  }

  @override
  String get weakNodeRevealed => 'Weak Node revealed: LockTarget';

  @override
  String get weakNodeCancelsPounce =>
      'Interrupting this node cancels downstream Pounce.';

  @override
  String get trainingEncounterComplete => 'Training encounter complete';

  @override
  String get trainingAnalysisSaved =>
      'Your trained Analysis informed the Weak Node interaction. Battle state is saved.';

  @override
  String get encounterEnded => 'Encounter ended';

  @override
  String get ashfangOverwhelmed =>
      'Ashfang overwhelmed your character. This result is saved.';

  @override
  String get attackAshfang => 'Attack Ashfang';

  @override
  String get endTurn => 'End turn';

  @override
  String get analyzeWeakNode => 'Analyze Weak Node';

  @override
  String get resolvePounce => 'Resolve Pounce';

  @override
  String unitHpDetail(String detail, int hp, int maxHp) {
    return '$detail · HP $hp / $maxHp';
  }

  @override
  String questMetaShort(String domain, int minutes) {
    return '$domain · $minutes min';
  }

  @override
  String get couldNotLoadTraining =>
      'Could not load Training. Please try again.';

  @override
  String get confirmPreparedDeck => 'Confirm Prepared Deck';

  @override
  String get graphGather => 'Gather';

  @override
  String get graphShape => 'Shape';

  @override
  String get graphMove => 'Move';

  @override
  String get graphGatherDescription =>
      'Collects the energy the Function will use.';

  @override
  String get graphShapeDescription =>
      'Forms that energy into the intended effect, such as a bolt.';

  @override
  String get graphMoveDescription =>
      'Directs the formed effect toward its target.';

  @override
  String get graphGatherSummary => 'collect energy';

  @override
  String get graphShapeSummary => 'form a bolt';

  @override
  String get graphMoveSummary => 'direct the result';

  @override
  String graphNodeSummary(String name, String summary) {
    return '$name · $summary';
  }

  @override
  String get graphCorrectMove =>
      'Correct — Move directs the effect to its target.';

  @override
  String get graphWrongMove =>
      'Not quite. Move is the step that directs the effect to its target.';

  @override
  String functionNodeSemantics(String node, String state) {
    return '$node, $state';
  }

  @override
  String get balanceAwaitingPlaytest =>
      'Illustrative inputs · awaiting playtest';

  @override
  String contentVersionStatus(String version, String status) {
    return '$version · $status';
  }

  @override
  String get battleHeroName => 'Astraea Hero';

  @override
  String analysisModifierLabel(int modifier) {
    return 'Analysis modifier +$modifier';
  }

  @override
  String get functionPathLabel =>
      'Function: DetectTarget → LockTarget → Pounce';

  @override
  String get battleOutcomeActive => 'ACTIVE';

  @override
  String get battleOutcomeVictory => 'VICTORY';

  @override
  String get battleOutcomeDefeat => 'DEFEAT';

  @override
  String get feedbackGuarding => 'Ashfang is guarding the training arena.';

  @override
  String get feedbackAshfangDefeated =>
      'Ashfang is defeated. The Weak Node changed the battle.';

  @override
  String get feedbackAttackResolved =>
      'Attack resolved through the combat engine.';

  @override
  String get feedbackEnemyFunctionBegins =>
      'Ashfang begins DetectTarget → LockTarget → Pounce.';

  @override
  String get feedbackWeakNodeFoundLegacy =>
      'Weak Node found. Interrupt LockTarget to cancel Pounce.';

  @override
  String get feedbackWeakNodeMissLegacy =>
      'Weak Node not revealed this time. Ashfang resolves Pounce.';

  @override
  String get feedbackInterruptedLegacy =>
      'LockTarget interrupted. Downstream Pounce was cancelled.';

  @override
  String get feedbackPounceResolved =>
      'Pounce resolved through the combat engine.';

  @override
  String get combatRotateDevice =>
      'Rotate your device to play the battle in landscape.';

  @override
  String get combatActionTimeline => 'ACTION TIMELINE';

  @override
  String get combatEnemyIntent => 'ENEMY INTENT';

  @override
  String get combatCurrentActor => 'CURRENT';

  @override
  String get combatHero => 'Hero';

  @override
  String get combatRio => 'Rio';

  @override
  String get combatYuma => 'Yuma';

  @override
  String get combatAshfang => 'Ashfang';

  @override
  String get combatReactionReady => 'Reaction ready';

  @override
  String get combatReactionSpent => 'Reaction spent';

  @override
  String get combatAttack => 'Attack';

  @override
  String get combatTechnique => 'Technique';

  @override
  String get combatSc => 'SC';

  @override
  String get combatAnalyze => 'Analyze';

  @override
  String get combatGuard => 'Guard';

  @override
  String get combatMove => 'Move';

  @override
  String get combatFireballI => 'Fireball I';

  @override
  String get combatFireballII => 'Fireball II';

  @override
  String get combatKnownFireball => 'Fireball I';

  @override
  String get combatModifiedFireball => 'Modified Fireball';

  @override
  String get combatFullChant => 'Full Chant';

  @override
  String get combatChantless => 'Chantless';

  @override
  String get combatUnknownFunction => 'Unknown Function';

  @override
  String get combatTargetHero => 'Target: Hero';

  @override
  String combatTimelineTurn(String name) {
    return '$name Turn';
  }

  @override
  String combatTimelineResolve(String spell) {
    return '$spell Resolve';
  }

  @override
  String get combatTimelineFunction => 'Active Function';

  @override
  String combatHp(int current, int max) {
    return 'HP $current/$max';
  }

  @override
  String combatMana(int current, int max) {
    return 'Mana $current/$max';
  }

  @override
  String get combatTutorialChantlessTitle => 'Start with a prepared spell';

  @override
  String get combatTutorialChantlessBody =>
      'Use Fireball I with Chantless casting. The Function resolves immediately.';

  @override
  String get combatCastFireballI => 'Cast Fireball I';

  @override
  String get combatKnownReactionTitle => 'REACTION';

  @override
  String get combatKnownReactionBody =>
      'Ashfang is constructing Fireball I. Rio can interrupt before the Function is established.';

  @override
  String get combatInterrupt => 'Interrupt';

  @override
  String get combatSaveReaction => 'Save Reaction';

  @override
  String get combatModifiedAnalysisTitle => 'Unknown modification detected';

  @override
  String get combatModifiedAnalysisBody =>
      'Use Analysis to reveal what is actually vulnerable in this Function.';

  @override
  String get combatAnalyzeModified => 'Analyze Modified Function';

  @override
  String get combatModifiedReactionTitle => 'Weak Node revealed';

  @override
  String get combatModifiedReactionBody =>
      'Analysis found a vulnerable Stabilization dependency. Rio can exploit it.';

  @override
  String get combatWeakNodeStabilization => 'Weak Node: Stabilization';

  @override
  String get combatStabilityUnknown => 'Stability ?';

  @override
  String combatStabilityValue(int value) {
    return 'Stability $value';
  }

  @override
  String get combatFunctionStructure => 'FUNCTION STRUCTURE';

  @override
  String get combatStructureUnknown =>
      'Internal dependencies have not been revealed.';

  @override
  String get combatStructureRevealed =>
      'Stabilization is structurally vulnerable.';

  @override
  String get combatBeginFullChant => 'Begin Fireball II · Full Chant';

  @override
  String get combatFullChantTitle => 'Commit to Full Chant';

  @override
  String get combatFullChantBody =>
      'Fireball II enters the Timeline and resolves after its construction completes.';

  @override
  String get combatFinisherTitle => 'Low Tier remains useful';

  @override
  String get combatFinisherBody =>
      'Finish with the cheaper Fireball I using Chantless casting.';

  @override
  String get combatFinishFireballI => 'Finish with Fireball I';

  @override
  String get combatVictoryTitle => 'Training battle complete';

  @override
  String get combatVictoryBody =>
      'You used Chantless, Interrupt, Analysis, a Weak Node, and Full Chant through the real CTB engine.';

  @override
  String get combatRestart => 'Restart Training';

  @override
  String get combatReturnAdventure => 'Return to Adventure';

  @override
  String get combatIntentHeroTurn => 'Read the field and choose your action.';

  @override
  String get combatIntentKnownFireball => 'Fireball I · Full Chant';

  @override
  String get combatIntentModifiedFireball => 'Modified Fireball · Full Chant';

  @override
  String get combatIntentHeroFullChant =>
      'Ashfang is recovering. Hero can commit to Full Chant.';

  @override
  String get combatIntentFinisher => 'Ashfang is nearly defeated.';

  @override
  String get combatIntentVictory => 'Training objective complete.';

  @override
  String get combatFeedbackOpening =>
      'Prepared SCs are direct battle options. Start with Fireball I.';

  @override
  String get combatFeedbackHeroChantless =>
      'Fireball I resolved immediately through Chantless casting.';

  @override
  String get combatFeedbackKnownCasting =>
      'Ashfang began a known Full Chant. The Interrupt window is open.';

  @override
  String get combatFeedbackKnownInterrupted =>
      'Rio broke the unfinished Fireball before establishment.';

  @override
  String get combatFeedbackKnownResolved =>
      'Reaction saved. Fireball I resolved and damaged Hero.';

  @override
  String get combatFeedbackModifiedCasting =>
      'Ashfang changed the Function. Its internal structure is unknown.';

  @override
  String get combatFeedbackAnalysisWeakNode =>
      'Analysis revealed Stability and a real Stabilization Weak Node.';

  @override
  String get combatFeedbackModifiedInterrupted =>
      'Weak Node bonus raised Interrupt Power enough to break the Function.';

  @override
  String get combatFeedbackModifiedResolved =>
      'The modified Function was allowed to resolve.';

  @override
  String get combatFeedbackHeroFullChantCasting =>
      'Hero committed Mana and entered Full Chant.';

  @override
  String get combatFeedbackHeroFullChantResolved =>
      'Fireball II resolved. Ashfang is barely standing.';

  @override
  String get combatFeedbackVictory =>
      'Ashfang defeated. Tutorial objective complete.';

  @override
  String get combatFeedbackDefeat => 'The party was defeated.';

  @override
  String get combatZoneMid => 'MID';

  @override
  String get combatTrainingArena => 'ASTRAEA TRAINING HALL';

  @override
  String get combatFullChantCastingTitle => 'Full Chant is constructing';

  @override
  String get combatFullChantCastingBody =>
      'Fireball II is now a pending Resolve event on the Timeline. Ashfang can act before the spell completes.';

  @override
  String get combatAdvanceTimeline => 'Advance to Resolve';

  @override
  String get combatDefeatTitle => 'Training failed';

  @override
  String get combatDefeatBody =>
      'The party was defeated. Restart the training encounter and try a different decision.';

  @override
  String get combatHoldFormation => 'Hold Formation';

  @override
  String get combatNodeCompression => 'Compression';

  @override
  String get combatNodeStabilization => 'Stabilization';

  @override
  String get combatNodeTrajectory => 'Trajectory';
}
