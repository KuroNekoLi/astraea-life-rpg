import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../life_quest/domain/life_domain.dart';
import '../application/training_preview_provider.dart';

class TrainingPreviewScreen extends ConsumerStatefulWidget {
  const TrainingPreviewScreen({super.key});

  @override
  ConsumerState<TrainingPreviewScreen> createState() =>
      _TrainingPreviewScreenState();
}

class _TrainingPreviewScreenState
    extends ConsumerState<TrainingPreviewScreen> {
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
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Growth Potential',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Life Quest rewards become Growth Potential. Training converts that potential into permanent character growth.',
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Function Analysis Drill',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cognitive Potential → Analysis. Better Analysis improves your ability to reveal enemy Function Weak Nodes.',
                    ),
                    const SizedBox(height: 16),
                    _row('Current Analysis', '${value.effectiveAnalysis}'),
                    _row('Analysis Aptitude', '${value.analysisAptitude} / 6'),
                    _row(
                      'Training cost',
                      '${value.quote.potentialCost} Cognitive Potential',
                    ),
                    _row(
                      'After Training',
                      'Analysis ${value.effectiveAnalysis} → ${value.effectiveAnalysis + value.quote.attributeGrowth}',
                    ),
                    _row('Ruleset', value.quote.contentVersion),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: value.canTrain && !_training
                          ? () => _train(value.characterId)
                          : null,
                      child: Text(
                        _training
                            ? 'Training…'
                            : value.canTrain
                            ? 'Train Analysis'
                            : 'Not enough Cognitive Potential',
                      ),
                    ),
                    if (!value.canTrain) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Complete another Learning Life Quest to earn more Cognitive Potential. Nothing is lost or reset.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (value.analysisPermanentGrowth > 0) ...[
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('Analysis growth is active'),
                  subtitle: Text(
                    '+${value.analysisPermanentGrowth} permanent Analysis from Training',
                  ),
                  trailing: const Icon(Icons.auto_awesome),
                ),
              ),
              const SizedBox(height: 8),
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

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Future<void> _train(String characterId) async {
    setState(() {
      _training = true;
      _pendingIdempotencyKey ??=
          'golden-path:$characterId:function-analysis:${DateTime.now().microsecondsSinceEpoch}';
    });
    try {
      final repository = await ref.read(trainingRepositoryProvider.future);
      await repository.trainFunctionAnalysis(
        idempotencyKey: _pendingIdempotencyKey!,
      );
      _pendingIdempotencyKey = null;
      ref.invalidate(trainingGoldenPathProvider);
      ref.invalidate(trainingPotentialProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Training complete. Analysis increased permanently.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _training = false);
    }
  }
}
