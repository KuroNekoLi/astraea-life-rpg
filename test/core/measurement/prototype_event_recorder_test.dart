import 'dart:convert';

import 'package:astraea_life_rpg/core/measurement/prototype_event_recorder.dart';
import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'measurement is off by default and records only allowlisted local milestones',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final recorder = PrototypeEventRecorder(
        database,
        () => DateTime.utc(2026, 1, 1),
      );
      await recorder.record(
        type: PrototypeEventType.characterCreated,
        properties: {'contentVersion': 'story-1'},
      );
      expect(await database.recordsOf('pilotEvent'), isEmpty);

      await recorder.setOptIn(true);
      await recorder.record(
        type: PrototypeEventType.lifeQuestCompleted,
        properties: {
          'lifeDomain': 'learning',
          'questTemplateId': 'learning.read20',
        },
        idempotencyKey: 'activity-1',
      );
      await recorder.record(
        type: PrototypeEventType.lifeQuestCompleted,
        properties: {
          'lifeDomain': 'learning',
          'questTemplateId': 'learning.read20',
        },
        idempotencyKey: 'activity-1',
      );
      expect((await database.recordsOf('pilotEvent')).length, 1);
      final row = (await database.recordsOf('pilotEvent')).single;
      final payload =
          jsonDecode(row.read<String>('payload')) as Map<String, dynamic>;
      expect(payload['eventName'], 'lifeQuestCompleted');
      expect(payload['properties'], {
        'lifeDomain': 'learning',
        'questTemplateId': 'learning.read20',
      });
      await expectLater(
        recorder.record(
          type: PrototypeEventType.characterCreated,
          properties: {'playerName': 'private'},
        ),
        throwsArgumentError,
      );
      await expectLater(
        recorder.record(
          type: PrototypeEventType.characterCreated,
          properties: {'result': 'private free text'},
        ),
        throwsArgumentError,
      );

      await recorder.setOptIn(false);
      expect(await database.recordsOf('pilotEvent'), isEmpty);
    },
  );
}
