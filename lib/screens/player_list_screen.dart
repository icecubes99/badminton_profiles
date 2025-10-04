import 'package:flutter/material.dart';

import '../models/player_profile.dart';
import '../widgets/player_list_tile.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({
    super.key,
    required this.players,
    required this.onAddPlayer,
    required this.onEditPlayer,
    required this.onDeletePlayer,
  });

  final List<PlayerProfile> players;
  final VoidCallback onAddPlayer;
  final void Function(PlayerProfile player) onEditPlayer;
  final void Function(String playerId) onDeletePlayer;

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = _filterPlayers();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'All Players',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) {
              setState(() {
                _searchTerm = value.trim();
              });
            },
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Search by nickname or full name',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredPlayers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      return Dismissible(
                        key: ValueKey(player.id),
                        direction: DismissDirection.endToStart,
                        background: _buildDismissibleBackground(),
                        confirmDismiss: (_) => _confirmDelete(player),
                        child: PlayerListTile(
                          player: player,
                          onTap: () => widget.onEditPlayer(player),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onAddPlayer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.person_add),
            label: const Text('Add New Player'),
          ),
        ],
      ),
    );
  }

  List<PlayerProfile> _filterPlayers() {
    final query = _searchTerm.toLowerCase();
    if (query.isEmpty) {
      return widget.players;
    }
    return widget.players.where((player) {
      return player.nickname.toLowerCase().contains(query) ||
          player.fullName.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.sports_tennis, color: Colors.white54, size: 48),
          SizedBox(height: 12),
          Text(
            'No players found',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool?> _confirmDelete(PlayerProfile player) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text('Delete ${player.nickname}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        widget.onDeletePlayer(player.id);
      }
      return shouldDelete;
    });
  }
}
