import 'dart:convert';

import '../../../core/persistence/app_database.dart';
import '../../life_quest/domain/life_domain.dart';

final class TrainingPreviewRepository {
  const TrainingPreviewRepository(this.database);

  final AppDatabase database;

  Future<Map<GrowthPotentialCategory, int>> availablePotential() async {
    final rows = await database
        .customSelect(
          "SELECT payload FROM app_records WHERE kind = 'growthPotential'",
        )
        .get();
    final balances = {
      for (final category in GrowthPotentialCategory.values) category: 0,
    };
    for (final row in rows) {
      final payload =
          jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
      final category = GrowthPotentialCategory.values.firstWhere(
        (value) => value.name == payload['key'],
        orElse: () => throw FormatException(
          'Unknown Growth Potential category: ${payload['key']}',
        ),
      );
      final amount = payload['amount'];
      if (amount is! int || amount < 0) {
        throw const FormatException('Invalid Growth Potential balance');
      }
      balances[category] = amount;
    }
    return Map.unmodifiable(balances);
  }
}
