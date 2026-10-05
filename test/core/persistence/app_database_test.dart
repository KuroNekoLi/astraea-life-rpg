import 'dart:io';

import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  test('database opens and preserves schema version across reopen', () async {
    final directory = await Directory.systemTemp.createTemp('astraea_test_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/test.sqlite');
    final database = AppDatabase(NativeDatabase(file));
    try {
      final row = await database
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(row.read<int>('user_version'), 1);
    } finally {
      await database.close();
    }
    final reopened = AppDatabase(NativeDatabase(file));
    try {
      final row = await reopened
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(row.read<int>('user_version'), 1);
    } finally {
      await reopened.close();
    }
  });
}
