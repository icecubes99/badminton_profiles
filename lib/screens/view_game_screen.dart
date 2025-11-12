import 'package:flutter/material.dart';

import '../models/game_session.dart';
import '../models/player_profile.dart';

// Screen for viewing game session details with options to edit or delete
class ViewGameScreen extends StatelessWidget {
  const ViewGameScreen({
    super.key,
    required this.game,
    required this.players,
    required this.onEdit,
    required this.onDelete,
    required this.onBack,
    required this.onAddPlayer,
    required this.onRemovePlayer,
  });

  final GameSession game; // Game session being viewed
  final List<PlayerProfile> players; // All available players
  final VoidCallback onEdit; // Callback to edit game
  final Future<void> Function() onDelete; // Callback to delete game
  final VoidCallback onBack; // Callback to go back
  final VoidCallback onAddPlayer; // Callback to add player to game
  final Future<void> Function(String playerId) onRemovePlayer; // Callback to remove player from game

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Main details container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFDCE4F4)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C1C2B5A),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with title and edit button
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.displayTitle,
                                  style: const TextStyle(
                                    color: Color(0xFF1C2B5A),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Created ${_formatDate(game.createdAt)}',
                                  style: const TextStyle(
                                    color: Color(0xFF9AA5BD),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined),
                            color: const Color(0xFF3D73FF),
                            tooltip: 'Edit Game',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Game Details Section
                      _buildSectionHeader('Game Details', Icons.info_outline),
                      const SizedBox(height: 16),
                      _buildDetailRow('Court Name', game.courtName, Icons.location_city_outlined),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Court Rate',
                        '\$${game.courtRate.toStringAsFixed(2)} per hour',
                        Icons.attach_money,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Shuttle Cock Price',
                        '\$${game.shuttleCockPrice.toStringAsFixed(2)} per piece',
                        Icons.sports_tennis,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Cost Division',
                        game.divideCourtEqually
                            ? 'Divided equally among players'
                            : 'Calculated per game',
                        Icons.calculate,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Court Schedules Section
                      _buildSectionHeader('Court Schedules', Icons.event),
                      const SizedBox(height: 16),
                      ...game.schedules.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildScheduleCard(entry.value),
                        );
                      }).toList(),
                      
                      const SizedBox(height: 32),
                      
                      // Cost Summary Section
                      _buildSectionHeader('Cost Summary', Icons.receipt_long),
                      const SizedBox(height: 16),
                      _buildCostSummaryCard(),
                      
                      const SizedBox(height: 32),
                      
                      // Players Section (placeholder for future feature)
                      _buildSectionHeader('Players', Icons.people_outline),
                      const SizedBox(height: 16),
                      _buildPlayersPlaceholder(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6C7A92),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () => _confirmDelete(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFF6B6B),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Delete Game'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3D73FF), size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF7A88A8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3D73FF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF9AA5BD),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1C2B5A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(schedule) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  schedule.courtNumber,
                  style: const TextStyle(
                    color: Color(0xFF3D73FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF3D73FF).withOpacity(0.3)),
                ),
                child: Text(
                  '${schedule.durationInHours.toStringAsFixed(1)} hrs',
                  style: const TextStyle(
                    color: Color(0xFF3D73FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF7A88A8)),
              const SizedBox(width: 8),
              Text(
                _formatScheduleDate(schedule.startTime),
                style: const TextStyle(
                  color: Color(0xFF7A88A8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFF7A88A8)),
              const SizedBox(width: 8),
              Text(
                '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                style: const TextStyle(
                  color: Color(0xFF7A88A8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D73FF), Color(0xFF5B8FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x333D73FF),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Hours',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${game.totalHours.toStringAsFixed(1)} hrs',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white30, thickness: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Court Cost',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${game.totalCourtCost.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '(\$${game.courtRate.toStringAsFixed(2)} × ${game.totalHours.toStringAsFixed(1)} hrs)',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersPlaceholder() {
    // Get assigned players
    final assignedPlayers = players.where((p) => game.playerIds.contains(p.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Players (${assignedPlayers.length})',
                style: const TextStyle(
                  color: Color(0xFF7A88A8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onAddPlayer,
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: const Text('Add Player'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3D73FF),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (assignedPlayers.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE1E8F5)),
            ),
            child: const Column(
              children: [
                Icon(Icons.person_add_outlined, size: 48, color: Color(0xFFB7C1D9)),
                SizedBox(height: 12),
                Text(
                  'No players assigned yet',
                  style: TextStyle(
                    color: Color(0xFF7A88A8),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap "Add Player" to assign players to this game',
                  style: TextStyle(
                    color: Color(0xFF9AA5BD),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          ...assignedPlayers.map((player) => _buildPlayerCard(player)).toList(),
      ],
    );
  }

  Widget _buildPlayerCard(PlayerProfile player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF3D73FF),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.nickname,
                  style: const TextStyle(
                    color: Color(0xFF1C2B5A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  player.fullName,
                  style: const TextStyle(
                    color: Color(0xFF7A88A8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFFF6B6B)),
            onPressed: () => onRemovePlayer(player.id),
            iconSize: 20,
            tooltip: 'Remove player',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }

  String _formatScheduleDate(DateTime date) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (alertContext) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: Text('Delete "${game.displayTitle}"? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(alertContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(alertContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF6B6B)),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await onDelete();
    }
  }
}
