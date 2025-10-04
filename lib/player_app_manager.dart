import 'package:flutter/material.dart';

import 'data/players.dart';
import 'models/player_form_values.dart';
import 'models/player_profile.dart';
import 'screens/add_player_screen.dart';
import 'screens/edit_player_screen.dart';
import 'screens/player_list_screen.dart';

class PlayerAppManager extends StatefulWidget {
  const PlayerAppManager({super.key});

  @override
  State<PlayerAppManager> createState() => _PlayerAppManagerState();
}

class _PlayerAppManagerState extends State<PlayerAppManager> {
  Widget? activeScreen;
  late List<PlayerProfile> _players;
  int _idCounter = seedPlayers.length;

  @override
  void initState() {
    super.initState();
    _players = List<PlayerProfile>.of(seedPlayers);
    activeScreen = _buildListScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: activeScreen ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void _showListScreen() {
    setState(() {
      activeScreen = _buildListScreen();
    });
  }

  void _showAddScreen() {
    setState(() {
      activeScreen = AddPlayerScreen(
        onSubmit: _handleCreatePlayer,
        onCancel: _showListScreen,
      );
    });
  }

  void _showEditScreen(PlayerProfile profile) {
    setState(() {
      activeScreen = EditPlayerScreen(
        player: profile,
        onSubmit: (values) => _handleUpdatePlayer(profile.id, values),
        onDelete: () => _handleDeletePlayer(profile.id),
        onCancel: _showListScreen,
      );
    });
  }

  void _handleCreatePlayer(PlayerFormValues values) {
    final newPlayer = PlayerProfile(
      id: _generateId(),
      nickname: values.nickname,
      fullName: values.fullName,
      contactNumber: values.contactNumber,
      email: values.email,
      address: values.address,
      remarks: values.remarks,
      levelRange: values.levelRange,
    );

    setState(() {
      _players.add(newPlayer);
      activeScreen = _buildListScreen();
    });
  }

  void _handleUpdatePlayer(String id, PlayerFormValues values) {
    final playerIndex = _players.indexWhere((player) => player.id == id);
    if (playerIndex == -1) {
      return;
    }

    final updatedPlayer = _players[playerIndex].copyWith(
      nickname: values.nickname,
      fullName: values.fullName,
      contactNumber: values.contactNumber,
      email: values.email,
      address: values.address,
      remarks: values.remarks,
      levelRange: values.levelRange,
    );

    setState(() {
      _players[playerIndex] = updatedPlayer;
      activeScreen = _buildListScreen();
    });
  }

  void _handleDeletePlayer(String id) {
    setState(() {
      _players.removeWhere((player) => player.id == id);
      activeScreen = _buildListScreen();
    });
  }

  PlayerListScreen _buildListScreen() {
    return PlayerListScreen(
      players: _players,
      onAddPlayer: _showAddScreen,
      onEditPlayer: _showEditScreen,
      onDeletePlayer: _handleDeletePlayer,
    );
  }

  String _generateId() {
    _idCounter += 1;
    return 'player-$_idCounter';
  }
}
