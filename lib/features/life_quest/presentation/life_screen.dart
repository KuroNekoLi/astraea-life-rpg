import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../character/application/training_preview_provider.dart';
import '../application/providers.dart';
import '../data/life_quest_repository.dart';
import '../../../design_system/theme/astraea_theme.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class LifeScreen extends ConsumerStatefulWidget {
  const LifeScreen({super.key});

  @override
  ConsumerState<LifeScreen> createState() => _LifeScreenState();
}

class _LifeScreenState extends ConsumerState<LifeScreen> {
  String _selectedDomain = 'All';

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final quests = ref.watch(lifeQuestsProvider);
    final repository = ref.watch(lifeQuestRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.lifeQuest)),
      body: quests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(context.l10n.couldNotLoadQuests('$error'))),
        data: (items) {
          final filtered = _selectedDomain == 'All'
              ? items
              : items
                    .where((quest) => quest['domain'] == _selectedDomain)
                    .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                context.l10n.today,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AstraeaColors.starlight,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                context.l10n.chooseWhatFitsYourDay,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.progressAlwaysHere,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AstraeaColors.muted),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final domain in [
                      'All',
                      'fitness',
                      'learning',
                      'languages',
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            domain == 'All'
                                ? context.l10n.domainAll
                                : localizedDomain(context.l10n, domain),
                          ),
                          selected: _selectedDomain == domain,
                          onSelected: (_) =>
                              setState(() => _selectedDomain = domain),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.availableQuestCount(filtered.length),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AstraeaColors.muted),
              ),
              const SizedBox(height: 8),
              for (final quest in filtered)
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    leading: _LifeDomainIcon(domain: quest['domain'] as String),
                    title: Text(
                      localizedQuestTitle(context.l10n, quest['id'] as String),
                    ),
                    subtitle: Text(
                      context.l10n.questMetaShort(
                        localizedDomain(
                          context.l10n,
                          quest['domain'] as String,
                        ),
                        quest['durationMinutes'] as int,
                      ),
                    ),
                    trailing: FilledButton.tonal(
                      onPressed: () => context.push('/life/${quest['id']}'),
                      child: Text(context.l10n.commonStart),
                    ),
                    onTap: () => context.push('/life/${quest['id']}'),
                  ),
                ),
              if (filtered.isEmpty)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.spa_outlined),
                    title: Text(context.l10n.noQuestsCategory),
                    subtitle: Text(context.l10n.addWhenReady),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final repo = repository.asData?.value;
                  if (repo == null) return;
                  final templates = await repo.templates();
                  if (context.mounted) {
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (sheetContext) => SafeArea(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (final template in templates)
                              ListTile(
                                title: Text(
                                  localizedQuestTitle(
                                    sheetContext.l10n,
                                    template.id,
                                  ),
                                ),
                                subtitle: Text(
                                  sheetContext.l10n.questMetaShort(
                                    localizedDomain(
                                      sheetContext.l10n,
                                      template.domain,
                                    ),
                                    template.durationMinutes,
                                  ),
                                ),
                                onTap: () async {
                                  await repo.addQuest(template);
                                  ref.invalidate(lifeQuestsProvider);
                                  if (sheetContext.mounted) {
                                    Navigator.pop(sheetContext);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(context.l10n.addLifeQuest),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LifeDomainIcon extends StatelessWidget {
  const _LifeDomainIcon({required this.domain});

  final String domain;

  @override
  Widget build(BuildContext context) {
    final color = switch (domain) {
      'fitness' => const Color(0xFF8EE0BE),
      'learning' => AstraeaColors.starlight,
      'languages' => const Color(0xFFC7ADFF),
      _ => AstraeaColors.gold,
    };
    final icon = switch (domain) {
      'fitness' => Icons.directions_walk,
      'learning' => Icons.menu_book_outlined,
      'languages' => Icons.translate,
      _ => Icons.favorite_outline,
    };
    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.16),
      child: Icon(icon, color: color),
    );
  }
}

class LifeQuestDetailScreen extends ConsumerWidget {
  const LifeQuestDetailScreen({required this.questId, super.key});
  final String questId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(lifeQuestsProvider);
    final repository = ref.watch(lifeQuestRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.questDetails)),
      body: quests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(context.l10n.couldNotLoadQuest('$error'))),
        data: (items) {
          final quest = items
              .where((item) => item['id'] == questId)
              .firstOrNull;
          if (quest == null) {
            return Center(child: Text(context.l10n.questNotFound));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                localizedQuestTitle(context.l10n, quest['id'] as String),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.questAboutMinutes(
                  localizedDomain(context.l10n, quest['domain'] as String),
                  quest['durationMinutes'] as int,
                ),
              ),
              const SizedBox(height: 16),
              Text(context.l10n.selfReportTimerEvidence),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  final repo = repository.asData?.value;
                  if (repo == null) return;
                  await repo.startTimer(questId);
                  if (context.mounted) {
                    context.push('/life/timer/$questId');
                  }
                },
                icon: const Icon(Icons.timer_outlined),
                label: Text(context.l10n.startTimer),
              ),
              TextButton(
                onPressed: () => context.push(
                  '/life/complete/$questId?source=manual&completionId=${DateTime.now().microsecondsSinceEpoch}&seconds=${(quest['durationMinutes'] as int) * 60}',
                ),
                child: Text(context.l10n.completeSelfReport),
              ),
            ],
          );
        },
      ),
    );
  }
}

class QuestCompletionScreen extends ConsumerWidget {
  const QuestCompletionScreen({
    required this.questId,
    required this.timerEvidence,
    required this.completionId,
    required this.durationSeconds,
    super.key,
  });
  final String questId;
  final bool timerEvidence;
  final String completionId;
  final int durationSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(lifeQuestsProvider);
    final repository = ref.watch(lifeQuestRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.questComplete)),
      body: quests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(context.l10n.couldNotLoadQuest('$error'))),
        data: (items) {
          final quest = items
              .where((item) => item['id'] == questId)
              .firstOrNull;
          if (quest == null) {
            return Center(child: Text(context.l10n.questNotFound));
          }
          final repo = repository.asData?.value;
          if (repo == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return FutureBuilder<RewardQuote>(
            future: repo.quote(
              durationMinutes: durationSeconds ~/ 60,
              timerEvidence: timerEvidence,
              domain: quest['domain'] as String,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final quote = snapshot.requireData;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedQuestTitle(context.l10n, quest['id'] as String),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.lifeXpReward(
                        quote.xp,
                        localizedDomain(
                          context.l10n,
                          quest['domain'] as String,
                        ),
                      ),
                    ),
                    Text(
                      context.l10n.potentialReward(
                        quote.potential,
                        localizedPotentialForDomain(
                          context.l10n,
                          quest['domain'] as String,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timerEvidence
                          ? context.l10n.timerEvidenceBonus
                          : context.l10n.selfReportPrivate,
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () async {
                        final repo = repository.asData?.value;
                        if (repo == null) return;
                        await repo.complete(
                          quest: quest,
                          completionId: completionId,
                          duration: Duration(seconds: durationSeconds),
                          timerEvidence: timerEvidence,
                          confirmReward: true,
                        );
                        ref.invalidate(lifeQuestsProvider);
                        ref.invalidate(trainingGoldenPathProvider);
                        ref.invalidate(trainingPotentialProvider);
                        if (context.mounted) {
                          context.go('/training');
                        }
                      },
                      child: Text(context.l10n.confirmReward),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LifeQuestTimerScreen extends ConsumerStatefulWidget {
  const LifeQuestTimerScreen({required this.questId, super.key});
  final String questId;

  @override
  ConsumerState<LifeQuestTimerScreen> createState() =>
      _LifeQuestTimerScreenState();
}

class _LifeQuestTimerScreenState extends ConsumerState<LifeQuestTimerScreen> {
  DateTime? _startedAt;
  bool _paused = false;
  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final repo = await ref.read(lifeQuestRepositoryProvider.future);
    final timer = await repo.activeTimer();
    if (mounted && timer != null) {
      setState(() {
        _startedAt = DateTime.parse(timer['startedAt'] as String);
        _paused = timer['status'] == 'paused';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.questTimer)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.timerRunsAway,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          if (_startedAt != null)
            StreamBuilder<DateTime>(
              stream: Stream<DateTime>.periodic(
                const Duration(seconds: 1),
                (_) => DateTime.now(),
              ).distinct(),
              builder: (context, snapshot) {
                final elapsed = _paused
                    ? Duration.zero
                    : (snapshot.data ?? DateTime.now()).difference(_startedAt!);
                final seconds = elapsed.inSeconds.clamp(0, 999999);
                return Text(
                  '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.displayMedium,
                );
              },
            ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final repo = await ref.read(
                    lifeQuestRepositoryProvider.future,
                  );
                  if (_paused) {
                    await repo.resumeTimer();
                  } else {
                    await repo.pauseTimer();
                  }
                  if (mounted) setState(() => _paused = !_paused);
                },
                child: Text(
                  _paused
                      ? context.l10n.commonResume
                      : context.l10n.commonPause,
                ),
              ),
              FilledButton(
                onPressed: () =>
                    context.go('/life/complete/${widget.questId}?source=timer'),
                child: Text(context.l10n.commonFinish),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
