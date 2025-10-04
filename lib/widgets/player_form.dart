import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/player_form_values.dart';
import '../models/player_level_range.dart';

class PlayerForm extends StatefulWidget {
  const PlayerForm({
    super.key,
    required this.title,
    required this.primaryButtonLabel,
    required this.onSubmit,
    required this.onCancel,
    this.initialValues,
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
  });

  final String title;
  final String primaryButtonLabel;
  final void Function(PlayerFormValues values) onSubmit;
  final VoidCallback onCancel;
  final PlayerFormValues? initialValues;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  State<PlayerForm> createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nicknameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _remarksController;
  late PlayerLevelRange _selectedRange;

  @override
  void initState() {
    super.initState();
    final defaults = widget.initialValues ??
        PlayerFormValues(
          nickname: '',
          fullName: '',
          contactNumber: '',
          email: '',
          address: '',
          remarks: '',
          levelRange: const PlayerLevelRange(startIndex: 0, endIndex: 2),
        );

    _nicknameController = TextEditingController(text: defaults.nickname);
    _fullNameController = TextEditingController(text: defaults.fullName);
    _contactController = TextEditingController(text: defaults.contactNumber);
    _emailController = TextEditingController(text: defaults.email);
    _addressController = TextEditingController(text: defaults.address);
    _remarksController = TextEditingController(text: defaults.remarks);
    _selectedRange = defaults.levelRange;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nicknameController,
              label: 'Nickname',
              validator: _nonEmptyValidator,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              validator: _nonEmptyValidator,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _contactController,
              label: 'Contact Number',
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              validator: _nonEmptyValidator,
              minLines: 2,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _remarksController,
              label: 'Remarks',
              minLines: 2,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            _buildLevelSelector(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLevelSelector() {
    final description = describeLevelRange(_selectedRange);
    final RangeValues values = RangeValues(
      _selectedRange.startIndex.toDouble(),
      _selectedRange.endIndex.toDouble(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Badminton Level Range',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RangeSlider(
                min: 0,
                max: (levelSteps.length - 1).toDouble(),
                values: values,
                divisions: levelSteps.length - 1,
                labels: RangeLabels(
                  getLevelStep(_selectedRange.startIndex).displayLabel,
                  getLevelStep(_selectedRange.endIndex).displayLabel,
                ),
                onChanged: (range) {
                  setState(() {
                    _selectedRange = PlayerLevelRange(
                      startIndex: range.start.round(),
                      endIndex: range.end.round(),
                    );
                  });
                },
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: levelSteps.map((step) {
                  return Chip(
                    label: Text(step.displayLabel),
                    backgroundColor: Colors.blueGrey.shade50,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(widget.primaryButtonLabel),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: widget.onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Cancel'),
        ),
        if (widget.secondaryButtonLabel != null &&
            widget.onSecondaryPressed != null) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: widget.onSecondaryPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(widget.secondaryButtonLabel!),
          ),
        ],
      ],
    );
  }

  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    final trimmed = value.trim();
    final digitsOnly = RegExp(r'^\d+$');
    if (!digitsOnly.hasMatch(trimmed)) {
      return 'Use digits only';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(trimmed)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final values = PlayerFormValues(
      nickname: _nicknameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      contactNumber: _contactController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      remarks: _remarksController.text.trim(),
      levelRange: _selectedRange,
    );

    widget.onSubmit(values);
  }
}
