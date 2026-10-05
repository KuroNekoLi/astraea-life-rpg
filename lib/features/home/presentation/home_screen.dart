import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../core/measurement/prototype_event_recorder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Astraea Academy')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Your life shapes your build.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a real-life action when it fits your day. Nothing expires or takes away progress.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/life'),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Life Quests'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/character/create'),
            child: const Text('Create Character'),
          ),
          OutlinedButton(
            onPressed: () => context.push('/training'),
            child: const Text('View Growth Potential'),
          ),
          OutlinedButton(
            onPressed: () => context.push('/story'),
            child: const Text('Continue Academy Story'),
          ),
          OutlinedButton(
            onPressed: () => context.push('/function-lab'),
            child: const Text('Function Analysis Tutorial'),
          ),
          const SizedBox(height: 20),
          const _PilotMeasurementControl(),
        ],
      ),
    ),
  );
}

class _PilotMeasurementControl extends ConsumerStatefulWidget {
  const _PilotMeasurementControl();

  @override
  ConsumerState<_PilotMeasurementControl> createState() =>
      _PilotMeasurementControlState();
}

class _PilotMeasurementControlState
    extends ConsumerState<_PilotMeasurementControl> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final database = await ref.read(databaseProvider.future);
      final enabled = await PrototypeEventRecorder(
        database,
        DateTime.now,
      ).optedIn;
      if (mounted) setState(() => _enabled = enabled);
    } catch (_) {
      if (mounted) setState(() => _enabled = false);
    }
  }

  Future<void> _changeConsent() async {
    final currentlyEnabled = _enabled ?? false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          currentlyEnabled
              ? 'Turn off pilot measurement?'
              : 'Enable private pilot measurement?',
        ),
        content: Text(
          currentlyEnabled
              ? 'Turning this off deletes locally stored milestone events.'
              : 'This stores a small set of gameplay milestones on this device only. It does not collect names, notes, evidence, health data, or custom quest text. There is no upload. You can turn it off and delete the events at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(currentlyEnabled ? 'Turn off' : 'Enable'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final database = await ref.read(databaseProvider.future);
    await PrototypeEventRecorder(
      database,
      DateTime.now,
    ).setOptIn(!currentlyEnabled);
    if (mounted) setState(() => _enabled = !currentlyEnabled);
  }

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: const Text('Optional pilot measurement'),
      subtitle: Text(_enabled == true ? 'On · local only' : 'Off · default'),
      trailing: _enabled == null
          ? const Icon(Icons.hourglass_top)
          : Switch(value: _enabled!, onChanged: (_) => _changeConsent()),
      onTap: _enabled == null ? null : _changeConsent,
    ),
  );
}
