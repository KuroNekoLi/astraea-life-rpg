import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_shell.dart';
import '../../../design_system/theme/astraea_theme.dart';
import '../application/character_profile_provider.dart';
import '../domain/attribute.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class CharacterProfileScreen extends ConsumerWidget {
  const CharacterProfileScreen({super.key});

  static const _icons = {
    AttributeType.manaCapacity: Icons.water_drop_outlined,
    AttributeType.manaOutput: Icons.bolt_outlined,
    AttributeType.computation: Icons.memory_outlined,
    AttributeType.processing: Icons.speed_outlined,
    AttributeType.precision: Icons.gps_fixed,
    AttributeType.efficiency: Icons.tune,
    AttributeType.ambientSync: Icons.waves_outlined,
    AttributeType.analysis: Icons.search,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(characterProfileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.character)),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: context.l10n.couldNotLoadCharacter,
          onRetry: () => ref.invalidate(characterProfileProvider),
        ),
        data: (value) {
          if (value == null) {
            return _EmptyCharacter(
              onCreate: () => context.push('/character/create'),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              AstraeaSectionHeader(
                eyebrow: context.l10n.yourAstraeaSelf,
                title: value.name,
                subtitle: localizedWeapon(context.l10n, value.weaponId),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [AstraeaColors.panelRaised, AstraeaColors.deepBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: AstraeaColors.night,
                      child: Icon(
                        Icons.person,
                        size: 34,
                        color: AstraeaColors.starlight,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.characterAttributes,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.trainingGrowsBuild,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AstraeaColors.pale.withValues(
                                    alpha: 0.78,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(context.l10n.attributesSection, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 10),
              GridView.builder(
                itemCount: AttributeType.values.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.65,
                ),
                itemBuilder: (context, index) {
                  final attribute = AttributeType.values[index];
                  final attributeValue = value.attributes[attribute]!;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _icons[attribute],
                                size: 17,
                                color: AstraeaColors.starlight,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  localizedAttribute(context.l10n, attribute),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${attributeValue.effectiveValue}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 6),
                              if (attributeValue.permanentGrowth > 0)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    context.l10n.trainedDelta(attributeValue.permanentGrowth),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: AstraeaColors.gold),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => context.push('/training'),
                icon: const Icon(Icons.auto_awesome),
                label: Text(context.l10n.viewTraining),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCharacter extends StatelessWidget {
  const _EmptyCharacter({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_add_alt_1, size: 48),
          const SizedBox(height: 16),
          Text(
            context.l10n.createAstraeaSelf,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.chooseStartingAttributesWeapon),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onCreate,
            child: Text(context.l10n.createCharacter),
          ),
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        const SizedBox(height: 8),
        TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
      ],
    ),
  );
}
