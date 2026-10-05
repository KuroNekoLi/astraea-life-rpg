final class StoryState {
  StoryState({
    required this.userId,
    required this.chapterId,
    required this.sceneId,
    required Set<String> flags,
    required Iterable<String> choices,
    required this.storyRevision,
    this.stepId,
    this.schemaVersion = 1,
    required this.contentVersion,
  }) : flags = Set.unmodifiable(flags),
       choices = List.unmodifiable(choices) {
    for (final value in [userId, chapterId, sceneId, contentVersion]) {
      if (value.trim().isEmpty) {
        throw ArgumentError('Story identifiers are required');
      }
    }
    if (storyRevision < 0 || schemaVersion < 1) {
      throw ArgumentError('Invalid story revision/schema');
    }
  }
  final String userId;
  final String chapterId;
  final String sceneId;
  final String? stepId;
  final Set<String> flags;
  final List<String> choices;
  final int storyRevision;
  final int schemaVersion;
  final String contentVersion;
}

final class StoryTransitionCommand {
  StoryTransitionCommand({
    required this.expectedStoryRevision,
    required this.chapterId,
    required this.sceneId,
    required this.contentVersion,
    this.stepId,
    Set<String> addFlags = const {},
    this.choiceId,
  }) : addFlags = Set.unmodifiable(addFlags) {
    if (expectedStoryRevision < 0) {
      throw ArgumentError.value(expectedStoryRevision);
    }
    for (final value in [chapterId, sceneId, contentVersion, ...addFlags]) {
      if (value.trim().isEmpty) {
        throw ArgumentError('Transition identifiers cannot be empty');
      }
    }
  }
  final int expectedStoryRevision;
  final String chapterId;
  final String sceneId;
  final String? stepId;
  final String contentVersion;
  final Set<String> addFlags;
  final String? choiceId;
}

sealed class StoryTransitionResult {
  const StoryTransitionResult();
}

final class StoryTransitionApplied extends StoryTransitionResult {
  const StoryTransitionApplied(this.state);
  final StoryState state;
}

final class StoryRevisionConflict extends StoryTransitionResult {
  const StoryRevisionConflict(this.expected, this.actual);
  final int expected;
  final int actual;
}

StoryTransitionResult applyStoryTransition(
  StoryState state,
  StoryTransitionCommand command,
) {
  if (command.expectedStoryRevision != state.storyRevision) {
    return StoryRevisionConflict(
      command.expectedStoryRevision,
      state.storyRevision,
    );
  }
  return StoryTransitionApplied(
    StoryState(
      userId: state.userId,
      chapterId: command.chapterId,
      sceneId: command.sceneId,
      stepId: command.stepId,
      flags: {...state.flags, ...command.addFlags},
      choices: [...state.choices, ?command.choiceId],
      storyRevision: state.storyRevision + 1,
      schemaVersion: state.schemaVersion,
      contentVersion: command.contentVersion,
    ),
  );
}
