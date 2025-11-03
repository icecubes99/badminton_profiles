import 'package:hive/hive.dart';

import '../models/player_profile.dart';

// Abstract interface defining player data operations
abstract class PlayerRepository {
  Future<void> init(); // Initialize database connection

  Future<List<PlayerProfile>> loadPlayers(); // Retrieve all players

  Future<void> savePlayer(PlayerProfile player); // Save/update a player

  Future<void> deletePlayer(String id); // Remove a player by ID
}

// Hive database implementation of PlayerRepository
class HivePlayerRepository implements PlayerRepository {
  HivePlayerRepository({required this.initialPlayers});

  static const String playersBoxName = 'players_box'; // Hive box name

  final List<PlayerProfile> initialPlayers; // Seed data for first launch

  late Box<PlayerProfile> _box; // Hive database box instance

  @override
  Future<void> init() async {
    // Open Hive box for player data storage
    _box = await Hive.openBox<PlayerProfile>(playersBoxName);
    
    // Populate with initial data if database is empty
    if (_box.isEmpty) {
      for (final player in initialPlayers) {
        await _box.put(player.id, player);
      }
    }
  }

  @override
  Future<List<PlayerProfile>> loadPlayers() async {
    // Return all stored players as a list
    return _box.values.toList(growable: false);
  }

  @override
  Future<void> savePlayer(PlayerProfile player) async {
    // Store player using their ID as the key
    await _box.put(player.id, player);
  }

  @override
  Future<void> deletePlayer(String id) async {
    // Remove player from database by ID
    await _box.delete(id);
  }
}
