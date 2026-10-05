import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_quest/domain/life_domain.dart';
import '../application/training_preview_provider.dart';

class TrainingPreviewScreen extends ConsumerWidget {
  const TrainingPreviewScreen({super.key});

  static const _labels = {
    GrowthPotentialCategory.physical: 'Physical Potential',
    GrowthPotentialCategory.cognitive: 'Cognitive Potential',
    GrowthPotentialCategory.communication: 'Communication Potential',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(trainingPotentialProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: balances.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load Growth Potential.'),
              TextButton(
                onPressed: () => ref.invalidate(trainingPotentialProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (values) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Growth Potential',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Life Quest rewards are shown here as potential. They do not directly change your Attributes.',
            ),
            const SizedBox(height: 16),
            for (final category in GrowthPotentialCategory.values)
              Card(
                child: ListTile(
                  title: Text(_labels[category]!),
                  trailing: Text('${values[category] ?? 0}'),
                ),
              ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Training conversion is not available yet',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'MVP prototype Training, Aptitude, and Fate rules are set. Training conversion is still being implemented, so your potential remains available; no points are spent on this screen.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
