import 'package:flutter/material.dart';

import 'package:badminton_profiles/data/levels.dart';
import 'package:badminton_profiles/models/player_profile.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
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
