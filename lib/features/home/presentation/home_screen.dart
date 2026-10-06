import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_shell.dart';
import '../../../core/measurement/prototype_event_recorder.dart';
import '../../../app/app_providers.dart';
import '../../../design_system/theme/astraea_theme.dart';
import '../../character/application/training_preview_provider.dart';
import '../../life_quest/application/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      titleSpacing: 20,
      title: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AstraeaColors.gold, size: 20),
          const SizedBox(width: 8),
          Text(
            'ASTRAEA',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              letterSpacing: 2.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'LIFE × RPG',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AstraeaColors.muted,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Character profile',
          onPressed: () => context.go('/character'),
          icon: const CircleAvatar(
            radius: 17,
            backgroundColor: AstraeaColors.panelRaised,
            child: Icon(Icons.person, size: 20),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          AstraeaHeroPanel(
            eyebrow: 'Astraea Academy · Chapter 01',
            title: 'One real action starts your journey.',
            description:
                'Choose a Life Quest, earn Growth Potential, and shape the hero who explores Astraea.',
            icon: Icons.favorite_outline,
            actionLabel: 'Choose a Life Quest',
            onPressed: () => context.go('/life'),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR JOURNEY',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                'Continue your journey',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AstraeaColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _JourneyGrid(),
          const SizedBox(height: 22),
          _TodayQuests(ref: ref),
          const SizedBox(height: 16),
          _GrowthReady(ref: ref),
          const SizedBox(height: 16),
          const _PilotMeasurementControl(),
        ],
      ),
    ),
  );
}

class _JourneyGrid extends StatelessWidget {
  const _JourneyGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = (constraints.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _JourneyCard(
            width: width,
            icon: Icons.favorite_outline,
            title: 'Life Quests',
            subtitle: 'Start with one real action',
            color: const Color(0xFFFFB5C7),
            onTap: () => context.go('/life'),
          ),
          _JourneyCard(
            width: width,
            icon: Icons.auto_awesome,
            title: 'Adventure',
            subtitle: 'Story & objectives',
            color: AstraeaColors.starlight,
            onTap: () => context.go('/adventure'),
          ),
          _JourneyCard(
            width: width,
            icon: Icons.person_outline,
            title: 'Character',
            subtitle: 'Your growing build',
            color: AstraeaColors.gold,
            onTap: () => context.go('/character'),
          ),
          _JourneyCard(
            width: width,
            icon: Icons.style_outlined,
            title: 'Prepared Deck',
            subtitle: 'Six spells',
            color: const Color(0xFFC3ADFF),
            onTap: () => context.go('/deck'),
          ),
        ],
      );
    },
  );
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.13),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AstraeaColors.muted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _TodayQuests extends StatelessWidget {
  const _TodayQuests({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final quests = ref.watch(lifeQuestsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TODAY', style: Theme.of(context).textTheme.labelLarge),
            TextButton(
              onPressed: () => context.go('/life'),
              child: const Text('All Quests'),
            ),
          ],
        ),
        quests.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => const Card(
            child: ListTile(
              title: Text('Life Quests are temporarily unavailable.'),
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const Card(
                child: ListTile(
                  leading: Icon(Icons.spa_outlined),
                  title: Text('A quiet day is okay.'),
                  subtitle: Text('Choose a Life Quest whenever it fits.'),
                ),
              );
            }
            return Column(
              children: [
                for (final quest in items.take(2))
                  Card(
                    child: ListTile(
                      leading: _domainBadge(quest['domain'] as String),
                      title: Text(quest['title'] as String),
                      subtitle: Text(
                        '${_domainName(quest['domain'] as String)} · ${quest['durationMinutes']} min',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/life'),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _GrowthReady extends StatelessWidget {
  const _GrowthReady({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final balances = ref.watch(trainingPotentialProvider);
    return balances.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (values) {
        final available = values.values.fold<int>(
          0,
          (sum, amount) => sum + amount,
        );
        if (available == 0) return const SizedBox.shrink();
        return Card(
          color: AstraeaColors.deepBlue,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AstraeaColors.panelRaised,
              child: Icon(Icons.auto_awesome, color: AstraeaColors.gold),
            ),
            title: const Text('Growth Potential ready'),
            subtitle: Text('$available Potential · Choose how to train'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => context.push('/training'),
          ),
        );
      },
    );
  }
}

Widget _domainBadge(String domain) {
  final color = switch (domain) {
    'fitness' => const Color(0xFF8EE0BE),
    'learning' => AstraeaColors.starlight,
    'languages' => const Color(0xFFD0B3FF),
    _ => AstraeaColors.gold,
  };
  final icon = switch (domain) {
    'fitness' => Icons.directions_walk,
    'learning' => Icons.menu_book_outlined,
    'languages' => Icons.translate,
    _ => Icons.favorite_outline,
  };
  return CircleAvatar(
    backgroundColor: color.withValues(alpha: 0.14),
    child: Icon(icon, color: color, size: 19),
  );
}

String _domainName(String domain) => switch (domain) {
  'fitness' => 'Fitness',
  'learning' => 'Learning',
  'languages' => 'Languages',
  _ => 'Life',
};

class _PilotMeasurementControl extends ConsumerStatefulWidget {
  const _PilotMeasurementControl();

  @override
  ConsumerState<_PilotMeasurementControl> createState() =>
      _PilotMeasurementControlState();
}

class _PilotMeasurementControlState
    extends ConsumerState<_PilotMeasurementControl> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final database = await ref.read(databaseProvider.future);
      final enabled = await PrototypeEventRecorder(
        database,
        DateTime.now,
      ).optedIn;
      if (mounted) setState(() => _enabled = enabled);
    } catch (_) {
      if (mounted) setState(() => _enabled = false);
    }
  }

  Future<void> _changeConsent() async {
    final currentlyEnabled = _enabled ?? false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          currentlyEnabled
              ? 'Turn off pilot measurement?'
              : 'Enable private pilot measurement?',
        ),
        content: Text(
          currentlyEnabled
              ? 'Turning this off deletes locally stored milestone events.'
              : 'This stores a small set of gameplay milestones on this device only. It does not collect names, notes, evidence, health data, or custom quest text. There is no upload. You can turn it off and delete the events at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(currentlyEnabled ? 'Turn off' : 'Enable'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final database = await ref.read(databaseProvider.future);
    await PrototypeEventRecorder(
      database,
      DateTime.now,
    ).setOptIn(!currentlyEnabled);
    if (mounted) setState(() => _enabled = !currentlyEnabled);
  }

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: const Text('Optional pilot measurement'),
      subtitle: Text(_enabled == true ? 'On · local only' : 'Off · default'),
      trailing: _enabled == null
          ? const Icon(Icons.hourglass_top)
          : Switch(value: _enabled!, onChanged: (_) => _changeConsent()),
      onTap: _enabled == null ? null : _changeConsent,
    ),
  );
}
