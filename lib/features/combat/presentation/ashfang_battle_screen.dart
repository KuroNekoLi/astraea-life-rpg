import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../game_engine/combat/combat_engine.dart';
import '../../../game_engine/function_graph/function_graph.dart';
import '../../../game_engine/function_graph/function_runtime.dart';
import '../../character/data/training_repository.dart';
import '../../story/application/overview_providers.dart';
import '../data/ashfang_battle_repository.dart';
import '../domain/ashfang_battle_engine.dart';
import 'widgets/combat_battle_stage.dart';

class AshfangBattleScreen extends ConsumerStatefulWidget {
  const AshfangBattleScreen({super.key});

  @override
  ConsumerState<AshfangBattleScreen> createState() =>
      _AshfangBattleScreenState();
}

class _AshfangBattleScreenState extends ConsumerState<AshfangBattleScreen>
    with WidgetsBindingObserver {
  late Future<_BattleData> _data;
  bool _routeActive = true;
  bool _appResumed = true;
  bool _commandInFlight = false;
  bool _reduceMotion = false;
  bool _paused = false;
  bool _showTargetPicker = false;
  bool _showFunctionPanel = false;
  bool _showSpellPanel = false;
  bool _showEventLog = false;
  bool _pendingSave = false;
  String? _selectedTargetId;
  String? _saveError;
  CombatStageCue? _cue;
  Timer? _playbackTimer;
  int _operationSequence = 0;

  bool get _canOperate =>
      _routeActive &&
      _appResumed &&
      !_paused &&
      !_commandInFlight &&
      !_pendingSave;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appResumed =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _data = _load();
    unawaited(_requestLandscape());
  }

  Future<void> _requestLandscape() async {
    try {
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      if (!_routeActive) {
        await _restoreNonBattleOrientation();
      }
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() => _saveError = 'Orientation request failed: $error');
      }
    }
  }

  Future<void> _restoreNonBattleOrientation() async {
    // The app has no global preferred-orientation override; an empty list
    // returns policy to the operating system after this route is removed.
    await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[]);
  }

  Future<_BattleData> _load() async {
    final json =
        jsonDecode(
              await rootBundle.loadString(
                'assets/content/encounters/ashfang_training_v2.json',
              ),
            )
            as Map<String, dynamic>;
    final graphData = json['functionGraph'] as Map<String, dynamic>;
    final nodes = (graphData['nodes'] as List<dynamic>).map((raw) {
      final node = raw as Map<String, dynamic>;
      return FunctionNode(
        id: node['id'] as String,
        type: node['type'] as String,
        parameters: const {},
        complexity: 1,
        interruptible: node['interruptible'] as bool,
        reversible: false,
      );
    }).toList();
    final edges = (graphData['edges'] as List<dynamic>).map((raw) {
      final edge = raw as List<dynamic>;
      return FunctionEdge(
        fromNodeId: edge[0] as String,
        toNodeId: edge[1] as String,
      );
    }).toList();
    final rules = (graphData['weakNodeRules'] as List<dynamic>).map((raw) {
      final item = raw as Map<String, dynamic>;
      return FunctionWeakNodeRule(
        id: item['id'] as String,
        nodeId: item['nodeId'] as String,
        downstreamNodeIds: (item['cancelNodes'] as List<dynamic>)
            .cast<String>()
            .toSet(),
      );
    }).toList();
    final graph = FunctionGraph(
      id: graphData['id'] as String,
      nodes: nodes,
      edges: edges,
      entryNodeIds: const {'detect-target'},
      outputNodeIds: const {'pounce'},
      weakNodeRuleIds: rules.map((item) => item.id).toSet(),
      schemaVersion: 1,
      contentVersion: json['contentVersion'] as String,
    );
    final db = await ref.read(databaseProvider.future);
    final repo = AshfangBattleRepository(db);
    final inputs = json['combatInputs'] as Map<String, dynamic>;
    final player = inputs['player'] as Map<String, dynamic>;
    final enemy = inputs['enemy'] as Map<String, dynamic>;
    final session = AshfangBattleEngine(
      graph: graph,
      rules: rules,
      analysisDifficulty: json['analysisDifficulty'] as int,
      analysisModifier: (await TrainingRepository(db).effectiveAnalysis() - 8)
          .clamp(0, 99)
          .toInt(),
      seed: inputs['seed'] as int,
      playerHp: player['hp'] as int,
      playerMana: player['mana'] as int,
      playerAttackBonus: player['attackBonus'] as int,
      playerDefense: player['defense'] as int,
      playerProcessing: player['processingModifier'] as int,
      playerDamage: player['attackDamage'] as int,
      playerCriticalDamage: player['criticalDamage'] as int,
      enemyHp: enemy['hp'] as int,
      enemyMana: enemy['mana'] as int,
      enemyAttackBonus: enemy['attackBonus'] as int,
      enemyDefense: enemy['defense'] as int,
      enemyProcessing: enemy['processingModifier'] as int,
      enemyDamage: enemy['pounceDamage'] as int,
      enemyCriticalDamage: enemy['criticalDamage'] as int,
    );
    final saved = await repo.load();
    if (saved != null && saved['contentVersion'] == json['contentVersion']) {
      AshfangBattleRepository.restore(session, saved);
    }
    return _BattleData(json, inputs['status'] as String, session, repo);
  }

  Future<void> _runAction(
    _BattleData data,
    VoidCallback action, {
    CombatStageCueKind? functionCue,
    String? actorId,
    String? targetId,
  }) async {
    if (!_canOperate) return;
    setState(() {
      _commandInFlight = true;
      _showTargetPicker = false;
      _selectedTargetId = null;
      _saveError = null;
    });
    final oldRevision = data.session.state.revision;
    final oldLogLength = data.session.state.eventLog.length;
    try {
      action();
      final state = data.session.state;
      final newEvents = state.eventLog.skip(oldLogLength).toList();
      final resolvedCue = _cueFor(
        battleId: AshfangBattleRepository.battleId,
        state: state,
        oldRevision: oldRevision,
        newEvents: newEvents,
        functionCue: functionCue,
        functionActionSucceeded: switch (functionCue) {
          CombatStageCueKind.analysisReveal =>
            data.session.knowledge.revealedWeakNodeIds.contains('lock-target'),
          CombatStageCueKind.interrupt =>
            data.session.activeFunction?.status ==
                FunctionRuntimeStatus.interrupted,
          _ => true,
        },
        actorId: actorId,
        targetId: targetId,
      );
      setState(() {
        _operationSequence += 1;
        _cue = resolvedCue;
      });
      await _persist(data);
      if (!mounted) return;
      setState(() => _commandInFlight = false);
      if (resolvedCue != null && !_effectiveReducedMotion) {
        _startPresentationLock(resolvedCue.kind);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _commandInFlight = false;
        if (!_pendingSave) _saveError = '此行動目前無法完成：$error';
      });
    }
  }

  Future<void> _persist(_BattleData data) async {
    try {
      await data.repository.save(
        data.session,
        DateTime.now(),
        contentVersion: data.content['contentVersion'] as String,
      );
      _pendingSave = false;
      _saveError = null;
    } catch (error) {
      _pendingSave = true;
      _saveError = '戰鬥進度尚未儲存。可重試儲存，不會重做剛才的行動。 ($error)';
      rethrow;
    }
  }

  CombatStageCue? _cueFor({
    required String battleId,
    required CombatState state,
    required int oldRevision,
    required List<String> newEvents,
    required CombatStageCueKind? functionCue,
    required bool functionActionSucceeded,
    required String? actorId,
    required String? targetId,
  }) {
    CombatStageCueKind? kind;
    String? cueActor = actorId;
    String? cueTarget = targetId;
    if (state.outcome == CombatOutcome.victory) {
      kind = CombatStageCueKind.victory;
    } else if (state.outcome == CombatOutcome.defeat) {
      kind = CombatStageCueKind.defeat;
    } else if (newEvents.contains('criticalHit')) {
      kind = CombatStageCueKind.criticalHit;
      cueActor ??= functionCue == CombatStageCueKind.analysisReveal
          ? 'ashfang'
          : null;
      cueTarget ??= functionCue == CombatStageCueKind.analysisReveal
          ? 'player'
          : 'ashfang';
    } else if (newEvents.contains('hit')) {
      kind = CombatStageCueKind.attackHit;
      cueActor ??= functionCue == CombatStageCueKind.analysisReveal
          ? 'ashfang'
          : null;
      cueTarget ??= functionCue == CombatStageCueKind.analysisReveal
          ? 'player'
          : 'ashfang';
    } else if (newEvents.contains('miss')) {
      kind = CombatStageCueKind.attackMiss;
      cueActor ??= functionCue == CombatStageCueKind.analysisReveal
          ? 'ashfang'
          : null;
      cueTarget ??= functionCue == CombatStageCueKind.analysisReveal
          ? 'player'
          : 'ashfang';
    } else if (functionCue != null) {
      if (functionActionSucceeded) kind = functionCue;
    } else if (state.revision != oldRevision) {
      kind = CombatStageCueKind.actorFocus;
    }
    if (kind == null) return null;
    final op = _operationSequence + 1;
    return CombatStageCue(
      id: '$battleId-$op-${state.revision}-${kind.name}',
      kind: kind,
      actorId: cueActor,
      targetId: cueTarget,
    );
  }

  bool get _effectiveReducedMotion =>
      _reduceMotion || MediaQuery.of(context).disableAnimations;

  void _startPresentationLock(CombatStageCueKind kind) {
    _playbackTimer?.cancel();
    setState(() => _commandInFlight = true);
    final delay = switch (kind) {
      CombatStageCueKind.attackHit => const Duration(milliseconds: 720),
      CombatStageCueKind.attackMiss => const Duration(milliseconds: 660),
      CombatStageCueKind.criticalHit => const Duration(milliseconds: 880),
      CombatStageCueKind.analysisReveal => const Duration(milliseconds: 620),
      CombatStageCueKind.interrupt => const Duration(milliseconds: 840),
      CombatStageCueKind.victory => const Duration(milliseconds: 960),
      CombatStageCueKind.defeat => const Duration(milliseconds: 900),
      _ => const Duration(milliseconds: 480),
    };
    _playbackTimer = Timer(delay, () {
      if (mounted) setState(() => _commandInFlight = false);
    });
  }

  void _skipPresentation() {
    _playbackTimer?.cancel();
    if (mounted) setState(() => _commandInFlight = false);
  }

  Future<void> _retrySave(_BattleData data) async {
    if (!_pendingSave || _commandInFlight) return;
    setState(() => _commandInFlight = true);
    try {
      await _persist(data);
      if (mounted) setState(() => _commandInFlight = false);
    } catch (_) {
      if (mounted) setState(() => _commandInFlight = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appResumed = state == AppLifecycleState.resumed;
    if (_appResumed && _routeActive) unawaited(_requestLandscape());
    if (!_appResumed) _skipPresentation();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _routeActive = false;
    _playbackTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_restoreNonBattleOrientation());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<_BattleData>(
    future: _data,
    builder: (context, snapshot) {
      if (MediaQuery.orientationOf(context) != Orientation.landscape) {
        return const _RotateToLandscapeScreen();
      }
      if (!snapshot.hasData) {
        return Scaffold(
          backgroundColor: const Color(0xff090f20),
          body: SafeArea(
            child: Center(
              child: snapshot.hasError
                  ? Text(
                      '戰鬥無法載入\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        );
      }
      final data = snapshot.requireData;
      return _battleView(data);
    },
  );

  Widget _battleView(_BattleData data) {
    final battle = data.session;
    final state = battle.state;
    final player = state.unit('player');
    final enemy = state.unit('ashfang');
    final playerTurn =
        state.activeCombatantId == 'player' &&
        state.outcome == CombatOutcome.active;
    final functionActive =
        state.outcome == CombatOutcome.active && battle.enemyActionPending;
    final lockActive = battle.activeFunction?.activeNodeId == 'lock-target';
    final revealed = battle.knowledge.revealedWeakNodeIds.contains(
      'lock-target',
    );
    final canAnalyze =
        functionActive &&
        lockActive &&
        !battle.knowledge.analysedNodeIds.contains('lock-target');
    final canInterrupt = functionActive && lockActive && revealed;
    final effectiveReducedMotion =
        _reduceMotion || MediaQuery.of(context).disableAnimations;
    final stageSnapshot = CombatStageSnapshot(
      battleId: AshfangBattleRepository.battleId,
      revision: state.revision,
      combatants: [
        for (final unit in state.combatants)
          CombatStageCombatantView(
            id: unit.id,
            side: unit.side == CombatSide.player
                ? CombatStageSide.player
                : CombatStageSide.enemy,
            defeated: unit.condition == CombatantCondition.defeated,
          ),
      ],
      activeCombatantId: state.activeCombatantId,
      outcome: switch (state.outcome) {
        CombatOutcome.active => CombatStageOutcome.active,
        CombatOutcome.victory => CombatStageOutcome.victory,
        CombatOutcome.defeat => CombatStageOutcome.defeat,
      },
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _openPause();
      },
      child: Scaffold(
        backgroundColor: const Color(0xff090f20),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              return Column(
                children: [
                  _BattleHeader(
                    round: state.round,
                    order: state.initiativeOrder,
                    activeId: state.activeCombatantId,
                    defeatedIds: state.combatants
                        .where(
                          (unit) =>
                              unit.condition == CombatantCondition.defeated,
                        )
                        .map((unit) => unit.id)
                        .toSet(),
                    outcome: state.outcome,
                    onPause: _openPause,
                    compact: compact,
                  ),
                  Expanded(
                    flex: compact ? 4 : 6,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CombatBattleStage(
                          snapshot: stageSnapshot,
                          cue: _cue,
                          reducedMotion: effectiveReducedMotion,
                          skipAnimations: false,
                          paused: _paused || !_appResumed,
                        ),
                        Positioned(
                          left: 10,
                          top: 8,
                          child: _BossStatus(hp: enemy.hp, maxHp: enemy.maxHp),
                        ),
                        Positioned(
                          right: 10,
                          top: 8,
                          child: _FunctionPeek(
                            active: functionActive,
                            activeNode: battle.activeFunction?.activeNodeId,
                            revealed: revealed,
                            cancelled:
                                battle.activeFunction?.cancelledNodeIds
                                    .contains('pounce') ??
                                false,
                            onTap: () =>
                                setState(() => _showFunctionPanel = true),
                          ),
                        ),
                        if (state.outcome != CombatOutcome.active)
                          _BattleResultOverlay(
                            victory: state.outcome == CombatOutcome.victory,
                            revealed: revealed,
                            cancelled:
                                battle.activeFunction?.cancelledNodeIds
                                    .contains('pounce') ??
                                false,
                            onContinue: () => context.go('/adventure'),
                          ),
                        if (_paused)
                          _PauseOverlay(
                            reduceMotion: _reduceMotion,
                            onResume: () => setState(() => _paused = false),
                            onToggleReducedMotion: (value) =>
                                setState(() => _reduceMotion = value),
                          ),
                        if (!_appResumed) const _LifecycleOverlay(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: compact ? 6 : 4,
                    child: _BattleCommandDock(
                      playerHp: player.hp,
                      playerMaxHp: player.maxHp,
                      playerMana: player.mana,
                      playerMaxMana: player.maxMana,
                      playerTurn: playerTurn,
                      activeActorName: _combatantName(state.activeCombatantId),
                      actionUsed: player.mainActionUsed,
                      functionActive: functionActive,
                      canAnalyze: canAnalyze,
                      canInterrupt: canInterrupt,
                      revealed: revealed,
                      feedback: battle.feedback,
                      eventLog: state.eventLog,
                      showTargetPicker: _showTargetPicker,
                      selectedTargetId: _selectedTargetId,
                      hasLivingTarget:
                          enemy.condition == CombatantCondition.active,
                      showFunctionPanel: _showFunctionPanel,
                      showSpellPanel: _showSpellPanel,
                      showEventLog: _showEventLog,
                      commandEnabled:
                          _canOperate && state.outcome == CombatOutcome.active,
                      saveError: _saveError,
                      isPendingSave: _pendingSave,
                      cue: _cue,
                      playback: _commandInFlight && !_pendingSave,
                      reducedMotion: effectiveReducedMotion,
                      onAttack: () => setState(() {
                        _showTargetPicker = true;
                        _selectedTargetId = null;
                        _showSpellPanel = false;
                        _showFunctionPanel = false;
                      }),
                      onSelectTarget: (id) =>
                          setState(() => _selectedTargetId = id),
                      onCancelTarget: () => setState(() {
                        _showTargetPicker = false;
                        _selectedTargetId = null;
                      }),
                      onConfirmAttack: () {
                        if (playerTurn &&
                            _selectedTargetId == 'ashfang' &&
                            enemy.condition == CombatantCondition.active) {
                          unawaited(
                            _runAction(
                              data,
                              battle.attack,
                              actorId: 'player',
                              targetId: 'ashfang',
                            ),
                          );
                        }
                      },
                      onEndTurn: () => unawaited(
                        _runAction(
                          data,
                          battle.endPlayerTurn,
                          actorId: 'player',
                        ),
                      ),
                      onAnalyze: () => unawaited(
                        _runAction(
                          data,
                          battle.analyzeWeakNode,
                          functionCue: CombatStageCueKind.analysisReveal,
                          actorId: 'player',
                          targetId: 'ashfang',
                        ),
                      ),
                      onInterrupt: () => unawaited(
                        _runAction(
                          data,
                          battle.interruptWeakNode,
                          functionCue: CombatStageCueKind.interrupt,
                          actorId: 'player',
                          targetId: 'ashfang',
                        ),
                      ),
                      onToggleFunction: () => setState(
                        () => _showFunctionPanel = !_showFunctionPanel,
                      ),
                      onToggleSpells: () =>
                          setState(() => _showSpellPanel = !_showSpellPanel),
                      onToggleLog: () =>
                          setState(() => _showEventLog = !_showEventLog),
                      onRetrySave: () => unawaited(_retrySave(data)),
                      onSkip: _skipPresentation,
                      compact: compact,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openPause() {
    if (mounted) setState(() => _paused = true);
  }
}

class _BattleHeader extends StatelessWidget {
  const _BattleHeader({
    required this.round,
    required this.order,
    required this.activeId,
    required this.defeatedIds,
    required this.outcome,
    required this.onPause,
    required this.compact,
  });

  final int round;
  final List<String> order;
  final String activeId;
  final Set<String> defeatedIds;
  final CombatOutcome outcome;
  final VoidCallback onPause;
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 54 : 62,
    child: Row(
      children: [
        const SizedBox(width: 12),
        Text('ROUND $round', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var index = 0; index < order.length; index++) ...[
                  if (index > 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.chevron_right, size: 18),
                    ),
                  _TimelineUnit(
                    id: order[index],
                    active:
                        order[index] == activeId &&
                        outcome == CombatOutcome.active,
                    defeated: defeatedIds.contains(order[index]),
                  ),
                ],
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: 'Pause battle',
          onPressed: onPause,
          icon: const Icon(Icons.pause_circle_outline),
        ),
        const SizedBox(width: 4),
      ],
    ),
  );
}

class _TimelineUnit extends StatelessWidget {
  const _TimelineUnit({
    required this.id,
    required this.active,
    required this.defeated,
  });

  final String id;
  final bool active;
  final bool defeated;

  @override
  Widget build(BuildContext context) {
    final name = _combatantName(id);
    return Semantics(
      label:
          '$name${active ? ', current turn' : ''}${defeated ? ', defeated' : ''}',
      child: Container(
        constraints: const BoxConstraints(minHeight: 38, minWidth: 88),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xff3d5683) : const Color(0xff18243e),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xffffd69a) : const Color(0xff4b5d7e),
            width: active ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              id == 'ashfang' ? Icons.pets_outlined : Icons.person_outline,
              size: 17,
            ),
            const SizedBox(width: 5),
            Text(name, style: Theme.of(context).textTheme.labelMedium),
            if (active) ...[
              const SizedBox(width: 5),
              const Text(
                'NOW',
                style: TextStyle(fontSize: 9, letterSpacing: .6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BossStatus extends StatelessWidget {
  const _BossStatus({required this.hp, required this.maxHp});

  final int hp;
  final int maxHp;

  @override
  Widget build(BuildContext context) => _HudPanel(
    child: SizedBox(
      width: 205,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ASHFANG TRAINING CONSTRUCT'),
          const SizedBox(height: 5),
          LinearProgressIndicator(value: hp / maxHp, minHeight: 6),
          const SizedBox(height: 4),
          Text('HP  $hp / $maxHp'),
        ],
      ),
    ),
  );
}

class _FunctionPeek extends StatelessWidget {
  const _FunctionPeek({
    required this.active,
    required this.activeNode,
    required this.revealed,
    required this.cancelled,
    required this.onTap,
  });

  final bool active;
  final String? activeNode;
  final bool revealed;
  final bool cancelled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: active ? 'Inspect current enemy Function' : 'Function information',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 150;
        return Material(
          color: const Color(0xdd111a31),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 12,
                vertical: compact ? 5 : 9,
              ),
              child: compact
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(active ? _nodeLabel(activeNode) : 'FUNCTION'),
                        if (revealed || cancelled) ...[
                          const SizedBox(width: 6),
                          Text(
                            cancelled
                                ? '· Weak Node · Pounce cancelled'
                                : '· Weak Node revealed',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('FUNCTION'),
                        Text(
                          active
                              ? _nodeLabel(activeNode)
                              : 'No active Function',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (revealed) const Text('Weak Node revealed'),
                        if (cancelled) const Text('Pounce cancelled'),
                      ],
                    ),
            ),
          ),
        );
      },
    ),
  );
}

class _BattleCommandDock extends ConsumerWidget {
  const _BattleCommandDock({
    required this.playerHp,
    required this.playerMaxHp,
    required this.playerMana,
    required this.playerMaxMana,
    required this.playerTurn,
    required this.activeActorName,
    required this.actionUsed,
    required this.functionActive,
    required this.canAnalyze,
    required this.canInterrupt,
    required this.revealed,
    required this.feedback,
    required this.eventLog,
    required this.showTargetPicker,
    required this.selectedTargetId,
    required this.hasLivingTarget,
    required this.showFunctionPanel,
    required this.showSpellPanel,
    required this.showEventLog,
    required this.commandEnabled,
    required this.saveError,
    required this.isPendingSave,
    required this.cue,
    required this.playback,
    required this.reducedMotion,
    required this.onAttack,
    required this.onSelectTarget,
    required this.onCancelTarget,
    required this.onConfirmAttack,
    required this.onEndTurn,
    required this.onAnalyze,
    required this.onInterrupt,
    required this.onToggleFunction,
    required this.onToggleSpells,
    required this.onToggleLog,
    required this.onRetrySave,
    required this.onSkip,
    required this.compact,
  });

  final int playerHp;
  final int playerMaxHp;
  final int playerMana;
  final int playerMaxMana;
  final bool playerTurn;
  final String activeActorName;
  final bool actionUsed;
  final bool functionActive;
  final bool canAnalyze;
  final bool canInterrupt;
  final bool revealed;
  final String feedback;
  final List<String> eventLog;
  final bool showTargetPicker;
  final String? selectedTargetId;
  final bool hasLivingTarget;
  final bool showFunctionPanel;
  final bool showSpellPanel;
  final bool showEventLog;
  final bool commandEnabled;
  final String? saveError;
  final bool isPendingSave;
  final CombatStageCue? cue;
  final bool playback;
  final bool reducedMotion;
  final VoidCallback onAttack;
  final ValueChanged<String> onSelectTarget;
  final VoidCallback onCancelTarget;
  final VoidCallback onConfirmAttack;
  final VoidCallback onEndTurn;
  final VoidCallback onAnalyze;
  final VoidCallback onInterrupt;
  final VoidCallback onToggleFunction;
  final VoidCallback onToggleSpells;
  final VoidCallback onToggleLog;
  final VoidCallback onRetrySave;
  final VoidCallback onSkip;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deck = ref.watch(preparedDeckProvider);
    final playerActionReady = playerTurn && !actionUsed && commandEnabled;
    final activeFunctionAction = functionActive && commandEnabled;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff111a2e),
        border: Border(top: BorderSide(color: Color(0xff465777))),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: compact ? 172 : 224,
                  child: _PlayerStatus(
                    hp: playerHp,
                    maxHp: playerMaxHp,
                    mana: playerMana,
                    maxMana: playerMaxMana,
                    active: playerTurn,
                  ),
                ),
                const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: showTargetPicker
                        ? _TargetPicker(
                            selectedTargetId: selectedTargetId,
                            hasLivingTarget: hasLivingTarget,
                            enabled:
                                commandEnabled && playerTurn && !actionUsed,
                            onSelect: onSelectTarget,
                            onCancel: onCancelTarget,
                            onConfirm: onConfirmAttack,
                          )
                        : showFunctionPanel
                        ? _FunctionPanel(
                            active: functionActive,
                            revealed: revealed,
                            canAnalyze: canAnalyze && commandEnabled,
                            canInterrupt: canInterrupt && commandEnabled,
                            onAnalyze: onAnalyze,
                            onInterrupt: onInterrupt,
                            onClose: onToggleFunction,
                          )
                        : showSpellPanel
                        ? _SpellPanel(deck: deck, onClose: onToggleSpells)
                        : showEventLog
                        ? _EventLogPanel(
                            eventLog: eventLog,
                            feedback: feedback,
                            onClose: onToggleLog,
                          )
                        : _CommandMenu(
                            playerActionReady: playerActionReady,
                            activeFunctionAction: activeFunctionAction,
                            canAnalyze: canAnalyze,
                            canInterrupt: canInterrupt,
                            actionUsed: actionUsed,
                            playerTurn: playerTurn,
                            onAttack: onAttack,
                            onSpells: onToggleSpells,
                            onFunction: onToggleFunction,
                            onAnalyze: onAnalyze,
                            onInterrupt: onInterrupt,
                            onEndTurn: onEndTurn,
                            onLog: onToggleLog,
                          ),
                  ),
                ),
              ],
            ),
          ),
          _BottomFeedback(
            feedback: saveError ?? feedback,
            eventLog: eventLog,
            pendingSave: isPendingSave,
            playback: playback && cue != null,
            reducedMotion: reducedMotion,
            onRetrySave: onRetrySave,
            onSkip: onSkip,
            onLog: onToggleLog,
          ),
        ],
      ),
    );
  }
}

class _PlayerStatus extends StatelessWidget {
  const _PlayerStatus({
    required this.hp,
    required this.maxHp,
    required this.mana,
    required this.maxMana,
    required this.active,
  });

  final int hp;
  final int maxHp;
  final int mana;
  final int maxMana;
  final bool active;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxHeight < 150 || constraints.maxWidth < 210;
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 12,
          vertical: compact ? 4 : 8,
        ),
        child: _HudPanel(
          child: SingleChildScrollView(
            child: compact
                ? Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              active
                                  ? 'ASTRAEA HERO · YOUR TURN'
                                  : 'ASTRAEA HERO',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'HP $hp/$maxHp   MP $mana/$maxMana',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 18),
                          const SizedBox(width: 6),
                          const Expanded(child: Text('ASTRAEA HERO')),
                          if (active) const Text('YOUR TURN'),
                        ],
                      ),
                      const SizedBox(height: 7),
                      _ResourceLine(label: 'HP', current: hp, maximum: maxHp),
                      const SizedBox(height: 3),
                      _ResourceLine(
                        label: 'MP',
                        current: mana,
                        maximum: maxMana,
                      ),
                    ],
                  ),
          ),
        ),
      );
    },
  );
}

class _ResourceLine extends StatelessWidget {
  const _ResourceLine({
    required this.label,
    required this.current,
    required this.maximum,
  });

  final String label;
  final int current;
  final int maximum;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(width: 22, child: Text(label)),
      Expanded(
        child: LinearProgressIndicator(
          value: maximum == 0 ? 0 : current / maximum,
          minHeight: 5,
        ),
      ),
      const SizedBox(width: 7),
      Text('$current/$maximum'),
    ],
  );
}

class _CommandMenu extends StatelessWidget {
  const _CommandMenu({
    required this.playerActionReady,
    required this.activeFunctionAction,
    required this.canAnalyze,
    required this.canInterrupt,
    required this.actionUsed,
    required this.playerTurn,
    required this.onAttack,
    required this.onSpells,
    required this.onFunction,
    required this.onAnalyze,
    required this.onInterrupt,
    required this.onEndTurn,
    required this.onLog,
  });

  final bool playerActionReady;
  final bool activeFunctionAction;
  final bool canAnalyze;
  final bool canInterrupt;
  final bool actionUsed;
  final bool playerTurn;
  final VoidCallback onAttack;
  final VoidCallback onSpells;
  final VoidCallback onFunction;
  final VoidCallback onAnalyze;
  final VoidCallback onInterrupt;
  final VoidCallback onEndTurn;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      _CommandButton(
        label: 'Attack',
        icon: Icons.gps_fixed,
        enabled: playerActionReady,
        onPressed: onAttack,
        semanticReason: playerTurn && actionUsed
            ? 'Main Action already used'
            : null,
      ),
      _CommandButton(
        label: 'Spell Cards',
        icon: Icons.auto_awesome,
        enabled: true,
        onPressed: onSpells,
      ),
      _CommandButton(
        label: 'Analyze',
        icon: Icons.search,
        enabled: canAnalyze && activeFunctionAction,
        onPressed: onAnalyze,
        semanticReason:
            'Available only while the current Function can be analyzed',
      ),
      _CommandButton(
        label: 'Interrupt',
        icon: Icons.link_off,
        enabled: canInterrupt && activeFunctionAction,
        onPressed: onInterrupt,
        semanticReason: 'Analyze and reveal the Weak Node first',
      ),
      _CommandButton(
        label: 'Items',
        icon: Icons.inventory_2_outlined,
        enabled: false,
        semanticReason: 'Combat items are not available in this version',
      ),
      _CommandButton(
        label: 'Function',
        icon: Icons.account_tree_outlined,
        enabled: true,
        onPressed: onFunction,
      ),
      _CommandButton(
        label: 'Event Log',
        icon: Icons.subject,
        enabled: true,
        onPressed: onLog,
      ),
      _CommandButton(
        label: 'End Turn',
        icon: Icons.skip_next,
        enabled: playerTurn && (playerActionReady || actionUsed),
        onPressed: onEndTurn,
        semanticReason: 'Available on the active player turn',
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = 4;
        final rows = (actions.length / columns).ceil();
        final buttonHeight = ((constraints.maxHeight - 4 * (rows - 1)) / rows)
            .clamp(48.0, 72.0);
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                playerTurn ? 'PLAYER COMMAND' : 'FUNCTION WINDOW',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: GridView.count(
                crossAxisCount: columns,
                crossAxisSpacing: 6,
                mainAxisSpacing: 4,
                childAspectRatio:
                    constraints.maxWidth / (columns * buttonHeight),
                physics: const NeverScrollableScrollPhysics(),
                children: actions,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CommandButton extends StatelessWidget {
  const _CommandButton({
    required this.label,
    required this.icon,
    required this.enabled,
    this.onPressed,
    this.semanticReason,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onPressed;
  final String? semanticReason;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    hint: enabled ? null : semanticReason,
    enabled: enabled,
    button: true,
    child: FilledButton.tonalIcon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 17),
      label: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        minimumSize: const Size(48, 48),
      ),
    ),
  );
}

class _TargetPicker extends StatelessWidget {
  const _TargetPicker({
    required this.selectedTargetId,
    required this.hasLivingTarget,
    required this.enabled,
    required this.onSelect,
    required this.onCancel,
    required this.onConfirm,
  });

  final String? selectedTargetId;
  final bool hasLivingTarget;
  final bool enabled;
  final ValueChanged<String> onSelect;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final target = hasLivingTarget
          ? ChoiceChip(
              label: const Text('Ashfang · active enemy'),
              selected: selectedTargetId == 'ashfang',
              onSelected: enabled ? (_) => onSelect('ashfang') : null,
              avatar: const Icon(Icons.pets_outlined),
            )
          : const Text('No valid target');
      final confirm = FilledButton.icon(
        onPressed: enabled && hasLivingTarget && selectedTargetId != null
            ? onConfirm
            : null,
        icon: const Icon(Icons.gps_fixed),
        label: const Text('Confirm Attack'),
      );

      if (constraints.maxHeight < 112) {
        return Row(
          children: [
            const Text('TARGET'),
            const SizedBox(width: 8),
            Expanded(
              child: Align(alignment: Alignment.centerLeft, child: target),
            ),
            IconButton(
              tooltip: 'Cancel target selection',
              onPressed: enabled ? onCancel : null,
              icon: const Icon(Icons.close),
            ),
            confirm,
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: Text('CHOOSE A TARGET')),
              IconButton(
                tooltip: 'Cancel target selection',
                onPressed: enabled ? onCancel : null,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: target),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: enabled ? onCancel : null,
                child: const Text('Cancel'),
              ),
              const Spacer(),
              confirm,
            ],
          ),
        ],
      );
    },
  );
}

class _FunctionPanel extends StatelessWidget {
  const _FunctionPanel({
    required this.active,
    required this.revealed,
    required this.canAnalyze,
    required this.canInterrupt,
    required this.onAnalyze,
    required this.onInterrupt,
    required this.onClose,
  });

  final bool active;
  final bool revealed;
  final bool canAnalyze;
  final bool canInterrupt;
  final VoidCallback onAnalyze;
  final VoidCallback onInterrupt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxHeight < 240) {
        return Row(
          children: [
            Expanded(
              child: Text(
                active
                    ? revealed
                          ? 'LockTarget → Pounce'
                          : 'LockTarget · structure unknown'
                    : 'No active Function',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (active && !revealed)
              FilledButton.icon(
                onPressed: canAnalyze ? onAnalyze : null,
                icon: const Icon(Icons.search),
                label: const Text('Analyze current node'),
              ),
            if (active && revealed)
              OutlinedButton.icon(
                onPressed: canInterrupt ? onInterrupt : null,
                icon: const Icon(Icons.link_off),
                label: const Text('Interrupt LockTarget'),
              ),
            IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: Text('ASHFANG FUNCTION')),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
            ],
          ),
          Expanded(
            child: Center(
              child: active
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GraphNode(
                          label: _nodeLabel('lock-target'),
                          active: true,
                        ),
                        if (revealed) ...[
                          const Icon(Icons.arrow_downward, size: 17),
                          _GraphNode(label: 'Pounce', cancelled: !canInterrupt),
                          const Text('Interrupting LockTarget cancels Pounce.'),
                        ] else
                          const Text('Further structure is not yet revealed.'),
                      ],
                    )
                  : const Text('No active Function.'),
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.icon(
                onPressed: canAnalyze ? onAnalyze : null,
                icon: const Icon(Icons.search),
                label: const Text('Analyze current node'),
              ),
              OutlinedButton.icon(
                onPressed: canInterrupt ? onInterrupt : null,
                icon: const Icon(Icons.link_off),
                label: const Text('Interrupt LockTarget'),
              ),
            ],
          ),
        ],
      );
    },
  );
}

class _GraphNode extends StatelessWidget {
  const _GraphNode({
    required this.label,
    this.active = false,
    this.cancelled = false,
  });

  final String label;
  final bool active;
  final bool cancelled;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
    decoration: BoxDecoration(
      color: active ? const Color(0xff344a73) : const Color(0xff1d2b45),
      border: Border.all(
        color: cancelled
            ? const Color(0xffffa18b)
            : active
            ? const Color(0xffffd69a)
            : const Color(0xff64799d),
        width: active ? 2 : 1,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text('$label${cancelled ? ' · cancelled' : ''}'),
  );
}

class _SpellPanel extends StatelessWidget {
  const _SpellPanel({required this.deck, required this.onClose});

  final AsyncValue<PreparedDeckOverview> deck;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          const Expanded(child: Text('PREPARED SPELL CARDS')),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
        ],
      ),
      Expanded(
        child: deck.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Cards unavailable: $error')),
          data: (value) => value.selectedSpells.isEmpty
              ? const Center(child: Text('No prepared cards.'))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.selectedSpells.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final card = value.selectedSpells[index];
                    return SizedBox(
                      width: 154,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_awesome),
                              const Spacer(),
                              Text(
                                card.name,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(card.role),
                              const SizedBox(height: 7),
                              const Text('尚無戰鬥資料'),
                              const Text(
                                '不可施放',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    ],
  );
}

class _EventLogPanel extends StatelessWidget {
  const _EventLogPanel({
    required this.eventLog,
    required this.feedback,
    required this.onClose,
  });

  final List<String> eventLog;
  final String feedback;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          const Expanded(child: Text('BATTLE LOG')),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
        ],
      ),
      Expanded(
        child: ListView(
          reverse: true,
          children: [
            for (final item in eventLog.reversed)
              ListTile(
                dense: true,
                leading: const Icon(Icons.fiber_manual_record, size: 12),
                title: Text(_eventLabel(item)),
              ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.info_outline),
              title: Text(feedback),
            ),
          ],
        ),
      ),
    ],
  );
}

class _BottomFeedback extends StatelessWidget {
  const _BottomFeedback({
    required this.feedback,
    required this.eventLog,
    required this.pendingSave,
    required this.playback,
    required this.reducedMotion,
    required this.onRetrySave,
    required this.onSkip,
    required this.onLog,
  });

  final String feedback;
  final List<String> eventLog;
  final bool pendingSave;
  final bool playback;
  final bool reducedMotion;
  final VoidCallback onRetrySave;
  final VoidCallback onSkip;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 38),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: const BoxDecoration(
      color: Color(0xff0c1427),
      border: Border(top: BorderSide(color: Color(0xff394967))),
    ),
    child: Row(
      children: [
        const Icon(Icons.chat_bubble_outline, size: 16),
        const SizedBox(width: 7),
        Expanded(
          child: Text(feedback, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (pendingSave)
          TextButton(onPressed: onRetrySave, child: const Text('Retry save'))
        else if (playback && !reducedMotion)
          TextButton(onPressed: onSkip, child: const Text('Skip')),
        TextButton.icon(
          onPressed: onLog,
          icon: const Icon(Icons.subject, size: 16),
          label: Text('Log ${eventLog.length}'),
        ),
      ],
    ),
  );
}

class _BattleResultOverlay extends StatelessWidget {
  const _BattleResultOverlay({
    required this.victory,
    required this.revealed,
    required this.cancelled,
    required this.onContinue,
  });

  final bool victory;
  final bool revealed;
  final bool cancelled;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxHeight < 150;
      final resultText = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: compact
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            victory ? 'VICTORY' : 'DEFEAT',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            victory
                ? 'Ashfang Training Construct defeated.'
                : 'Astraea Hero was defeated.',
          ),
          if (revealed && cancelled && !compact)
            const Text('LockTarget interrupted · Pounce cancelled'),
        ],
      );
      final icon = Icon(
        victory ? Icons.emoji_events_outlined : Icons.favorite_border,
        size: compact ? 32 : 38,
      );
      final continueButton = FilledButton(
        onPressed: onContinue,
        child: const Text('Continue to Adventure'),
      );

      return ColoredBox(
        color: const Color(0xdd080e1e),
        child: Center(
          child: _HudPanel(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: compact ? double.infinity : 430,
              ),
              child: Padding(
                padding: EdgeInsets.all(compact ? 6 : 20),
                child: compact
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          icon,
                          const SizedBox(width: 8),
                          Flexible(child: resultText),
                          const SizedBox(width: 8),
                          continueButton,
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          icon,
                          const SizedBox(height: 7),
                          resultText,
                          const SizedBox(height: 14),
                          continueButton,
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay({
    required this.reduceMotion,
    required this.onResume,
    required this.onToggleReducedMotion,
  });

  final bool reduceMotion;
  final VoidCallback onResume;
  final ValueChanged<bool> onToggleReducedMotion;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xdd080e1e),
    child: Center(
      child: _HudPanel(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PAUSED', style: Theme.of(context).textTheme.titleLarge),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reduce motion'),
                value: reduceMotion,
                onChanged: onToggleReducedMotion,
              ),
              FilledButton.icon(
                onPressed: onResume,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
              ),
              const SizedBox(height: 4),
              const Text('Leaving this encounter is unavailable here.'),
            ],
          ),
        ),
      ),
    ),
  );
}

class _LifecycleOverlay extends StatelessWidget {
  const _LifecycleOverlay();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Color(0xdd080e1e),
    child: Center(child: Text('戰鬥已暫停，返回遊戲後可繼續。')),
  );
}

class _RotateToLandscapeScreen extends StatelessWidget {
  const _RotateToLandscapeScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff090f20),
    body: SafeArea(
      child: Center(
        child: Semantics(
          label: '請旋轉裝置至橫向。戰鬥操作目前停用。',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.screen_rotation, size: 52),
              const SizedBox(height: 14),
              Text(
                '請旋轉裝置至橫向',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('戰鬥操作在橫向畫面啟用。'),
            ],
          ),
        ),
      ),
    ),
  );
}

class _HudPanel extends StatelessWidget {
  const _HudPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xee141f37),
      border: Border.all(color: const Color(0xff526789)),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x55000000),
          blurRadius: 12,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(padding: const EdgeInsets.all(10), child: child),
  );
}

String _combatantName(String id) => switch (id) {
  'player' => 'Hero',
  'ashfang' => 'Ashfang',
  _ => id,
};

String _nodeLabel(String? id) => switch (id) {
  'detect-target' => 'DetectTarget',
  'lock-target' => 'LockTarget',
  'pounce' => 'Pounce',
  null => 'No active node',
  _ => id,
};

String _eventLabel(String event) => switch (event) {
  'attackResolved' => 'Attack resolved',
  'criticalHit' => 'Critical hit',
  'hit' => 'Hit',
  'miss' => 'Miss',
  'defeated' => 'A combatant was defeated',
  'turnEnded' => 'Turn ended',
  'moved' => 'Movement resolved',
  'guardReaction' => 'Guard reaction resolved',
  _ => 'Battle event',
};

final class _BattleData {
  const _BattleData(
    this.content,
    this.balanceStatus,
    this.session,
    this.repository,
  );

  final Map<String, dynamic> content;
  final String balanceStatus;
  final AshfangBattleEngine session;
  final AshfangBattleRepository repository;
}
