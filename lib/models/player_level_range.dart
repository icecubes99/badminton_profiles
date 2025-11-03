import 'package:hive/hive.dart';

part 'player_level_range.g.dart';

// Hive database model for storing player skill level ranges
@HiveType(typeId: 1) // Unique type ID for Hive serialization
class PlayerLevelRange {
  @HiveField(0) // Field index for Hive storage
  final int startIndex; // Starting skill level index

  @HiveField(1)
  final int endIndex; // Ending skill level index

  const PlayerLevelRange({
    required this.startIndex,
    required this.endIndex,
  });

  // Creates a copy with optionally updated values
  PlayerLevelRange copyWith({int? startIndex, int? endIndex}) {
    return PlayerLevelRange(
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
    );
  }

  // Checks if a given skill level index falls within this range
  bool contains(int index) {
    return index >= startIndex && index <= endIndex;
  }
}
