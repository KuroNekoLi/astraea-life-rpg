import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Astraea'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get navLife;

  /// No description provided for @navAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get navAdventure;

  /// No description provided for @navDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck'**
  String get navDeck;

  /// No description provided for @navCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get navCharacter;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get commonStart;

  /// No description provided for @commonFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get commonFinish;

  /// No description provided for @commonPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get commonPause;

  /// No description provided for @commonResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get commonResume;

  /// No description provided for @commonEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get commonEnable;

  /// No description provided for @commonTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get commonTurnOff;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Turn real-life effort into magic that changes the world.'**
  String get splashTagline;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start'**
  String get tapToStart;

  /// No description provided for @welcomeToAstraea.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Astraea'**
  String get welcomeToAstraea;

  /// No description provided for @onboardingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your everyday effort can shape your Astraea self.'**
  String get onboardingHeadline;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Real life and the academy are connected, while your actions remain yours to choose.'**
  String get onboardingBody;

  /// No description provided for @enterAstraea.
  ///
  /// In en, this message translates to:
  /// **'Enter Astraea'**
  String get enterAstraea;

  /// No description provided for @noStreakPenalty.
  ///
  /// In en, this message translates to:
  /// **'No streak penalties. Progress waits whenever you do.'**
  String get noStreakPenalty;

  /// No description provided for @chooseLifeQuest.
  ///
  /// In en, this message translates to:
  /// **'Choose a Life Quest'**
  String get chooseLifeQuest;

  /// No description provided for @earnGrowthPotential.
  ///
  /// In en, this message translates to:
  /// **'Earn Growth Potential'**
  String get earnGrowthPotential;

  /// No description provided for @buildRpgSelf.
  ///
  /// In en, this message translates to:
  /// **'Build your RPG self'**
  String get buildRpgSelf;

  /// No description provided for @chooseLifeQuestDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a real-world action when it fits your day.'**
  String get chooseLifeQuestDescription;

  /// No description provided for @earnGrowthPotentialDescription.
  ///
  /// In en, this message translates to:
  /// **'Your action creates an opportunity to grow in-game.'**
  String get earnGrowthPotentialDescription;

  /// No description provided for @buildRpgSelfDescription.
  ///
  /// In en, this message translates to:
  /// **'Train, prepare your deck, and explore the academy.'**
  String get buildRpgSelfDescription;

  /// No description provided for @homeBrandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'LIFE × RPG'**
  String get homeBrandSubtitle;

  /// No description provided for @homeHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Astraea Academy · Chapter 01'**
  String get homeHeroEyebrow;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'One real action starts your journey.'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a Life Quest, earn Growth Potential, and shape the hero who explores Astraea.'**
  String get homeHeroDescription;

  /// No description provided for @yourJourney.
  ///
  /// In en, this message translates to:
  /// **'YOUR JOURNEY'**
  String get yourJourney;

  /// No description provided for @continueYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Continue your journey'**
  String get continueYourJourney;

  /// No description provided for @journeyLifeQuests.
  ///
  /// In en, this message translates to:
  /// **'Life Quests'**
  String get journeyLifeQuests;

  /// No description provided for @journeyLifeQuestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with one real action'**
  String get journeyLifeQuestsSubtitle;

  /// No description provided for @journeyAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get journeyAdventure;

  /// No description provided for @journeyAdventureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Story & objectives'**
  String get journeyAdventureSubtitle;

  /// No description provided for @journeyCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get journeyCharacter;

  /// No description provided for @journeyCharacterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your growing build'**
  String get journeyCharacterSubtitle;

  /// No description provided for @journeyPreparedDeck.
  ///
  /// In en, this message translates to:
  /// **'Prepared Deck'**
  String get journeyPreparedDeck;

  /// No description provided for @journeyPreparedDeckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Six spells'**
  String get journeyPreparedDeckSubtitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @allQuests.
  ///
  /// In en, this message translates to:
  /// **'All Quests'**
  String get allQuests;

  /// No description provided for @lifeQuestsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Life Quests are temporarily unavailable.'**
  String get lifeQuestsUnavailable;

  /// No description provided for @quietDayTitle.
  ///
  /// In en, this message translates to:
  /// **'A quiet day is okay.'**
  String get quietDayTitle;

  /// No description provided for @quietDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Life Quest whenever it fits.'**
  String get quietDaySubtitle;

  /// No description provided for @growthPotentialReady.
  ///
  /// In en, this message translates to:
  /// **'Growth Potential ready'**
  String get growthPotentialReady;

  /// No description provided for @characterProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Character profile'**
  String get characterProfileTooltip;

  /// No description provided for @optionalPilotMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Optional pilot measurement'**
  String get optionalPilotMeasurement;

  /// No description provided for @pilotOnLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'On · local only'**
  String get pilotOnLocalOnly;

  /// No description provided for @pilotOffDefault.
  ///
  /// In en, this message translates to:
  /// **'Off · default'**
  String get pilotOffDefault;

  /// No description provided for @pilotTurnOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off pilot measurement?'**
  String get pilotTurnOffTitle;

  /// No description provided for @pilotEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable private pilot measurement?'**
  String get pilotEnableTitle;

  /// No description provided for @pilotTurnOffBody.
  ///
  /// In en, this message translates to:
  /// **'Turning this off deletes locally stored milestone events.'**
  String get pilotTurnOffBody;

  /// No description provided for @pilotEnableBody.
  ///
  /// In en, this message translates to:
  /// **'This stores a small set of gameplay milestones on this device only. It does not collect names, notes, evidence, health data, or custom quest text. There is no upload. You can turn it off and delete the events at any time.'**
  String get pilotEnableBody;

  /// No description provided for @potentialChooseHowToTrain.
  ///
  /// In en, this message translates to:
  /// **'{amount} Potential · Choose how to train'**
  String potentialChooseHowToTrain(int amount);

  /// No description provided for @lifeQuest.
  ///
  /// In en, this message translates to:
  /// **'Life Quest'**
  String get lifeQuest;

  /// No description provided for @couldNotLoadQuests.
  ///
  /// In en, this message translates to:
  /// **'Could not load quests: {error}'**
  String couldNotLoadQuests(String error);

  /// No description provided for @chooseWhatFitsYourDay.
  ///
  /// In en, this message translates to:
  /// **'Choose what fits your day.'**
  String get chooseWhatFitsYourDay;

  /// No description provided for @progressAlwaysHere.
  ///
  /// In en, this message translates to:
  /// **'Your progress is always here. There are no streak penalties.'**
  String get progressAlwaysHere;

  /// No description provided for @availableQuestCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1 {1 available quest} other {{count} available quests}}'**
  String availableQuestCount(int count);

  /// No description provided for @domainAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get domainAll;

  /// No description provided for @domainFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get domainFitness;

  /// No description provided for @domainLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get domainLearning;

  /// No description provided for @domainLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get domainLanguages;

  /// No description provided for @domainLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get domainLife;

  /// No description provided for @noQuestsCategory.
  ///
  /// In en, this message translates to:
  /// **'No quests in this category yet.'**
  String get noQuestsCategory;

  /// No description provided for @addWhenReady.
  ///
  /// In en, this message translates to:
  /// **'Add one when you are ready.'**
  String get addWhenReady;

  /// No description provided for @addLifeQuest.
  ///
  /// In en, this message translates to:
  /// **'Add a Life Quest'**
  String get addLifeQuest;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @questDetails.
  ///
  /// In en, this message translates to:
  /// **'Quest details'**
  String get questDetails;

  /// No description provided for @couldNotLoadQuest.
  ///
  /// In en, this message translates to:
  /// **'Could not load quest: {error}'**
  String couldNotLoadQuest(String error);

  /// No description provided for @questNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quest not found'**
  String get questNotFound;

  /// No description provided for @questAboutMinutes.
  ///
  /// In en, this message translates to:
  /// **'{domain} · about {minutes} minutes'**
  String questAboutMinutes(String domain, int minutes);

  /// No description provided for @selfReportTimerEvidence.
  ///
  /// In en, this message translates to:
  /// **'Self-report is always available. A timer adds lightweight evidence.'**
  String get selfReportTimerEvidence;

  /// No description provided for @startTimer.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get startTimer;

  /// No description provided for @completeSelfReport.
  ///
  /// In en, this message translates to:
  /// **'Complete with self-report'**
  String get completeSelfReport;

  /// No description provided for @questComplete.
  ///
  /// In en, this message translates to:
  /// **'Quest complete'**
  String get questComplete;

  /// No description provided for @lifeXpReward.
  ///
  /// In en, this message translates to:
  /// **'+{amount} {domain} Life XP'**
  String lifeXpReward(int amount, String domain);

  /// No description provided for @potentialReward.
  ///
  /// In en, this message translates to:
  /// **'+{amount} {category} Potential'**
  String potentialReward(int amount, String category);

  /// No description provided for @timerEvidenceBonus.
  ///
  /// In en, this message translates to:
  /// **'Timer evidence · bonus included'**
  String get timerEvidenceBonus;

  /// No description provided for @selfReportPrivate.
  ///
  /// In en, this message translates to:
  /// **'Self-report · private'**
  String get selfReportPrivate;

  /// No description provided for @confirmReward.
  ///
  /// In en, this message translates to:
  /// **'Confirm reward'**
  String get confirmReward;

  /// No description provided for @questTimer.
  ///
  /// In en, this message translates to:
  /// **'Quest timer'**
  String get questTimer;

  /// No description provided for @timerRunsAway.
  ///
  /// In en, this message translates to:
  /// **'Timer runs while you are away.'**
  String get timerRunsAway;

  /// No description provided for @potentialPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get potentialPhysical;

  /// No description provided for @potentialCognitive.
  ///
  /// In en, this message translates to:
  /// **'Cognitive'**
  String get potentialCognitive;

  /// No description provided for @potentialCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get potentialCommunication;

  /// No description provided for @potentialGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get potentialGrowth;

  /// No description provided for @questFitnessWalk10.
  ///
  /// In en, this message translates to:
  /// **'Walk 10 minutes'**
  String get questFitnessWalk10;

  /// No description provided for @questFitnessExercise20.
  ///
  /// In en, this message translates to:
  /// **'Exercise 20 minutes'**
  String get questFitnessExercise20;

  /// No description provided for @questLearningRead20.
  ///
  /// In en, this message translates to:
  /// **'Read 20 minutes'**
  String get questLearningRead20;

  /// No description provided for @questLearningStudy20.
  ///
  /// In en, this message translates to:
  /// **'Study 20 minutes'**
  String get questLearningStudy20;

  /// No description provided for @questLanguagesPractice15.
  ///
  /// In en, this message translates to:
  /// **'Practice a language 15 minutes'**
  String get questLanguagesPractice15;

  /// No description provided for @createAstraeaSelf.
  ///
  /// In en, this message translates to:
  /// **'Create your Astraea self'**
  String get createAstraeaSelf;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @characterName.
  ///
  /// In en, this message translates to:
  /// **'Character name'**
  String get characterName;

  /// No description provided for @distributePoints.
  ///
  /// In en, this message translates to:
  /// **'Distribute 32 points · Base 8 · Maximum 15'**
  String get distributePoints;

  /// No description provided for @characterBuildFocusDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your hero’s build focus. These Attributes are planned to shape combat options; no choice blocks the main story.'**
  String get characterBuildFocusDescription;

  /// No description provided for @pointsSpent.
  ///
  /// In en, this message translates to:
  /// **'{spent} / {budget} points'**
  String pointsSpent(int spent, int budget);

  /// No description provided for @attributeAllocationSummary.
  ///
  /// In en, this message translates to:
  /// **'Base {base} + {allocated} allocated = {starting} starting value\n{effect}'**
  String attributeAllocationSummary(
    int base,
    int allocated,
    int starting,
    String effect,
  );

  /// No description provided for @initialWeapon.
  ///
  /// In en, this message translates to:
  /// **'Initial weapon'**
  String get initialWeapon;

  /// No description provided for @weaponAstraeaLongsword.
  ///
  /// In en, this message translates to:
  /// **'Astraea Longsword'**
  String get weaponAstraeaLongsword;

  /// No description provided for @weaponStandardSpear.
  ///
  /// In en, this message translates to:
  /// **'Standard Spear'**
  String get weaponStandardSpear;

  /// No description provided for @weaponTrainingArcaneGun.
  ///
  /// In en, this message translates to:
  /// **'Training Arcane Gun'**
  String get weaponTrainingArcaneGun;

  /// No description provided for @weaponStandardStaff.
  ///
  /// In en, this message translates to:
  /// **'Standard Staff'**
  String get weaponStandardStaff;

  /// No description provided for @attributeManaCapacity.
  ///
  /// In en, this message translates to:
  /// **'Mana Capacity'**
  String get attributeManaCapacity;

  /// No description provided for @attributeManaOutput.
  ///
  /// In en, this message translates to:
  /// **'Mana Output'**
  String get attributeManaOutput;

  /// No description provided for @attributeComputation.
  ///
  /// In en, this message translates to:
  /// **'Computation'**
  String get attributeComputation;

  /// No description provided for @attributeProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get attributeProcessing;

  /// No description provided for @attributePrecision.
  ///
  /// In en, this message translates to:
  /// **'Precision'**
  String get attributePrecision;

  /// No description provided for @attributeEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get attributeEfficiency;

  /// No description provided for @attributeAmbientSync.
  ///
  /// In en, this message translates to:
  /// **'Ambient Sync'**
  String get attributeAmbientSync;

  /// No description provided for @attributeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get attributeAnalysis;

  /// No description provided for @attributeManaCapacityEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Mana limit and costly spell stamina'**
  String get attributeManaCapacityEffect;

  /// No description provided for @attributeManaOutputEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Safe output and burst spell size'**
  String get attributeManaOutputEffect;

  /// No description provided for @attributeComputationEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Complex Functions and counter reasoning'**
  String get attributeComputationEffect;

  /// No description provided for @attributeProcessingEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Initiative, reactions, and fast actions'**
  String get attributeProcessingEffect;

  /// No description provided for @attributePrecisionEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Targeting, interrupts, and control'**
  String get attributePrecisionEffect;

  /// No description provided for @attributeEfficiencyEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Mana use and resource efficiency'**
  String get attributeEfficiencyEffect;

  /// No description provided for @attributeAmbientSyncEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Environmental and support magic'**
  String get attributeAmbientSyncEffect;

  /// No description provided for @attributeAnalysisEffect.
  ///
  /// In en, this message translates to:
  /// **'Focus: Reveal enemy Weak Nodes and counters'**
  String get attributeAnalysisEffect;

  /// No description provided for @character.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get character;

  /// No description provided for @yourAstraeaSelf.
  ///
  /// In en, this message translates to:
  /// **'Your Astraea self'**
  String get yourAstraeaSelf;

  /// No description provided for @characterAttributes.
  ///
  /// In en, this message translates to:
  /// **'Character Attributes'**
  String get characterAttributes;

  /// No description provided for @trainingGrowsBuild.
  ///
  /// In en, this message translates to:
  /// **'Training grows your chosen build over time.'**
  String get trainingGrowsBuild;

  /// No description provided for @attributesSection.
  ///
  /// In en, this message translates to:
  /// **'ATTRIBUTES'**
  String get attributesSection;

  /// No description provided for @trainedDelta.
  ///
  /// In en, this message translates to:
  /// **'+{amount} trained'**
  String trainedDelta(int amount);

  /// No description provided for @viewTraining.
  ///
  /// In en, this message translates to:
  /// **'View Training'**
  String get viewTraining;

  /// No description provided for @chooseStartingAttributesWeapon.
  ///
  /// In en, this message translates to:
  /// **'Choose your starting Attributes and weapon to begin.'**
  String get chooseStartingAttributesWeapon;

  /// No description provided for @createCharacter.
  ///
  /// In en, this message translates to:
  /// **'Create Character'**
  String get createCharacter;

  /// No description provided for @couldNotLoadCharacter.
  ///
  /// In en, this message translates to:
  /// **'Could not load your character.'**
  String get couldNotLoadCharacter;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @chooseTraining.
  ///
  /// In en, this message translates to:
  /// **'Choose a Training'**
  String get chooseTraining;

  /// No description provided for @trainingDescription.
  ///
  /// In en, this message translates to:
  /// **'Life Quest rewards become Growth Potential. Choose a matching drill to turn it into permanent character growth.'**
  String get trainingDescription;

  /// No description provided for @physicalPotential.
  ///
  /// In en, this message translates to:
  /// **'Physical Potential'**
  String get physicalPotential;

  /// No description provided for @cognitivePotential.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Potential'**
  String get cognitivePotential;

  /// No description provided for @communicationPotential.
  ///
  /// In en, this message translates to:
  /// **'Communication Potential'**
  String get communicationPotential;

  /// No description provided for @potentialBuilding.
  ///
  /// In en, this message translates to:
  /// **'Potential is building toward your next Training'**
  String get potentialBuilding;

  /// No description provided for @potentialBuildingDescription.
  ///
  /// In en, this message translates to:
  /// **'A new character starts with 0 Growth Potential. Your first Life Quest adds its authored reward to the matching category. Training stays locked until that category covers the quoted cost; no reward or cost is changed.'**
  String get potentialBuildingDescription;

  /// No description provided for @trainingPotentialProgress.
  ///
  /// In en, this message translates to:
  /// **'{category}: {available} / {cost} · {attribute}'**
  String trainingPotentialProgress(
    String category,
    int available,
    int cost,
    String attribute,
  );

  /// No description provided for @chooseAnotherLifeQuest.
  ///
  /// In en, this message translates to:
  /// **'Choose another Life Quest'**
  String get chooseAnotherLifeQuest;

  /// No description provided for @availableDrills.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE DRILLS'**
  String get availableDrills;

  /// No description provided for @analysisGrowthActive.
  ///
  /// In en, this message translates to:
  /// **'Analysis growth is active'**
  String get analysisGrowthActive;

  /// No description provided for @permanentAnalysisGrowth.
  ///
  /// In en, this message translates to:
  /// **'+{amount} permanent Analysis from Training'**
  String permanentAnalysisGrowth(int amount);

  /// No description provided for @keepJourneyMoving.
  ///
  /// In en, this message translates to:
  /// **'Keep your journey moving'**
  String get keepJourneyMoving;

  /// No description provided for @trainingPermanentDescription.
  ///
  /// In en, this message translates to:
  /// **'Training changes your character permanently. Check the updated build, then return to the academy.'**
  String get trainingPermanentDescription;

  /// No description provided for @viewCharacter.
  ///
  /// In en, this message translates to:
  /// **'View Character'**
  String get viewCharacter;

  /// No description provided for @continueAdventure.
  ///
  /// In en, this message translates to:
  /// **'Continue Adventure'**
  String get continueAdventure;

  /// No description provided for @tryAnalysisAshfang.
  ///
  /// In en, this message translates to:
  /// **'Try Analysis against Ashfang'**
  String get tryAnalysisAshfang;

  /// No description provided for @trainingComplete.
  ///
  /// In en, this message translates to:
  /// **'Training complete. Your attribute grew permanently.'**
  String get trainingComplete;

  /// No description provided for @trainingPotentialToAttribute.
  ///
  /// In en, this message translates to:
  /// **'{category} Potential → {attribute}'**
  String trainingPotentialToAttribute(String category, String attribute);

  /// No description provided for @trainingAttributeChange.
  ///
  /// In en, this message translates to:
  /// **'{attribute} {before} → {after}'**
  String trainingAttributeChange(String attribute, int before, int after);

  /// No description provided for @aptitudeCost.
  ///
  /// In en, this message translates to:
  /// **'Aptitude {aptitude}/6 · Cost {cost} {category} Potential'**
  String aptitudeCost(int aptitude, int cost, String category);

  /// No description provided for @trainingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Training…'**
  String get trainingInProgress;

  /// No description provided for @trainAttribute.
  ///
  /// In en, this message translates to:
  /// **'Train {attribute}'**
  String trainAttribute(String attribute);

  /// No description provided for @needMorePotential.
  ///
  /// In en, this message translates to:
  /// **'Need {amount} more {category} Potential'**
  String needMorePotential(int amount, String category);

  /// No description provided for @trainingReactionDrill.
  ///
  /// In en, this message translates to:
  /// **'Reaction Drill'**
  String get trainingReactionDrill;

  /// No description provided for @trainingPrecisionMovement.
  ///
  /// In en, this message translates to:
  /// **'Precision Movement'**
  String get trainingPrecisionMovement;

  /// No description provided for @trainingFunctionAnalysisDrill.
  ///
  /// In en, this message translates to:
  /// **'Function Analysis Drill'**
  String get trainingFunctionAnalysisDrill;

  /// No description provided for @trainingComplexityExercise.
  ///
  /// In en, this message translates to:
  /// **'Complexity Exercise'**
  String get trainingComplexityExercise;

  /// No description provided for @trainingManaControlDrill.
  ///
  /// In en, this message translates to:
  /// **'Mana Control Drill'**
  String get trainingManaControlDrill;

  /// No description provided for @trainingIntentEncodingDrill.
  ///
  /// In en, this message translates to:
  /// **'Intent Encoding Drill'**
  String get trainingIntentEncodingDrill;

  /// No description provided for @trainingReactionFocus.
  ///
  /// In en, this message translates to:
  /// **'Build focus: initiative, reactions, and fast battle decisions.'**
  String get trainingReactionFocus;

  /// No description provided for @trainingPrecisionFocus.
  ///
  /// In en, this message translates to:
  /// **'Build focus: targeting, interrupts, and precise control.'**
  String get trainingPrecisionFocus;

  /// No description provided for @trainingAnalysisFocus.
  ///
  /// In en, this message translates to:
  /// **'Build focus: revealing enemy Function Weak Nodes.'**
  String get trainingAnalysisFocus;

  /// No description provided for @trainingComplexityFocus.
  ///
  /// In en, this message translates to:
  /// **'Build focus: complex Functions and counter reasoning.'**
  String get trainingComplexityFocus;

  /// No description provided for @trainingManaControlFocus.
  ///
  /// In en, this message translates to:
  /// **'Build focus: Mana use and resource efficiency.'**
  String get trainingManaControlFocus;

  /// No description provided for @trainingIntentEncodingFocus.
  ///
  /// In en, this message translates to:
  /// **'Build focus: safe output and burst spell capacity.'**
  String get trainingIntentEncodingFocus;

  /// No description provided for @adventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// No description provided for @startAshfangBattle.
  ///
  /// In en, this message translates to:
  /// **'Start Ashfang Training Battle'**
  String get startAshfangBattle;

  /// No description provided for @couldNotLoadChapterRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not load chapter · Retry'**
  String get couldNotLoadChapterRetry;

  /// No description provided for @chapter01.
  ///
  /// In en, this message translates to:
  /// **'Chapter 01'**
  String get chapter01;

  /// No description provided for @firstStepsAcademy.
  ///
  /// In en, this message translates to:
  /// **'Your first steps into the Astraea Academy.'**
  String get firstStepsAcademy;

  /// No description provided for @storyPath.
  ///
  /// In en, this message translates to:
  /// **'STORY PATH'**
  String get storyPath;

  /// No description provided for @chapterOneComplete.
  ///
  /// In en, this message translates to:
  /// **'Chapter One complete'**
  String get chapterOneComplete;

  /// No description provided for @nextPracticeFunction.
  ///
  /// In en, this message translates to:
  /// **'Next, practice reading an enemy Function and finding its Weak Node.'**
  String get nextPracticeFunction;

  /// No description provided for @practiceFunctionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Practice Function Analysis'**
  String get practiceFunctionAnalysis;

  /// No description provided for @returnHome.
  ///
  /// In en, this message translates to:
  /// **'Return Home'**
  String get returnHome;

  /// No description provided for @tryFunctionAnalysisTutorial.
  ///
  /// In en, this message translates to:
  /// **'Try Function Analysis Tutorial'**
  String get tryFunctionAnalysisTutorial;

  /// No description provided for @currentObjective.
  ///
  /// In en, this message translates to:
  /// **'CURRENT OBJECTIVE'**
  String get currentObjective;

  /// No description provided for @chapterProgress.
  ///
  /// In en, this message translates to:
  /// **'Chapter progress · {completed} of {total} scenes'**
  String chapterProgress(int completed, int total);

  /// No description provided for @sceneAcademyArrival.
  ///
  /// In en, this message translates to:
  /// **'Academy Arrival'**
  String get sceneAcademyArrival;

  /// No description provided for @sceneAptitudeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Aptitude Assessment'**
  String get sceneAptitudeAssessment;

  /// No description provided for @sceneFunctionTheory.
  ///
  /// In en, this message translates to:
  /// **'Function Theory'**
  String get sceneFunctionTheory;

  /// No description provided for @sceneChantAndChantless.
  ///
  /// In en, this message translates to:
  /// **'Chant and Chantless'**
  String get sceneChantAndChantless;

  /// No description provided for @scenePreparedDeck.
  ///
  /// In en, this message translates to:
  /// **'Prepared Deck'**
  String get scenePreparedDeck;

  /// No description provided for @scene1Title.
  ///
  /// In en, this message translates to:
  /// **'Astraea Academy'**
  String get scene1Title;

  /// No description provided for @scene2Title.
  ///
  /// In en, this message translates to:
  /// **'Aptitude Assessment'**
  String get scene2Title;

  /// No description provided for @scene3Title.
  ///
  /// In en, this message translates to:
  /// **'Function Theory'**
  String get scene3Title;

  /// No description provided for @scene4Title.
  ///
  /// In en, this message translates to:
  /// **'Full Chant and Chantless'**
  String get scene4Title;

  /// No description provided for @scene5Title.
  ///
  /// In en, this message translates to:
  /// **'Spell Cards and Prepared Deck'**
  String get scene5Title;

  /// No description provided for @scene1Beat1.
  ///
  /// In en, this message translates to:
  /// **'Astraea Academy is one of the world\'s most important institutions for magical education, research, and Aberration response.'**
  String get scene1Beat1;

  /// No description provided for @scene1Beat2.
  ///
  /// In en, this message translates to:
  /// **'...Finally. I really made it here.'**
  String get scene1Beat2;

  /// No description provided for @scene1Beat3.
  ///
  /// In en, this message translates to:
  /// **'Since that day, I have wanted to come here. Someday... I want to become someone who can use magic to protect others. First, I should report in.'**
  String get scene1Beat3;

  /// No description provided for @scene1Beat4.
  ///
  /// In en, this message translates to:
  /// **'Objective: New student registration · Go to the academy gate and speak with Yuma Saeki.'**
  String get scene1Beat4;

  /// No description provided for @scene2Beat1.
  ///
  /// In en, this message translates to:
  /// **'Create your Astraea self: allocate eight Attributes and choose a starting weapon.'**
  String get scene2Beat1;

  /// No description provided for @scene2Beat2.
  ///
  /// In en, this message translates to:
  /// **'Each Attribute starts at Base 8; allocate 32 points; starting cap 15.'**
  String get scene2Beat2;

  /// No description provided for @scene2Beat3.
  ///
  /// In en, this message translates to:
  /// **'Life Progress represents your history of investment, not a rating of your real-world ability.'**
  String get scene2Beat3;

  /// No description provided for @scene3Beat1.
  ///
  /// In en, this message translates to:
  /// **'Magic is not a wish. Magic is a method of transforming World State A into B.'**
  String get scene3Beat1;

  /// No description provided for @scene3Beat2.
  ///
  /// In en, this message translates to:
  /// **'f(S0)=S1'**
  String get scene3Beat2;

  /// No description provided for @scene3Beat3.
  ///
  /// In en, this message translates to:
  /// **'Function Graph: Gather(Energy) → Shape(Bolt) → Move(Target). Tap a node to inspect its role in the spell sequence.'**
  String get scene3Beat3;

  /// No description provided for @scene4Beat1.
  ///
  /// In en, this message translates to:
  /// **'Full Chant: Human → Chant → Magic System'**
  String get scene4Beat1;

  /// No description provided for @scene4Beat2.
  ///
  /// In en, this message translates to:
  /// **'Chantless: Human → Mental Encoding → Magic System'**
  String get scene4Beat2;

  /// No description provided for @scene4Beat3.
  ///
  /// In en, this message translates to:
  /// **'Chantless does not skip processing; the caster internalizes the encoding.'**
  String get scene4Beat3;

  /// No description provided for @scene5Beat1.
  ///
  /// In en, this message translates to:
  /// **'Function Graph → Encode → Spell Card → Prepared Deck → Cast'**
  String get scene5Beat1;

  /// No description provided for @scene5Beat2.
  ///
  /// In en, this message translates to:
  /// **'A Spell Card stores a constructed request structure; the Prepared Deck contains preloaded spells, not random draws.'**
  String get scene5Beat2;

  /// No description provided for @scene5Beat3.
  ///
  /// In en, this message translates to:
  /// **'Choose six Spell Cards for the Prepared Deck.'**
  String get scene5Beat3;

  /// No description provided for @preparedDeck.
  ///
  /// In en, this message translates to:
  /// **'Prepared Deck'**
  String get preparedDeck;

  /// No description provided for @couldNotLoadDeckRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not load deck · Retry'**
  String get couldNotLoadDeckRetry;

  /// No description provided for @spellCards.
  ///
  /// In en, this message translates to:
  /// **'Spell Cards'**
  String get spellCards;

  /// No description provided for @buildPreparedDeck.
  ///
  /// In en, this message translates to:
  /// **'Build your Prepared Deck'**
  String get buildPreparedDeck;

  /// No description provided for @yourPreparedDeck.
  ///
  /// In en, this message translates to:
  /// **'Your Prepared Deck'**
  String get yourPreparedDeck;

  /// No description provided for @chooseSixFunctions.
  ///
  /// In en, this message translates to:
  /// **'Choose six ready-to-cast Functions for your build.'**
  String get chooseSixFunctions;

  /// No description provided for @noDeckPrepared.
  ///
  /// In en, this message translates to:
  /// **'No deck prepared yet'**
  String get noDeckPrepared;

  /// No description provided for @preparedCount.
  ///
  /// In en, this message translates to:
  /// **'Prepared {selected} / 6'**
  String preparedCount(int selected);

  /// No description provided for @cardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String cardsCount(int count);

  /// No description provided for @readySection.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get readySection;

  /// No description provided for @cardLibrary.
  ///
  /// In en, this message translates to:
  /// **'CARD LIBRARY'**
  String get cardLibrary;

  /// No description provided for @continueDeckSetup.
  ///
  /// In en, this message translates to:
  /// **'Continue to Deck Setup'**
  String get continueDeckSetup;

  /// No description provided for @spellArcBolt.
  ///
  /// In en, this message translates to:
  /// **'Arc Bolt'**
  String get spellArcBolt;

  /// No description provided for @spellFocusedShot.
  ///
  /// In en, this message translates to:
  /// **'Focused Shot'**
  String get spellFocusedShot;

  /// No description provided for @spellEnergyBurst.
  ///
  /// In en, this message translates to:
  /// **'Energy Burst'**
  String get spellEnergyBurst;

  /// No description provided for @spellBarrier.
  ///
  /// In en, this message translates to:
  /// **'Barrier'**
  String get spellBarrier;

  /// No description provided for @spellDeflect.
  ///
  /// In en, this message translates to:
  /// **'Deflect'**
  String get spellDeflect;

  /// No description provided for @spellStepShift.
  ///
  /// In en, this message translates to:
  /// **'Step Shift'**
  String get spellStepShift;

  /// No description provided for @spellWeakNodeScan.
  ///
  /// In en, this message translates to:
  /// **'Weak Node Scan'**
  String get spellWeakNodeScan;

  /// No description provided for @spellManaStabilize.
  ///
  /// In en, this message translates to:
  /// **'Mana Stabilize'**
  String get spellManaStabilize;

  /// No description provided for @spellInterruptPulse.
  ///
  /// In en, this message translates to:
  /// **'Interrupt Pulse'**
  String get spellInterruptPulse;

  /// No description provided for @roleAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get roleAttack;

  /// No description provided for @roleDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get roleDefense;

  /// No description provided for @roleMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get roleMobility;

  /// No description provided for @roleAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get roleAnalysis;

  /// No description provided for @roleSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get roleSupport;

  /// No description provided for @roleCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get roleCounter;

  /// No description provided for @couldNotLoadStory.
  ///
  /// In en, this message translates to:
  /// **'Could not load story: {error}'**
  String couldNotLoadStory(String error);

  /// No description provided for @academyStory.
  ///
  /// In en, this message translates to:
  /// **'Academy Story'**
  String get academyStory;

  /// No description provided for @preparedDeckSavedNext.
  ///
  /// In en, this message translates to:
  /// **'Your Prepared Deck is saved. Continue by practicing how to read an enemy Function and discover its Weak Node.'**
  String get preparedDeckSavedNext;

  /// No description provided for @returnToAdventure.
  ///
  /// In en, this message translates to:
  /// **'Return to Adventure'**
  String get returnToAdventure;

  /// No description provided for @preparedDeckCount.
  ///
  /// In en, this message translates to:
  /// **'Prepared Deck: {selected} / 6'**
  String preparedDeckCount(int selected);

  /// No description provided for @functionGraph.
  ///
  /// In en, this message translates to:
  /// **'Function Graph'**
  String get functionGraph;

  /// No description provided for @tapStepRole.
  ///
  /// In en, this message translates to:
  /// **'Tap a step to see what it contributes.'**
  String get tapStepRole;

  /// No description provided for @quickCheck.
  ///
  /// In en, this message translates to:
  /// **'Quick check: Which step directs the formed effect toward its target?'**
  String get quickCheck;

  /// No description provided for @fullChantSlowerStable.
  ///
  /// In en, this message translates to:
  /// **'Full Chant is slower and stable.'**
  String get fullChantSlowerStable;

  /// No description provided for @chantlessFasterInternal.
  ///
  /// In en, this message translates to:
  /// **'Chantless is faster and requires internalized encoding.'**
  String get chantlessFasterInternal;

  /// No description provided for @bothPerformProcessing.
  ///
  /// In en, this message translates to:
  /// **'Both methods perform the Function processing.'**
  String get bothPerformProcessing;

  /// No description provided for @couldNotLoadFunction.
  ///
  /// In en, this message translates to:
  /// **'Could not load Function: {error}'**
  String couldNotLoadFunction(String error);

  /// No description provided for @functionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Function Analysis'**
  String get functionAnalysis;

  /// No description provided for @ashfangTrainingConstruct.
  ///
  /// In en, this message translates to:
  /// **'Ashfang Training Construct'**
  String get ashfangTrainingConstruct;

  /// No description provided for @enemyFunctionPath.
  ///
  /// In en, this message translates to:
  /// **'Enemy Function: DetectTarget → LockTarget → Pounce'**
  String get enemyFunctionPath;

  /// No description provided for @characterAnalysisModifier.
  ///
  /// In en, this message translates to:
  /// **'Character Analysis: {analysis} → +{modifier} Function analysis modifier'**
  String characterAnalysisModifier(int analysis, int modifier);

  /// No description provided for @analyzeActiveFunction.
  ///
  /// In en, this message translates to:
  /// **'Analyze active Function'**
  String get analyzeActiveFunction;

  /// No description provided for @interruptLockTarget.
  ///
  /// In en, this message translates to:
  /// **'Interrupt LockTarget'**
  String get interruptLockTarget;

  /// No description provided for @observeNextFunctionNode.
  ///
  /// In en, this message translates to:
  /// **'Observe next Function node'**
  String get observeNextFunctionNode;

  /// No description provided for @resetTutorialPattern.
  ///
  /// In en, this message translates to:
  /// **'Reset tutorial pattern'**
  String get resetTutorialPattern;

  /// No description provided for @contentBalance.
  ///
  /// In en, this message translates to:
  /// **'Content balance: {status}'**
  String contentBalance(String status);

  /// No description provided for @nodeStateCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by Weak Node interruption'**
  String get nodeStateCancelled;

  /// No description provided for @nodeStateWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak Node revealed · interruptible'**
  String get nodeStateWeak;

  /// No description provided for @nodeStateActive.
  ///
  /// In en, this message translates to:
  /// **'Active Function'**
  String get nodeStateActive;

  /// No description provided for @nodeStateAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting execution'**
  String get nodeStateAwaiting;

  /// No description provided for @feedbackPreparingPounce.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is preparing Pounce. Inspect the Function before it resolves.'**
  String get feedbackPreparingPounce;

  /// No description provided for @feedbackPreparingAgain.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is preparing Pounce again.'**
  String get feedbackPreparingAgain;

  /// No description provided for @feedbackLockActive.
  ///
  /// In en, this message translates to:
  /// **'LockTarget is active. It is interruptible, but its role is not yet analyzed.'**
  String get feedbackLockActive;

  /// No description provided for @feedbackWeakFound.
  ///
  /// In en, this message translates to:
  /// **'Weak Node found: interrupting LockTarget cancels downstream Pounce.'**
  String get feedbackWeakFound;

  /// No description provided for @feedbackAnalysisMiss.
  ///
  /// In en, this message translates to:
  /// **'Analysis did not reveal the node. Try again.'**
  String get feedbackAnalysisMiss;

  /// No description provided for @feedbackInterrupted.
  ///
  /// In en, this message translates to:
  /// **'LockTarget interrupted. Pounce is cancelled.'**
  String get feedbackInterrupted;

  /// No description provided for @feedbackInterruptFailed.
  ///
  /// In en, this message translates to:
  /// **'This Function could not be interrupted.'**
  String get feedbackInterruptFailed;

  /// No description provided for @functionNodeDetectTarget.
  ///
  /// In en, this message translates to:
  /// **'Detect Target'**
  String get functionNodeDetectTarget;

  /// No description provided for @functionNodeLockTarget.
  ///
  /// In en, this message translates to:
  /// **'Lock Target'**
  String get functionNodeLockTarget;

  /// No description provided for @functionNodePounce.
  ///
  /// In en, this message translates to:
  /// **'Pounce'**
  String get functionNodePounce;

  /// No description provided for @ashfangEncounter.
  ///
  /// In en, this message translates to:
  /// **'Ashfang Encounter'**
  String get ashfangEncounter;

  /// No description provided for @battleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Battle unavailable: {error}'**
  String battleUnavailable(String error);

  /// No description provided for @prototypeEncounterInputs.
  ///
  /// In en, this message translates to:
  /// **'Prototype encounter inputs'**
  String get prototypeEncounterInputs;

  /// No description provided for @battleRoundStatus.
  ///
  /// In en, this message translates to:
  /// **'Round {round} · {status}'**
  String battleRoundStatus(int round, String status);

  /// No description provided for @weakNodeRevealed.
  ///
  /// In en, this message translates to:
  /// **'Weak Node revealed: LockTarget'**
  String get weakNodeRevealed;

  /// No description provided for @weakNodeCancelsPounce.
  ///
  /// In en, this message translates to:
  /// **'Interrupting this node cancels downstream Pounce.'**
  String get weakNodeCancelsPounce;

  /// No description provided for @trainingEncounterComplete.
  ///
  /// In en, this message translates to:
  /// **'Training encounter complete'**
  String get trainingEncounterComplete;

  /// No description provided for @trainingAnalysisSaved.
  ///
  /// In en, this message translates to:
  /// **'Your trained Analysis informed the Weak Node interaction. Battle state is saved.'**
  String get trainingAnalysisSaved;

  /// No description provided for @encounterEnded.
  ///
  /// In en, this message translates to:
  /// **'Encounter ended'**
  String get encounterEnded;

  /// No description provided for @ashfangOverwhelmed.
  ///
  /// In en, this message translates to:
  /// **'Ashfang overwhelmed your character. This result is saved.'**
  String get ashfangOverwhelmed;

  /// No description provided for @attackAshfang.
  ///
  /// In en, this message translates to:
  /// **'Attack Ashfang'**
  String get attackAshfang;

  /// No description provided for @endTurn.
  ///
  /// In en, this message translates to:
  /// **'End turn'**
  String get endTurn;

  /// No description provided for @analyzeWeakNode.
  ///
  /// In en, this message translates to:
  /// **'Analyze Weak Node'**
  String get analyzeWeakNode;

  /// No description provided for @resolvePounce.
  ///
  /// In en, this message translates to:
  /// **'Resolve Pounce'**
  String get resolvePounce;

  /// No description provided for @unitHpDetail.
  ///
  /// In en, this message translates to:
  /// **'{detail} · HP {hp} / {maxHp}'**
  String unitHpDetail(String detail, int hp, int maxHp);

  /// No description provided for @questMetaShort.
  ///
  /// In en, this message translates to:
  /// **'{domain} · {minutes} min'**
  String questMetaShort(String domain, int minutes);

  /// No description provided for @couldNotLoadTraining.
  ///
  /// In en, this message translates to:
  /// **'Could not load Training. Please try again.'**
  String get couldNotLoadTraining;

  /// No description provided for @confirmPreparedDeck.
  ///
  /// In en, this message translates to:
  /// **'Confirm Prepared Deck'**
  String get confirmPreparedDeck;

  /// No description provided for @graphGather.
  ///
  /// In en, this message translates to:
  /// **'Gather'**
  String get graphGather;

  /// No description provided for @graphShape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get graphShape;

  /// No description provided for @graphMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get graphMove;

  /// No description provided for @graphGatherDescription.
  ///
  /// In en, this message translates to:
  /// **'Collects the energy the Function will use.'**
  String get graphGatherDescription;

  /// No description provided for @graphShapeDescription.
  ///
  /// In en, this message translates to:
  /// **'Forms that energy into the intended effect, such as a bolt.'**
  String get graphShapeDescription;

  /// No description provided for @graphMoveDescription.
  ///
  /// In en, this message translates to:
  /// **'Directs the formed effect toward its target.'**
  String get graphMoveDescription;

  /// No description provided for @graphGatherSummary.
  ///
  /// In en, this message translates to:
  /// **'collect energy'**
  String get graphGatherSummary;

  /// No description provided for @graphShapeSummary.
  ///
  /// In en, this message translates to:
  /// **'form a bolt'**
  String get graphShapeSummary;

  /// No description provided for @graphMoveSummary.
  ///
  /// In en, this message translates to:
  /// **'direct the result'**
  String get graphMoveSummary;

  /// No description provided for @graphNodeSummary.
  ///
  /// In en, this message translates to:
  /// **'{name} · {summary}'**
  String graphNodeSummary(String name, String summary);

  /// No description provided for @graphCorrectMove.
  ///
  /// In en, this message translates to:
  /// **'Correct — Move directs the effect to its target.'**
  String get graphCorrectMove;

  /// No description provided for @graphWrongMove.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Move is the step that directs the effect to its target.'**
  String get graphWrongMove;

  /// No description provided for @functionNodeSemantics.
  ///
  /// In en, this message translates to:
  /// **'{node}, {state}'**
  String functionNodeSemantics(String node, String state);

  /// No description provided for @balanceAwaitingPlaytest.
  ///
  /// In en, this message translates to:
  /// **'Illustrative inputs · awaiting playtest'**
  String get balanceAwaitingPlaytest;

  /// No description provided for @contentVersionStatus.
  ///
  /// In en, this message translates to:
  /// **'{version} · {status}'**
  String contentVersionStatus(String version, String status);

  /// No description provided for @battleHeroName.
  ///
  /// In en, this message translates to:
  /// **'Astraea Hero'**
  String get battleHeroName;

  /// No description provided for @analysisModifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Analysis modifier +{modifier}'**
  String analysisModifierLabel(int modifier);

  /// No description provided for @functionPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Function: DetectTarget → LockTarget → Pounce'**
  String get functionPathLabel;

  /// No description provided for @battleOutcomeActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get battleOutcomeActive;

  /// No description provided for @battleOutcomeVictory.
  ///
  /// In en, this message translates to:
  /// **'VICTORY'**
  String get battleOutcomeVictory;

  /// No description provided for @battleOutcomeDefeat.
  ///
  /// In en, this message translates to:
  /// **'DEFEAT'**
  String get battleOutcomeDefeat;

  /// No description provided for @feedbackGuarding.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is guarding the training arena.'**
  String get feedbackGuarding;

  /// No description provided for @feedbackAshfangDefeated.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is defeated. The Weak Node changed the battle.'**
  String get feedbackAshfangDefeated;

  /// No description provided for @feedbackAttackResolved.
  ///
  /// In en, this message translates to:
  /// **'Attack resolved through the combat engine.'**
  String get feedbackAttackResolved;

  /// No description provided for @feedbackEnemyFunctionBegins.
  ///
  /// In en, this message translates to:
  /// **'Ashfang begins DetectTarget → LockTarget → Pounce.'**
  String get feedbackEnemyFunctionBegins;

  /// No description provided for @feedbackWeakNodeFoundLegacy.
  ///
  /// In en, this message translates to:
  /// **'Weak Node found. Interrupt LockTarget to cancel Pounce.'**
  String get feedbackWeakNodeFoundLegacy;

  /// No description provided for @feedbackWeakNodeMissLegacy.
  ///
  /// In en, this message translates to:
  /// **'Weak Node not revealed this time. Ashfang resolves Pounce.'**
  String get feedbackWeakNodeMissLegacy;

  /// No description provided for @feedbackInterruptedLegacy.
  ///
  /// In en, this message translates to:
  /// **'LockTarget interrupted. Downstream Pounce was cancelled.'**
  String get feedbackInterruptedLegacy;

  /// No description provided for @feedbackPounceResolved.
  ///
  /// In en, this message translates to:
  /// **'Pounce resolved through the combat engine.'**
  String get feedbackPounceResolved;

  /// No description provided for @combatRotateDevice.
  ///
  /// In en, this message translates to:
  /// **'Rotate your device to play the battle in landscape.'**
  String get combatRotateDevice;

  /// No description provided for @combatActionTimeline.
  ///
  /// In en, this message translates to:
  /// **'ACTION TIMELINE'**
  String get combatActionTimeline;

  /// No description provided for @combatEnemyIntent.
  ///
  /// In en, this message translates to:
  /// **'ENEMY INTENT'**
  String get combatEnemyIntent;

  /// No description provided for @combatCurrentActor.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get combatCurrentActor;

  /// No description provided for @combatHero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get combatHero;

  /// No description provided for @combatRio.
  ///
  /// In en, this message translates to:
  /// **'Rio'**
  String get combatRio;

  /// No description provided for @combatYuma.
  ///
  /// In en, this message translates to:
  /// **'Yuma'**
  String get combatYuma;

  /// No description provided for @combatAshfang.
  ///
  /// In en, this message translates to:
  /// **'Ashfang'**
  String get combatAshfang;

  /// No description provided for @combatReactionReady.
  ///
  /// In en, this message translates to:
  /// **'Reaction ready'**
  String get combatReactionReady;

  /// No description provided for @combatReactionSpent.
  ///
  /// In en, this message translates to:
  /// **'Reaction spent'**
  String get combatReactionSpent;

  /// No description provided for @combatAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get combatAttack;

  /// No description provided for @combatTechnique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get combatTechnique;

  /// No description provided for @combatSc.
  ///
  /// In en, this message translates to:
  /// **'SC'**
  String get combatSc;

  /// No description provided for @combatAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get combatAnalyze;

  /// No description provided for @combatGuard.
  ///
  /// In en, this message translates to:
  /// **'Guard'**
  String get combatGuard;

  /// No description provided for @combatMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get combatMove;

  /// No description provided for @combatFireballI.
  ///
  /// In en, this message translates to:
  /// **'Fireball I'**
  String get combatFireballI;

  /// No description provided for @combatFireballII.
  ///
  /// In en, this message translates to:
  /// **'Fireball II'**
  String get combatFireballII;

  /// No description provided for @combatKnownFireball.
  ///
  /// In en, this message translates to:
  /// **'Fireball I'**
  String get combatKnownFireball;

  /// No description provided for @combatModifiedFireball.
  ///
  /// In en, this message translates to:
  /// **'Modified Fireball'**
  String get combatModifiedFireball;

  /// No description provided for @combatFullChant.
  ///
  /// In en, this message translates to:
  /// **'Full Chant'**
  String get combatFullChant;

  /// No description provided for @combatChantless.
  ///
  /// In en, this message translates to:
  /// **'Chantless'**
  String get combatChantless;

  /// No description provided for @combatUnknownFunction.
  ///
  /// In en, this message translates to:
  /// **'Unknown Function'**
  String get combatUnknownFunction;

  /// No description provided for @combatTargetHero.
  ///
  /// In en, this message translates to:
  /// **'Target: Hero'**
  String get combatTargetHero;

  /// No description provided for @combatTimelineTurn.
  ///
  /// In en, this message translates to:
  /// **'{name} Turn'**
  String combatTimelineTurn(String name);

  /// No description provided for @combatTimelineResolve.
  ///
  /// In en, this message translates to:
  /// **'{spell} Resolve'**
  String combatTimelineResolve(String spell);

  /// No description provided for @combatTimelineFunction.
  ///
  /// In en, this message translates to:
  /// **'Active Function'**
  String get combatTimelineFunction;

  /// No description provided for @combatHp.
  ///
  /// In en, this message translates to:
  /// **'HP {current}/{max}'**
  String combatHp(int current, int max);

  /// No description provided for @combatMana.
  ///
  /// In en, this message translates to:
  /// **'Mana {current}/{max}'**
  String combatMana(int current, int max);

  /// No description provided for @combatTutorialChantlessTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a prepared spell'**
  String get combatTutorialChantlessTitle;

  /// No description provided for @combatTutorialChantlessBody.
  ///
  /// In en, this message translates to:
  /// **'Use Fireball I with Chantless casting. The Function resolves immediately.'**
  String get combatTutorialChantlessBody;

  /// No description provided for @combatCastFireballI.
  ///
  /// In en, this message translates to:
  /// **'Cast Fireball I'**
  String get combatCastFireballI;

  /// No description provided for @combatKnownReactionTitle.
  ///
  /// In en, this message translates to:
  /// **'REACTION'**
  String get combatKnownReactionTitle;

  /// No description provided for @combatKnownReactionBody.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is constructing Fireball I. Rio can interrupt before the Function is established.'**
  String get combatKnownReactionBody;

  /// No description provided for @combatInterrupt.
  ///
  /// In en, this message translates to:
  /// **'Interrupt'**
  String get combatInterrupt;

  /// No description provided for @combatSaveReaction.
  ///
  /// In en, this message translates to:
  /// **'Save Reaction'**
  String get combatSaveReaction;

  /// No description provided for @combatModifiedAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown modification detected'**
  String get combatModifiedAnalysisTitle;

  /// No description provided for @combatModifiedAnalysisBody.
  ///
  /// In en, this message translates to:
  /// **'Use Analysis to reveal what is actually vulnerable in this Function.'**
  String get combatModifiedAnalysisBody;

  /// No description provided for @combatAnalyzeModified.
  ///
  /// In en, this message translates to:
  /// **'Analyze Modified Function'**
  String get combatAnalyzeModified;

  /// No description provided for @combatModifiedReactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Weak Node revealed'**
  String get combatModifiedReactionTitle;

  /// No description provided for @combatModifiedReactionBody.
  ///
  /// In en, this message translates to:
  /// **'Analysis found a vulnerable Stabilization dependency. Rio can exploit it.'**
  String get combatModifiedReactionBody;

  /// No description provided for @combatWeakNodeStabilization.
  ///
  /// In en, this message translates to:
  /// **'Weak Node: Stabilization'**
  String get combatWeakNodeStabilization;

  /// No description provided for @combatStabilityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Stability ?'**
  String get combatStabilityUnknown;

  /// No description provided for @combatStabilityValue.
  ///
  /// In en, this message translates to:
  /// **'Stability {value}'**
  String combatStabilityValue(int value);

  /// No description provided for @combatFunctionStructure.
  ///
  /// In en, this message translates to:
  /// **'FUNCTION STRUCTURE'**
  String get combatFunctionStructure;

  /// No description provided for @combatStructureUnknown.
  ///
  /// In en, this message translates to:
  /// **'Internal dependencies have not been revealed.'**
  String get combatStructureUnknown;

  /// No description provided for @combatStructureRevealed.
  ///
  /// In en, this message translates to:
  /// **'Stabilization is structurally vulnerable.'**
  String get combatStructureRevealed;

  /// No description provided for @combatBeginFullChant.
  ///
  /// In en, this message translates to:
  /// **'Begin Fireball II · Full Chant'**
  String get combatBeginFullChant;

  /// No description provided for @combatFullChantTitle.
  ///
  /// In en, this message translates to:
  /// **'Commit to Full Chant'**
  String get combatFullChantTitle;

  /// No description provided for @combatFullChantBody.
  ///
  /// In en, this message translates to:
  /// **'Fireball II enters the Timeline and resolves after its construction completes.'**
  String get combatFullChantBody;

  /// No description provided for @combatFinisherTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Tier remains useful'**
  String get combatFinisherTitle;

  /// No description provided for @combatFinisherBody.
  ///
  /// In en, this message translates to:
  /// **'Finish with the cheaper Fireball I using Chantless casting.'**
  String get combatFinisherBody;

  /// No description provided for @combatFinishFireballI.
  ///
  /// In en, this message translates to:
  /// **'Finish with Fireball I'**
  String get combatFinishFireballI;

  /// No description provided for @combatVictoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Training battle complete'**
  String get combatVictoryTitle;

  /// No description provided for @combatVictoryBody.
  ///
  /// In en, this message translates to:
  /// **'You used Chantless, Interrupt, Analysis, a Weak Node, and Full Chant through the real CTB engine.'**
  String get combatVictoryBody;

  /// No description provided for @combatRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart Training'**
  String get combatRestart;

  /// No description provided for @combatReturnAdventure.
  ///
  /// In en, this message translates to:
  /// **'Return to Adventure'**
  String get combatReturnAdventure;

  /// No description provided for @combatIntentHeroTurn.
  ///
  /// In en, this message translates to:
  /// **'Read the field and choose your action.'**
  String get combatIntentHeroTurn;

  /// No description provided for @combatIntentKnownFireball.
  ///
  /// In en, this message translates to:
  /// **'Fireball I · Full Chant'**
  String get combatIntentKnownFireball;

  /// No description provided for @combatIntentModifiedFireball.
  ///
  /// In en, this message translates to:
  /// **'Modified Fireball · Full Chant'**
  String get combatIntentModifiedFireball;

  /// No description provided for @combatIntentHeroFullChant.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is recovering. Hero can commit to Full Chant.'**
  String get combatIntentHeroFullChant;

  /// No description provided for @combatIntentFinisher.
  ///
  /// In en, this message translates to:
  /// **'Ashfang is nearly defeated.'**
  String get combatIntentFinisher;

  /// No description provided for @combatIntentVictory.
  ///
  /// In en, this message translates to:
  /// **'Training objective complete.'**
  String get combatIntentVictory;

  /// No description provided for @combatFeedbackOpening.
  ///
  /// In en, this message translates to:
  /// **'Prepared SCs are direct battle options. Start with Fireball I.'**
  String get combatFeedbackOpening;

  /// No description provided for @combatFeedbackHeroChantless.
  ///
  /// In en, this message translates to:
  /// **'Fireball I resolved immediately through Chantless casting.'**
  String get combatFeedbackHeroChantless;

  /// No description provided for @combatFeedbackKnownCasting.
  ///
  /// In en, this message translates to:
  /// **'Ashfang began a known Full Chant. The Interrupt window is open.'**
  String get combatFeedbackKnownCasting;

  /// No description provided for @combatFeedbackKnownInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Rio broke the unfinished Fireball before establishment.'**
  String get combatFeedbackKnownInterrupted;

  /// No description provided for @combatFeedbackKnownResolved.
  ///
  /// In en, this message translates to:
  /// **'Reaction saved. Fireball I resolved and damaged Hero.'**
  String get combatFeedbackKnownResolved;

  /// No description provided for @combatFeedbackModifiedCasting.
  ///
  /// In en, this message translates to:
  /// **'Ashfang changed the Function. Its internal structure is unknown.'**
  String get combatFeedbackModifiedCasting;

  /// No description provided for @combatFeedbackAnalysisWeakNode.
  ///
  /// In en, this message translates to:
  /// **'Analysis revealed Stability and a real Stabilization Weak Node.'**
  String get combatFeedbackAnalysisWeakNode;

  /// No description provided for @combatFeedbackModifiedInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Weak Node bonus raised Interrupt Power enough to break the Function.'**
  String get combatFeedbackModifiedInterrupted;

  /// No description provided for @combatFeedbackModifiedResolved.
  ///
  /// In en, this message translates to:
  /// **'The modified Function was allowed to resolve.'**
  String get combatFeedbackModifiedResolved;

  /// No description provided for @combatFeedbackHeroFullChantCasting.
  ///
  /// In en, this message translates to:
  /// **'Hero committed Mana and entered Full Chant.'**
  String get combatFeedbackHeroFullChantCasting;

  /// No description provided for @combatFeedbackHeroFullChantResolved.
  ///
  /// In en, this message translates to:
  /// **'Fireball II resolved. Ashfang is barely standing.'**
  String get combatFeedbackHeroFullChantResolved;

  /// No description provided for @combatFeedbackVictory.
  ///
  /// In en, this message translates to:
  /// **'Ashfang defeated. Tutorial objective complete.'**
  String get combatFeedbackVictory;

  /// No description provided for @combatFeedbackDefeat.
  ///
  /// In en, this message translates to:
  /// **'The party was defeated.'**
  String get combatFeedbackDefeat;

  /// No description provided for @combatZoneMid.
  ///
  /// In en, this message translates to:
  /// **'MID'**
  String get combatZoneMid;

  /// No description provided for @combatTrainingArena.
  ///
  /// In en, this message translates to:
  /// **'ASTRAEA TRAINING HALL'**
  String get combatTrainingArena;

  /// No description provided for @combatFullChantCastingTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Chant is constructing'**
  String get combatFullChantCastingTitle;

  /// No description provided for @combatFullChantCastingBody.
  ///
  /// In en, this message translates to:
  /// **'Fireball II is now a pending Resolve event on the Timeline. Ashfang can act before the spell completes.'**
  String get combatFullChantCastingBody;

  /// No description provided for @combatAdvanceTimeline.
  ///
  /// In en, this message translates to:
  /// **'Advance to Resolve'**
  String get combatAdvanceTimeline;

  /// No description provided for @combatDefeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Training failed'**
  String get combatDefeatTitle;

  /// No description provided for @combatDefeatBody.
  ///
  /// In en, this message translates to:
  /// **'The party was defeated. Restart the training encounter and try a different decision.'**
  String get combatDefeatBody;

  /// No description provided for @combatHoldFormation.
  ///
  /// In en, this message translates to:
  /// **'Hold Formation'**
  String get combatHoldFormation;

  /// No description provided for @combatNodeCompression.
  ///
  /// In en, this message translates to:
  /// **'Compression'**
  String get combatNodeCompression;

  /// No description provided for @combatNodeStabilization.
  ///
  /// In en, this message translates to:
  /// **'Stabilization'**
  String get combatNodeStabilization;

  /// No description provided for @combatNodeTrajectory.
  ///
  /// In en, this message translates to:
  /// **'Trajectory'**
  String get combatNodeTrajectory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
