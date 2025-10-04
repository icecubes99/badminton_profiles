import '../models/player_level_range.dart';

class LevelStep {
  final int index;
  final String levelLabel;
  final String strengthLabel;

  const LevelStep({
    required this.index,
    required this.levelLabel,
    required this.strengthLabel,
  });

  String get displayLabel => '$levelLabel ($strengthLabel)';
}

const List<String> levelNames = [
  'Beginners',
  'Intermediate',
  'Level G',
  'Level F',
  'Level E',
  'Level D',
  'Open Player',
];

const List<String> strengthLabels = ['Weak', 'Mid', 'Strong'];

List<LevelStep> buildLevelSteps() {
  final steps = <LevelStep>[];
  var index = 0;
  for (final level in levelNames) {
    for (final strength in strengthLabels) {
      steps.add(
        LevelStep(
          index: index,
          levelLabel: level,
          strengthLabel: strength,
        ),
      );
      index++;
    }
  }
  return steps;
}

final List<LevelStep> levelSteps = buildLevelSteps();

LevelStep getLevelStep(int index) {
  return levelSteps[index.clamp(0, levelSteps.length - 1)];
}

String describeLevelRange(PlayerLevelRange range) {
  final start = getLevelStep(range.startIndex);
  final end = getLevelStep(range.endIndex);
  if (start.index == end.index) {
    return start.displayLabel;
  }
  return '${start.displayLabel} - ${end.displayLabel}';
}
