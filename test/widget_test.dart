import 'package:flutter_test/flutter_test.dart';

import 'package:badminton_profiles/models/game_session.dart';
import 'package:badminton_profiles/models/player_profile.dart';
import 'package:badminton_profiles/models/player_level_range.dart';
import 'package:badminton_profiles/models/user_settings.dart';
import 'package:badminton_profiles/player_app_manager.dart';
import 'package:badminton_profiles/repository/game_repository.dart';
import 'package:badminton_profiles/repository/player_repository.dart';
import 'package:badminton_profiles/repository/settings_repository.dart';

class _FakeRepository implements PlayerRepository {
  _FakeRepository([List<PlayerProfile>? players])
      : _players = List<PlayerProfile>.from(players ?? const []);

  List<PlayerProfile> _players;

  @override
  Future<void> init() async {}

  @override
  Future<List<PlayerProfile>> loadPlayers() async {
    return _players;
  }

  @override
  Future<void> savePlayer(PlayerProfile player) async {
    final index = _players.indexWhere((element) => element.id == player.id);
    if (index == -1) {
      _players.add(player);
    } else {
      _players[index] = player;
    }
  }

  @override
  Future<void> deletePlayer(String id) async {
    _players = _players.where((player) => player.id != id).toList();
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  UserSettings _settings = UserSettings.defaults;

  @override
  Future<void> init() async {}

  @override
  Future<UserSettings> loadSettings() async {
    return _settings;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    _settings = settings;
  }
}

class _FakeGameRepository implements GameRepository {
  List<GameSession> _games = [];

  @override
  Future<void> init() async {}

  @override
  Future<List<GameSession>> loadGames() async {
    return _games;
  }

  @override
  Future<void> saveGame(GameSession game) async {
    final index = _games.indexWhere((element) => element.id == game.id);
    if (index == -1) {
      _games.add(game);
    } else {
      _games[index] = game;
    }
  }

  @override
  Future<void> deleteGame(String id) async {
    _games = _games.where((game) => game.id != id).toList();
  }
}

void main() {
  testWidgets('renders player list header', (WidgetTester tester) async {
    final repository = _FakeRepository([
      PlayerProfile(
        id: 'player-1',
        nickname: 'Test Player',
        fullName: 'Test Player',
        contactNumber: '0000000000',
        email: 'test@example.com',
        address: 'Address',
        remarks: 'Remarks',
        levelRange: const PlayerLevelRange(startIndex: 0, endIndex: 0),
      ),
    ]);

    await tester.pumpWidget(PlayerAppManager(
      repository: repository,
      settingsRepository: _FakeSettingsRepository(),
      gameRepository: _FakeGameRepository(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('All Players'), findsOneWidget);
  });
}
