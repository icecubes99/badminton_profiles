import 'package:flutter/material.dart';

import '../models/game_session.dart';

// Main screen that displays a searchable list of all games with add/edit/delete functionality
class GamesListScreen extends StatefulWidget {
  const GamesListScreen({
    super.key,
    required this.games,
    required this.onAddGame,
    required this.onViewGame,
    required this.onDeleteGame,
    this.isLoading = false,
  });

  final List<GameSession> games; // List of games to display
  final VoidCallback onAddGame; // Callback to add new game
  final void Function(GameSession game) onViewGame; // Callback to view game details
  final Future<void> Function(String gameId) onDeleteGame; // Callback to delete game
  final bool isLoading; // Loading state indicator

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  String _searchTerm = ''; // Current search query

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being fetched
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final filteredGames = _filterGames(); // Apply search filter

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640), // Limit content width
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with title and add button
              Row(
                children: [
                  const Text(
                    'All Games',
                    style: TextStyle(
                      color: Color(0xFF1C2B5A),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  _buildAddButton(), // Floating action button for adding games
                ],
              ),
              const SizedBox(height: 20),
              _buildSearchField(), // Search input field
              const SizedBox(height: 20),
              Expanded(
                child: filteredGames.isEmpty
                    ? _buildEmptyState() // Show empty state when no games found
                    : _buildGamesList(filteredGames), // Show filtered games list
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the search input field with styling and real-time filtering
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDFE5F1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1C2B5A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchTerm = value.trim(); // Update search term and rebuild UI
          });
        },
        style: const TextStyle(color: Color(0xFF1C2B5A)),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color(0xFF6C7A92)), // Search icon
          hintText: 'Search by game name or date',
          hintStyle: TextStyle(color: Color(0xFF9AA5BD)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Builds the scrollable list of games with swipe-to-delete functionality
  Widget _buildGamesList(List<GameSession> games) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6ECF5)),
        ),
        child: ListView.separated(
          itemCount: games.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE6ECF5)), // Dividers between items
          itemBuilder: (context, index) {
            final game = games[index];
            return Dismissible(
              key: ValueKey(game.id), // Unique key for each game
              direction: DismissDirection.endToStart, // Swipe right to left
              background: _buildDismissibleBackground(), // Red delete background
              confirmDismiss: (_) => _confirmDelete(game), // Confirm before deleting
              child: _buildGameTile(game),
            );
          },
        ),
      ),
    );
  }

  // Builds a game tile showing game info
  Widget _buildGameTile(GameSession game) {
    return InkWell(
      onTap: () => widget.onViewGame(game),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Game icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.sports_tennis,
                color: Color(0xFF3D73FF),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Game details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.displayTitle,
                    style: const TextStyle(
                      color: Color(0xFF1C2B5A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatScheduleInfo(game),
                    style: const TextStyle(
                      color: Color(0xFF7A88A8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 14,
                        color: Color(0xFF9AA5BD),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${game.playerIds.length} ${game.playerIds.length == 1 ? 'player' : 'players'}',
                        style: const TextStyle(
                          color: Color(0xFF9AA5BD),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.attach_money,
                        size: 14,
                        color: Color(0xFF9AA5BD),
                      ),
                      Text(
                        '\$${game.totalCourtCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF9AA5BD),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9AA5BD),
            ),
          ],
        ),
      ),
    );
  }

  String _formatScheduleInfo(GameSession game) {
    if (game.schedules.isEmpty) {
      return 'No schedules';
    }
    final firstSchedule = game.schedules.first;
    final date = firstSchedule.startTime;
    return '${_monthName(date.month)} ${date.day}, ${date.year} • ${game.schedules.length} schedule${game.schedules.length > 1 ? 's' : ''}';
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  // Builds the circular add button with blue background
  Widget _buildAddButton() {
    return Material(
      color: const Color(0xFF3D73FF), // Blue background
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onAddGame, // Trigger add game callback
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.add, color: Colors.white, size: 28), // White plus icon
        ),
      ),
    );
  }

  // Filters the games list based on search term (game title or date)
  List<GameSession> _filterGames() {
    final query = _searchTerm.toLowerCase();
    if (query.isEmpty) {
      return widget.games; // Return all games if no search term
    }
    return widget.games.where((game) {
      // Search by title
      final titleMatch = game.displayTitle.toLowerCase().contains(query);
      
      // Search by date
      final dateStr = _formatScheduleInfo(game).toLowerCase();
      final dateMatch = dateStr.contains(query);
      
      return titleMatch || dateMatch;
    }).toList();
  }

  // Shows empty state when no games are found or list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.sports_tennis, color: Color(0xFFB7C1D9), size: 56), // Tennis icon
          SizedBox(height: 12),
          Text(
            'No games found',
            style: TextStyle(
              color: Color(0xFF6F7D96),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Builds the red background shown when swiping to delete
  Widget _buildDismissibleBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF6B6B), // Red background color
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Icon(Icons.delete, color: Colors.white), // White delete icon
    );
  }

  // Shows confirmation dialog and handles delete action
  Future<bool?> _confirmDelete(GameSession game) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: Text('Delete "${game.displayTitle}"?'), // Show game title
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel deletion
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm deletion
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((shouldDelete) async {
      if (shouldDelete == true) {
        await widget.onDeleteGame(game.id); // Execute delete callback
      }
      return shouldDelete; // Return result for Dismissible widget
    });
  }
}
