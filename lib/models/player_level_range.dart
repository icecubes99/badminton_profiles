import 'package:hive/hive.dart';

part 'player_level_range.g.dart';

@HiveType(typeId: 1)
class PlayerLevelRange {
  @HiveField(0)
  final int startIndex;

  @HiveField(1)
  final int endIndex;

  const PlayerLevelRange({
    required this.startIndex,
    required this.endIndex,
  });

  PlayerLevelRange copyWith({int? startIndex, int? endIndex}) {
    return PlayerLevelRange(
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
    );
  }

  bool contains(int index) {
    return index >= startIndex && index <= endIndex;
  }
}
