import 'package:hive/hive.dart';

import 'player_level_range.dart';

part 'player_profile.g.dart';

@HiveType(typeId: 2)
class PlayerProfile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nickname;

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  final String contactNumber;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final String remarks;

  @HiveField(7)
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
