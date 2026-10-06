import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/theme/astraea_theme.dart';
import '../../life_quest/domain/life_domain.dart';
import '../data/training_repository.dart';
import '../application/training_preview_provider.dart';

class TrainingPreviewScreen extends ConsumerStatefulWidget {
  const TrainingPreviewScreen({super.key});

  @override
  ConsumerState<TrainingPreviewScreen> createState() =>
      _TrainingPreviewScreenState();
}

class _TrainingPreviewScreenState extends ConsumerState<TrainingPreviewScreen> {
  static const _labels = {
    GrowthPotentialCategory.physical: 'Physical Potential',
    GrowthPotentialCategory.cognitive: 'Cognitive Potential',
    GrowthPotentialCategory.communication: 'Communication Potential',
  };

  bool _training = false;
  String? _pendingIdempotencyKey;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingGoldenPathProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error'),
              TextButton(
                onPressed: () => ref.invalidate(trainingGoldenPathProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Choose a Training',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Life Quest rewards become Growth Potential. Choose a matching drill to turn it into permanent character growth.',
            ),
            const SizedBox(height: 16),
            for (final category in GrowthPotentialCategory.values)
              Card(
                child: ListTile(
                  title: Text(_labels[category]!),
                  trailing: Text('${value.balances[category] ?? 0}'),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'AVAILABLE DRILLS',
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
                  title: const Text('Analysis growth is active'),
                  subtitle: Text(
                    '+${value.analysisPermanentGrowth} permanent Analysis from Training',
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
                      'Keep your journey moving',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Training changes your character permanently. Check the updated build, then return to the academy.',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.go('/character'),
                          icon: const Icon(Icons.person_outline),
                          label: const Text('View Character'),
                        ),
                        FilledButton.icon(
                          onPressed: () => context.go('/adventure'),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Continue Adventure'),
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
                label: const Text('Try Analysis against Ashfang'),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Training complete. Your attribute grew permanently.',
            ),
          ),
        );
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

  static const _details = {
    'reaction-drill': (
      'Reaction Drill',
      'Processing',
      'Build focus: initiative, reactions, and fast battle decisions.',
    ),
    'precision-movement': (
      'Precision Movement',
      'Precision',
      'Build focus: targeting, interrupts, and precise control.',
    ),
    'function-analysis-drill': (
      'Function Analysis Drill',
      'Analysis',
      'Build focus: revealing enemy Function Weak Nodes.',
    ),
    'complexity-exercise': (
      'Complexity Exercise',
      'Computation',
      'Build focus: complex Functions and counter reasoning.',
    ),
    'mana-control-drill': (
      'Mana Control Drill',
      'Efficiency',
      'Build focus: Mana use and resource efficiency.',
    ),
    'intent-encoding-drill': (
      'Intent Encoding Drill',
      'Mana Output',
      'Build focus: safe output and burst spell capacity.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final detail = _details[option.definitionId]!;
    final category = option.quote.potentialCategory;
    final categoryLabel = switch (category) {
      GrowthPotentialCategory.physical => 'Physical',
      GrowthPotentialCategory.cognitive => 'Cognitive',
      GrowthPotentialCategory.communication => 'Communication',
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail.$1, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('$categoryLabel Potential → ${detail.$2}'),
            const SizedBox(height: 6),
            Text(
              detail.$3,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AstraeaColors.muted),
            ),
            const SizedBox(height: 10),
            Text(
              '${detail.$2} ${option.currentAttributeValue} → ${option.currentAttributeValue + option.quote.attributeGrowth}',
            ),
            const SizedBox(height: 4),
            Text(
              'Aptitude ${option.quote.aptitudeRating}/6 · Cost ${option.quote.potentialCost} $categoryLabel Potential',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: option.canTrain && !training ? onTrain : null,
                child: Text(
                  training
                      ? 'Training…'
                      : option.canTrain
                      ? 'Train ${detail.$2}'
                      : 'Need ${option.quote.potentialCost - option.availablePotential} more $categoryLabel Potential',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
