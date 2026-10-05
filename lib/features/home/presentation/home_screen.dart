import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            onPressed: () => context.push('/story'),
            child: const Text('Continue Academy Story'),
          ),
        ],
      ),
    ),
  );
}
