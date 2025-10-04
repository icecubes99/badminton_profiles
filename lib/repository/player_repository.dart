import 'package:hive/hive.dart';

import '../models/player_profile.dart';

abstract class PlayerRepository {
  Future<void> init();

  Future<List<PlayerProfile>> loadPlayers();

  Future<void> savePlayer(PlayerProfile player);

  Future<void> deletePlayer(String id);
}

class HivePlayerRepository implements PlayerRepository {
  HivePlayerRepository({required this.initialPlayers});

  static const String playersBoxName = 'players_box';

  final List<PlayerProfile> initialPlayers;

  late Box<PlayerProfile> _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<PlayerProfile>(playersBoxName);
    if (_box.isEmpty) {
      for (final player in initialPlayers) {
        await _box.put(player.id, player);
      }
    }
  }

  @override
  Future<List<PlayerProfile>> loadPlayers() async {
    return _box.values.toList(growable: false);
  }

  @override
  Future<void> savePlayer(PlayerProfile player) async {
    await _box.put(player.id, player);
  }

  @override
  Future<void> deletePlayer(String id) async {
    await _box.delete(id);
  }
}
