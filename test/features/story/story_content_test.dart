import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'story content ships the five Scene 1–5 tutorial beats and a six-slot deck pool',
    () async {
      final story =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/content/story/scene_1_5_v1.json',
                ),
              )
              as Map<String, dynamic>;
      final scenes = story['scenes'] as List<dynamic>;
      expect(story['contentVersion'], isNotEmpty);
      expect(scenes.map((scene) => (scene as Map<String, dynamic>)['id']), [
        'scene-1',
        'scene-2',
        'scene-3',
        'scene-4',
        'scene-5',
      ]);
      expect(story['status'], 'prototype-excerpt');

      final spells =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/content/spells/mvp_pool_v1.json',
                ),
              )
              as Map<String, dynamic>;
      expect(
        (spells['spells'] as List<dynamic>).length,
        greaterThanOrEqualTo(6),
      );
      expect(spells['status'], contains('proposal'));
    },
  );
}
