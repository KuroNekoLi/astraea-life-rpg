import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_shell.dart';
import '../../../design_system/theme/astraea_theme.dart';
import '../application/overview_providers.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class DeckScreen extends ConsumerWidget {
  const DeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deck = ref.watch(preparedDeckProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.preparedDeck)),
      body: deck.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(preparedDeckProvider),
            child: Text(context.l10n.couldNotLoadDeckRetry),
          ),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            AstraeaSectionHeader(
              eyebrow: context.l10n.spellCards,
              title: value.selectedSpellIds.isEmpty
                  ? context.l10n.buildPreparedDeck
                  : context.l10n.yourPreparedDeck,
              subtitle: context.l10n.chooseSixFunctions,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.style, color: AstraeaColors.starlight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        value.selectedSpellIds.isEmpty
                            ? context.l10n.noDeckPrepared
                            : context.l10n.preparedCount(value.selectedSpellIds.length),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(context.l10n.cardsCount(value.allSpells.length)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (value.selectedSpells.isNotEmpty) ...[
              Text(context.l10n.readySection, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              for (final spell in value.selectedSpells)
                _SpellCardTile(spell: spell, selected: true),
              const SizedBox(height: 12),
            ],
            Text(context.l10n.cardLibrary, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth > 520 ? 3 : 2;
                return GridView.builder(
                  itemCount: value.allSpells.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) => _SpellCard(
                    spell: value.allSpells[index],
                    selected: value.selectedSpellIds.contains(
                      value.allSpells[index].id,
                    ),
                  ),
                );
              },
            ),
            if (value.selectedSpellIds.isEmpty) ...[
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () => context.push('/story'),
                icon: const Icon(Icons.auto_awesome),
                label: Text(context.l10n.continueDeckSetup),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpellCard extends StatelessWidget {
  const _SpellCard({required this.spell, required this.selected});

  final SpellCardView spell;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = _roleColor(spell.role);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.35), AstraeaColors.panel],
        ),
        border: Border.all(
          color: selected ? AstraeaColors.gold : color.withValues(alpha: 0.55),
          width: selected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AstraeaColors.night,
                child: Icon(_roleIcon(spell.role), size: 16, color: color),
              ),
              const Spacer(),
              if (selected)
                const Icon(Icons.check_circle, color: AstraeaColors.gold),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedSpellRole(context.l10n, spell.role).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                localizedSpellName(context.l10n, spell.id),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpellCardTile extends StatelessWidget {
  const _SpellCardTile({required this.spell, required this.selected});

  final SpellCardView spell;
  final bool selected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Card(
      child: ListTile(
        leading: Icon(_roleIcon(spell.role), color: _roleColor(spell.role)),
        title: Text(spell.name),
        subtitle: Text(localizedSpellRole(context.l10n, spell.role)),
        trailing: selected
            ? const Icon(Icons.check_circle, color: AstraeaColors.gold)
            : null,
      ),
    ),
  );
}

Color _roleColor(String role) => switch (role) {
  'Attack' => const Color(0xFFFF9D8D),
  'Defense' => const Color(0xFF90C8FF),
  'Mobility' => const Color(0xFFC6A6FF),
  'Analysis' => const Color(0xFF7FE1D1),
  'Support' => AstraeaColors.gold,
  _ => const Color(0xFFFFB7D4),
};

IconData _roleIcon(String role) => switch (role) {
  'Attack' => Icons.local_fire_department_outlined,
  'Defense' => Icons.shield_outlined,
  'Mobility' => Icons.air,
  'Analysis' => Icons.visibility_outlined,
  'Support' => Icons.auto_awesome_outlined,
  _ => Icons.bolt_outlined,
};
