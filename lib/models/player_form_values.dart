import 'player_level_range.dart';

// Data class to hold form input values before creating a PlayerProfile
class PlayerFormValues {
  // Player identification and contact information
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final PlayerLevelRange levelRange; // Player's skill level range

  // Constructor requires all fields to ensure complete player data
  const PlayerFormValues({
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.levelRange,
  });
}
