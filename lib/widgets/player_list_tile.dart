import 'package:flutter/material.dart';

import 'package:badminton_profiles/data/levels.dart';
import 'package:badminton_profiles/models/player_profile.dart';

// Individual player list item with avatar, name, and skill level information
class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.player,
    required this.onTap,
  });

  final PlayerProfile player; // Player data to display
  final VoidCallback onTap; // Callback when tile is tapped

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFor(player.nickname); // Generate initials for avatar
    final color = _avatarColorFor(initials); // Get color based on initials
    final subtitle = '${player.fullName} • ${describeLevelRange(player.levelRange)}'; // Combine full name and level

    return ListTile(
      onTap: onTap, // Handle tap for editing
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color, // Colored background based on initials
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        player.nickname, // Primary display name
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C2B5A),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle, // Full name and skill level
          style: const TextStyle(
            color: Color(0xFF647196),
            fontSize: 14,
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF99A3BA)), // Edit indicator
    );
  }

  // Generates initials from nickname for avatar display
  String _initialsFor(String nickname) {
    if (nickname.isEmpty) {
      return '?'; // Fallback for empty nickname
    }
    final parts = nickname.trim().split(RegExp(r'\s+')); // Split by whitespace
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase(); // Single word: first letter
    }
    final first = parts.first.substring(0, 1).toUpperCase(); // First word's first letter
    final last = parts.last.substring(0, 1).toUpperCase(); // Last word's first letter
    return '$first$last'; // Combine first and last initials
  }

  // Selects avatar color based on initials for consistent visual identity
  Color _avatarColorFor(String initials) {
    const palette = <Color>[
      Color(0xFF4C6EF5), // Blue
      Color(0xFF845EF7), // Purple
      Color(0xFFFF6B6B), // Red
      Color(0xFF51CF66), // Green
      Color(0xFFFF922B), // Orange
      Color(0xFF339AF0), // Light Blue
    ];
    final index = initials.codeUnitAt(0) % palette.length; // Use first character's ASCII value
    return palette[index]; // Return corresponding color from palette
  }
}
