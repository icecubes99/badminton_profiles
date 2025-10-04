import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/player_profile.dart';

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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  _buildAddButton(),
                ],
              ),
              const SizedBox(height: 20),
              _buildSearchField(),
              const SizedBox(height: 20),
              Expanded(
                child: filteredPlayers.isEmpty
                    ? _buildEmptyState()
                    : _buildPlayerList(filteredPlayers),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            _searchTerm = value.trim();
          });
        },
        style: const TextStyle(color: Color(0xFF1C2B5A)),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color(0xFF6C7A92)),
          hintText: 'Search by name or nickname',
          hintStyle: TextStyle(color: Color(0xFF9AA5BD)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

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
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE6ECF5)),
          itemBuilder: (context, index) {
            final player = players[index];
            return Dismissible(
              key: ValueKey(player.id),
              direction: DismissDirection.endToStart,
              background: _buildDismissibleBackground(),
              confirmDismiss: (_) => _confirmDelete(player),
              child: _PlayerListTile(
                player: player,
                onTap: () => widget.onEditPlayer(player),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Material(
      color: const Color(0xFF3D73FF),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onAddPlayer,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
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
          Icon(Icons.sports_tennis, color: Color(0xFFB7C1D9), size: 56),
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

  Widget _buildDismissibleBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF6B6B),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
              onPressed: () => Navigator.of(context).pop(true),
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

class _PlayerListTile extends StatelessWidget {
  const _PlayerListTile({
    required this.player,
    required this.onTap,
  });

  final PlayerProfile player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFor(player.nickname);
    final color = _avatarColorFor(initials);
    final subtitle = '${player.fullName} • ${describeLevelRange(player.levelRange)}';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color,
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        player.nickname,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C2B5A),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF647196),
            fontSize: 14,
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF99A3BA)),
    );
  }

  String _initialsFor(String nickname) {
    if (nickname.isEmpty) {
      return '?';
    }
    final parts = nickname.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.substring(0, 1).toUpperCase();
    final last = parts.last.substring(0, 1).toUpperCase();
    return '$first$last';
  }

  Color _avatarColorFor(String initials) {
    const palette = <Color>[
      Color(0xFF4C6EF5),
      Color(0xFF845EF7),
      Color(0xFFFF6B6B),
      Color(0xFF51CF66),
      Color(0xFFFF922B),
      Color(0xFF339AF0),
    ];
    final index = initials.codeUnitAt(0) % palette.length;
    return palette[index];
  }
}
