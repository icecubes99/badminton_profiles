import 'package:flutter/material.dart';

import 'data/players.dart';
import 'models/player_form_values.dart';
import 'models/player_profile.dart';
import 'repository/player_repository.dart';
import 'screens/add_player_screen.dart';
import 'screens/edit_player_screen.dart';
import 'screens/player_list_screen.dart';

class PlayerAppManager extends StatefulWidget {
  const PlayerAppManager({super.key, required this.repository});

  final PlayerRepository repository;

  @override
  State<PlayerAppManager> createState() => _PlayerAppManagerState();
}

class _PlayerAppManagerState extends State<PlayerAppManager> {
  List<PlayerProfile> _players = const [];
  late Widget _activeScreen;
  bool _isLoading = true;
  int _idCounter = 0;

  @override
  void initState() {
    super.initState();
    _activeScreen = _buildListScreen();
    _initialize();
  }

  Future<void> _initialize() async {
    await widget.repository.init();
    final loadedPlayers = await widget.repository.loadPlayers();
    setState(() {
      _players = loadedPlayers;
      _isLoading = false;
      _idCounter = _deriveCounter(loadedPlayers);
      _activeScreen = _buildListScreen();
    });
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

  Future<void> _handleCreatePlayer(PlayerFormValues values) async {
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

    await widget.repository.savePlayer(newPlayer);

    setState(() {
      _players = [..._players, newPlayer];
      _activeScreen = _buildListScreen();
    });
  }

  Future<void> _handleUpdatePlayer(String id, PlayerFormValues values) async {
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

    await widget.repository.savePlayer(updated);

    setState(() {
      final nextPlayers = [..._players];
      nextPlayers[index] = updated;
      _players = nextPlayers;
      _activeScreen = _buildListScreen();
    });
  }

  Future<void> _handleDeletePlayer(String id) async {
    await widget.repository.deletePlayer(id);

    setState(() {
      _players = _players.where((player) => player.id != id).toList();
      _activeScreen = _buildListScreen();
    });
  }

  Widget _buildListScreen() {
    return PlayerListScreen(
      players: _players,
      onAddPlayer: _showAddScreen,
      onEditPlayer: _showEditScreen,
      onDeletePlayer: _handleDeletePlayer,
      isLoading: _isLoading,
    );
  }

  String _generateId() {
    _idCounter += 1;
    return 'player-$_idCounter';
  }

  int _deriveCounter(List<PlayerProfile> players) {
    if (players.isEmpty) {
      return seedPlayers.length;
    }
    int maxValue = seedPlayers.length;
    for (final player in players) {
      final parts = player.id.split('-');
      if (parts.isNotEmpty) {
        final value = int.tryParse(parts.last) ?? 0;
        if (value > maxValue) {
          maxValue = value;
        }
      }
    }
    return maxValue;
  }
}

