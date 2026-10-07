import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/theme/astraea_theme.dart';
import '../../life_quest/domain/life_domain.dart';
import '../data/training_repository.dart';
import '../application/character_profile_provider.dart';
import '../application/training_preview_provider.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class TrainingPreviewScreen extends ConsumerStatefulWidget {
  const TrainingPreviewScreen({super.key});

  @override
  ConsumerState<TrainingPreviewScreen> createState() =>
      _TrainingPreviewScreenState();
}

class _TrainingPreviewScreenState extends ConsumerState<TrainingPreviewScreen> {
  bool _training = false;
  String? _pendingIdempotencyKey;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingGoldenPathProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.training)),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.couldNotLoadTraining),
              TextButton(
                onPressed: () => ref.invalidate(trainingGoldenPathProvider),
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              context.l10n.chooseTraining,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(context.l10n.trainingDescription),
            const SizedBox(height: 16),
            for (final category in GrowthPotentialCategory.values)
              Card(
                child: ListTile(
                  title: Text(switch (category) {
                    GrowthPotentialCategory.physical =>
                      context.l10n.physicalPotential,
                    GrowthPotentialCategory.cognitive =>
                      context.l10n.cognitivePotential,
                    GrowthPotentialCategory.communication =>
                      context.l10n.communicationPotential,
                  }),
                  trailing: Text('${value.balances[category] ?? 0}'),
                ),
              ),
            if (value.options.every((option) => !option.canTrain)) ...[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.potentialBuilding,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(context.l10n.potentialBuildingDescription),
                      const SizedBox(height: 8),
                      for (final option in value.options.where(
                        (item) => item.availablePotential > 0,
                      ))
                        Text(
                          context.l10n.trainingPotentialProgress(
                            localizedPotentialCategory(
                              context.l10n,
                              option.quote.potentialCategory,
                            ),
                            option.availablePotential,
                            option.quote.potentialCost,
                            localizedAttribute(
                              context.l10n,
                              option.quote.attribute,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/life'),
                        icon: const Icon(Icons.checklist),
                        label: Text(context.l10n.chooseAnotherLifeQuest),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              context.l10n.availableDrills,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            for (final option in value.options)
              _TrainingOptionCard(
                option: option,
                training: _training,
                onTrain: () => _train(value.characterId, option.definitionId),
              ),
            if (value.analysisPermanentGrowth > 0)
              Card(
                child: ListTile(
                  title: Text(context.l10n.analysisGrowthActive),
                  subtitle: Text(
                    context.l10n.permanentAnalysisGrowth(
                      value.analysisPermanentGrowth,
                    ),
                  ),
                  trailing: const Icon(Icons.auto_awesome),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.keepJourneyMoving,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(context.l10n.trainingPermanentDescription),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.go('/character'),
                          icon: const Icon(Icons.person_outline),
                          label: Text(context.l10n.viewCharacter),
                        ),
                        FilledButton.icon(
                          onPressed: () => context.go('/adventure'),
                          icon: const Icon(Icons.auto_awesome),
                          label: Text(context.l10n.continueAdventure),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (value.analysisPermanentGrowth > 0) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/function-lab'),
                icon: const Icon(Icons.visibility),
                label: Text(context.l10n.tryAnalysisAshfang),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _train(String characterId, String definitionId) async {
    setState(() {
      _training = true;
      _pendingIdempotencyKey ??=
          'training:$characterId:$definitionId:${DateTime.now().microsecondsSinceEpoch}';
    });
    try {
      final repository = await ref.read(trainingRepositoryProvider.future);
      await repository.train(
        trainingDefinitionId: definitionId,
        idempotencyKey: _pendingIdempotencyKey!,
      );
      _pendingIdempotencyKey = null;
      ref.invalidate(trainingGoldenPathProvider);
      ref.invalidate(trainingPotentialProvider);
      ref.invalidate(characterProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.trainingComplete)));
      }
    } finally {
      if (mounted) setState(() => _training = false);
    }
  }
}

class _TrainingOptionCard extends StatelessWidget {
  const _TrainingOptionCard({
    required this.option,
    required this.training,
    required this.onTrain,
  });

  final TrainingOptionPreview option;
  final bool training;
  final VoidCallback onTrain;

  @override
  Widget build(BuildContext context) {
    final detail = localizedTrainingDefinition(
      context.l10n,
      option.definitionId,
    );
    final category = option.quote.potentialCategory;
    final categoryLabel = localizedPotentialCategory(context.l10n, category);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail.$1, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              context.l10n.trainingPotentialToAttribute(
                categoryLabel,
                detail.$2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              detail.$3,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AstraeaColors.muted),
            ),
            const SizedBox(height: 10),
            Text(
              context.l10n.trainingAttributeChange(
                detail.$2,
                option.currentAttributeValue,
                option.currentAttributeValue + option.quote.attributeGrowth,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.aptitudeCost(
                option.quote.aptitudeRating,
                option.quote.potentialCost,
                categoryLabel,
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: option.canTrain && !training ? onTrain : null,
                child: Text(
                  training
                      ? context.l10n.trainingInProgress
                      : option.canTrain
                      ? context.l10n.trainAttribute(detail.$2)
                      : context.l10n.needMorePotential(
                          option.quote.potentialCost -
                              option.availablePotential,
                          categoryLabel,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
