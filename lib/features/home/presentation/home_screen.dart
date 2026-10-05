import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// M0 placeholder; approved product screens are introduced in later milestones.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Astraea')),
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Astraea Academy'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push('/life'),
              child: const Text('Life Quests'),
            ),
          ],
        ),
      ),
    ),
  );
}
