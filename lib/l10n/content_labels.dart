import '../features/character/domain/attribute.dart';
import '../features/life_quest/domain/life_domain.dart';
import 'app_localizations.dart';

String localizedQuestTitle(AppLocalizations l10n, String id) => switch (id) {
  'fitness.walk10' => l10n.questFitnessWalk10,
  'fitness.exercise20' => l10n.questFitnessExercise20,
  'learning.read20' => l10n.questLearningRead20,
  'learning.study20' => l10n.questLearningStudy20,
  'languages.practice15' => l10n.questLanguagesPractice15,
  _ => id,
};

String localizedDomain(AppLocalizations l10n, String domain) => switch (domain) {
  'fitness' => l10n.domainFitness,
  'learning' => l10n.domainLearning,
  'languages' => l10n.domainLanguages,
  _ => l10n.domainLife,
};

String localizedPotentialCategory(
  AppLocalizations l10n,
  GrowthPotentialCategory category,
) => switch (category) {
  GrowthPotentialCategory.physical => l10n.potentialPhysical,
  GrowthPotentialCategory.cognitive => l10n.potentialCognitive,
  GrowthPotentialCategory.communication => l10n.potentialCommunication,
};

String localizedPotentialForDomain(
  AppLocalizations l10n,
  String domain,
) => switch (domain) {
  'fitness' => l10n.potentialPhysical,
  'learning' => l10n.potentialCognitive,
  'languages' => l10n.potentialCommunication,
  _ => l10n.potentialGrowth,
};

String localizedAttribute(AppLocalizations l10n, AttributeType value) =>
    switch (value) {
      AttributeType.manaCapacity => l10n.attributeManaCapacity,
      AttributeType.manaOutput => l10n.attributeManaOutput,
      AttributeType.computation => l10n.attributeComputation,
      AttributeType.processing => l10n.attributeProcessing,
      AttributeType.precision => l10n.attributePrecision,
      AttributeType.efficiency => l10n.attributeEfficiency,
      AttributeType.ambientSync => l10n.attributeAmbientSync,
      AttributeType.analysis => l10n.attributeAnalysis,
    };

String localizedAttributeEffect(AppLocalizations l10n, AttributeType value) =>
    switch (value) {
      AttributeType.manaCapacity => l10n.attributeManaCapacityEffect,
      AttributeType.manaOutput => l10n.attributeManaOutputEffect,
      AttributeType.computation => l10n.attributeComputationEffect,
      AttributeType.processing => l10n.attributeProcessingEffect,
      AttributeType.precision => l10n.attributePrecisionEffect,
      AttributeType.efficiency => l10n.attributeEfficiencyEffect,
      AttributeType.ambientSync => l10n.attributeAmbientSyncEffect,
      AttributeType.analysis => l10n.attributeAnalysisEffect,
    };

String localizedWeapon(AppLocalizations l10n, String id) => switch (id) {
  'astraea_longsword' => l10n.weaponAstraeaLongsword,
  'standard_spear' => l10n.weaponStandardSpear,
  'training_arcane_gun' => l10n.weaponTrainingArcaneGun,
  'standard_staff' => l10n.weaponStandardStaff,
  _ => id,
};

String localizedSpellName(AppLocalizations l10n, String id) => switch (id) {
  'arc_bolt' => l10n.spellArcBolt,
  'focused_shot' => l10n.spellFocusedShot,
  'energy_burst' => l10n.spellEnergyBurst,
  'barrier' => l10n.spellBarrier,
  'deflect' => l10n.spellDeflect,
  'step_shift' => l10n.spellStepShift,
  'weak_node_scan' => l10n.spellWeakNodeScan,
  'mana_stabilize' => l10n.spellManaStabilize,
  'interrupt_pulse' => l10n.spellInterruptPulse,
  _ => id,
};

String localizedSpellRole(AppLocalizations l10n, String role) => switch (role) {
  'Attack' => l10n.roleAttack,
  'Defense' => l10n.roleDefense,
  'Mobility' => l10n.roleMobility,
  'Analysis' => l10n.roleAnalysis,
  'Support' => l10n.roleSupport,
  'Counter' => l10n.roleCounter,
  _ => role,
};

String localizedSceneTitle(AppLocalizations l10n, String id) => switch (id) {
  'scene-1' => l10n.scene1Title,
  'scene-2' => l10n.scene2Title,
  'scene-3' => l10n.scene3Title,
  'scene-4' => l10n.scene4Title,
  'scene-5' => l10n.scene5Title,
  _ => id,
};

List<String> localizedSceneBeats(AppLocalizations l10n, String id) =>
    switch (id) {
      'scene-1' => [
        l10n.scene1Beat1,
        l10n.scene1Beat2,
        l10n.scene1Beat3,
        l10n.scene1Beat4,
      ],
      'scene-2' => [l10n.scene2Beat1, l10n.scene2Beat2, l10n.scene2Beat3],
      'scene-3' => [l10n.scene3Beat1, l10n.scene3Beat2, l10n.scene3Beat3],
      'scene-4' => [l10n.scene4Beat1, l10n.scene4Beat2, l10n.scene4Beat3],
      'scene-5' => [l10n.scene5Beat1, l10n.scene5Beat2, l10n.scene5Beat3],
      _ => const [],
    };

String localizedFunctionNodeType(AppLocalizations l10n, String type) =>
    switch (type) {
      'DetectTarget' => l10n.functionNodeDetectTarget,
      'LockTarget' => l10n.functionNodeLockTarget,
      'Pounce' => l10n.functionNodePounce,
      _ => type,
    };

(String, String, String) localizedTrainingDefinition(
  AppLocalizations l10n,
  String id,
) => switch (id) {
  'reaction-drill' => (
    l10n.trainingReactionDrill,
    l10n.attributeProcessing,
    l10n.trainingReactionFocus,
  ),
  'precision-movement' => (
    l10n.trainingPrecisionMovement,
    l10n.attributePrecision,
    l10n.trainingPrecisionFocus,
  ),
  'function-analysis-drill' => (
    l10n.trainingFunctionAnalysisDrill,
    l10n.attributeAnalysis,
    l10n.trainingAnalysisFocus,
  ),
  'complexity-exercise' => (
    l10n.trainingComplexityExercise,
    l10n.attributeComputation,
    l10n.trainingComplexityFocus,
  ),
  'mana-control-drill' => (
    l10n.trainingManaControlDrill,
    l10n.attributeEfficiency,
    l10n.trainingManaControlFocus,
  ),
  'intent-encoding-drill' => (
    l10n.trainingIntentEncodingDrill,
    l10n.attributeManaOutput,
    l10n.trainingIntentEncodingFocus,
  ),
  _ => (id, id, id),
};


String localizedBalanceStatus(AppLocalizations l10n, String status) =>
    switch (status) {
      'illustrative-inputs-awaiting-playtest' => l10n.balanceAwaitingPlaytest,
      _ => status,
    };
