import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/player_form_values.dart';
import '../models/player_level_range.dart';

const TextStyle _scaleTopLabelStyle = TextStyle(
  color: Color(0xFF9AA5BD),
  fontSize: 10,
  fontWeight: FontWeight.w600,
);

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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Color(0xFF1C2B5A),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _handleSubmit,
                          child: Text(
                            widget.primaryButtonLabel,
                            style: const TextStyle(
                              color: Color(0xFF3D73FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _nicknameController,
                      label: 'Nickname',
                      icon: Icons.person_outline,
                      validator: _nonEmptyValidator,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      icon: Icons.badge_outlined,
                      validator: _nonEmptyValidator,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _contactController,
                      label: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: _phoneValidator,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Home Address',
                      icon: Icons.location_on_outlined,
                      validator: _nonEmptyValidator,
                      minLines: 2,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _remarksController,
                      label: 'Remarks',
                      icon: Icons.menu_book_outlined,
                      minLines: 2,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 28),
                    _buildLevelSelector(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF7A88A8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          minLines: minLines,
          maxLines: maxLines,
          style: const TextStyle(color: Color(0xFF1C2B5A)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFF),
            prefixIcon: Icon(icon, color: const Color(0xFF3D73FF)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E8F5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF3D73FF), width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelSelector() {
    final values = RangeValues(
      _selectedRange.startIndex.toDouble(),
      _selectedRange.endIndex.toDouble(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LEVEL',
          style: TextStyle(
            color: Color(0xFF7A88A8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E8F5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                describeLevelRange(_selectedRange),
                style: const TextStyle(
                  color: Color(0xFF1C2B5A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  activeTrackColor: const Color(0xFF3D73FF),
                  inactiveTrackColor: const Color(0xFFD7E2F7),
                  trackHeight: 4,
                ),
                child: RangeSlider(
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
              ),
              const SizedBox(height: 12),
              _buildLevelScale(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelScale() {
    return Column(
      children: [
        Row(
          children: levelNames.map((_) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('W', style: _scaleTopLabelStyle),
                  Text('M', style: _scaleTopLabelStyle),
                  Text('S', style: _scaleTopLabelStyle),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Row(
          children: levelNames.map((level) {
            return Expanded(
              child: Text(
                level.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF5C6C8F),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooterActions() {
    final actions = <Widget>[
      TextButton(
        onPressed: widget.onCancel,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6C7A92),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: const Text('Cancel'),
      ),
    ];

    if (widget.secondaryButtonLabel != null && widget.onSecondaryPressed != null) {
      actions.add(
        TextButton(
          onPressed: widget.onSecondaryPressed,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF6B6B),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: Text(widget.secondaryButtonLabel!),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: actions
          .map((button) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: button,
              ))
          .toList(),
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
    final digitsOnly = RegExp(r'^\d+$');
    if (!digitsOnly.hasMatch(value.trim())) {
      return 'Use digits only';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(value.trim())) {
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
