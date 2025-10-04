import 'player_level_range.dart';

class PlayerFormValues {
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final PlayerLevelRange levelRange;

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
