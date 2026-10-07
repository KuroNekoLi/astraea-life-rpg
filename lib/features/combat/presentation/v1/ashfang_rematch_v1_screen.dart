import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/theme/astraea_theme.dart';
import '../../../../game_engine/combat/v1/combat_models.dart';
import '../../../../l10n/l10n.dart';
import '../../application/ashfang_rematch_v1_provider.dart';
import '../../application/ashfang_rematch_v1_session.dart';

class AshfangRematchV1Screen extends ConsumerWidget {
  const AshfangRematchV1Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(ashfangRematchV1Provider);
    final controller = ref.read(ashfangRematchV1Provider.notifier);
    final size = MediaQuery.sizeOf(context);

    if (size.height > size.width) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                context.l10n.combatRotateDevice,
                textAlign: TextAlign.center,
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
                Flexible(
                  flex: 14,
                  child: _RematchTimeline(view: view),
                ),
                Flexible(
                  flex: 60,
                  child: _RematchBattlefield(view: view),
                ),
                Flexible(
                  flex: 26,
                  child: _RematchCommands(
                    view: view,
                    controller: controller,
                  ),
                ),
              ],
            ),
            if (view.phase == AshfangRematchPhaseV1.reactionWindow)
              _RematchReactionOverlay(
                view: view,
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }
}

class _RematchTimeline extends StatelessWidget {
  const _RematchTimeline({required this.view});

  final AshfangRematchV1ViewState view;

  @override
  Widget build(BuildContext context) {
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
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          if (view.battle.activeTurn != null)
            _TimelineChip(
              label: _actorName(context, view.battle.activeTurn!.actorId),
              active: true,
            ),
          for (final event in view.battle.timeline.take(7))
            _TimelineChip(
              label: event.type == TimelineEventType.characterTurn
                  ? context.l10n.combatTimelineTurn(
                      _actorName(context, event.actorId!),
                    )
                  : context.l10n.combatTimelineFunction,
              active: false,
            ),
          const Spacer(),
          Text(
            context.l10n.combatFreePractice,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AstraeaColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineChip extends StatelessWidget {
  const _TimelineChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
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
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _RematchBattlefield extends StatelessWidget {
  const _RematchBattlefield({required this.view});

  final AshfangRematchV1ViewState view;

  @override
  Widget build(BuildContext context) {
    final enemyCasting = view.enemyCastingFunction != null;
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.black.withValues(alpha: 0.24),
            child: Row(
              children: [
                Text(
                  context.l10n.combatEnemyIntent,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AstraeaColors.gold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    enemyCasting
                        ? context.l10n.combatRematchEnemyCasting
                        : context.l10n.combatRematchEnemyPressure,
                  ),
                ),
                if (enemyCasting)
                  Text(
                    view.rioKnowledge?.knownStability == null
                        ? context.l10n.combatStabilityUnknown
                        : context.l10n.combatStabilityValue(
                            view.rioKnowledge!.knownStability!,
                          ),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AstraeaColors.starlight,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.2, 0.1),
                        radius: 1.2,
                        colors: [
                          AstraeaColors.starlight.withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.65, 0.35),
                  child: _BattleActor(
                    name: context.l10n.combatHero,
                    actor: view.battle.actor('hero'),
                    icon: Icons.auto_awesome,
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.28, 0.60),
                  child: _BattleActor(
                    name: context.l10n.combatYuma,
                    actor: view.battle.actor('yuma'),
                    icon: Icons.shield_outlined,
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.08, 0.20),
                  child: _BattleActor(
                    name: context.l10n.combatRio,
                    actor: view.battle.actor('rio'),
                    icon: Icons.visibility_outlined,
                  ),
                ),
                Align(
                  alignment: const Alignment(0.58, -0.02),
                  child: _BattleActor(
                    name: context.l10n.combatAshfang,
                    actor: view.battle.actor('ashfang'),
                    icon: Icons.pets,
                    hostile: true,
                  ),
                ),
                if (enemyCasting)
                  Align(
                    alignment: const Alignment(0.22, -0.35),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: view.weakNodeRevealed
                              ? AstraeaColors.gold
                              : AstraeaColors.starlight,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AstraeaColors.starlight.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Icon(
                        view.weakNodeRevealed
                            ? Icons.hub_outlined
                            : Icons.blur_circular,
                        color: view.weakNodeRevealed
                            ? AstraeaColors.gold
                            : AstraeaColors.starlight,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFF0A1B30),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              context.l10n.combatRematchSubtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AstraeaColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BattleActor extends StatelessWidget {
  const _BattleActor({
    required this.name,
    required this.actor,
    required this.icon,
    this.hostile = false,
  });

  final String name;
  final CombatantStateV1 actor;
  final IconData icon;
  final bool hostile;

  @override
  Widget build(BuildContext context) {
    final accent = hostile
        ? Theme.of(context).colorScheme.error
        : AstraeaColors.starlight;
    return Container(
      width: 116,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AstraeaColors.panel.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
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

class _RematchCommands extends StatelessWidget {
  const _RematchCommands({
    required this.view,
    required this.controller,
  });

  final AshfangRematchV1ViewState view;
  final AshfangRematchV1Controller controller;

  @override
  Widget build(BuildContext context) {
    if (view.phase == AshfangRematchPhaseV1.victory ||
        view.phase == AshfangRematchPhaseV1.defeat) {
      final victory = view.phase == AshfangRematchPhaseV1.victory;
      return Container(
        color: const Color(0xFF0B1D34),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              victory
                  ? context.l10n.combatRematchVictoryTitle
                  : context.l10n.combatRematchDefeatTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: victory
                    ? AstraeaColors.gold
                    : Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              victory
                  ? context.l10n.combatRematchVictoryBody
                  : context.l10n.combatRematchDefeatBody,
            ),
            const Spacer(),
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

    final actorId = view.activePlayerId;
    final actor = actorId == null ? null : view.battle.actor(actorId);

    return Container(
      color: const Color(0xFF0B1D34),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.combatRematchTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (actor != null) ...[
            Text(
              context.l10n.combatRematchPlayerTurn(
                _actorName(context, actorId!),
              ),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AstraeaColors.starlight,
              ),
            ),
            const SizedBox(height: 4),
            Text(context.l10n.combatHp(actor.hp, actor.maxHp)),
            Text(context.l10n.combatMana(actor.mana, actor.maxMana)),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: controller.basicAttack,
              icon: const Icon(Icons.gps_fixed),
              label: Text(context.l10n.combatRematchBasicAttack),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: controller.guard,
              icon: const Icon(Icons.shield_outlined),
              label: Text(context.l10n.combatRematchGuard),
            ),
            if (actorId == 'hero') ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: controller.castHeroFireballI,
                icon: const Icon(Icons.local_fire_department_outlined),
                label: Text(context.l10n.combatRematchFireballI),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: controller.beginHeroFireballIIFullChant,
                icon: const Icon(Icons.auto_awesome),
                label: Text(context.l10n.combatRematchFireballII),
              ),
            ],
            if (actorId == 'rio') ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: view.enemyCastingFunction == null
                    ? null
                    : controller.analyzeEnemyFunction,
                icon: const Icon(Icons.search),
                label: Text(context.l10n.combatRematchAnalyze),
              ),
              const SizedBox(height: 6),
              Text(
                view.enemyCastingFunction == null
                    ? context.l10n.combatRematchNoCastingHint
                    : context.l10n.combatRematchCastingHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AstraeaColors.muted,
                ),
              ),
            ],
          ] else ...[
            const Spacer(),
            Text(
              context.l10n.combatRematchCastingHint,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}

class _RematchReactionOverlay extends StatelessWidget {
  const _RematchReactionOverlay({
    required this.view,
    required this.controller,
  });

  final AshfangRematchV1ViewState view;
  final AshfangRematchV1Controller controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              color: const Color(0xFF102847),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.combatRematchReactionTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AstraeaColors.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      view.weakNodeRevealed
                          ? context.l10n.combatRematchReactionBodyKnown
                          : context.l10n.combatRematchReactionBodyUnknown,
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: () =>
                          controller.interruptEnemyFunction(),
                      icon: const Icon(Icons.bolt),
                      label: Text(context.l10n.combatRematchInterrupt),
                    ),
                    if (view.weakNodeRevealed) ...[
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: () => controller.interruptEnemyFunction(
                          exploitWeakNode: true,
                        ),
                        icon: const Icon(Icons.hub_outlined),
                        label: Text(
                          context.l10n.combatRematchExploitWeakNode,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: controller.saveReaction,
                      child: Text(context.l10n.combatRematchSaveReaction),
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

String _actorName(BuildContext context, String id) => switch (id) {
  'hero' => context.l10n.combatHero,
  'rio' => context.l10n.combatRio,
  'yuma' => context.l10n.combatYuma,
  'ashfang' => context.l10n.combatAshfang,
  _ => id,
};
