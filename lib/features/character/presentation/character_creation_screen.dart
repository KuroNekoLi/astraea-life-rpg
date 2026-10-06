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
    appBar: AppBar(title: const Text('Create your Astraea self')),
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
          child: Text(_saving ? 'Saving…' : 'Continue'),
        ),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          controller: _name,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'Character name'),
        ),
        const SizedBox(height: 20),
        Text(
          'Distribute 32 points · Base 8 · Maximum 15',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text('$_spent / $initialAllocationBudget points'),
        for (final attribute in AttributeType.values)
          ListTile(
            title: Text(_label(attribute)),
            subtitle: Text(
              'Base ${baseAttributeValue + _allocation[attribute]!}',
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
          decoration: const InputDecoration(labelText: 'Initial weapon'),
          items: const [
            DropdownMenuItem(
              value: 'astraea_longsword',
              child: Text('Astraea Longsword'),
            ),
            DropdownMenuItem(
              value: 'standard_spear',
              child: Text('Standard Spear'),
            ),
            DropdownMenuItem(
              value: 'training_arcane_gun',
              child: Text('Training Arcane Gun'),
            ),
            DropdownMenuItem(
              value: 'standard_staff',
              child: Text('Standard Staff'),
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

String _label(AttributeType value) => switch (value) {
  AttributeType.manaCapacity => 'Mana Capacity',
  AttributeType.manaOutput => 'Mana Output',
  AttributeType.computation => 'Computation',
  AttributeType.processing => 'Processing',
  AttributeType.precision => 'Precision',
  AttributeType.efficiency => 'Efficiency',
  AttributeType.ambientSync => 'Ambient Sync',
  AttributeType.analysis => 'Analysis',
};
