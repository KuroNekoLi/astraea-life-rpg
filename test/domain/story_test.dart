import 'package:astraea_life_rpg/features/story/domain/story_state.dart';
import 'package:test/test.dart';

void main() {
  final initial = StoryState(
    userId: 'u',
    chapterId: 'ch1',
    sceneId: 's1',
    stepId: 'opening',
    flags: {'arrived'},
    choices: [],
    storyRevision: 3,
    contentVersion: 'v1',
  );
  final command = StoryTransitionCommand(
    expectedStoryRevision: 3,
    chapterId: 'ch1',
    sceneId: 's2',
    stepId: 'dialogue',
    contentVersion: 'v1',
    addFlags: {'met_yuma'},
    choiceId: 'greet',
  );

  test(
    'story transition checks expected revision and increments exactly once',
    () {
      final result = applyStoryTransition(initial, command);
      expect(result, isA<StoryTransitionApplied>());
      final state = (result as StoryTransitionApplied).state;
      expect(state.storyRevision, 4);
      expect(state.flags, {'arrived', 'met_yuma'});
      expect(state.choices, ['greet']);
      expect(initial.storyRevision, 3);
    },
  );

  test('stale story transition returns conflict without changing state', () {
    final result = applyStoryTransition(
      initial,
      StoryTransitionCommand(
        expectedStoryRevision: 2,
        chapterId: 'ch1',
        sceneId: 's2',
        contentVersion: 'v1',
      ),
    );
    expect(result, isA<StoryRevisionConflict>());
    expect((result as StoryRevisionConflict).actual, 3);
    expect(initial.sceneId, 's1');
  });
}
