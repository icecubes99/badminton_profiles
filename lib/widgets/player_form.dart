import 'package:flutter/material.dart';

import '../data/levels.dart';
import '../models/player_form_values.dart';
import '../models/player_level_range.dart';

// Style for level scale labels (W, M, S)
const TextStyle _scaleTopLabelStyle = TextStyle(
  color: Color(0xFF9AA5BD),
  fontSize: 10,
  fontWeight: FontWeight.w600,
);

// Reusable form widget for adding/editing player profiles with validation and skill level selection
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

  final String title; // Form title (e.g., "Add New Player")
  final String primaryButtonLabel; // Primary button text (e.g., "Save Player")
  final Future<void> Function(PlayerFormValues values) onSubmit; // Callback when form is submitted
  final VoidCallback onCancel; // Callback when user cancels
  final PlayerFormValues? initialValues; // Pre-fill form for editing
  final String? secondaryButtonLabel; // Optional secondary button (e.g., "Delete Player")
  final Future<void> Function()? onSecondaryPressed; // Secondary button callback

  @override
  State<PlayerForm> createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form validation key

  // Text controllers for form fields
  late final TextEditingController _nicknameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _remarksController;
  late PlayerLevelRange _selectedRange; // Currently selected skill level range
  bool _isSubmitting = false; // Prevents multiple submissions

  @override
  void initState() {
    super.initState();
    // Initialize form with provided values or defaults
    final defaults = widget.initialValues ??
        PlayerFormValues(
          nickname: '',
          fullName: '',
          contactNumber: '',
          email: '',
          address: '',
          remarks: '',
          levelRange: const PlayerLevelRange(startIndex: 0, endIndex: 2), // Default beginner range
        );

    // Initialize text controllers with default/initial values
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
    // Clean up text controllers to prevent memory leaks
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
        key: _formKey, // Enables form validation
        child: Column(
          children: [
            // Main form container with styling
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
                    // Header with title and submit button
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
                          onPressed: _isSubmitting ? null : _handleSubmit, // Disable during submission
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
                    // Required form fields with validation
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
                      validator: _phoneValidator, // Custom phone validation
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator, // Custom email validation
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Home Address',
                      icon: Icons.location_on_outlined,
                      validator: _nonEmptyValidator,
                      minLines: 2, // Multi-line address field
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _remarksController,
                      label: 'Remarks',
                      icon: Icons.menu_book_outlined,
                      minLines: 2, // Multi-line remarks field (optional)
                      maxLines: 3,
                    ),
                    const SizedBox(height: 28),
                    _buildLevelSelector(), // Interactive skill level range selector
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildFooterActions(), // Cancel and optional secondary button
          ],
        ),
      ),
    );
  }

  // Builds a styled text field with label, icon, and validation
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
        // Field label in uppercase
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
        // Text input field with styling and validation
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator, // Custom validation function
          minLines: minLines,
          maxLines: maxLines,
          style: const TextStyle(color: Color(0xFF1C2B5A)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFF),
            prefixIcon: Icon(icon, color: const Color(0xFF3D73FF)), // Blue icon
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE1E8F5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF3D73FF), width: 1.6), // Blue focus border
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent), // Red error border
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

  // Builds the interactive skill level range selector with visual feedback
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
              // Display selected level range description
              Text(
                describeLevelRange(_selectedRange),
                style: const TextStyle(
                  color: Color(0xFF1C2B5A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Range slider for selecting skill level range
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  activeTrackColor: const Color(0xFF3D73FF), // Blue active track
                  inactiveTrackColor: const Color(0xFFD7E2F7), // Light blue inactive track
                  trackHeight: 4,
                ),
                child: RangeSlider(
                  min: 0,
                  max: (levelSteps.length - 1).toDouble(),
                  values: values,
                  divisions: levelSteps.length - 1, // Discrete level steps
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
              _buildLevelScale(), // Visual scale showing all available levels
            ],
          ),
        ),
      ],
    );
  }

  // Builds visual scale showing all skill levels (Weak/Medium/Strong for each level)
  Widget _buildLevelScale() {
    return Column(
      children: [
        // Top row showing W, M, S indicators for each level
        Row(
          children: levelNames.map((_) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('W', style: _scaleTopLabelStyle), // Weak
                  Text('M', style: _scaleTopLabelStyle), // Medium
                  Text('S', style: _scaleTopLabelStyle), // Strong
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        // Bottom row showing level names (Beginner, Intermediate, etc.)
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

  // Builds footer action buttons (Cancel and optional secondary button)
  Widget _buildFooterActions() {
    final actions = <Widget>[
      TextButton(
        onPressed: _isSubmitting ? null : widget.onCancel, // Disable during submission
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6C7A92),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: const Text('Cancel'),
      ),
    ];

    // Add secondary button if provided (e.g., Delete button)
    if (widget.secondaryButtonLabel != null && widget.onSecondaryPressed != null) {
      actions.add(
        TextButton(
          onPressed: _isSubmitting ? null : () => _handleSecondaryAction(widget.onSecondaryPressed!),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF6B6B), // Red color for destructive actions
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

  // Handles secondary button action (e.g., delete) with loading state management
  Future<void> _handleSecondaryAction(Future<void> Function() action) async {
    if (_isSubmitting) {
      return; // Prevent multiple simultaneous actions
    }
    setState(() {
      _isSubmitting = true; // Show loading state
    });
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false; // Reset loading state
        });
      }
    }
  }

  // Validation functions for form fields
  
  // Validates that field is not empty
  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Validates phone number format (digits only)
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

  // Validates email format using regex
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

  // Handles form submission with validation
  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Stop if validation fails
    }

    // Create form values from current input
    final values = PlayerFormValues(
      nickname: _nicknameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      contactNumber: _contactController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      remarks: _remarksController.text.trim(),
      levelRange: _selectedRange,
    );

    widget.onSubmit(values); // Call parent callback with validated data
  }
}







