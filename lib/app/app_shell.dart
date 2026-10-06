import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design_system/theme/astraea_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, required this.location, super.key});

  final Widget child;
  final String location;

  static const _destinations = [
    _AppDestination('Home', '/home', Icons.home_outlined, Icons.home),
    _AppDestination('Life', '/life', Icons.checklist_outlined, Icons.checklist),
    _AppDestination(
      'Adventure',
      '/adventure',
      Icons.auto_awesome_outlined,
      Icons.auto_awesome,
    ),
    _AppDestination('Deck', '/deck', Icons.style_outlined, Icons.style),
    _AppDestination(
      'Character',
      '/character',
      Icons.person_outline,
      Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex;
    final isBattleRoute = location.startsWith('/battle/');
    return Scaffold(
      body: child,
      bottomNavigationBar: isBattleRoute
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                final path = _destinations[index].path;
                if (path != location) context.go(path);
              },
              destinations: [
                for (final destination in _destinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: destination.label,
                  ),
              ],
            ),
    );
  }

  int get _selectedIndex {
    for (var index = 0; index < _destinations.length; index++) {
      final path = _destinations[index].path;
      if (location == path || location.startsWith('$path/')) return index;
    }
    if (location == '/story' ||
        location == '/function-lab' ||
        location.startsWith('/battle')) {
      return 2;
    }
    if (location == '/training' || location == '/character/create') return 4;
    return 0;
  }
}

final class _AppDestination {
  const _AppDestination(this.label, this.path, this.icon, this.selectedIcon);

  final String label;
  final String path;
  final IconData icon;
  final IconData selectedIcon;
}

class AstraeaSectionHeader extends StatelessWidget {
  const AstraeaSectionHeader({
    required this.eyebrow,
    required this.title,
    this.subtitle,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AstraeaColors.starlight,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(title, style: Theme.of(context).textTheme.headlineSmall),
      if (subtitle != null) ...[
        const SizedBox(height: 6),
        Text(
          subtitle!,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AstraeaColors.muted),
        ),
      ],
    ],
  );
}

class AstraeaHeroPanel extends StatelessWidget {
  const AstraeaHeroPanel({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF24466E), Color(0xFF10213A), AstraeaColors.night],
      ),
      border: Border.all(color: const Color(0x556F9BCB)),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -12,
          top: -22,
          child: Icon(
            icon,
            size: 156,
            color: AstraeaColors.starlight.withValues(alpha: 0.12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AstraeaColors.gold,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AstraeaColors.pale.withValues(alpha: 0.82),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(actionLabel),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
