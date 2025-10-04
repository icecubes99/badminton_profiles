import '../models/player_level_range.dart';
import '../models/player_profile.dart';

final List<PlayerProfile> seedPlayers = [
  PlayerProfile(
    id: 'player-1',
    nickname: 'SmashKing',
    fullName: 'Alex Johnson',
    contactNumber: '09171234567',
    email: 'alex.johnson@example.com',
    address: '123 Shuttle Street, Court City',
    remarks: 'Prefers mixed doubles on weekends.',
    levelRange: const PlayerLevelRange(startIndex: 6, endIndex: 8),
  ),
  PlayerProfile(
    id: 'player-2',
    nickname: 'FeatherLight',
    fullName: 'Bianca Cruz',
    contactNumber: '09981234567',
    email: 'bianca.cruz@example.com',
    address: '45 Drop Shot Avenue, Net Town',
    remarks: 'Available for tournaments and coaching.',
    levelRange: const PlayerLevelRange(startIndex: 12, endIndex: 14),
  ),
];
