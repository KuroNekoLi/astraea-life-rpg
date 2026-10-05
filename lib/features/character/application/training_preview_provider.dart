import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../data/training_preview_repository.dart';
import '../../life_quest/domain/life_domain.dart';

final trainingPotentialProvider =
    FutureProvider<Map<GrowthPotentialCategory, int>>((ref) async {
      final database = await ref.watch(databaseProvider.future);
      return TrainingPreviewRepository(database).availablePotential();
    });
