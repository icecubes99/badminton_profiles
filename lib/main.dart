import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/players.dart';
import 'models/player_level_range.dart';
import 'models/player_profile.dart';
import 'player_app_manager.dart';
import 'repository/player_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PlayerLevelRangeAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PlayerProfileAdapter());
  }

  final repository = HivePlayerRepository(initialPlayers: seedPlayers);

  runApp(PlayerAppManager(repository: repository));
}
