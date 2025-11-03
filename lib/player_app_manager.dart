import 'package:flutter/material.dart';

import 'data/players.dart';
import 'models/player_form_values.dart';
import 'models/player_profile.dart';
import 'repository/player_repository.dart';
import 'screens/add_player_screen.dart';
import 'screens/edit_player_screen.dart';
import 'screens/player_list_screen.dart';

// Main app manager that handles navigation and player data management
class PlayerAppManager extends StatefulWidget {
  const PlayerAppManager({super.key, required this.repository});

  final PlayerRepository repository; // Data access layer

  @override
  State<PlayerAppManager> createState() => _PlayerAppManagerState();
}

class _PlayerAppManagerState extends State<PlayerAppManager> {
  List<PlayerProfile> _players = const []; // Current list of players
  late Widget _activeScreen; // Currently displayed screen
  bool _isLoading = true; // Loading state indicator
  int _idCounter = 0; // Counter for generating unique player IDs

  @override
  void initState() {
    super.initState();
    _activeScreen = _buildListScreen();
    _initialize(); // Load initial data
  }

  // Initialize the app by loading saved players from database
  Future<void> _initialize() async {
    await widget.repository.init();
    final loadedPlayers = await widget.repository.loadPlayers();
    setState(() {
      _players = loadedPlayers;
      _isLoading = false;
      _idCounter = _deriveCounter(loadedPlayers); // Set counter based on existing data
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
          // Gradient background for visual appeal
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3F6FB), Color(0xFFE7ECF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(child: _activeScreen), // Display current screen
        ),
      ),
    );
  }

  // Navigation methods to switch between screens
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

  // Create a new player from form data and save to database
  Future<void> _handleCreatePlayer(PlayerFormValues values) async {
    final newPlayer = PlayerProfile(
      id: _generateId(), // Generate unique ID
      nickname: values.nickname,
      fullName: values.fullName,
      contactNumber: values.contactNumber,
      email: values.email,
      address: values.address,
      remarks: values.remarks,
      levelRange: values.levelRange,
    );

    await widget.repository.savePlayer(newPlayer); // Persist to database

    setState(() {
      _players = [..._players, newPlayer]; // Add to local list
      _activeScreen = _buildListScreen(); // Return to list view
    });
  }

  // Update existing player with new form data
  Future<void> _handleUpdatePlayer(String id, PlayerFormValues values) async {
    final index = _players.indexWhere((player) => player.id == id);
    if (index == -1) {
      return; // Player not found
    }

    // Create updated player using copyWith method
    final updated = _players[index].copyWith(
      nickname: values.nickname,
      fullName: values.fullName,
      contactNumber: values.contactNumber,
      email: values.email,
      address: values.address,
      remarks: values.remarks,
      levelRange: values.levelRange,
    );

    await widget.repository.savePlayer(updated); // Save to database

    setState(() {
      final nextPlayers = [..._players];
      nextPlayers[index] = updated; // Update local list
      _players = nextPlayers;
      _activeScreen = _buildListScreen();
    });
  }

  // Remove player from database and local list
  Future<void> _handleDeletePlayer(String id) async {
    await widget.repository.deletePlayer(id);

    setState(() {
      _players = _players.where((player) => player.id != id).toList();
      _activeScreen = _buildListScreen();
    });
  }

  // Build the main player list screen
  Widget _buildListScreen() {
    return PlayerListScreen(
      players: _players,
      onAddPlayer: _showAddScreen,
      onEditPlayer: _showEditScreen,
      onDeletePlayer: _handleDeletePlayer,
      isLoading: _isLoading,
    );
  }

  // Generate unique ID for new players
  String _generateId() {
    _idCounter += 1;
    return 'player-$_idCounter';
  }

  // Calculate the highest existing ID number to continue sequence
  int _deriveCounter(List<PlayerProfile> players) {
    if (players.isEmpty) {
      return seedPlayers.length; // Start after seed data
    }
    int maxValue = seedPlayers.length;
    for (final player in players) {
      final parts = player.id.split('-');
      if (parts.isNotEmpty) {
        final value = int.tryParse(parts.last) ?? 0;
        if (value > maxValue) {
          maxValue = value; // Find highest existing ID number
        }
      }
    }
    return maxValue;
  }
}

