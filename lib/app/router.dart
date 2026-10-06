import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/story/presentation/adventure_screen.dart';
import '../features/story/presentation/deck_screen.dart';
import '../features/story/presentation/story_screen.dart';
import '../features/story/presentation/function_lab_screen.dart';
import '../features/character/presentation/character_creation_screen.dart';
import '../features/character/presentation/character_profile_screen.dart';
import '../features/life_quest/presentation/life_screen.dart';
import '../features/character/presentation/training_preview_screen.dart';
import '../features/home/presentation/launch_screens.dart';
import '../features/combat/presentation/ashfang_battle_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/splash'),
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (_, _) => const HomeScreen(),
          ),
          GoRoute(
            path: '/life',
            name: 'life',
            builder: (_, _) => const LifeScreen(),
          ),
          GoRoute(
            path: '/adventure',
            name: 'adventure',
            builder: (_, _) => const AdventureScreen(),
          ),
          GoRoute(
            path: '/battle/ashfang',
            builder: (_, _) => const AshfangBattleScreen(),
          ),
          GoRoute(
            path: '/deck',
            name: 'deck',
            builder: (_, _) => const DeckScreen(),
          ),
          GoRoute(
            path: '/character',
            name: 'character',
            builder: (_, _) => const CharacterProfileScreen(),
          ),
          GoRoute(
            path: '/training',
            builder: (_, _) => const TrainingPreviewScreen(),
          ),
          GoRoute(path: '/story', builder: (_, _) => const StoryScreen()),
          GoRoute(
            path: '/function-lab',
            builder: (_, _) => const FunctionLabScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/character/create',
        builder: (_, _) => const CharacterCreationScreen(),
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
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
