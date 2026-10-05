import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/providers.dart';
import '../data/life_quest_repository.dart';

class LifeScreen extends ConsumerWidget {
  const LifeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(lifeQuestsProvider);
    final repository = ref.watch(lifeQuestRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Life Quests')),
      body: quests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load quests: $error')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Choose one meaningful action for today.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final quest in items)
              Card(
                child: ListTile(
                  title: Text(quest['title'] as String),
                  subtitle: Text(
                    '${quest['domain']} · ${quest['durationMinutes']} min',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/life/${quest['id']}'),
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
                              title: Text(template.title),
                              subtitle: Text(
                                '${template.domain} · ${template.durationMinutes} min',
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
              label: const Text('Add a Life Quest'),
            ),
          ],
        ),
      ),
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
      appBar: AppBar(title: const Text('Quest details')),
      body: quests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load quest: $error')),
        data: (items) {
          final quest = items
              .where((item) => item['id'] == questId)
              .firstOrNull;
          if (quest == null) {
            return const Center(child: Text('Quest not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                quest['title'] as String,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${quest['domain']} · about ${quest['durationMinutes']} minutes',
              ),
              const SizedBox(height: 16),
              const Text(
                'Self-report is always available. A timer adds lightweight evidence.',
              ),
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
                label: const Text('Start timer'),
              ),
              TextButton(
                onPressed: () => context.push(
                  '/life/complete/$questId?source=manual&completionId=${DateTime.now().microsecondsSinceEpoch}&seconds=${(quest['durationMinutes'] as int) * 60}',
                ),
                child: const Text('Complete with self-report'),
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
      appBar: AppBar(title: const Text('Quest complete')),
      body: quests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load quest: $error')),
        data: (items) {
          final quest = items
              .where((item) => item['id'] == questId)
              .firstOrNull;
          if (quest == null) {
            return const Center(child: Text('Quest not found'));
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
                      quest['title'] as String,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text('+${quote.xp} ${quest['domain']} Life XP'),
                    Text(
                      '+${quote.potential} ${_potentialLabel(quest['domain'] as String)} Potential',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timerEvidence
                          ? 'Timer evidence · bonus included'
                          : 'Self-report · private',
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
                        if (context.mounted) {
                          context.go('/life');
                        }
                      },
                      child: const Text('Confirm reward'),
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

String _potentialLabel(String domain) => switch (domain) {
  'fitness' => 'Physical',
  'learning' => 'Cognitive',
  'languages' => 'Communication',
  _ => 'Growth',
};

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
    appBar: AppBar(title: const Text('Quest timer')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Timer runs while you are away.',
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
                child: Text(_paused ? 'Resume' : 'Pause'),
              ),
              FilledButton(
                onPressed: () =>
                    context.go('/life/complete/${widget.questId}?source=timer'),
                child: const Text('Finish'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
