import 'package:hive/hive.dart';

import 'court_schedule.dart';

part 'game_session.g.dart';

// Main game session data model that gets stored in Hive database
@HiveType(typeId: 5)
class GameSession {
  @HiveField(0)
  final String id; // Unique identifier for each game

  @HiveField(1)
  final String? gameTitle; // Optional custom title, defaults to scheduled date if null

  @HiveField(2)
  final String courtName; // Name of the court

  @HiveField(3)
  final List<CourtSchedule> schedules; // Multiple court schedules

  @HiveField(4)
  final double courtRate; // Per hour court rate

  @HiveField(5)
  final double shuttleCockPrice; // Price per shuttlecock

  @HiveField(6)
  final bool divideCourtEqually; // Whether to divide court cost equally among players

  @HiveField(7)
  final DateTime createdAt; // When the game was created

  @HiveField(8)
  final List<String> playerIds; // List of player IDs assigned to this game

  const GameSession({
    required this.id,
    this.gameTitle,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideCourtEqually,
    required this.createdAt,
    this.playerIds = const [],
  });

  // Get display title (custom title or formatted date)
  String get displayTitle {
    if (gameTitle != null && gameTitle!.trim().isNotEmpty) {
      return gameTitle!;
    }
    if (schedules.isEmpty) {
      return 'Untitled Game';
    }
    // Format first schedule date as title
    final firstSchedule = schedules.first;
    final date = firstSchedule.startTime;
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  // Calculate total hours across all schedules
  double get totalHours {
    return schedules.fold(0.0, (sum, schedule) => sum + schedule.durationInHours);
  }

  // Calculate total court cost
  double get totalCourtCost {
    return totalHours * courtRate;
  }

  GameSession copyWith({
    String? gameTitle,
    String? courtName,
    List<CourtSchedule>? schedules,
    double? courtRate,
    double? shuttleCockPrice,
    bool? divideCourtEqually,
    List<String>? playerIds,
  }) {
    return GameSession(
      id: id,
      gameTitle: gameTitle ?? this.gameTitle,
      courtName: courtName ?? this.courtName,
      schedules: schedules ?? this.schedules,
      courtRate: courtRate ?? this.courtRate,
      shuttleCockPrice: shuttleCockPrice ?? this.shuttleCockPrice,
      divideCourtEqually: divideCourtEqually ?? this.divideCourtEqually,
      createdAt: createdAt,
      playerIds: playerIds ?? this.playerIds,
    );
  }
}
