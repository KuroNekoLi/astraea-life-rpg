import 'package:astraea_life_rpg/core/persistence/app_database.dart';
import 'package:astraea_life_rpg/features/combat/data/combat_checkpoint_repository.dart';
import 'package:astraea_life_rpg/game_engine/combat/combat_engine.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'battle checkpoint round-trips turn, units, Mana and log for resume',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final checkpoint = CombatState(
        combatants: [
          CombatantState(
            id: 'hero',
            side: CombatSide.player,
            hp: 18,
            maxHp: 20,
            mana: 4,
            maxMana: 8,
            attackBonus: 2,
            defense: 12,
            processingModifier: 1,
            zone: 'near',
            reactionAvailable: false,
            mainActionUsed: true,
          ),
          CombatantState(
            id: 'sentry',
            side: CombatSide.enemy,
            hp: 9,
            maxHp: 12,
            mana: 0,
            maxMana: 0,
            attackBonus: 1,
            defense: 10,
            processingModifier: 0,
            zone: 'far',
            reactionAvailable: true,
          ),
        ],
        initiativeOrder: ['hero', 'sentry'],
        activeCombatantId: 'sentry',
        round: 2,
        revision: 7,
        seed: 42,
        rngState: 123456,
        eventLog: ['hit', 'moved'],
      );
      final store = CombatCheckpointRepository(database);
      await store.save(
        checkpoint,
        battleId: 'training-1',
        savedAt: DateTime.utc(2026, 1, 1),
      );
      final restored = await store.latest(battleId: 'training-1');
      expect(restored, isNotNull);
      expect(restored!.revision, 7);
      expect(restored.round, 2);
      expect(restored.activeCombatantId, 'sentry');
      expect(restored.unit('hero').hp, 18);
      expect(restored.unit('hero').mana, 4);
      expect(restored.unit('hero').mainActionUsed, isTrue);
      expect(restored.eventLog, ['hit', 'moved']);
      expect(restored.seed, 42);
      expect(restored.rngState, 123456);
    },
  );
}
