import 'package:flutter/material.dart';

import '../models/player_form_values.dart';
import '../widgets/player_form.dart';

// Screen for adding a new player - displays a form for entering player details
class AddPlayerScreen extends StatelessWidget {
  const AddPlayerScreen({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  final Future<void> Function(PlayerFormValues values) onSubmit; // Callback when form is submitted
  final VoidCallback onCancel; // Callback when user cancels

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640), // Limit form width for better UX
        child: PlayerForm(
          title: 'Add New Player',
          primaryButtonLabel: 'Save Player',
          onSubmit: onSubmit, // Pass submit callback to form
          onCancel: onCancel, // Pass cancel callback to form
        ),
      ),
    );
  }
}
