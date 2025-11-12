import 'package:hive_flutter/hive_flutter.dart';

import '../models/game_session.dart';

// Abstract interface for game session persistence
abstract class GameRepository {
  Future<void> init();
  Future<List<GameSession>> loadGames();
  Future<void> saveGame(GameSession game);
  Future<void> deleteGame(String id);
}

// Hive implementation of game repository
class HiveGameRepository implements GameRepository {
  static const String _boxName = 'game_sessions';
  Box<GameSession>? _box;

  @override
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<GameSession>(_boxName);
    }
  }

  @override
  Future<List<GameSession>> loadGames() async {
    await init();
    return _box!.values.toList();
  }

  @override
  Future<void> saveGame(GameSession game) async {
    await init();
    await _box!.put(game.id, game);
  }

  @override
  Future<void> deleteGame(String id) async {
    await init();
    await _box!.delete(id);
  }
}
