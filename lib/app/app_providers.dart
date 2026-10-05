import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/persistence/app_database.dart';
import '../core/persistence/open_database.dart';

/// Lazy until a feature needs persistence; the shell does not perform I/O.
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final database = await openDatabase();
  if (!ref.mounted) {
    await database.close();
    throw StateError('Database scope disposed during initialization');
  }
  ref.onDispose(database.close);
  return database;
});
