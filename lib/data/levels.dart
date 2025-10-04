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

  String get displayLabel {
    return '$levelLabel ($strengthLabel)';
  }
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

const List<String> strengthLabels = [
  'Weak',
  'Mid',
  'Strong',
];

List<LevelStep> buildLevelSteps() {
  final List<LevelStep> steps = [];
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
  return levelSteps.firstWhere((step) => step.index == index);
}

String describeLevelRange(PlayerLevelRange range) {
  final startStep = getLevelStep(range.startIndex);
  final endStep = getLevelStep(range.endIndex);
  if (startStep.index == endStep.index) {
    return startStep.displayLabel;
  }
  return '${startStep.displayLabel} - ${endStep.displayLabel}';
}

int clampLevelIndex(int value) {
  final int min = 0;
  final int max = levelSteps.length - 1;
  if (value < min) {
    return min;
  }
  if (value > max) {
    return max;
  }
  return value;
}
