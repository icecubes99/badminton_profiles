import 'package:hive/hive.dart';

import 'player_level_range.dart';

part 'player_profile.g.dart';

// Main player data model that gets stored in Hive database
@HiveType(typeId: 2) // Unique type ID for Hive serialization
class PlayerProfile {
  @HiveField(0) // Field index for Hive storage
  final String id; // Unique identifier for each player

  @HiveField(1)
  final String nickname; // Player's preferred name

  @HiveField(2)
  final String fullName; // Player's complete legal name

  @HiveField(3)
  final String contactNumber; // Phone number for communication

  @HiveField(4)
  final String email; // Email address for contact

  @HiveField(5)
  final String address; // Physical address

  @HiveField(6)
  final String remarks; // Additional notes about the player

  @HiveField(7)
  final PlayerLevelRange levelRange; // Player's skill level range

  // Constructor ensures all player data is provided
  const PlayerProfile({
    required this.id,
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.levelRange,
  });

  // Creates a copy with optionally updated fields (immutable pattern)
  PlayerProfile copyWith({
    String? nickname,
    String? fullName,
    String? contactNumber,
    String? email,
    String? address,
    String? remarks,
    PlayerLevelRange? levelRange,
  }) {
    return PlayerProfile(
      id: id, // ID never changes
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      remarks: remarks ?? this.remarks,
      levelRange: levelRange ?? this.levelRange,
    );
  }
}
