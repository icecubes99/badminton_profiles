import 'package:hive/hive.dart';

part 'user_settings.g.dart';

// User settings model for court and shuttlecock pricing configuration
@HiveType(typeId: 3) // Unique type ID for Hive serialization
class UserSettings {
  @HiveField(0)
  final String defaultCourtName; // Name of the court (e.g., "City Sports Center")

  @HiveField(1)
  final double defaultCourtRate; // Per hour price of a court (e.g., 400.0)

  @HiveField(2)
  final double defaultShuttleCockPrice; // Price per shuttlecock (e.g., 50.0)

  @HiveField(3)
  final bool divideCourtEqually; // If true, divide court cost equally among players; if false, calculate per game

  const UserSettings({
    required this.defaultCourtName,
    required this.defaultCourtRate,
    required this.defaultShuttleCockPrice,
    required this.divideCourtEqually,
  });

  // Creates a copy with optionally updated fields (immutable pattern)
  UserSettings copyWith({
    String? defaultCourtName,
    double? defaultCourtRate,
    double? defaultShuttleCockPrice,
    bool? divideCourtEqually,
  }) {
    return UserSettings(
      defaultCourtName: defaultCourtName ?? this.defaultCourtName,
      defaultCourtRate: defaultCourtRate ?? this.defaultCourtRate,
      defaultShuttleCockPrice: defaultShuttleCockPrice ?? this.defaultShuttleCockPrice,
      divideCourtEqually: divideCourtEqually ?? this.divideCourtEqually,
    );
  }

  // Default settings
  static const UserSettings defaults = UserSettings(
    defaultCourtName: '',
    defaultCourtRate: 0.0,
    defaultShuttleCockPrice: 0.0,
    divideCourtEqually: true,
  );
}
