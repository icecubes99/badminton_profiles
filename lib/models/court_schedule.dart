import 'package:hive/hive.dart';

part 'court_schedule.g.dart';

// Represents a court schedule entry with court number and time range
@HiveType(typeId: 4)
class CourtSchedule {
  @HiveField(0)
  final String courtNumber; // e.g., "Court 1", "Court 2"

  @HiveField(1)
  final DateTime startTime; // Start time of the booking

  @HiveField(2)
  final DateTime endTime; // End time of the booking

  const CourtSchedule({
    required this.courtNumber,
    required this.startTime,
    required this.endTime,
  });

  // Calculate duration in hours
  double get durationInHours {
    final duration = endTime.difference(startTime);
    return duration.inMinutes / 60.0;
  }

  CourtSchedule copyWith({
    String? courtNumber,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return CourtSchedule(
      courtNumber: courtNumber ?? this.courtNumber,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
