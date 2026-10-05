import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// JSON payload storage keeps authored and player records versioned at boundaries.
class AppRecords extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [AppRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(appRecords);
    },
  );

  Future<List<QueryRow>> recordsOf(String kind) => customSelect(
    'SELECT id, payload, created_at FROM app_records WHERE kind = ? ORDER BY created_at',
    variables: [Variable.withString(kind)],
  ).get();

  Future<void> putRecord({
    required String id,
    required String kind,
    required String payload,
    required DateTime createdAt,
  }) => customStatement(
    'INSERT INTO app_records (id, kind, payload, created_at) VALUES (?, ?, ?, ?)',
    [id, kind, payload, createdAt.millisecondsSinceEpoch ~/ 1000],
  );
}
