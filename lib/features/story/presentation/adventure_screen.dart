import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_shell.dart';
import '../../../design_system/theme/astraea_theme.dart';
import '../application/overview_providers.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class AdventureScreen extends ConsumerWidget {
  const AdventureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventure = ref.watch(adventureOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.adventure)),
      bottomNavigationBar: adventure.when(
        loading: () => null,
        error: (_, _) => null,
        data: (progress) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: FilledButton.icon(
              onPressed: () => progress.isComplete
                  ? context.push('/battle/ashfang')
                  : context.push('/story'),
              icon: Icon(
                progress.isComplete
                    ? Icons.sports_martial_arts
                    : Icons.arrow_forward_rounded,
              ),
              label: Text(
                progress.isComplete
                    ? context.l10n.startAshfangBattle
                    : context.l10n.continueAdventure,
              ),
            ),
          ),
        ),
      ),
      body: adventure.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(adventureOverviewProvider),
            child: Text(context.l10n.couldNotLoadChapterRetry),
          ),
        ),
        data: (progress) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            AstraeaSectionHeader(
              eyebrow: context.l10n.chapter01,
              title: localizedSceneTitle(context.l10n, progress.chapterSceneId),
              subtitle: context.l10n.firstStepsAcademy,
            ),
            const SizedBox(height: 18),
            _ChapterMapCard(progress: progress),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.storyPath,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  '${progress.completedScenes} / ${progress.sceneCount}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AstraeaColors.starlight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < progress.sceneCount; index++)
              _StoryStop(
                number: index + 1,
                title: [
                  context.l10n.sceneAcademyArrival,
                  context.l10n.sceneAptitudeAssessment,
                  context.l10n.sceneFunctionTheory,
                  context.l10n.sceneChantAndChantless,
                  context.l10n.scenePreparedDeck,
                ][index],
                isComplete: index < progress.completedScenes,
                isCurrent:
                    index == progress.completedScenes && !progress.isComplete,
              ),
            const SizedBox(height: 16),
            if (progress.isComplete) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(context.l10n.chapterOneComplete),
                  subtitle: Text(context.l10n.nextPracticeFunction),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.push('/function-lab'),
                icon: const Icon(Icons.account_tree_outlined),
                label: Text(context.l10n.practiceFunctionAnalysis),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home_outlined),
                label: Text(context.l10n.returnHome),
              ),
            ] else ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.push('/function-lab'),
                icon: const Icon(Icons.account_tree_outlined),
                label: Text(context.l10n.tryFunctionAnalysisTutorial),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChapterMapCard extends StatelessWidget {
  const _ChapterMapCard({required this.progress});

  final AdventureOverview progress;

  @override
  Widget build(BuildContext context) => Container(
    height: 194,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF395F8A), Color(0xFF172E4D), AstraeaColors.night],
      ),
      border: Border.all(color: const Color(0x6679A0C8)),
    ),
    child: Stack(
      children: [
        Positioned(
          right: 10,
          bottom: -18,
          child: Icon(
            Icons.castle_outlined,
            size: 176,
            color: AstraeaColors.pale.withValues(alpha: 0.12),
          ),
        ),
        Positioned(
          top: 24,
          right: 42,
          child: Icon(
            Icons.auto_awesome,
            size: 20,
            color: AstraeaColors.gold.withValues(alpha: 0.9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                context.l10n.currentObjective,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AstraeaColors.gold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                progress.currentSceneId == null
                    ? context.l10n.chapterOneComplete
                    : localizedSceneTitle(
                        context.l10n,
                        progress.currentSceneId!,
                      ),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                context.l10n.chapterProgress(
                  progress.completedScenes,
                  progress.sceneCount,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AstraeaColors.pale.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StoryStop extends StatelessWidget {
  const _StoryStop({
    required this.number,
    required this.title,
    required this.isComplete,
    required this.isCurrent,
  });

  final int number;
  final String title;
  final bool isComplete;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Card(
      color: isCurrent ? AstraeaColors.panelRaised : AstraeaColors.panel,
      child: ListTile(
        leading: CircleAvatar(
          radius: 17,
          backgroundColor: isComplete
              ? const Color(0xFF275744)
              : AstraeaColors.deepBlue,
          child: isComplete
              ? const Icon(Icons.check, size: 18, color: Color(0xFF9EE3B7))
              : Text('$number'),
        ),
        title: Text(title),
        trailing: isCurrent
            ? const Icon(Icons.play_arrow_rounded, color: AstraeaColors.gold)
            : null,
      ),
    ),
  );
}
