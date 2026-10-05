import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/theme/astraea_theme.dart';
import 'router.dart';

class AstraeaApp extends ConsumerWidget {
  const AstraeaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Astraea',
    theme: AstraeaTheme.light,
    routerConfig: ref.watch(routerProvider),
  );
}
