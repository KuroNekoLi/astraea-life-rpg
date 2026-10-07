import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/theme/astraea_theme.dart';
import '../../../../game_engine/combat/v1/combat_models.dart';
import '../../../../l10n/l10n.dart';
import '../../application/ashfang_combat_v1_provider.dart';
import '../../application/ashfang_combat_v1_session.dart';

class AshfangCombatV1Screen extends ConsumerWidget {
  const AshfangCombatV1Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(ashfangCombatV1Provider);
    final controller = ref.read(ashfangCombatV1Provider.notifier);
    final size = MediaQuery.sizeOf(context);

    if (size.height > size.width) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.screen_rotation, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.combatRotateDevice,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AstraeaColors.night,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Flexible(flex: 14, child: _TimelineRail(view: view)),
                Flexible(flex: 60, child: _Battlefield(view: view)),
                Flexible(
                  flex: 26,
                  child: _ContextPanel(view: view, controller: controller),
                ),
              ],
            ),
            if (view.stage == AshfangTutorialStageV1.knownReaction ||
                view.stage == AshfangTutorialStageV1.modifiedInterrupt)
              _ReactionOverlay(view: view, controller: controller),
          ],
        ),
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.view});
  final AshfangCombatV1ViewState view;

  @override
  Widget build(BuildContext context) {
    final events = view.battle.timeline.take(6).toList(growable: false);
    return Container(
      color: const Color(0xFF09192D),
      padding: const EdgeInsets.fromLTRB(12, 16, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.combatActionTimeline,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AstraeaColors.starlight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          if (view.battle.activeTurn != null)
            _TimelineItem(
              label: _actorName(context, view.battle.activeTurn!.actorId),
              active: true,
              icon: Icons.play_arrow_rounded,
            ),
          for (final event in events)
            _TimelineItem(
              label: _timelineLabel(context, view.battle, event),
              active: false,
              icon: event.type == TimelineEventType.characterTurn
                  ? Icons.circle_outlined
                  : Icons.auto_awesome,
            ),
          const Spacer(),
          Text(
            context.l10n.combatTrainingArena,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AstraeaColors.muted),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.label,
    required this.active,
    required this.icon,
  });

  final String label;
  final bool active;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: active ? AstraeaColors.panelRaised : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? AstraeaColors.starlight.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: active ? AstraeaColors.starlight : AstraeaColors.muted,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Battlefield extends StatelessWidget {
  const _Battlefield({required this.view});
  final AshfangCombatV1ViewState view;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF102647), Color(0xFF071426)],
        ),
      ),
      child: Column(
        children: [
          _EnemyIntentRibbon(view: view),
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(child: _ArcaneFieldPainter()),
                Positioned(
                  top: 14,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      context.l10n.combatZoneMid,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AstraeaColors.muted.withValues(alpha: 0.7),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.70, 0.36),
                  child: _ActorToken(
                    name: context.l10n.combatHero,
                    actor: view.battle.actor('hero'),
                    icon: Icons.auto_awesome,
                    active: view.battle.activeTurn?.actorId == 'hero',
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.38, 0.62),
                  child: _ActorToken(
                    name: context.l10n.combatYuma,
                    actor: view.battle.actor('yuma'),
                    icon: Icons.shield_outlined,
                    active: view.battle.activeTurn?.actorId == 'yuma',
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.12, 0.28),
                  child: _ActorToken(
                    name: context.l10n.combatRio,
                    actor: view.battle.actor('rio'),
                    icon: Icons.visibility_outlined,
                    active: view.battle.activeTurn?.actorId == 'rio',
                  ),
                ),
                Align(
                  alignment: const Alignment(0.58, -0.04),
                  child: _ActorToken(
                    name: context.l10n.combatAshfang,
                    actor: view.battle.actor('ashfang'),
                    icon: Icons.pets,
                    active: view.battle.activeTurn?.actorId == 'ashfang',
                    hostile: true,
                    casting: view.enemyCastingFunction != null,
                  ),
                ),
                if (view.enemyCastingFunction != null)
                  Align(
                    alignment: const Alignment(0.18, -0.35),
                    child: _FunctionOrb(revealed: view.weakNodeRevealed),
                  ),
              ],
            ),
          ),
          _FeedbackBar(view: view),
          _PartyStatusStrip(view: view),
        ],
      ),
    );
  }
}

class _EnemyIntentRibbon extends StatelessWidget {
  const _EnemyIntentRibbon({required this.view});
  final AshfangCombatV1ViewState view;

  @override
  Widget build(BuildContext context) {
    final intent = switch (view.stage) {
      AshfangTutorialStageV1.knownReaction =>
        context.l10n.combatIntentKnownFireball,
      AshfangTutorialStageV1.modifiedAnalysis ||
      AshfangTutorialStageV1.modifiedInterrupt =>
        context.l10n.combatIntentModifiedFireball,
      AshfangTutorialStageV1.heroFullChant =>
        context.l10n.combatIntentHeroFullChant,
      AshfangTutorialStageV1.heroFinisher => context.l10n.combatIntentFinisher,
      AshfangTutorialStageV1.victory => context.l10n.combatIntentVictory,
      _ => context.l10n.combatIntentHeroTurn,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.combatEnemyIntent,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AstraeaColors.gold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(intent, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (view.enemyCastingFunction != null) ...[
            const SizedBox(width: 12),
            Text(
              view.rioKnowledge?.knownStability == null
                  ? context.l10n.combatStabilityUnknown
                  : context.l10n.combatStabilityValue(
                      view.rioKnowledge!.knownStability!,
                    ),
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AstraeaColors.starlight),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActorToken extends StatelessWidget {
  const _ActorToken({
    required this.name,
    required this.actor,
    required this.icon,
    required this.active,
    this.hostile = false,
    this.casting = false,
  });

  final String name;
  final CombatantStateV1 actor;
  final IconData icon;
  final bool active;
  final bool hostile;
  final bool casting;

  @override
  Widget build(BuildContext context) {
    final accent = hostile
        ? const Color(0xFFFF9A9F)
        : active
        ? AstraeaColors.gold
        : AstraeaColors.starlight;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 118,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AstraeaColors.panel.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accent.withValues(alpha: active || casting ? 0.8 : 0.32),
          width: active || casting ? 2 : 1,
        ),
        boxShadow: [
          if (active || casting)
            BoxShadow(color: accent.withValues(alpha: 0.18), blurRadius: 18),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 30),
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: actor.maxHp == 0 ? 0 : actor.hp / actor.maxHp,
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}

class _FunctionOrb extends StatelessWidget {
  const _FunctionOrb({required this.revealed});
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: revealed
              ? AstraeaColors.gold
              : AstraeaColors.starlight.withValues(alpha: 0.7),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AstraeaColors.starlight.withValues(alpha: 0.20),
            blurRadius: 28,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          revealed ? Icons.hub_outlined : Icons.blur_circular,
          color: revealed ? AstraeaColors.gold : AstraeaColors.starlight,
          size: 34,
        ),
      ),
    );
  }
}

class _FeedbackBar extends StatelessWidget {
  const _FeedbackBar({required this.view});
  final AshfangCombatV1ViewState view;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.22),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        _feedbackText(context, view.feedback),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AstraeaColors.pale),
      ),
    );
  }
}

class _PartyStatusStrip extends StatelessWidget {
  const _PartyStatusStrip({required this.view});
  final AshfangCombatV1ViewState view;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(color: Color(0xFF0A1B30)),
      child: Row(
        children: [
          for (final id in const ['hero', 'yuma', 'rio'])
            Expanded(
              child: _PartyStatus(
                name: _actorName(context, id),
                actor: view.battle.actor(id),
              ),
            ),
        ],
      ),
    );
  }
}

class _PartyStatus extends StatelessWidget {
  const _PartyStatus({required this.name, required this.actor});
  final String name;
  final CombatantStateV1 actor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Icon(
                actor.reactionAvailable ? Icons.bolt : Icons.bolt_outlined,
                size: 14,
                color: actor.reactionAvailable
                    ? AstraeaColors.gold
                    : AstraeaColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: actor.hp / actor.maxHp, minHeight: 4),
          const SizedBox(height: 3),
          Text(
            context.l10n.combatMana(actor.mana, actor.maxMana),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AstraeaColors.muted),
          ),
        ],
      ),
    );
  }
}

class _ContextPanel extends StatelessWidget {
  const _ContextPanel({required this.view, required this.controller});

  final AshfangCombatV1ViewState view;
  final AshfangCombatV1Controller controller;

  @override
  Widget build(BuildContext context) {
    final actorId = switch (view.stage) {
      AshfangTutorialStageV1.modifiedAnalysis ||
      AshfangTutorialStageV1.modifiedInterrupt ||
      AshfangTutorialStageV1.knownReaction => 'rio',
      _ => 'hero',
    };
    final actor = view.battle.actor(actorId);

    return Container(
      color: const Color(0xFF0B1D34),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.combatCurrentActor,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AstraeaColors.muted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _actorName(context, actorId),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(context.l10n.combatHp(actor.hp, actor.maxHp)),
          Text(context.l10n.combatMana(actor.mana, actor.maxMana)),
          Text(
            actor.reactionAvailable
                ? context.l10n.combatReactionReady
                : context.l10n.combatReactionSpent,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: actor.reactionAvailable
                  ? AstraeaColors.gold
                  : AstraeaColors.muted,
            ),
          ),
          const SizedBox(height: 14),
          _RootCommands(stage: view.stage),
          const SizedBox(height: 14),
          Expanded(
            child: _StageAction(view: view, controller: controller),
          ),
        ],
      ),
    );
  }
}

class _RootCommands extends StatelessWidget {
  const _RootCommands({required this.stage});
  final AshfangTutorialStageV1 stage;

  @override
  Widget build(BuildContext context) {
    final selected = switch (stage) {
      AshfangTutorialStageV1.modifiedAnalysis => 'analyze',
      AshfangTutorialStageV1.heroChantless ||
      AshfangTutorialStageV1.heroFullChant ||
      AshfangTutorialStageV1.heroFinisher => 'sc',
      _ => '',
    };
    final items = [
      ('attack', context.l10n.combatAttack, Icons.gps_fixed),
      ('technique', context.l10n.combatTechnique, Icons.flash_on_outlined),
      ('sc', context.l10n.combatSc, Icons.style_outlined),
      ('analyze', context.l10n.combatAnalyze, Icons.search),
      ('guard', context.l10n.combatGuard, Icons.shield_outlined),
      ('move', context.l10n.combatMove, Icons.open_with),
    ];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final item in items)
          SizedBox(
            width: 92,
            child: OutlinedButton.icon(
              onPressed: item.$1 == selected ? () {} : null,
              icon: Icon(item.$3, size: 16),
              label: Text(
                item.$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: item.$1 == selected
                  ? OutlinedButton.styleFrom(
                      side: const BorderSide(color: AstraeaColors.starlight),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}

class _StageAction extends StatelessWidget {
  const _StageAction({required this.view, required this.controller});
  final AshfangCombatV1ViewState view;
  final AshfangCombatV1Controller controller;

  @override
  Widget build(BuildContext context) {
    return switch (view.stage) {
      AshfangTutorialStageV1.heroChantless => _ActionCard(
        title: context.l10n.combatTutorialChantlessTitle,
        body: context.l10n.combatTutorialChantlessBody,
        badges: [context.l10n.combatFireballI, context.l10n.combatChantless],
        actionLabel: context.l10n.combatCastFireballI,
        onPressed: controller.heroFireballIChantless,
      ),
      AshfangTutorialStageV1.modifiedAnalysis => _AnalysisAction(
        view: view,
        controller: controller,
      ),
      AshfangTutorialStageV1.heroFullChant => _ActionCard(
        title: context.l10n.combatFullChantTitle,
        body: context.l10n.combatFullChantBody,
        badges: [context.l10n.combatFireballII, context.l10n.combatFullChant],
        actionLabel: context.l10n.combatBeginFullChant,
        onPressed: controller.beginHeroFireballIIFullChant,
      ),
      AshfangTutorialStageV1.heroFinisher => _ActionCard(
        title: context.l10n.combatFinisherTitle,
        body: context.l10n.combatFinisherBody,
        badges: [context.l10n.combatFireballI, context.l10n.combatChantless],
        actionLabel: context.l10n.combatFinishFireballI,
        onPressed: controller.finishWithFireballI,
      ),
      AshfangTutorialStageV1.victory => _VictoryPanel(controller: controller),
      AshfangTutorialStageV1.defeat => _VictoryPanel(controller: controller),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.body,
    required this.badges,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String body;
  final List<String> badges;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AstraeaColors.panel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AstraeaColors.muted),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final badge in badges) Chip(label: Text(badge))],
            ),
            const SizedBox(height: 14),
            FilledButton(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _AnalysisAction extends StatelessWidget {
  const _AnalysisAction({required this.view, required this.controller});
  final AshfangCombatV1ViewState view;
  final AshfangCombatV1Controller controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AstraeaColors.panel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AstraeaColors.starlight.withValues(alpha: 0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.combatModifiedAnalysisTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.combatModifiedAnalysisBody,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AstraeaColors.muted),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.combatFunctionStructure,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            _MiniFunctionGraph(revealed: view.weakNodeRevealed),
            const SizedBox(height: 10),
            Text(
              view.weakNodeRevealed
                  ? context.l10n.combatStructureRevealed
                  : context.l10n.combatStructureUnknown,
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: controller.analyzeModifiedFireball,
              icon: const Icon(Icons.search),
              label: Text(context.l10n.combatAnalyzeModified),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniFunctionGraph extends StatelessWidget {
  const _MiniFunctionGraph({required this.revealed});
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    final normal = AstraeaColors.starlight.withValues(alpha: 0.65);
    final weak = AstraeaColors.gold;
    return Row(
      children: [
        _GraphNode(color: normal),
        Expanded(child: Divider(color: normal)),
        _GraphNode(color: revealed ? weak : normal),
        Expanded(child: Divider(color: normal)),
        _GraphNode(color: normal),
      ],
    );
  }
}

class _GraphNode extends StatelessWidget {
  const _GraphNode({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 10),
        ],
      ),
    );
  }
}

class _ReactionOverlay extends StatelessWidget {
  const _ReactionOverlay({required this.view, required this.controller});
  final AshfangCombatV1ViewState view;
  final AshfangCombatV1Controller controller;

  @override
  Widget build(BuildContext context) {
    final modified = view.stage == AshfangTutorialStageV1.modifiedInterrupt;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Card(
              color: const Color(0xFF102847),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      modified
                          ? context.l10n.combatModifiedReactionTitle
                          : context.l10n.combatKnownReactionTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AstraeaColors.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      modified
                          ? context.l10n.combatModifiedReactionBody
                          : context.l10n.combatKnownReactionBody,
                    ),
                    const SizedBox(height: 12),
                    if (modified)
                      Text(context.l10n.combatWeakNodeStabilization),
                    Text(
                      modified
                          ? context.l10n.combatStabilityValue(58)
                          : context.l10n.combatStabilityValue(42),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AstraeaColors.starlight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: modified
                          ? controller.interruptModifiedWeakNode
                          : controller.interruptKnownFireball,
                      icon: const Icon(Icons.bolt),
                      label: Text(context.l10n.combatInterrupt),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: modified
                          ? controller.allowModifiedFireballToResolve
                          : controller.saveKnownReaction,
                      child: Text(context.l10n.combatSaveReaction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VictoryPanel extends StatelessWidget {
  const _VictoryPanel({required this.controller});
  final AshfangCombatV1Controller controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AstraeaColors.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AstraeaColors.gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.combatVictoryTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AstraeaColors.gold),
          ),
          const SizedBox(height: 8),
          Text(context.l10n.combatVictoryBody),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: controller.reset,
            child: Text(context.l10n.combatRestart),
          ),
          TextButton(
            onPressed: () => context.go('/adventure'),
            child: Text(context.l10n.combatReturnAdventure),
          ),
        ],
      ),
    );
  }
}

class _ArcaneFieldPainter extends StatelessWidget {
  const _ArcaneFieldPainter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ArcanePainter());
  }
}

class _ArcanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = AstraeaColors.starlight.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final glow = Paint()
      ..color = AstraeaColors.starlight.withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.55, size.height * 0.52),
        width: size.width * 0.72,
        height: size.height * 0.55,
      ),
      line,
    );
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.52),
      math.min(size.width, size.height) * 0.18,
      line,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.68, size.width, size.height * 0.32),
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcanePainter oldDelegate) => false;
}

String _actorName(BuildContext context, String id) => switch (id) {
  'hero' => context.l10n.combatHero,
  'rio' => context.l10n.combatRio,
  'yuma' => context.l10n.combatYuma,
  'ashfang' => context.l10n.combatAshfang,
  _ => id,
};

String _spellName(BuildContext context, String id) => switch (id) {
  'known-fireball' => context.l10n.combatKnownFireball,
  'modified-fireball' => context.l10n.combatModifiedFireball,
  'fireball-i' => context.l10n.combatFireballI,
  'fireball-ii' => context.l10n.combatFireballII,
  _ => context.l10n.combatUnknownFunction,
};

String _timelineLabel(
  BuildContext context,
  BattleStateV1 battle,
  TimelineEventV1 event,
) {
  if (event.type == TimelineEventType.characterTurn) {
    return context.l10n.combatTimelineTurn(_actorName(context, event.actorId!));
  }

  ActiveFunctionV1? function;
  if (event.functionId != null) {
    for (final candidate in battle.activeFunctions) {
      if (candidate.id == event.functionId) {
        function = candidate;
        break;
      }
    }
  }

  if (event.type == TimelineEventType.spellResolve && function != null) {
    return context.l10n.combatTimelineResolve(
      _spellName(context, function.actionId),
    );
  }
  return context.l10n.combatTimelineFunction;
}

String _feedbackText(
  BuildContext context,
  AshfangTutorialFeedbackV1 feedback,
) => switch (feedback) {
  AshfangTutorialFeedbackV1.opening => context.l10n.combatFeedbackOpening,
  AshfangTutorialFeedbackV1.heroChantlessResolved =>
    context.l10n.combatFeedbackHeroChantless,
  AshfangTutorialFeedbackV1.knownFireballCasting =>
    context.l10n.combatFeedbackKnownCasting,
  AshfangTutorialFeedbackV1.knownFireballInterrupted =>
    context.l10n.combatFeedbackKnownInterrupted,
  AshfangTutorialFeedbackV1.knownFireballResolved =>
    context.l10n.combatFeedbackKnownResolved,
  AshfangTutorialFeedbackV1.modifiedFireballCasting =>
    context.l10n.combatFeedbackModifiedCasting,
  AshfangTutorialFeedbackV1.analysisRevealedWeakNode =>
    context.l10n.combatFeedbackAnalysisWeakNode,
  AshfangTutorialFeedbackV1.modifiedFireballInterrupted =>
    context.l10n.combatFeedbackModifiedInterrupted,
  AshfangTutorialFeedbackV1.modifiedFireballResolved =>
    context.l10n.combatFeedbackModifiedResolved,
  AshfangTutorialFeedbackV1.heroFullChantCasting =>
    context.l10n.combatFeedbackHeroFullChantCasting,
  AshfangTutorialFeedbackV1.heroFullChantResolved =>
    context.l10n.combatFeedbackHeroFullChantResolved,
  AshfangTutorialFeedbackV1.victory => context.l10n.combatFeedbackVictory,
  AshfangTutorialFeedbackV1.defeat => context.l10n.combatFeedbackDefeat,
};
