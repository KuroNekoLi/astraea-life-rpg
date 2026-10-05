import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'app_database.dart';

Future<AppDatabase> openDatabase() async {
  final directory = await getApplicationSupportDirectory();
  return AppDatabase(
    NativeDatabase.createInBackground(
      File(path.join(directory.path, 'astraea.sqlite')),
    ),
  );
}
