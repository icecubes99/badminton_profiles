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
  late List<PlayerProfile> _players;
  late Widget _activeScreen;
  int _idCounter = seedPlayers.length;

  @override
  void initState() {
    super.initState();
    _players = List<PlayerProfile>.of(seedPlayers);
    _activeScreen = _buildListScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3F6FB), Color(0xFFE7ECF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(child: _activeScreen),
        ),
      ),
    );
  }

  void _showListScreen() {
    setState(() {
      _activeScreen = _buildListScreen();
    });
  }

  void _showAddScreen() {
    setState(() {
      _activeScreen = AddPlayerScreen(
        onSubmit: _handleCreatePlayer,
        onCancel: _showListScreen,
      );
    });
  }

  void _showEditScreen(PlayerProfile player) {
    setState(() {
      _activeScreen = EditPlayerScreen(
        player: player,
        onSubmit: (values) => _handleUpdatePlayer(player.id, values),
        onDelete: () => _handleDeletePlayer(player.id),
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
      _activeScreen = _buildListScreen();
    });
  }

  void _handleUpdatePlayer(String id, PlayerFormValues values) {
    final index = _players.indexWhere((player) => player.id == id);
    if (index == -1) {
      return;
    }

    final updated = _players[index].copyWith(
      nickname: values.nickname,
      fullName: values.fullName,
      contactNumber: values.contactNumber,
      email: values.email,
      address: values.address,
      remarks: values.remarks,
      levelRange: values.levelRange,
    );

    setState(() {
      _players[index] = updated;
      _activeScreen = _buildListScreen();
    });
  }

  void _handleDeletePlayer(String id) {
    setState(() {
      _players.removeWhere((player) => player.id == id);
      _activeScreen = _buildListScreen();
    });
  }

  Widget _buildListScreen() {
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
