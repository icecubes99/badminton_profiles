import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/player_profile.dart';

class PlayerListTile extends StatelessWidget {
  const PlayerListTile({
    super.key,
    required this.player,
    required this.onTap,
  });

  final PlayerProfile player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(255, 255, 255, 0.9),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          player.nickname,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(player.fullName),
              Text(
                describeLevelRange(player.levelRange),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
