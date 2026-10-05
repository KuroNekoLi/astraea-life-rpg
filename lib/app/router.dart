import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/story/presentation/story_screen.dart';
import '../features/story/presentation/function_lab_screen.dart';
import '../features/character/presentation/character_creation_screen.dart';
import '../features/life_quest/presentation/life_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/home'),
      GoRoute(path: '/story', builder: (_, _) => const StoryScreen()),
      GoRoute(
        path: '/function-lab',
        builder: (_, _) => const FunctionLabScreen(),
      ),
      GoRoute(
        path: '/character/create',
        builder: (_, _) => const CharacterCreationScreen(),
      ),
      GoRoute(
        path: '/life',
        name: 'life',
        builder: (_, _) => const LifeScreen(),
      ),
      GoRoute(
        path: '/life/:questId',
        builder: (_, state) =>
            LifeQuestDetailScreen(questId: state.pathParameters['questId']!),
      ),
      GoRoute(
        path: '/life/timer/:questId',
        builder: (_, state) =>
            LifeQuestTimerScreen(questId: state.pathParameters['questId']!),
      ),
      GoRoute(
        path: '/life/complete/:questId',
        builder: (_, state) => QuestCompletionScreen(
          questId: state.pathParameters['questId']!,
          timerEvidence: state.uri.queryParameters['source'] == 'timer',
          completionId: state.uri.queryParameters['completionId'] ?? '',
          durationSeconds:
              int.tryParse(state.uri.queryParameters['seconds'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (_, _) => const HomeScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
