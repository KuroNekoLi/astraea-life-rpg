// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Astraea';

  @override
  String get navHome => '首頁';

  @override
  String get navLife => '生活';

  @override
  String get navAdventure => '冒險';

  @override
  String get navDeck => '牌組';

  @override
  String get navCharacter => '角色';

  @override
  String get commonRetry => '重試';

  @override
  String get commonContinue => '繼續';

  @override
  String get commonBack => '返回';

  @override
  String get commonCancel => '取消';

  @override
  String get commonStart => '開始';

  @override
  String get commonFinish => '完成';

  @override
  String get commonPause => '暫停';

  @override
  String get commonResume => '繼續';

  @override
  String get commonEnable => '啟用';

  @override
  String get commonTurnOff => '關閉';

  @override
  String get splashTagline => '讓現實的努力，成為改變世界的魔法。';

  @override
  String get tapToStart => '點擊開始';

  @override
  String get welcomeToAstraea => '歡迎來到 Astraea';

  @override
  String get onboardingHeadline => '你每天投入的努力，都能塑造在 Astraea 中的自己。';

  @override
  String get onboardingBody => '現實生活與學院彼此相連，但要做什麼始終由你決定。';

  @override
  String get enterAstraea => '進入 Astraea';

  @override
  String get noStreakPenalty => '沒有連續打卡懲罰。你休息時，進度會等你回來。';

  @override
  String get chooseLifeQuest => '選擇 Life Quest';

  @override
  String get earnGrowthPotential => '獲得成長潛能';

  @override
  String get buildRpgSelf => '打造你的 RPG 角色';

  @override
  String get chooseLifeQuestDescription => '在適合今天的時候，選一件真實世界中的行動。';

  @override
  String get earnGrowthPotentialDescription => '你的行動會轉化為遊戲內的成長機會。';

  @override
  String get buildRpgSelfDescription => '訓練、準備術式牌組，並探索學院。';

  @override
  String get homeBrandSubtitle => '生活 × RPG';

  @override
  String get homeHeroEyebrow => 'Astraea Academy · 第一章';

  @override
  String get homeHeroTitle => '一個真實行動，就能讓旅程開始。';

  @override
  String get homeHeroDescription => '選擇 Life Quest、獲得成長潛能，塑造探索 Astraea 的你。';

  @override
  String get yourJourney => '你的旅程';

  @override
  String get continueYourJourney => '繼續旅程';

  @override
  String get journeyLifeQuests => 'Life Quest';

  @override
  String get journeyLifeQuestsSubtitle => '從一個真實行動開始';

  @override
  String get journeyAdventure => '冒險';

  @override
  String get journeyAdventureSubtitle => '故事與目標';

  @override
  String get journeyCharacter => '角色';

  @override
  String get journeyCharacterSubtitle => '正在成長的 Build';

  @override
  String get journeyPreparedDeck => 'Prepared Deck';

  @override
  String get journeyPreparedDeckSubtitle => '六張準備術式';

  @override
  String get today => '今天';

  @override
  String get allQuests => '全部任務';

  @override
  String get lifeQuestsUnavailable => '目前無法載入 Life Quest。';

  @override
  String get quietDayTitle => '今天安靜一點也沒關係。';

  @override
  String get quietDaySubtitle => '適合的時候再選一個 Life Quest。';

  @override
  String get growthPotentialReady => '已有可用的成長潛能';

  @override
  String get characterProfileTooltip => '角色資料';

  @override
  String get optionalPilotMeasurement => '選用的試玩測量';

  @override
  String get pilotOnLocalOnly => '開啟 · 僅本機';

  @override
  String get pilotOffDefault => '關閉 · 預設';

  @override
  String get pilotTurnOffTitle => '關閉試玩測量？';

  @override
  String get pilotEnableTitle => '啟用私密試玩測量？';

  @override
  String get pilotTurnOffBody => '關閉後會刪除儲存在本機的里程碑事件。';

  @override
  String get pilotEnableBody =>
      '這只會在本機儲存少量遊戲里程碑，不會收集姓名、筆記、證據、健康資料或自訂任務文字，也不會上傳。你可以隨時關閉並刪除這些事件。';

  @override
  String potentialChooseHowToTrain(int amount) {
    return '$amount 點潛能 · 選擇訓練方式';
  }

  @override
  String get lifeQuest => 'Life Quest';

  @override
  String couldNotLoadQuests(String error) {
    return '無法載入任務：$error';
  }

  @override
  String get chooseWhatFitsYourDay => '選擇今天適合你的行動。';

  @override
  String get progressAlwaysHere => '你的進度一直都在，也沒有連續打卡懲罰。';

  @override
  String availableQuestCount(int count) {
    return '目前有 $count 個可用任務';
  }

  @override
  String get domainAll => '全部';

  @override
  String get domainFitness => '健身';

  @override
  String get domainLearning => '學習';

  @override
  String get domainLanguages => '語言';

  @override
  String get domainLife => '生活';

  @override
  String get noQuestsCategory => '這個分類目前還沒有任務。';

  @override
  String get addWhenReady => '準備好的時候再新增即可。';

  @override
  String get addLifeQuest => '新增 Life Quest';

  @override
  String minutesShort(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get questDetails => '任務詳情';

  @override
  String couldNotLoadQuest(String error) {
    return '無法載入任務：$error';
  }

  @override
  String get questNotFound => '找不到這個任務';

  @override
  String questAboutMinutes(String domain, int minutes) {
    return '$domain · 約 $minutes 分鐘';
  }

  @override
  String get selfReportTimerEvidence => '你可以直接自行回報；使用計時器則會留下輕量證據。';

  @override
  String get startTimer => '開始計時';

  @override
  String get completeSelfReport => '自行回報完成';

  @override
  String get questComplete => '任務完成';

  @override
  String lifeXpReward(int amount, String domain) {
    return '+$amount $domain Life XP';
  }

  @override
  String potentialReward(int amount, String category) {
    return '+$amount $category 潛能';
  }

  @override
  String get timerEvidenceBonus => '計時器證據 · 已包含加成';

  @override
  String get selfReportPrivate => '自行回報 · 私密';

  @override
  String get confirmReward => '確認獎勵';

  @override
  String get questTimer => '任務計時器';

  @override
  String get timerRunsAway => '離開畫面後計時仍會繼續。';

  @override
  String get potentialPhysical => '體能';

  @override
  String get potentialCognitive => '認知';

  @override
  String get potentialCommunication => '溝通';

  @override
  String get potentialGrowth => '成長';

  @override
  String get questFitnessWalk10 => '步行 10 分鐘';

  @override
  String get questFitnessExercise20 => '運動 20 分鐘';

  @override
  String get questLearningRead20 => '閱讀 20 分鐘';

  @override
  String get questLearningStudy20 => '學習 20 分鐘';

  @override
  String get questLanguagesPractice15 => '語言練習 15 分鐘';

  @override
  String get createAstraeaSelf => '建立你的 Astraea 自我';

  @override
  String get saving => '儲存中…';

  @override
  String get characterName => '角色名稱';

  @override
  String get distributePoints => '配置 32 點 · 基礎 8 · 上限 15';

  @override
  String get characterBuildFocusDescription =>
      '選擇角色的 Build 方向。這些能力值會影響戰鬥選項，但任何選擇都不會封鎖主線故事。';

  @override
  String pointsSpent(int spent, int budget) {
    return '$spent / $budget 點';
  }

  @override
  String attributeAllocationSummary(
    int base,
    int allocated,
    int starting,
    String effect,
  ) {
    return '基礎 $base + 配置 $allocated = 初始 $starting\n$effect';
  }

  @override
  String get initialWeapon => '初始武器';

  @override
  String get weaponAstraeaLongsword => 'Astraea 長劍';

  @override
  String get weaponStandardSpear => '標準長槍';

  @override
  String get weaponTrainingArcaneGun => '訓練用奧術槍';

  @override
  String get weaponStandardStaff => '標準法杖';

  @override
  String get attributeManaCapacity => 'Mana 容量';

  @override
  String get attributeManaOutput => 'Mana 輸出';

  @override
  String get attributeComputation => '運算';

  @override
  String get attributeProcessing => '處理速度';

  @override
  String get attributePrecision => '精準';

  @override
  String get attributeEfficiency => '效率';

  @override
  String get attributeAmbientSync => '環境同步';

  @override
  String get attributeAnalysis => '分析';

  @override
  String get attributeManaCapacityEffect => '重點：Mana 上限與高消耗術式續航';

  @override
  String get attributeManaOutputEffect => '重點：安全輸出與爆發術式規模';

  @override
  String get attributeComputationEffect => '重點：複雜 Function 與 Counter 推理';

  @override
  String get attributeProcessingEffect => '重點：時間軸、Reaction 與快速行動';

  @override
  String get attributePrecisionEffect => '重點：目標控制、Interrupt 與精準操作';

  @override
  String get attributeEfficiencyEffect => '重點：Mana 使用與資源效率';

  @override
  String get attributeAmbientSyncEffect => '重點：環境與支援魔法';

  @override
  String get attributeAnalysisEffect => '重點：揭露敵方 Weak Node 與 Counter 路徑';

  @override
  String get character => '角色';

  @override
  String get yourAstraeaSelf => '你的 Astraea 自我';

  @override
  String get characterAttributes => '角色能力';

  @override
  String get trainingGrowsBuild => '訓練會逐步塑造你選擇的 Build。';

  @override
  String get attributesSection => '能力值';

  @override
  String trainedDelta(int amount) {
    return '+$amount 訓練成長';
  }

  @override
  String get viewTraining => '查看訓練';

  @override
  String get chooseStartingAttributesWeapon => '選擇初始能力與武器後即可開始。';

  @override
  String get createCharacter => '建立角色';

  @override
  String get couldNotLoadCharacter => '無法載入角色。';

  @override
  String get training => '訓練';

  @override
  String get chooseTraining => '選擇訓練';

  @override
  String get trainingDescription => 'Life Quest 的獎勵會成為成長潛能。選擇對應訓練，將它轉化為永久角色成長。';

  @override
  String get physicalPotential => '體能潛能';

  @override
  String get cognitivePotential => '認知潛能';

  @override
  String get communicationPotential => '溝通潛能';

  @override
  String get potentialBuilding => '潛能正在累積，逐步接近下一次訓練';

  @override
  String get potentialBuildingDescription =>
      '新角色從 0 點成長潛能開始。第一個 Life Quest 會依內容提供對應分類的獎勵；當該分類足以支付訓練成本時才會解鎖。';

  @override
  String trainingPotentialProgress(
    String category,
    int available,
    int cost,
    String attribute,
  ) {
    return '$category：$available / $cost · $attribute';
  }

  @override
  String get chooseAnotherLifeQuest => '選擇另一個 Life Quest';

  @override
  String get availableDrills => '可用訓練';

  @override
  String get analysisGrowthActive => 'Analysis 成長已生效';

  @override
  String permanentAnalysisGrowth(int amount) {
    return '訓練已永久增加 $amount 點 Analysis';
  }

  @override
  String get keepJourneyMoving => '繼續你的旅程';

  @override
  String get trainingPermanentDescription =>
      '訓練會永久改變角色。確認更新後的 Build，再回到學院繼續前進。';

  @override
  String get viewCharacter => '查看角色';

  @override
  String get continueAdventure => '繼續冒險';

  @override
  String get tryAnalysisAshfang => '對 Ashfang 嘗試 Analysis';

  @override
  String get trainingComplete => '訓練完成。你的能力已永久成長。';

  @override
  String trainingPotentialToAttribute(String category, String attribute) {
    return '$category潛能 → $attribute';
  }

  @override
  String trainingAttributeChange(String attribute, int before, int after) {
    return '$attribute $before → $after';
  }

  @override
  String aptitudeCost(int aptitude, int cost, String category) {
    return 'Aptitude $aptitude/6 · 消耗 $cost $category潛能';
  }

  @override
  String get trainingInProgress => '訓練中…';

  @override
  String trainAttribute(String attribute) {
    return '訓練 $attribute';
  }

  @override
  String needMorePotential(int amount, String category) {
    return '還需要 $amount 點$category潛能';
  }

  @override
  String get trainingReactionDrill => 'Reaction 訓練';

  @override
  String get trainingPrecisionMovement => '精準移動訓練';

  @override
  String get trainingFunctionAnalysisDrill => 'Function Analysis 訓練';

  @override
  String get trainingComplexityExercise => '複雜度訓練';

  @override
  String get trainingManaControlDrill => 'Mana 控制訓練';

  @override
  String get trainingIntentEncodingDrill => '意圖編碼訓練';

  @override
  String get trainingReactionFocus => 'Build 重點：時間軸、Reaction 與快速戰鬥判斷。';

  @override
  String get trainingPrecisionFocus => 'Build 重點：目標、Interrupt 與精準控制。';

  @override
  String get trainingAnalysisFocus => 'Build 重點：揭露敵方 Function 的 Weak Node。';

  @override
  String get trainingComplexityFocus => 'Build 重點：複雜 Function 與 Counter 推理。';

  @override
  String get trainingManaControlFocus => 'Build 重點：Mana 使用與資源效率。';

  @override
  String get trainingIntentEncodingFocus => 'Build 重點：安全輸出與爆發術式容量。';

  @override
  String get adventure => '冒險';

  @override
  String get startAshfangBattle => '開始 Ashfang 訓練戰';

  @override
  String get couldNotLoadChapterRetry => '無法載入章節 · 重試';

  @override
  String get chapter01 => '第一章';

  @override
  String get firstStepsAcademy => '踏入 Astraea Academy 的第一步。';

  @override
  String get storyPath => '故事路徑';

  @override
  String get chapterOneComplete => '第一章完成';

  @override
  String get nextPracticeFunction => '接下來練習讀取敵方 Function，並找出可能的 Weak Node。';

  @override
  String get practiceFunctionAnalysis => '練習 Function Analysis';

  @override
  String get returnHome => '返回首頁';

  @override
  String get tryFunctionAnalysisTutorial => '嘗試 Function Analysis 教學';

  @override
  String get currentObjective => '目前目標';

  @override
  String chapterProgress(int completed, int total) {
    return '章節進度 · 已完成 $completed / $total 個場景';
  }

  @override
  String get sceneAcademyArrival => '抵達學院';

  @override
  String get sceneAptitudeAssessment => '適性評估';

  @override
  String get sceneFunctionTheory => 'Function 理論';

  @override
  String get sceneChantAndChantless => '詠唱與無詠唱';

  @override
  String get scenePreparedDeck => 'Prepared Deck';

  @override
  String get scene1Title => 'Astraea Academy';

  @override
  String get scene2Title => '適性評估';

  @override
  String get scene3Title => 'Function 理論';

  @override
  String get scene4Title => 'Full Chant 與 Chantless';

  @override
  String get scene5Title => 'Spell Card 與 Prepared Deck';

  @override
  String get scene1Beat1 => '星環中央魔導學院。集魔法教育、研究與異形應對人才培育於一身，是世界上最重要的魔導學府之一。';

  @override
  String get scene1Beat2 => '……終於。真的考上了。';

  @override
  String get scene1Beat3 => '從那一天開始，我就一直想來這裡。總有一天……我也想成為能夠用魔法保護別人的人。先去報到吧。';

  @override
  String get scene1Beat4 => '目標：新生報到 · 前往學院正門與佐伯悠真交談。';

  @override
  String get scene2Beat1 => '建立你的 Astraea 自我：配置八項能力，選擇初始武器。';

  @override
  String get scene2Beat2 => '每項能力 Base 8；配置 32 點；初始值上限 15。';

  @override
  String get scene2Beat3 => 'Life Progress 表示投入歷史，不等同於現實能力評級。';

  @override
  String get scene3Beat1 =>
      'Magic is not a wish. Magic is a method of transforming World State A into B.';

  @override
  String get scene3Beat2 => 'f(S0)=S1';

  @override
  String get scene3Beat3 =>
      'Function Graph：Gather(Energy) → Shape(Bolt) → Move(Target)。點選節點查看其在術式序列中的作用。';

  @override
  String get scene4Beat1 => 'Full Chant: Human → Chant → Magic System';

  @override
  String get scene4Beat2 => 'Chantless: Human → Mental Encoding → Magic System';

  @override
  String get scene4Beat3 => 'Chantless 並非省略處理；編碼由施術者內化。';

  @override
  String get scene5Beat1 =>
      'Function Graph → Encode → Spell Card → Prepared Deck → Cast';

  @override
  String get scene5Beat2 =>
      'Spell Card 保存已構築的術式 request structure；Prepared Deck 是預先載入的術式，不是隨機抽牌。';

  @override
  String get scene5Beat3 => '選擇六張術式卡加入 Prepared Deck。';

  @override
  String get preparedDeck => 'Prepared Deck';

  @override
  String get couldNotLoadDeckRetry => '無法載入牌組 · 重試';

  @override
  String get spellCards => 'Spell Card';

  @override
  String get buildPreparedDeck => '建立 Prepared Deck';

  @override
  String get yourPreparedDeck => '你的 Prepared Deck';

  @override
  String get chooseSixFunctions => '選擇六個可直接施放的 Function，組成你的戰鬥 Build。';

  @override
  String get noDeckPrepared => '尚未準備牌組';

  @override
  String preparedCount(int selected) {
    return '已準備 $selected / 6';
  }

  @override
  String cardsCount(int count) {
    return '共 $count 張';
  }

  @override
  String get readySection => '已準備';

  @override
  String get cardLibrary => '術式庫';

  @override
  String get continueDeckSetup => '繼續設定牌組';

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
  String get roleAttack => '攻擊';

  @override
  String get roleDefense => '防禦';

  @override
  String get roleMobility => '位移';

  @override
  String get roleAnalysis => '分析';

  @override
  String get roleSupport => '支援';

  @override
  String get roleCounter => '反制';

  @override
  String couldNotLoadStory(String error) {
    return '無法載入故事：$error';
  }

  @override
  String get academyStory => '學院故事';

  @override
  String get preparedDeckSavedNext =>
      'Prepared Deck 已儲存。接下來練習讀取敵方 Function，並找出 Weak Node。';

  @override
  String get returnToAdventure => '返回冒險';

  @override
  String preparedDeckCount(int selected) {
    return 'Prepared Deck：$selected / 6';
  }

  @override
  String get functionGraph => 'Function Graph';

  @override
  String get tapStepRole => '點選步驟查看它在術式中的作用。';

  @override
  String get quickCheck => '快速確認：哪一個步驟負責把已形成的效果導向目標？';

  @override
  String get fullChantSlowerStable => 'Full Chant 較慢，但更加穩定。';

  @override
  String get chantlessFasterInternal => 'Chantless 更快，但需要施術者內化編碼。';

  @override
  String get bothPerformProcessing => '兩種方式都會執行完整的 Function 處理。';

  @override
  String couldNotLoadFunction(String error) {
    return '無法載入 Function：$error';
  }

  @override
  String get functionAnalysis => 'Function Analysis';

  @override
  String get ashfangTrainingConstruct => 'Ashfang Training Construct';

  @override
  String get enemyFunctionPath =>
      '敵方 Function：DetectTarget → LockTarget → Pounce';

  @override
  String characterAnalysisModifier(int analysis, int modifier) {
    return '角色 Analysis：$analysis → Function 分析修正 +$modifier';
  }

  @override
  String get analyzeActiveFunction => '分析目前 Function';

  @override
  String get interruptLockTarget => 'Interrupt LockTarget';

  @override
  String get observeNextFunctionNode => '觀察下一個 Function 節點';

  @override
  String get resetTutorialPattern => '重設教學模式';

  @override
  String contentBalance(String status) {
    return '內容平衡狀態：$status';
  }

  @override
  String get nodeStateCancelled => '已由 Weak Node Interrupt 取消';

  @override
  String get nodeStateWeak => 'Weak Node 已揭露 · 可 Interrupt';

  @override
  String get nodeStateActive => 'Function 執行中';

  @override
  String get nodeStateAwaiting => '等待執行';

  @override
  String get feedbackPreparingPounce =>
      'Ashfang 正在準備 Pounce。先觀察 Function，再讓它完成。';

  @override
  String get feedbackPreparingAgain => 'Ashfang 再次準備 Pounce。';

  @override
  String get feedbackLockActive => 'LockTarget 已啟動。它可以被 Interrupt，但你尚未分析它的作用。';

  @override
  String get feedbackWeakFound =>
      '找到 Weak Node：Interrupt LockTarget 會取消後續 Pounce。';

  @override
  String get feedbackAnalysisMiss => '這次 Analysis 沒有揭露節點，再試一次。';

  @override
  String get feedbackInterrupted => 'LockTarget 已被 Interrupt。Pounce 取消。';

  @override
  String get feedbackInterruptFailed => '這個 Function 無法被 Interrupt。';

  @override
  String get functionNodeDetectTarget => '偵測目標';

  @override
  String get functionNodeLockTarget => '鎖定目標';

  @override
  String get functionNodePounce => '撲擊';

  @override
  String get ashfangEncounter => 'Ashfang 遭遇戰';

  @override
  String battleUnavailable(String error) {
    return '戰鬥無法使用：$error';
  }

  @override
  String get prototypeEncounterInputs => 'Prototype 遭遇戰輸入';

  @override
  String battleRoundStatus(int round, String status) {
    return 'Round $round · $status';
  }

  @override
  String get weakNodeRevealed => 'Weak Node 已揭露：LockTarget';

  @override
  String get weakNodeCancelsPounce => 'Interrupt 這個節點會取消後續 Pounce。';

  @override
  String get trainingEncounterComplete => '訓練戰完成';

  @override
  String get trainingAnalysisSaved =>
      '你訓練後的 Analysis 影響了 Weak Node 互動，戰鬥狀態已儲存。';

  @override
  String get encounterEnded => '遭遇戰結束';

  @override
  String get ashfangOverwhelmed => 'Ashfang 擊敗了你的角色，此結果已儲存。';

  @override
  String get attackAshfang => '攻擊 Ashfang';

  @override
  String get endTurn => '結束行動';

  @override
  String get analyzeWeakNode => '分析 Weak Node';

  @override
  String get resolvePounce => '執行 Pounce';

  @override
  String unitHpDetail(String detail, int hp, int maxHp) {
    return '$detail · HP $hp / $maxHp';
  }

  @override
  String questMetaShort(String domain, int minutes) {
    return '$domain · $minutes 分鐘';
  }

  @override
  String get couldNotLoadTraining => '無法載入訓練資料，請稍後再試。';

  @override
  String get confirmPreparedDeck => '確認 Prepared Deck';

  @override
  String get graphGather => 'Gather';

  @override
  String get graphShape => 'Shape';

  @override
  String get graphMove => 'Move';

  @override
  String get graphGatherDescription => '收集這個 Function 執行時所需的能量。';

  @override
  String get graphShapeDescription => '把能量塑形成預定效果，例如能量彈。';

  @override
  String get graphMoveDescription => '把已形成的效果導向目標。';

  @override
  String get graphGatherSummary => '收集能量';

  @override
  String get graphShapeSummary => '形成能量彈';

  @override
  String get graphMoveSummary => '導向結果';

  @override
  String graphNodeSummary(String name, String summary) {
    return '$name · $summary';
  }

  @override
  String get graphCorrectMove => '正確——Move 會把效果導向目標。';

  @override
  String get graphWrongMove => '還不對。負責把效果導向目標的是 Move。';

  @override
  String functionNodeSemantics(String node, String state) {
    return '$node，$state';
  }

  @override
  String get balanceAwaitingPlaytest => '示意數值 · 等待實際測試';

  @override
  String contentVersionStatus(String version, String status) {
    return '$version · $status';
  }

  @override
  String get battleHeroName => 'Astraea 主角';

  @override
  String analysisModifierLabel(int modifier) {
    return 'Analysis 修正 +$modifier';
  }

  @override
  String get functionPathLabel => 'Function：DetectTarget → LockTarget → Pounce';

  @override
  String get battleOutcomeActive => '進行中';

  @override
  String get battleOutcomeVictory => '勝利';

  @override
  String get battleOutcomeDefeat => '失敗';

  @override
  String get feedbackGuarding => 'Ashfang 正守著訓練場。';

  @override
  String get feedbackAshfangDefeated => 'Ashfang 已被擊敗。Weak Node 改變了這場戰鬥。';

  @override
  String get feedbackAttackResolved => '攻擊已由戰鬥引擎解析。';

  @override
  String get feedbackEnemyFunctionBegins =>
      'Ashfang 開始執行 DetectTarget → LockTarget → Pounce。';

  @override
  String get feedbackWeakNodeFoundLegacy =>
      '找到 Weak Node。Interrupt LockTarget 即可取消 Pounce。';

  @override
  String get feedbackWeakNodeMissLegacy =>
      '這次沒有揭露 Weak Node，Ashfang 將執行 Pounce。';

  @override
  String get feedbackInterruptedLegacy =>
      'LockTarget 已被 Interrupt，後續 Pounce 已取消。';

  @override
  String get feedbackPounceResolved => 'Pounce 已由戰鬥引擎解析。';

  @override
  String get combatRotateDevice => '請將裝置旋轉為橫向以進行戰鬥。';

  @override
  String get combatActionTimeline => '行動時間軸';

  @override
  String get combatEnemyIntent => '敵方意圖';

  @override
  String get combatCurrentActor => '目前角色';

  @override
  String get combatHero => '主角';

  @override
  String get combatRio => 'Rio';

  @override
  String get combatYuma => 'Yuma';

  @override
  String get combatAshfang => 'Ashfang';

  @override
  String get combatReactionReady => 'Reaction 可用';

  @override
  String get combatReactionSpent => 'Reaction 已使用';

  @override
  String get combatAttack => '攻擊';

  @override
  String get combatTechnique => '戰技';

  @override
  String get combatSc => 'SC';

  @override
  String get combatAnalyze => '分析';

  @override
  String get combatGuard => '防禦';

  @override
  String get combatMove => '移動';

  @override
  String get combatFireballI => 'Fireball I';

  @override
  String get combatFireballII => 'Fireball II';

  @override
  String get combatKnownFireball => 'Fireball I';

  @override
  String get combatModifiedFireball => '改造 Fireball';

  @override
  String get combatFullChant => 'Full Chant';

  @override
  String get combatChantless => 'Chantless';

  @override
  String get combatUnknownFunction => '未知 Function';

  @override
  String get combatTargetHero => '目標：主角';

  @override
  String combatTimelineTurn(String name) {
    return '$name 行動';
  }

  @override
  String combatTimelineResolve(String spell) {
    return '$spell 解析';
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
  String get combatTutorialChantlessTitle => '先從 Prepared Spell 開始';

  @override
  String get combatTutorialChantlessBody =>
      '使用 Chantless 施放 Fireball I，Function 會立即解析。';

  @override
  String get combatCastFireballI => '施放 Fireball I';

  @override
  String get combatKnownReactionTitle => 'REACTION';

  @override
  String get combatKnownReactionBody =>
      'Ashfang 正在構築 Fireball I。Rio 可以在 Function 成立前 Interrupt。';

  @override
  String get combatInterrupt => 'Interrupt';

  @override
  String get combatSaveReaction => '保留 Reaction';

  @override
  String get combatModifiedAnalysisTitle => '偵測到未知改造';

  @override
  String get combatModifiedAnalysisBody =>
      '使用 Analysis 找出這個 Function 真正可利用的結構資訊。';

  @override
  String get combatAnalyzeModified => '分析改造 Function';

  @override
  String get combatModifiedReactionTitle => 'Weak Node 已揭露';

  @override
  String get combatModifiedReactionBody =>
      'Analysis 找到脆弱的 Stabilization 相依節點，Rio 可以利用它。';

  @override
  String get combatWeakNodeStabilization => 'Weak Node：Stabilization';

  @override
  String get combatStabilityUnknown => 'Stability ?';

  @override
  String combatStabilityValue(int value) {
    return 'Stability $value';
  }

  @override
  String get combatFunctionStructure => 'FUNCTION 結構';

  @override
  String get combatStructureUnknown => '內部相依關係尚未揭露。';

  @override
  String get combatStructureRevealed => 'Stabilization 存在可利用的結構弱點。';

  @override
  String get combatBeginFullChant => '開始 Fireball II · Full Chant';

  @override
  String get combatFullChantTitle => '投入 Full Chant';

  @override
  String get combatFullChantBody => 'Fireball II 會進入 Timeline，完成構築後才解析。';

  @override
  String get combatFinisherTitle => '低 Tier 仍然有價值';

  @override
  String get combatFinisherBody => '以較低消耗的 Fireball I Chantless 完成戰鬥。';

  @override
  String get combatFinishFireballI => '以 Fireball I 收尾';

  @override
  String get combatVictoryTitle => '訓練戰完成';

  @override
  String get combatVictoryBody =>
      '你已透過真正的 CTB engine 使用 Chantless、Interrupt、Analysis、Weak Node 與 Full Chant。';

  @override
  String get combatRestart => '重新訓練';

  @override
  String get combatReturnAdventure => '返回冒險';

  @override
  String get combatIntentHeroTurn => '閱讀戰場並選擇行動。';

  @override
  String get combatIntentKnownFireball => 'Fireball I · Full Chant';

  @override
  String get combatIntentModifiedFireball => '改造 Fireball · Full Chant';

  @override
  String get combatIntentHeroFullChant => 'Ashfang 正在恢復。主角可以投入 Full Chant。';

  @override
  String get combatIntentFinisher => 'Ashfang 已接近被擊敗。';

  @override
  String get combatIntentVictory => '訓練目標完成。';

  @override
  String get combatFeedbackOpening =>
      'Prepared SC 是可直接使用的戰鬥選項。先從 Fireball I 開始。';

  @override
  String get combatFeedbackHeroChantless => 'Fireball I 透過 Chantless 立即解析。';

  @override
  String get combatFeedbackKnownCasting =>
      'Ashfang 開始已知的 Full Chant，Interrupt window 已開啟。';

  @override
  String get combatFeedbackKnownInterrupted =>
      'Rio 在 Function 成立前破壞了尚未完成的 Fireball。';

  @override
  String get combatFeedbackKnownResolved =>
      '你保留了 Reaction。Fireball I 成功解析並傷害主角。';

  @override
  String get combatFeedbackModifiedCasting => 'Ashfang 改造了 Function，內部結構目前未知。';

  @override
  String get combatFeedbackAnalysisWeakNode =>
      'Analysis 揭露了 Stability 與真正的 Stabilization Weak Node。';

  @override
  String get combatFeedbackModifiedInterrupted =>
      'Weak Node bonus 提高了 Interrupt Power，成功破壞 Function。';

  @override
  String get combatFeedbackModifiedResolved => '改造 Function 被允許完成解析。';

  @override
  String get combatFeedbackHeroFullChantCasting => '主角支付 Mana 並進入 Full Chant。';

  @override
  String get combatFeedbackHeroFullChantResolved =>
      'Fireball II 成功解析，Ashfang 已奄奄一息。';

  @override
  String get combatFeedbackVictory => 'Ashfang 已被擊敗，教學目標完成。';

  @override
  String get combatFeedbackDefeat => '隊伍戰敗。';

  @override
  String get combatZoneMid => 'MID';

  @override
  String get combatTrainingArena => 'ASTRAEA 訓練場';

  @override
  String get combatFullChantCastingTitle => 'Full Chant 正在構築';

  @override
  String get combatFullChantCastingBody =>
      'Fireball II 已成為 Timeline 上等待解析的 Resolve event。術式完成前，Ashfang 仍有機會行動。';

  @override
  String get combatAdvanceTimeline => '推進至 Resolve';

  @override
  String get combatDefeatTitle => '訓練失敗';

  @override
  String get combatDefeatBody => '隊伍已戰敗。重新開始訓練，嘗試不同的決策。';

  @override
  String get combatHoldFormation => '維持陣形';

  @override
  String get combatNodeCompression => '壓縮';

  @override
  String get combatNodeStabilization => '穩定';

  @override
  String get combatNodeTrajectory => '軌跡';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'Astraea';

  @override
  String get navHome => '首頁';

  @override
  String get navLife => '生活';

  @override
  String get navAdventure => '冒險';

  @override
  String get navDeck => '牌組';

  @override
  String get navCharacter => '角色';

  @override
  String get commonRetry => '重試';

  @override
  String get commonContinue => '繼續';

  @override
  String get commonBack => '返回';

  @override
  String get commonCancel => '取消';

  @override
  String get commonStart => '開始';

  @override
  String get commonFinish => '完成';

  @override
  String get commonPause => '暫停';

  @override
  String get commonResume => '繼續';

  @override
  String get commonEnable => '啟用';

  @override
  String get commonTurnOff => '關閉';

  @override
  String get splashTagline => '讓現實的努力，成為改變世界的魔法。';

  @override
  String get tapToStart => '點擊開始';

  @override
  String get welcomeToAstraea => '歡迎來到 Astraea';

  @override
  String get onboardingHeadline => '你每天投入的努力，都能塑造在 Astraea 中的自己。';

  @override
  String get onboardingBody => '現實生活與學院彼此相連，但要做什麼始終由你決定。';

  @override
  String get enterAstraea => '進入 Astraea';

  @override
  String get noStreakPenalty => '沒有連續打卡懲罰。你休息時，進度會等你回來。';

  @override
  String get chooseLifeQuest => '選擇 Life Quest';

  @override
  String get earnGrowthPotential => '獲得成長潛能';

  @override
  String get buildRpgSelf => '打造你的 RPG 角色';

  @override
  String get chooseLifeQuestDescription => '在適合今天的時候，選一件真實世界中的行動。';

  @override
  String get earnGrowthPotentialDescription => '你的行動會轉化為遊戲內的成長機會。';

  @override
  String get buildRpgSelfDescription => '訓練、準備術式牌組，並探索學院。';

  @override
  String get homeBrandSubtitle => '生活 × RPG';

  @override
  String get homeHeroEyebrow => 'Astraea Academy · 第一章';

  @override
  String get homeHeroTitle => '一個真實行動，就能讓旅程開始。';

  @override
  String get homeHeroDescription => '選擇 Life Quest、獲得成長潛能，塑造探索 Astraea 的你。';

  @override
  String get yourJourney => '你的旅程';

  @override
  String get continueYourJourney => '繼續旅程';

  @override
  String get journeyLifeQuests => 'Life Quest';

  @override
  String get journeyLifeQuestsSubtitle => '從一個真實行動開始';

  @override
  String get journeyAdventure => '冒險';

  @override
  String get journeyAdventureSubtitle => '故事與目標';

  @override
  String get journeyCharacter => '角色';

  @override
  String get journeyCharacterSubtitle => '正在成長的 Build';

  @override
  String get journeyPreparedDeck => 'Prepared Deck';

  @override
  String get journeyPreparedDeckSubtitle => '六張準備術式';

  @override
  String get today => '今天';

  @override
  String get allQuests => '全部任務';

  @override
  String get lifeQuestsUnavailable => '目前無法載入 Life Quest。';

  @override
  String get quietDayTitle => '今天安靜一點也沒關係。';

  @override
  String get quietDaySubtitle => '適合的時候再選一個 Life Quest。';

  @override
  String get growthPotentialReady => '已有可用的成長潛能';

  @override
  String get characterProfileTooltip => '角色資料';

  @override
  String get optionalPilotMeasurement => '選用的試玩測量';

  @override
  String get pilotOnLocalOnly => '開啟 · 僅本機';

  @override
  String get pilotOffDefault => '關閉 · 預設';

  @override
  String get pilotTurnOffTitle => '關閉試玩測量？';

  @override
  String get pilotEnableTitle => '啟用私密試玩測量？';

  @override
  String get pilotTurnOffBody => '關閉後會刪除儲存在本機的里程碑事件。';

  @override
  String get pilotEnableBody =>
      '這只會在本機儲存少量遊戲里程碑，不會收集姓名、筆記、證據、健康資料或自訂任務文字，也不會上傳。你可以隨時關閉並刪除這些事件。';

  @override
  String potentialChooseHowToTrain(int amount) {
    return '$amount 點潛能 · 選擇訓練方式';
  }

  @override
  String get lifeQuest => 'Life Quest';

  @override
  String couldNotLoadQuests(String error) {
    return '無法載入任務：$error';
  }

  @override
  String get chooseWhatFitsYourDay => '選擇今天適合你的行動。';

  @override
  String get progressAlwaysHere => '你的進度一直都在，也沒有連續打卡懲罰。';

  @override
  String availableQuestCount(int count) {
    return '目前有 $count 個可用任務';
  }

  @override
  String get domainAll => '全部';

  @override
  String get domainFitness => '健身';

  @override
  String get domainLearning => '學習';

  @override
  String get domainLanguages => '語言';

  @override
  String get domainLife => '生活';

  @override
  String get noQuestsCategory => '這個分類目前還沒有任務。';

  @override
  String get addWhenReady => '準備好的時候再新增即可。';

  @override
  String get addLifeQuest => '新增 Life Quest';

  @override
  String minutesShort(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get questDetails => '任務詳情';

  @override
  String couldNotLoadQuest(String error) {
    return '無法載入任務：$error';
  }

  @override
  String get questNotFound => '找不到這個任務';

  @override
  String questAboutMinutes(String domain, int minutes) {
    return '$domain · 約 $minutes 分鐘';
  }

  @override
  String get selfReportTimerEvidence => '你可以直接自行回報；使用計時器則會留下輕量證據。';

  @override
  String get startTimer => '開始計時';

  @override
  String get completeSelfReport => '自行回報完成';

  @override
  String get questComplete => '任務完成';

  @override
  String lifeXpReward(int amount, String domain) {
    return '+$amount $domain Life XP';
  }

  @override
  String potentialReward(int amount, String category) {
    return '+$amount $category 潛能';
  }

  @override
  String get timerEvidenceBonus => '計時器證據 · 已包含加成';

  @override
  String get selfReportPrivate => '自行回報 · 私密';

  @override
  String get confirmReward => '確認獎勵';

  @override
  String get questTimer => '任務計時器';

  @override
  String get timerRunsAway => '離開畫面後計時仍會繼續。';

  @override
  String get potentialPhysical => '體能';

  @override
  String get potentialCognitive => '認知';

  @override
  String get potentialCommunication => '溝通';

  @override
  String get potentialGrowth => '成長';

  @override
  String get questFitnessWalk10 => '步行 10 分鐘';

  @override
  String get questFitnessExercise20 => '運動 20 分鐘';

  @override
  String get questLearningRead20 => '閱讀 20 分鐘';

  @override
  String get questLearningStudy20 => '學習 20 分鐘';

  @override
  String get questLanguagesPractice15 => '語言練習 15 分鐘';

  @override
  String get createAstraeaSelf => '建立你的 Astraea 自我';

  @override
  String get saving => '儲存中…';

  @override
  String get characterName => '角色名稱';

  @override
  String get distributePoints => '配置 32 點 · 基礎 8 · 上限 15';

  @override
  String get characterBuildFocusDescription =>
      '選擇角色的 Build 方向。這些能力值會影響戰鬥選項，但任何選擇都不會封鎖主線故事。';

  @override
  String pointsSpent(int spent, int budget) {
    return '$spent / $budget 點';
  }

  @override
  String attributeAllocationSummary(
    int base,
    int allocated,
    int starting,
    String effect,
  ) {
    return '基礎 $base + 配置 $allocated = 初始 $starting\n$effect';
  }

  @override
  String get initialWeapon => '初始武器';

  @override
  String get weaponAstraeaLongsword => 'Astraea 長劍';

  @override
  String get weaponStandardSpear => '標準長槍';

  @override
  String get weaponTrainingArcaneGun => '訓練用奧術槍';

  @override
  String get weaponStandardStaff => '標準法杖';

  @override
  String get attributeManaCapacity => 'Mana 容量';

  @override
  String get attributeManaOutput => 'Mana 輸出';

  @override
  String get attributeComputation => '運算';

  @override
  String get attributeProcessing => '處理速度';

  @override
  String get attributePrecision => '精準';

  @override
  String get attributeEfficiency => '效率';

  @override
  String get attributeAmbientSync => '環境同步';

  @override
  String get attributeAnalysis => '分析';

  @override
  String get attributeManaCapacityEffect => '重點：Mana 上限與高消耗術式續航';

  @override
  String get attributeManaOutputEffect => '重點：安全輸出與爆發術式規模';

  @override
  String get attributeComputationEffect => '重點：複雜 Function 與 Counter 推理';

  @override
  String get attributeProcessingEffect => '重點：時間軸、Reaction 與快速行動';

  @override
  String get attributePrecisionEffect => '重點：目標控制、Interrupt 與精準操作';

  @override
  String get attributeEfficiencyEffect => '重點：Mana 使用與資源效率';

  @override
  String get attributeAmbientSyncEffect => '重點：環境與支援魔法';

  @override
  String get attributeAnalysisEffect => '重點：揭露敵方 Weak Node 與 Counter 路徑';

  @override
  String get character => '角色';

  @override
  String get yourAstraeaSelf => '你的 Astraea 自我';

  @override
  String get characterAttributes => '角色能力';

  @override
  String get trainingGrowsBuild => '訓練會逐步塑造你選擇的 Build。';

  @override
  String get attributesSection => '能力值';

  @override
  String trainedDelta(int amount) {
    return '+$amount 訓練成長';
  }

  @override
  String get viewTraining => '查看訓練';

  @override
  String get chooseStartingAttributesWeapon => '選擇初始能力與武器後即可開始。';

  @override
  String get createCharacter => '建立角色';

  @override
  String get couldNotLoadCharacter => '無法載入角色。';

  @override
  String get training => '訓練';

  @override
  String get chooseTraining => '選擇訓練';

  @override
  String get trainingDescription => 'Life Quest 的獎勵會成為成長潛能。選擇對應訓練，將它轉化為永久角色成長。';

  @override
  String get physicalPotential => '體能潛能';

  @override
  String get cognitivePotential => '認知潛能';

  @override
  String get communicationPotential => '溝通潛能';

  @override
  String get potentialBuilding => '潛能正在累積，逐步接近下一次訓練';

  @override
  String get potentialBuildingDescription =>
      '新角色從 0 點成長潛能開始。第一個 Life Quest 會依內容提供對應分類的獎勵；當該分類足以支付訓練成本時才會解鎖。';

  @override
  String trainingPotentialProgress(
    String category,
    int available,
    int cost,
    String attribute,
  ) {
    return '$category：$available / $cost · $attribute';
  }

  @override
  String get chooseAnotherLifeQuest => '選擇另一個 Life Quest';

  @override
  String get availableDrills => '可用訓練';

  @override
  String get analysisGrowthActive => 'Analysis 成長已生效';

  @override
  String permanentAnalysisGrowth(int amount) {
    return '訓練已永久增加 $amount 點 Analysis';
  }

  @override
  String get keepJourneyMoving => '繼續你的旅程';

  @override
  String get trainingPermanentDescription =>
      '訓練會永久改變角色。確認更新後的 Build，再回到學院繼續前進。';

  @override
  String get viewCharacter => '查看角色';

  @override
  String get continueAdventure => '繼續冒險';

  @override
  String get tryAnalysisAshfang => '對 Ashfang 嘗試 Analysis';

  @override
  String get trainingComplete => '訓練完成。你的能力已永久成長。';

  @override
  String trainingPotentialToAttribute(String category, String attribute) {
    return '$category潛能 → $attribute';
  }

  @override
  String trainingAttributeChange(String attribute, int before, int after) {
    return '$attribute $before → $after';
  }

  @override
  String aptitudeCost(int aptitude, int cost, String category) {
    return 'Aptitude $aptitude/6 · 消耗 $cost $category潛能';
  }

  @override
  String get trainingInProgress => '訓練中…';

  @override
  String trainAttribute(String attribute) {
    return '訓練 $attribute';
  }

  @override
  String needMorePotential(int amount, String category) {
    return '還需要 $amount 點$category潛能';
  }

  @override
  String get trainingReactionDrill => 'Reaction 訓練';

  @override
  String get trainingPrecisionMovement => '精準移動訓練';

  @override
  String get trainingFunctionAnalysisDrill => 'Function Analysis 訓練';

  @override
  String get trainingComplexityExercise => '複雜度訓練';

  @override
  String get trainingManaControlDrill => 'Mana 控制訓練';

  @override
  String get trainingIntentEncodingDrill => '意圖編碼訓練';

  @override
  String get trainingReactionFocus => 'Build 重點：時間軸、Reaction 與快速戰鬥判斷。';

  @override
  String get trainingPrecisionFocus => 'Build 重點：目標、Interrupt 與精準控制。';

  @override
  String get trainingAnalysisFocus => 'Build 重點：揭露敵方 Function 的 Weak Node。';

  @override
  String get trainingComplexityFocus => 'Build 重點：複雜 Function 與 Counter 推理。';

  @override
  String get trainingManaControlFocus => 'Build 重點：Mana 使用與資源效率。';

  @override
  String get trainingIntentEncodingFocus => 'Build 重點：安全輸出與爆發術式容量。';

  @override
  String get adventure => '冒險';

  @override
  String get startAshfangBattle => '開始 Ashfang 訓練戰';

  @override
  String get couldNotLoadChapterRetry => '無法載入章節 · 重試';

  @override
  String get chapter01 => '第一章';

  @override
  String get firstStepsAcademy => '踏入 Astraea Academy 的第一步。';

  @override
  String get storyPath => '故事路徑';

  @override
  String get chapterOneComplete => '第一章完成';

  @override
  String get nextPracticeFunction => '接下來練習讀取敵方 Function，並找出可能的 Weak Node。';

  @override
  String get practiceFunctionAnalysis => '練習 Function Analysis';

  @override
  String get returnHome => '返回首頁';

  @override
  String get tryFunctionAnalysisTutorial => '嘗試 Function Analysis 教學';

  @override
  String get currentObjective => '目前目標';

  @override
  String chapterProgress(int completed, int total) {
    return '章節進度 · 已完成 $completed / $total 個場景';
  }

  @override
  String get sceneAcademyArrival => '抵達學院';

  @override
  String get sceneAptitudeAssessment => '適性評估';

  @override
  String get sceneFunctionTheory => 'Function 理論';

  @override
  String get sceneChantAndChantless => '詠唱與無詠唱';

  @override
  String get scenePreparedDeck => 'Prepared Deck';

  @override
  String get scene1Title => 'Astraea Academy';

  @override
  String get scene2Title => '適性評估';

  @override
  String get scene3Title => 'Function 理論';

  @override
  String get scene4Title => 'Full Chant 與 Chantless';

  @override
  String get scene5Title => 'Spell Card 與 Prepared Deck';

  @override
  String get scene1Beat1 => '星環中央魔導學院。集魔法教育、研究與異形應對人才培育於一身，是世界上最重要的魔導學府之一。';

  @override
  String get scene1Beat2 => '……終於。真的考上了。';

  @override
  String get scene1Beat3 => '從那一天開始，我就一直想來這裡。總有一天……我也想成為能夠用魔法保護別人的人。先去報到吧。';

  @override
  String get scene1Beat4 => '目標：新生報到 · 前往學院正門與佐伯悠真交談。';

  @override
  String get scene2Beat1 => '建立你的 Astraea 自我：配置八項能力，選擇初始武器。';

  @override
  String get scene2Beat2 => '每項能力 Base 8；配置 32 點；初始值上限 15。';

  @override
  String get scene2Beat3 => 'Life Progress 表示投入歷史，不等同於現實能力評級。';

  @override
  String get scene3Beat1 =>
      'Magic is not a wish. Magic is a method of transforming World State A into B.';

  @override
  String get scene3Beat2 => 'f(S0)=S1';

  @override
  String get scene3Beat3 =>
      'Function Graph：Gather(Energy) → Shape(Bolt) → Move(Target)。點選節點查看其在術式序列中的作用。';

  @override
  String get scene4Beat1 => 'Full Chant: Human → Chant → Magic System';

  @override
  String get scene4Beat2 => 'Chantless: Human → Mental Encoding → Magic System';

  @override
  String get scene4Beat3 => 'Chantless 並非省略處理；編碼由施術者內化。';

  @override
  String get scene5Beat1 =>
      'Function Graph → Encode → Spell Card → Prepared Deck → Cast';

  @override
  String get scene5Beat2 =>
      'Spell Card 保存已構築的術式 request structure；Prepared Deck 是預先載入的術式，不是隨機抽牌。';

  @override
  String get scene5Beat3 => '選擇六張術式卡加入 Prepared Deck。';

  @override
  String get preparedDeck => 'Prepared Deck';

  @override
  String get couldNotLoadDeckRetry => '無法載入牌組 · 重試';

  @override
  String get spellCards => 'Spell Card';

  @override
  String get buildPreparedDeck => '建立 Prepared Deck';

  @override
  String get yourPreparedDeck => '你的 Prepared Deck';

  @override
  String get chooseSixFunctions => '選擇六個可直接施放的 Function，組成你的戰鬥 Build。';

  @override
  String get noDeckPrepared => '尚未準備牌組';

  @override
  String preparedCount(int selected) {
    return '已準備 $selected / 6';
  }

  @override
  String cardsCount(int count) {
    return '共 $count 張';
  }

  @override
  String get readySection => '已準備';

  @override
  String get cardLibrary => '術式庫';

  @override
  String get continueDeckSetup => '繼續設定牌組';

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
  String get roleAttack => '攻擊';

  @override
  String get roleDefense => '防禦';

  @override
  String get roleMobility => '位移';

  @override
  String get roleAnalysis => '分析';

  @override
  String get roleSupport => '支援';

  @override
  String get roleCounter => '反制';

  @override
  String couldNotLoadStory(String error) {
    return '無法載入故事：$error';
  }

  @override
  String get academyStory => '學院故事';

  @override
  String get preparedDeckSavedNext =>
      'Prepared Deck 已儲存。接下來練習讀取敵方 Function，並找出 Weak Node。';

  @override
  String get returnToAdventure => '返回冒險';

  @override
  String preparedDeckCount(int selected) {
    return 'Prepared Deck：$selected / 6';
  }

  @override
  String get functionGraph => 'Function Graph';

  @override
  String get tapStepRole => '點選步驟查看它在術式中的作用。';

  @override
  String get quickCheck => '快速確認：哪一個步驟負責把已形成的效果導向目標？';

  @override
  String get fullChantSlowerStable => 'Full Chant 較慢，但更加穩定。';

  @override
  String get chantlessFasterInternal => 'Chantless 更快，但需要施術者內化編碼。';

  @override
  String get bothPerformProcessing => '兩種方式都會執行完整的 Function 處理。';

  @override
  String couldNotLoadFunction(String error) {
    return '無法載入 Function：$error';
  }

  @override
  String get functionAnalysis => 'Function Analysis';

  @override
  String get ashfangTrainingConstruct => 'Ashfang Training Construct';

  @override
  String get enemyFunctionPath =>
      '敵方 Function：DetectTarget → LockTarget → Pounce';

  @override
  String characterAnalysisModifier(int analysis, int modifier) {
    return '角色 Analysis：$analysis → Function 分析修正 +$modifier';
  }

  @override
  String get analyzeActiveFunction => '分析目前 Function';

  @override
  String get interruptLockTarget => 'Interrupt LockTarget';

  @override
  String get observeNextFunctionNode => '觀察下一個 Function 節點';

  @override
  String get resetTutorialPattern => '重設教學模式';

  @override
  String contentBalance(String status) {
    return '內容平衡狀態：$status';
  }

  @override
  String get nodeStateCancelled => '已由 Weak Node Interrupt 取消';

  @override
  String get nodeStateWeak => 'Weak Node 已揭露 · 可 Interrupt';

  @override
  String get nodeStateActive => 'Function 執行中';

  @override
  String get nodeStateAwaiting => '等待執行';

  @override
  String get feedbackPreparingPounce =>
      'Ashfang 正在準備 Pounce。先觀察 Function，再讓它完成。';

  @override
  String get feedbackPreparingAgain => 'Ashfang 再次準備 Pounce。';

  @override
  String get feedbackLockActive => 'LockTarget 已啟動。它可以被 Interrupt，但你尚未分析它的作用。';

  @override
  String get feedbackWeakFound =>
      '找到 Weak Node：Interrupt LockTarget 會取消後續 Pounce。';

  @override
  String get feedbackAnalysisMiss => '這次 Analysis 沒有揭露節點，再試一次。';

  @override
  String get feedbackInterrupted => 'LockTarget 已被 Interrupt。Pounce 取消。';

  @override
  String get feedbackInterruptFailed => '這個 Function 無法被 Interrupt。';

  @override
  String get functionNodeDetectTarget => '偵測目標';

  @override
  String get functionNodeLockTarget => '鎖定目標';

  @override
  String get functionNodePounce => '撲擊';

  @override
  String get ashfangEncounter => 'Ashfang 遭遇戰';

  @override
  String battleUnavailable(String error) {
    return '戰鬥無法使用：$error';
  }

  @override
  String get prototypeEncounterInputs => 'Prototype 遭遇戰輸入';

  @override
  String battleRoundStatus(int round, String status) {
    return 'Round $round · $status';
  }

  @override
  String get weakNodeRevealed => 'Weak Node 已揭露：LockTarget';

  @override
  String get weakNodeCancelsPounce => 'Interrupt 這個節點會取消後續 Pounce。';

  @override
  String get trainingEncounterComplete => '訓練戰完成';

  @override
  String get trainingAnalysisSaved =>
      '你訓練後的 Analysis 影響了 Weak Node 互動，戰鬥狀態已儲存。';

  @override
  String get encounterEnded => '遭遇戰結束';

  @override
  String get ashfangOverwhelmed => 'Ashfang 擊敗了你的角色，此結果已儲存。';

  @override
  String get attackAshfang => '攻擊 Ashfang';

  @override
  String get endTurn => '結束行動';

  @override
  String get analyzeWeakNode => '分析 Weak Node';

  @override
  String get resolvePounce => '執行 Pounce';

  @override
  String unitHpDetail(String detail, int hp, int maxHp) {
    return '$detail · HP $hp / $maxHp';
  }

  @override
  String questMetaShort(String domain, int minutes) {
    return '$domain · $minutes 分鐘';
  }

  @override
  String get couldNotLoadTraining => '無法載入訓練資料，請稍後再試。';

  @override
  String get confirmPreparedDeck => '確認 Prepared Deck';

  @override
  String get graphGather => 'Gather';

  @override
  String get graphShape => 'Shape';

  @override
  String get graphMove => 'Move';

  @override
  String get graphGatherDescription => '收集這個 Function 執行時所需的能量。';

  @override
  String get graphShapeDescription => '把能量塑形成預定效果，例如能量彈。';

  @override
  String get graphMoveDescription => '把已形成的效果導向目標。';

  @override
  String get graphGatherSummary => '收集能量';

  @override
  String get graphShapeSummary => '形成能量彈';

  @override
  String get graphMoveSummary => '導向結果';

  @override
  String graphNodeSummary(String name, String summary) {
    return '$name · $summary';
  }

  @override
  String get graphCorrectMove => '正確——Move 會把效果導向目標。';

  @override
  String get graphWrongMove => '還不對。負責把效果導向目標的是 Move。';

  @override
  String functionNodeSemantics(String node, String state) {
    return '$node，$state';
  }

  @override
  String get balanceAwaitingPlaytest => '示意數值 · 等待實際測試';

  @override
  String contentVersionStatus(String version, String status) {
    return '$version · $status';
  }

  @override
  String get battleHeroName => 'Astraea 主角';

  @override
  String analysisModifierLabel(int modifier) {
    return 'Analysis 修正 +$modifier';
  }

  @override
  String get functionPathLabel => 'Function：DetectTarget → LockTarget → Pounce';

  @override
  String get battleOutcomeActive => '進行中';

  @override
  String get battleOutcomeVictory => '勝利';

  @override
  String get battleOutcomeDefeat => '失敗';

  @override
  String get feedbackGuarding => 'Ashfang 正守著訓練場。';

  @override
  String get feedbackAshfangDefeated => 'Ashfang 已被擊敗。Weak Node 改變了這場戰鬥。';

  @override
  String get feedbackAttackResolved => '攻擊已由戰鬥引擎解析。';

  @override
  String get feedbackEnemyFunctionBegins =>
      'Ashfang 開始執行 DetectTarget → LockTarget → Pounce。';

  @override
  String get feedbackWeakNodeFoundLegacy =>
      '找到 Weak Node。Interrupt LockTarget 即可取消 Pounce。';

  @override
  String get feedbackWeakNodeMissLegacy =>
      '這次沒有揭露 Weak Node，Ashfang 將執行 Pounce。';

  @override
  String get feedbackInterruptedLegacy =>
      'LockTarget 已被 Interrupt，後續 Pounce 已取消。';

  @override
  String get feedbackPounceResolved => 'Pounce 已由戰鬥引擎解析。';

  @override
  String get combatRotateDevice => '請將裝置旋轉為橫向以進行戰鬥。';

  @override
  String get combatActionTimeline => '行動時間軸';

  @override
  String get combatEnemyIntent => '敵方意圖';

  @override
  String get combatCurrentActor => '目前角色';

  @override
  String get combatHero => '主角';

  @override
  String get combatRio => 'Rio';

  @override
  String get combatYuma => 'Yuma';

  @override
  String get combatAshfang => 'Ashfang';

  @override
  String get combatReactionReady => 'Reaction 可用';

  @override
  String get combatReactionSpent => 'Reaction 已使用';

  @override
  String get combatAttack => '攻擊';

  @override
  String get combatTechnique => '戰技';

  @override
  String get combatSc => 'SC';

  @override
  String get combatAnalyze => '分析';

  @override
  String get combatGuard => '防禦';

  @override
  String get combatMove => '移動';

  @override
  String get combatFireballI => 'Fireball I';

  @override
  String get combatFireballII => 'Fireball II';

  @override
  String get combatKnownFireball => 'Fireball I';

  @override
  String get combatModifiedFireball => '改造 Fireball';

  @override
  String get combatFullChant => 'Full Chant';

  @override
  String get combatChantless => 'Chantless';

  @override
  String get combatUnknownFunction => '未知 Function';

  @override
  String get combatTargetHero => '目標：主角';

  @override
  String combatTimelineTurn(String name) {
    return '$name 行動';
  }

  @override
  String combatTimelineResolve(String spell) {
    return '$spell 解析';
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
  String get combatTutorialChantlessTitle => '先從 Prepared Spell 開始';

  @override
  String get combatTutorialChantlessBody =>
      '使用 Chantless 施放 Fireball I，Function 會立即解析。';

  @override
  String get combatCastFireballI => '施放 Fireball I';

  @override
  String get combatKnownReactionTitle => 'REACTION';

  @override
  String get combatKnownReactionBody =>
      'Ashfang 正在構築 Fireball I。Rio 可以在 Function 成立前 Interrupt。';

  @override
  String get combatInterrupt => 'Interrupt';

  @override
  String get combatSaveReaction => '保留 Reaction';

  @override
  String get combatModifiedAnalysisTitle => '偵測到未知改造';

  @override
  String get combatModifiedAnalysisBody =>
      '使用 Analysis 找出這個 Function 真正可利用的結構資訊。';

  @override
  String get combatAnalyzeModified => '分析改造 Function';

  @override
  String get combatModifiedReactionTitle => 'Weak Node 已揭露';

  @override
  String get combatModifiedReactionBody =>
      'Analysis 找到脆弱的 Stabilization 相依節點，Rio 可以利用它。';

  @override
  String get combatWeakNodeStabilization => 'Weak Node：Stabilization';

  @override
  String get combatStabilityUnknown => 'Stability ?';

  @override
  String combatStabilityValue(int value) {
    return 'Stability $value';
  }

  @override
  String get combatFunctionStructure => 'FUNCTION 結構';

  @override
  String get combatStructureUnknown => '內部相依關係尚未揭露。';

  @override
  String get combatStructureRevealed => 'Stabilization 存在可利用的結構弱點。';

  @override
  String get combatBeginFullChant => '開始 Fireball II · Full Chant';

  @override
  String get combatFullChantTitle => '投入 Full Chant';

  @override
  String get combatFullChantBody => 'Fireball II 會進入 Timeline，完成構築後才解析。';

  @override
  String get combatFinisherTitle => '低 Tier 仍然有價值';

  @override
  String get combatFinisherBody => '以較低消耗的 Fireball I Chantless 完成戰鬥。';

  @override
  String get combatFinishFireballI => '以 Fireball I 收尾';

  @override
  String get combatVictoryTitle => '訓練戰完成';

  @override
  String get combatVictoryBody =>
      '你已透過真正的 CTB engine 使用 Chantless、Interrupt、Analysis、Weak Node 與 Full Chant。';

  @override
  String get combatRestart => '重新訓練';

  @override
  String get combatReturnAdventure => '返回冒險';

  @override
  String get combatIntentHeroTurn => '閱讀戰場並選擇行動。';

  @override
  String get combatIntentKnownFireball => 'Fireball I · Full Chant';

  @override
  String get combatIntentModifiedFireball => '改造 Fireball · Full Chant';

  @override
  String get combatIntentHeroFullChant => 'Ashfang 正在恢復。主角可以投入 Full Chant。';

  @override
  String get combatIntentFinisher => 'Ashfang 已接近被擊敗。';

  @override
  String get combatIntentVictory => '訓練目標完成。';

  @override
  String get combatFeedbackOpening =>
      'Prepared SC 是可直接使用的戰鬥選項。先從 Fireball I 開始。';

  @override
  String get combatFeedbackHeroChantless => 'Fireball I 透過 Chantless 立即解析。';

  @override
  String get combatFeedbackKnownCasting =>
      'Ashfang 開始已知的 Full Chant，Interrupt window 已開啟。';

  @override
  String get combatFeedbackKnownInterrupted =>
      'Rio 在 Function 成立前破壞了尚未完成的 Fireball。';

  @override
  String get combatFeedbackKnownResolved =>
      '你保留了 Reaction。Fireball I 成功解析並傷害主角。';

  @override
  String get combatFeedbackModifiedCasting => 'Ashfang 改造了 Function，內部結構目前未知。';

  @override
  String get combatFeedbackAnalysisWeakNode =>
      'Analysis 揭露了 Stability 與真正的 Stabilization Weak Node。';

  @override
  String get combatFeedbackModifiedInterrupted =>
      'Weak Node bonus 提高了 Interrupt Power，成功破壞 Function。';

  @override
  String get combatFeedbackModifiedResolved => '改造 Function 被允許完成解析。';

  @override
  String get combatFeedbackHeroFullChantCasting => '主角支付 Mana 並進入 Full Chant。';

  @override
  String get combatFeedbackHeroFullChantResolved =>
      'Fireball II 成功解析，Ashfang 已奄奄一息。';

  @override
  String get combatFeedbackVictory => 'Ashfang 已被擊敗，教學目標完成。';

  @override
  String get combatFeedbackDefeat => '隊伍戰敗。';

  @override
  String get combatZoneMid => 'MID';

  @override
  String get combatTrainingArena => 'ASTRAEA 訓練場';

  @override
  String get combatFullChantCastingTitle => 'Full Chant 正在構築';

  @override
  String get combatFullChantCastingBody =>
      'Fireball II 已成為 Timeline 上等待解析的 Resolve event。術式完成前，Ashfang 仍有機會行動。';

  @override
  String get combatAdvanceTimeline => '推進至 Resolve';

  @override
  String get combatDefeatTitle => '訓練失敗';

  @override
  String get combatDefeatBody => '隊伍已戰敗。重新開始訓練，嘗試不同的決策。';

  @override
  String get combatHoldFormation => '維持陣形';

  @override
  String get combatNodeCompression => '壓縮';

  @override
  String get combatNodeStabilization => '穩定';

  @override
  String get combatNodeTrajectory => '軌跡';
}
