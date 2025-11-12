import 'package:flutter/material.dart';

import 'data/players.dart';
import 'models/court_schedule.dart';
import 'models/game_session.dart';
import 'models/player_form_values.dart';
import 'models/player_profile.dart';
import 'models/user_settings.dart';
import 'repository/game_repository.dart';
import 'repository/player_repository.dart';
import 'repository/settings_repository.dart';
import 'screens/add_game_screen.dart';
import 'screens/add_player_screen.dart';
import 'screens/add_player_to_game_screen.dart';
import 'screens/edit_game_screen.dart';
import 'screens/edit_player_screen.dart';
import 'screens/games_list_screen.dart';
import 'screens/player_list_screen.dart';
import 'screens/user_settings_screen.dart';
import 'screens/view_game_screen.dart';

// Main app manager that handles navigation and player data management
class PlayerAppManager extends StatefulWidget {
  const PlayerAppManager({
    super.key, 
    required this.repository,
    required this.settingsRepository,
    required this.gameRepository,
  });

  final PlayerRepository repository; // Data access layer
  final SettingsRepository settingsRepository; // Settings data access layer
  final GameRepository gameRepository; // Game sessions data access layer

  @override
  State<PlayerAppManager> createState() => _PlayerAppManagerState();
}

class _PlayerAppManagerState extends State<PlayerAppManager> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  
  List<PlayerProfile> _players = const []; // Current list of players
  List<GameSession> _games = const []; // Current list of games
  UserSettings _settings = UserSettings.defaults; // Current user settings
  int _currentNavIndex = 0; // Current navigation tab index (0: Players, 1: Games, 2: Settings)
  late Widget _activeScreen; // Currently displayed screen
  bool _isLoading = true; // Loading state indicator
  int _playerIdCounter = 0; // Counter for generating unique player IDs
  int _gameIdCounter = 0; // Counter for generating unique game IDs

  @override
  void initState() {
    super.initState();
    _activeScreen = _buildListScreen();
    _initialize(); // Load initial data
  }

  // Initialize the app by loading saved players, games, and settings from database
  Future<void> _initialize() async {
    await widget.repository.init();
    await widget.settingsRepository.init();
    await widget.gameRepository.init();
    final loadedPlayers = await widget.repository.loadPlayers();
    final loadedSettings = await widget.settingsRepository.loadSettings();
    final loadedGames = await widget.gameRepository.loadGames();
    setState(() {
      _players = loadedPlayers;
      _settings = loadedSettings;
      _games = loadedGames;
      _isLoading = false;
      _playerIdCounter = _derivePlayerCounter(loadedPlayers); // Set counter based on existing data
      _gameIdCounter = _deriveGameCounter(loadedGames);
      _activeScreen = _buildListScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
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
        bottomNavigationBar: _buildBottomNavigationBar(), // Add bottom navigation
      ),
    );
  }

  // Build bottom navigation bar with three main sections
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C1C2B5A),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: _onNavTapped,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3D73FF),
          unselectedItemColor: const Color(0xFF9AA5BD),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Players',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_tennis_outlined),
              activeIcon: Icon(Icons.sports_tennis),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  // Handle navigation tab changes
  void _onNavTapped(int index) {
    setState(() {
      _currentNavIndex = index;
      switch (index) {
        case 0:
          _activeScreen = _buildListScreen();
          break;
        case 1:
          _activeScreen = _buildGamesListScreen();
          break;
        case 2:
          _activeScreen = UserSettingsScreen(
            currentSettings: _settings,
            onSave: _handleSaveSettings,
            onCancel: () => _onNavTapped(0), // Go back to players
          );
          break;
      }
    });
  }

  // Build the Games List screen
  Widget _buildGamesListScreen() {
    return GamesListScreen(
      games: _games,
      onAddGame: _showAddGameScreen,
      onViewGame: _showViewGameScreen,
      onDeleteGame: _handleDeleteGame,
      isLoading: _isLoading,
    );
  }

  // Build the Add Game screen
  Widget _buildAddGameScreen() {
    return AddGameScreen(
      userSettings: _settings,
      onSave: _handleCreateGame,
      onCancel: _showGamesListScreen,
    );
  }

  // Navigation methods for games
  void _showGamesListScreen() {
    setState(() {
      _currentNavIndex = 1;
      _activeScreen = _buildGamesListScreen();
    });
  }

  void _showAddGameScreen() {
    setState(() {
      _activeScreen = _buildAddGameScreen();
    });
  }

  void _showViewGameScreen(GameSession game) {
    setState(() {
      _activeScreen = ViewGameScreen(
        game: game,
        players: _players,
        onEdit: () => _showEditGameScreen(game),
        onDelete: () => _handleDeleteGame(game.id),
        onBack: _showGamesListScreen,
        onAddPlayer: () => _showAddPlayerToGameScreen(game),
        onRemovePlayer: (playerId) => _handleRemovePlayerFromGame(game.id, playerId),
      );
    });
  }

  void _showAddPlayerToGameScreen(GameSession game) {
    // Filter out players already in the game
    final availablePlayers = _players.where((p) => !game.playerIds.contains(p.id)).toList();
    
    setState(() {
      _activeScreen = AddPlayerToGameScreen(
        availablePlayers: availablePlayers,
        onPlayerSelected: (playerId) => _handleAddPlayerToGame(game.id, playerId),
        onCancel: () => _showViewGameScreen(game),
      );
    });
  }

  void _showEditGameScreen(GameSession game) {
    setState(() {
      _activeScreen = EditGameScreen(
        game: game,
        onSave: ({
          String? gameTitle,
          required String courtName,
          required List<CourtSchedule> schedules,
          required double courtRate,
          required double shuttleCockPrice,
          required bool divideCourtEqually,
        }) => _handleUpdateGame(
          game.id,
          gameTitle: gameTitle,
          courtName: courtName,
          schedules: schedules,
          courtRate: courtRate,
          shuttleCockPrice: shuttleCockPrice,
          divideCourtEqually: divideCourtEqually,
        ),
        onCancel: () => _showViewGameScreen(game),
      );
    });
  }

  // Create a new game session
  Future<void> _handleCreateGame({
    String? gameTitle,
    required String courtName,
    required List<CourtSchedule> schedules,
    required double courtRate,
    required double shuttleCockPrice,
    required bool divideCourtEqually,
  }) async {
    final newGame = GameSession(
      id: _generateGameId(),
      gameTitle: gameTitle,
      courtName: courtName,
      schedules: schedules,
      courtRate: courtRate,
      shuttleCockPrice: shuttleCockPrice,
      divideCourtEqually: divideCourtEqually,
      createdAt: DateTime.now(),
    );

    await widget.gameRepository.saveGame(newGame);

    setState(() {
      _games = [..._games, newGame];
      _currentNavIndex = 1;
      _activeScreen = _buildGamesListScreen();
    });

    // Show success message
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Game "${newGame.displayTitle}" created successfully!'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  // Delete a game from database and local list
  Future<void> _handleDeleteGame(String id) async {
    await widget.gameRepository.deleteGame(id);

    setState(() {
      _games = _games.where((game) => game.id != id).toList();
      _activeScreen = _buildGamesListScreen();
    });
  }

  // Update an existing game session
  Future<void> _handleUpdateGame(
    String id, {
    String? gameTitle,
    required String courtName,
    required List<CourtSchedule> schedules,
    required double courtRate,
    required double shuttleCockPrice,
    required bool divideCourtEqually,
  }) async {
    final index = _games.indexWhere((game) => game.id == id);
    if (index == -1) {
      return; // Game not found
    }

    // Create updated game using copyWith method
    final updated = _games[index].copyWith(
      gameTitle: gameTitle,
      courtName: courtName,
      schedules: schedules,
      courtRate: courtRate,
      shuttleCockPrice: shuttleCockPrice,
      divideCourtEqually: divideCourtEqually,
    );

    await widget.gameRepository.saveGame(updated);

    setState(() {
      _games = [..._games]..[index] = updated;
      _activeScreen = _buildGamesListScreen();
    });

    // Show success message
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Game "${updated.displayTitle}" updated successfully!'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  // Add a player to a game
  Future<void> _handleAddPlayerToGame(String gameId, String playerId) async {
    final index = _games.indexWhere((game) => game.id == gameId);
    if (index == -1) {
      return; // Game not found
    }

    final game = _games[index];
    if (game.playerIds.contains(playerId)) {
      return; // Player already in game
    }

    // Add player to game
    final updated = game.copyWith(
      playerIds: [...game.playerIds, playerId],
    );

    await widget.gameRepository.saveGame(updated);

    setState(() {
      _games = [..._games]..[index] = updated;
      _showViewGameScreen(updated); // Go back to view screen
    });

    // Show success message
    final player = _players.firstWhere((p) => p.id == playerId);
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('${player.nickname} added to game'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  // Remove a player from a game
  Future<void> _handleRemovePlayerFromGame(String gameId, String playerId) async {
    final index = _games.indexWhere((game) => game.id == gameId);
    if (index == -1) {
      return; // Game not found
    }

    final game = _games[index];
    
    // Remove player from game
    final updated = game.copyWith(
      playerIds: game.playerIds.where((id) => id != playerId).toList(),
    );

    await widget.gameRepository.saveGame(updated);

    setState(() {
      _games = [..._games]..[index] = updated;
      _showViewGameScreen(updated); // Refresh view screen
    });

    // Show success message
    final player = _players.firstWhere((p) => p.id == playerId);
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('${player.nickname} removed from game'),
        backgroundColor: const Color(0xFFFF9800),
      ),
    );
  }

  // Generate unique ID for new games
  String _generateGameId() {
    _gameIdCounter += 1;
    return 'game-$_gameIdCounter';
  }

  // Calculate the highest existing game ID number
  int _deriveGameCounter(List<GameSession> games) {
    if (games.isEmpty) {
      return 0;
    }
    int maxValue = 0;
    for (final game in games) {
      final parts = game.id.split('-');
      if (parts.isNotEmpty) {
        final value = int.tryParse(parts.last) ?? 0;
        if (value > maxValue) {
          maxValue = value;
        }
      }
    }
    return maxValue;
  }

  // Build placeholder screen for future features
  Widget _buildPlaceholderScreen(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: const Color(0xFFB7C1D9)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C2B5A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF7A88A8),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods to switch between screens
  void _showListScreen() {
    setState(() {
      _currentNavIndex = 0;
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

  // Save user settings to database
  Future<void> _handleSaveSettings(UserSettings settings) async {
    await widget.settingsRepository.saveSettings(settings);

    setState(() {
      _settings = settings;
      _currentNavIndex = 0;
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
    _playerIdCounter += 1;
    return 'player-$_playerIdCounter';
  }

  // Calculate the highest existing player ID number to continue sequence
  int _derivePlayerCounter(List<PlayerProfile> players) {
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

