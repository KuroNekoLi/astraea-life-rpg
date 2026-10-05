import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Schema 1 establishes the connection without speculative domain tables.
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
