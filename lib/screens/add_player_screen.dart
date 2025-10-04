import 'package:flutter/material.dart';

import '../models/player_form_values.dart';
import '../widgets/player_form.dart';

class AddPlayerScreen extends StatelessWidget {
  const AddPlayerScreen({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  final void Function(PlayerFormValues values) onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: PlayerForm(
          title: 'Add New Player',
          primaryButtonLabel: 'Save Player',
          onSubmit: onSubmit,
          onCancel: onCancel,
        ),
      ),
    );
  }
}
