import 'package:flutter/material.dart';

import '../models/player_form_values.dart';
import '../models/player_profile.dart';
import '../widgets/player_form.dart';

// Screen for editing an existing player - pre-fills form with current data and includes delete option
class EditPlayerScreen extends StatelessWidget {
  const EditPlayerScreen({
    super.key,
    required this.player,
    required this.onSubmit,
    required this.onDelete,
    required this.onCancel,
  });

  final PlayerProfile player; // Player being edited
  final Future<void> Function(PlayerFormValues values) onSubmit; // Callback when form is submitted
  final Future<void> Function() onDelete; // Callback when player is deleted
  final VoidCallback onCancel; // Callback when user cancels

  @override
  Widget build(BuildContext context) {
    // Convert player profile to form values for pre-filling the form
    final initialValues = PlayerFormValues(
      nickname: player.nickname,
      fullName: player.fullName,
      contactNumber: player.contactNumber,
      email: player.email,
      address: player.address,
      remarks: player.remarks,
      levelRange: player.levelRange,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640), // Limit form width for better UX
        child: PlayerForm(
          title: 'Edit Player Profile',
          primaryButtonLabel: 'Update Player',
          initialValues: initialValues, // Pre-fill form with existing data
          onSubmit: onSubmit,
          onCancel: onCancel,
          secondaryButtonLabel: 'Delete Player', // Additional delete button
          onSecondaryPressed: () => _confirmDelete(context), // Show confirmation before delete
        ),
      ),
    );
  }

  // Shows confirmation dialog before deleting player to prevent accidental deletion
  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (alertContext) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text('Delete ${player.nickname}? This cannot be undone.'), // Warning message
          actions: [
            TextButton(
              onPressed: () => Navigator.of(alertContext).pop(false), // Cancel deletion
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(alertContext).pop(true), // Confirm deletion
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // Only delete if user confirmed
    if (shouldDelete == true) {
      await onDelete();
    }
  }
}
