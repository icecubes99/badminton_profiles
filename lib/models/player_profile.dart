import 'player_level_range.dart';

class PlayerProfile {
  final String id;
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final PlayerLevelRange levelRange;

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
      id: id,
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
