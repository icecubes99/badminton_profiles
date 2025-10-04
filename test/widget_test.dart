import 'package:flutter_test/flutter_test.dart';

import 'package:badminton_profiles/models/player_profile.dart';
import 'package:badminton_profiles/models/player_level_range.dart';
import 'package:badminton_profiles/player_app_manager.dart';
import 'package:badminton_profiles/repository/player_repository.dart';

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

    await tester.pumpWidget(PlayerAppManager(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('All Players'), findsOneWidget);
  });
}
