import 'package:flutter/material.dart';

import '../models/player_form_values.dart';
import '../models/player_profile.dart';
import '../widgets/player_form.dart';

class EditPlayerScreen extends StatelessWidget {
  const EditPlayerScreen({
    super.key,
    required this.player,
    required this.onSubmit,
    required this.onDelete,
    required this.onCancel,
  });

  final PlayerProfile player;
  final void Function(PlayerFormValues values) onSubmit;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
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
        constraints: const BoxConstraints(maxWidth: 600),
        child: PlayerForm(
          title: 'Edit Player Profile',
          primaryButtonLabel: 'Update Player',
          initialValues: initialValues,
          onSubmit: onSubmit,
          onCancel: onCancel,
          secondaryButtonLabel: 'Delete Player',
          onSecondaryPressed: () => _confirmDelete(context),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text('Delete ${player.nickname}? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      onDelete();
    }
  }
}
