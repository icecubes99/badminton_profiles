import 'package:flutter/material.dart';

import 'package:badminton_profiles/widgets/player_list_tile.dart';
import '../models/player_profile.dart';

// Main screen that displays a searchable list of all players with add/edit/delete functionality
class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({
    super.key,
    required this.players,
    required this.onAddPlayer,
    required this.onEditPlayer,
    required this.onDeletePlayer,
    this.isLoading = false,
  });

  final List<PlayerProfile> players; // List of players to display
  final VoidCallback onAddPlayer; // Callback to add new player
  final void Function(PlayerProfile player) onEditPlayer; // Callback to edit existing player
  final Future<void> Function(String playerId) onDeletePlayer; // Callback to delete player
  final bool isLoading; // Loading state indicator

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  String _searchTerm = ''; // Current search query

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being fetched
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final filteredPlayers = _filterPlayers(); // Apply search filter

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
                    'All Players',
                    style: TextStyle(
                      color: Color(0xFF1C2B5A),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  _buildAddButton(), // Floating action button for adding players
                ],
              ),
              const SizedBox(height: 20),
              _buildSearchField(), // Search input field
              const SizedBox(height: 20),
              Expanded(
                child: filteredPlayers.isEmpty
                    ? _buildEmptyState() // Show empty state when no players found
                    : _buildPlayerList(filteredPlayers), // Show filtered player list
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
          hintText: 'Search by name or nickname',
          hintStyle: TextStyle(color: Color(0xFF9AA5BD)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Builds the scrollable list of players with swipe-to-delete functionality
  Widget _buildPlayerList(List<PlayerProfile> players) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6ECF5)),
        ),
        child: ListView.separated(
          itemCount: players.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE6ECF5)), // Dividers between items
          itemBuilder: (context, index) {
            final player = players[index];
            return Dismissible(
              key: ValueKey(player.id), // Unique key for each player
              direction: DismissDirection.endToStart, // Swipe right to left
              background: _buildDismissibleBackground(), // Red delete background
              confirmDismiss: (_) => _confirmDelete(player), // Confirm before deleting
              child: PlayerTile(
                player: player,
                onTap: () => widget.onEditPlayer(player), // Tap to edit player
              ),
            );
          },
        ),
      ),
    );
  }

  // Builds the circular add button with blue background
  Widget _buildAddButton() {
    return Material(
      color: const Color(0xFF3D73FF), // Blue background
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onAddPlayer, // Trigger add player callback
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.add, color: Colors.white, size: 28), // White plus icon
        ),
      ),
    );
  }

  // Filters the player list based on search term (nickname or full name)
  List<PlayerProfile> _filterPlayers() {
    final query = _searchTerm.toLowerCase();
    if (query.isEmpty) {
      return widget.players; // Return all players if no search term
    }
    return widget.players.where((player) {
      return player.nickname.toLowerCase().contains(query) ||
          player.fullName.toLowerCase().contains(query); // Case-insensitive search
    }).toList();
  }

  // Shows empty state when no players are found or list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.sports_tennis, color: Color(0xFFB7C1D9), size: 56), // Tennis icon
          SizedBox(height: 12),
          Text(
            'No players found',
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
  Future<bool?> _confirmDelete(PlayerProfile player) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text('Delete ${player.nickname}?'), // Show player nickname
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
        await widget.onDeletePlayer(player.id); // Execute delete callback
      }
      return shouldDelete; // Return result for Dismissible widget
    });
  }
}
