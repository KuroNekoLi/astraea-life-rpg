import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../design_system/theme/astraea_theme.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final database = await ref.read(databaseProvider.future);
    final settings = await database.recordsOf('setting');
    final hasEntered = settings.any(
      (row) => row.read<String>('id') == 'onboarding-complete',
    );
    if (context.mounted) {
      context.go(hasEntered ? '/home' : '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF142D50), AstraeaColors.night, Color(0xFF030914)],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 76,
              right: -42,
              child: Icon(
                Icons.castle_outlined,
                size: 300,
                color: Color(0x1FBCDFFF),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.auto_awesome,
                      size: 32,
                      color: AstraeaColors.gold,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'ASTRAEA',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 7,
                      ),
                    ),
                    Text(
                      'LIFE  ×  RPG',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AstraeaColors.starlight,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '讓現實的努力，成為改變世界的魔法。',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AstraeaColors.pale.withValues(alpha: 0.82),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _start(context, ref),
                        child: const Text('Tap to start'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _enter(BuildContext context, WidgetRef ref) async {
    final database = await ref.read(databaseProvider.future);
    await database.customStatement(
      'INSERT OR REPLACE INTO app_records (id, kind, payload, created_at) VALUES (?, ?, ?, ?)',
      [
        'onboarding-complete',
        'setting',
        jsonEncode({'complete': true, 'schemaVersion': 1}),
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ],
    );
    if (context.mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => context.go('/splash'),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Welcome to Astraea'),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF345D8D), AstraeaColors.deepBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      size: 74,
                      color: AstraeaColors.gold,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Your everyday effort can shape your Astraea self.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Real life and the academy are connected, while your actions remain yours to choose.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AstraeaColors.muted),
                ),
                const SizedBox(height: 18),
                const _OnboardingStep(
                  icon: Icons.favorite_outline,
                  title: 'Choose a Life Quest',
                  description:
                      'Pick a real-world action when it fits your day.',
                ),
                const _OnboardingStep(
                  icon: Icons.auto_awesome,
                  title: 'Earn Growth Potential',
                  description:
                      'Your action creates an opportunity to grow in-game.',
                ),
                const _OnboardingStep(
                  icon: Icons.shield_outlined,
                  title: 'Build your RPG self',
                  description:
                      'Train, prepare your deck, and explore the academy.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _enter(context, ref),
                    child: const Text('Enter Astraea'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No streak penalties. Progress waits whenever you do.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AstraeaColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon, color: AstraeaColors.starlight),
      title: Text(title),
      subtitle: Text(description),
    ),
  );
}
