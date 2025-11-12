import 'package:flutter/material.dart';

import '../models/player_profile.dart';

// Screen for selecting players to add to a game
class AddPlayerToGameScreen extends StatefulWidget {
  const AddPlayerToGameScreen({
    super.key,
    required this.availablePlayers,
    required this.onPlayerSelected,
    required this.onCancel,
  });

  final List<PlayerProfile> availablePlayers; // Players not yet in the game
  final Future<void> Function(String playerId) onPlayerSelected; // Callback when player is selected
  final VoidCallback onCancel; // Callback to cancel

  @override
  State<AddPlayerToGameScreen> createState() => _AddPlayerToGameScreenState();
}

class _AddPlayerToGameScreenState extends State<AddPlayerToGameScreen> {
  String _searchQuery = '';
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = _searchQuery.isEmpty
        ? widget.availablePlayers
        : widget.availablePlayers.where((player) {
            final query = _searchQuery.toLowerCase();
            return player.nickname.toLowerCase().contains(query) ||
                player.fullName.toLowerCase().contains(query);
          }).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDCE4F4)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C1C2B5A),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title and cancel button
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Add Player to Game',
                            style: TextStyle(
                              color: Color(0xFF1C2B5A),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isAdding ? null : widget.onCancel,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF6C7A92),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search field
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Color(0xFF1C2B5A)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFF),
                        hintText: 'Search by name...',
                        hintStyle: const TextStyle(color: Color(0xFF9AA5BD)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF3D73FF)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE1E8F5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF3D73FF), width: 1.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Players list
            Expanded(
              child: widget.availablePlayers.isEmpty
                  ? _buildEmptyState()
                  : filteredPlayers.isEmpty
                      ? _buildNoResults()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: filteredPlayers.length,
                          itemBuilder: (context, index) {
                            return _buildPlayerCard(filteredPlayers[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDCE4F4)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: Color(0xFFB7C1D9)),
            SizedBox(height: 16),
            Text(
              'All players have been added',
              style: TextStyle(
                color: Color(0xFF7A88A8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'There are no more players to add to this game',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9AA5BD),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDCE4F4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64, color: Color(0xFFB7C1D9)),
            const SizedBox(height: 16),
            const Text(
              'No players found',
              style: TextStyle(
                color: Color(0xFF7A88A8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No players match "$_searchQuery"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9AA5BD),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(PlayerProfile player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1C2B5A),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _isAdding ? null : () => _handleAddPlayer(player.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF3D73FF),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.nickname,
                        style: const TextStyle(
                          color: Color(0xFF1C2B5A),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        player.fullName,
                        style: const TextStyle(
                          color: Color(0xFF7A88A8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF3D73FF),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddPlayer(String playerId) async {
    setState(() {
      _isAdding = true;
    });

    try {
      await widget.onPlayerSelected(playerId);
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }
}
