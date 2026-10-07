import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../app/app_providers.dart';
import '../../../core/measurement/prototype_event_recorder.dart';
import '../domain/attribute.dart';
import '../domain/character_growth_policy.dart';
import '../../../game_engine/rng/rng.dart';
import '../../../l10n/content_labels.dart';
import '../../../l10n/l10n.dart';

class CharacterCreationScreen extends ConsumerStatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  ConsumerState<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState
    extends ConsumerState<CharacterCreationScreen> {
  final _name = TextEditingController();
  final _allocation = {
    for (final attribute in AttributeType.values) attribute: 4,
  };
  String _weapon = 'astraea_longsword';
  bool _saving = false;
  int get _spent => _allocation.values.fold(0, (sum, value) => sum + value);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.createAstraeaSelf)),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed:
              !_saving &&
                  _spent == initialAllocationBudget &&
                  _name.text.trim().isNotEmpty
              ? _save
              : null,
          child: Text(
            _saving ? context.l10n.saving : context.l10n.commonContinue,
          ),
        ),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          controller: _name,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: context.l10n.characterName),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.distributePoints,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(context.l10n.characterBuildFocusDescription),
        const SizedBox(height: 4),
        Text(context.l10n.pointsSpent(_spent, initialAllocationBudget)),
        for (final attribute in AttributeType.values)
          ListTile(
            title: Text(localizedAttribute(context.l10n, attribute)),
            subtitle: Text(
              context.l10n.attributeAllocationSummary(
                baseAttributeValue,
                _allocation[attribute]!,
                baseAttributeValue + _allocation[attribute]!,
                localizedAttributeEffect(context.l10n, attribute),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _allocation[attribute]! > 0
                      ? () => setState(
                          () => _allocation[attribute] =
                              _allocation[attribute]! - 1,
                        )
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text('${_allocation[attribute]}'),
                IconButton(
                  onPressed:
                      _spent < initialAllocationBudget &&
                          _allocation[attribute]! <
                              initialAttributeCap - baseAttributeValue
                      ? () => setState(
                          () => _allocation[attribute] =
                              _allocation[attribute]! + 1,
                        )
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _weapon,
          decoration: InputDecoration(labelText: context.l10n.initialWeapon),
          items: [
            for (final weaponId in const [
              'astraea_longsword',
              'standard_spear',
              'training_arcane_gun',
              'standard_staff',
            ])
              DropdownMenuItem(
                value: weaponId,
                child: Text(localizedWeapon(context.l10n, weaponId)),
              ),
          ],
          onChanged: (value) => setState(() => _weapon = value ?? _weapon),
        ),
      ],
    ),
  );

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final database = await ref.read(databaseProvider.future);
      final now = DateTime.now();
      final id = 'hero-${now.microsecondsSinceEpoch}';
      final allocation = CharacterInitialAllocation(_allocation);
      final attributes = allocation.toAttributeState(id);
      final growthContent =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/content/progression/character_growth_mvp_v1.json',
                ),
              )
              as Map<String, dynamic>;
      final growthPolicy = CharacterGrowthPolicy.fromJson(growthContent);
      final aptitudeSeed = now.microsecondsSinceEpoch & 0xffffffff;
      final aptitudeRng = SeededRng(aptitudeSeed);
      final aptitude = growthPolicy.rollAptitudes(aptitudeRng);
      final payload = {
        'id': id,
        'name': _name.text.trim(),
        'weaponId': _weapon,
        'attributes': {
          for (final entry in attributes.values.entries)
            entry.key.name: entry.value.baseValue,
        },
        'allocation': {
          for (final entry in allocation.allocation.entries)
            entry.key.name: entry.value,
        },
        'aptitude': {
          'contentVersion': aptitude.contentVersion,
          'ratings': {
            for (final entry in aptitude.ratings.entries)
              entry.key.name: entry.value,
          },
          'fateRerollUsed': aptitude.fateRerollUsed,
          'rngSeed': aptitudeSeed,
          'rngState': aptitudeRng.state,
        },
        'schemaVersion': 2,
        'revision': 0,
      };
      await database.putRecord(
        id: 'active-character',
        kind: 'character',
        payload: jsonEncode(payload),
        createdAt: now,
      );
      try {
        await PrototypeEventRecorder(database, DateTime.now).record(
          type: PrototypeEventType.characterCreated,
          properties: {'contentVersion': 'character-creation-1'},
          idempotencyKey: id,
        );
      } catch (_) {
        // Measurement is optional and cannot block character creation.
      }
      if (mounted) context.go('/life');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
