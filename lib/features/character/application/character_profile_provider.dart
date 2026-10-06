import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../data/training_repository.dart';
import '../domain/attribute.dart';

final characterProfileProvider = FutureProvider<CharacterProfileView?>((
  ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  final rows = await database.recordsOf('character');
  final active = rows.where(
    (row) => row.read<String>('id') == 'active-character',
  );
  final row = active.firstOrNull;
  if (row == null) return null;

  final character =
      jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
  final attributes = await TrainingRepository(database).currentAttributeState();
  return CharacterProfileView(
    name: character['name'] as String? ?? 'Astraea Adventurer',
    weaponId: character['weaponId'] as String? ?? 'Unassigned',
    attributes: attributes.values,
  );
});

final class CharacterProfileView {
  const CharacterProfileView({
    required this.name,
    required this.weaponId,
    required this.attributes,
  });

  final String name;
  final String weaponId;
  final Map<AttributeType, AttributeValue> attributes;
}
