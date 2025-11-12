import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/players.dart';
import 'models/court_schedule.dart';
import 'models/game_session.dart';
import 'models/player_level_range.dart';
import 'models/player_profile.dart';
import 'models/user_settings.dart';
import 'player_app_manager.dart';
import 'repository/game_repository.dart';
import 'repository/player_repository.dart';
import 'repository/settings_repository.dart';

// Application entry point
Future<void> main() async {
  // Ensures Flutter binding is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database for local storage
  await Hive.initFlutter();

  // Register Hive type adapters for custom data serialization
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PlayerLevelRangeAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PlayerProfileAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(UserSettingsAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(CourtScheduleAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(GameSessionAdapter());
  }

  // Create repositories
  final repository = HivePlayerRepository(initialPlayers: seedPlayers);
  final settingsRepository = HiveSettingsRepository();
  final gameRepository = HiveGameRepository();

  // Launch the Flutter application
  runApp(PlayerAppManager(
    repository: repository,
    settingsRepository: settingsRepository,
    gameRepository: gameRepository,
  ));
}
