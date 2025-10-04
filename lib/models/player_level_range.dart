class PlayerLevelRange {
  final int startIndex;
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
