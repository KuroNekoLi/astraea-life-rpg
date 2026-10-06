import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../life_quest/domain/life_domain.dart';
import '../data/training_repository.dart';

final trainingRepositoryProvider = FutureProvider<TrainingRepository>((
  ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  return TrainingRepository(database);
});

final trainingGoldenPathProvider = FutureProvider<TrainingGoldenPathState>((
  ref,
) async {
  final repository = await ref.watch(trainingRepositoryProvider.future);
  return repository.goldenPathState();
});

final trainingPotentialProvider =
    FutureProvider<Map<GrowthPotentialCategory, int>>((ref) async {
      final repository = await ref.watch(trainingRepositoryProvider.future);
      return repository.availablePotential();
    });
