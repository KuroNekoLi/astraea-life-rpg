import 'package:flutter/material.dart';

/// M0 placeholder; approved product screens are introduced in later milestones.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Astraea')),
    body: const SafeArea(child: Center(child: Text('Astraea'))),
  );
}
