import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_settings.dart';

// Screen for configuring user settings for court and shuttlecock pricing
class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({
    super.key,
    required this.currentSettings,
    required this.onSave,
    this.onCancel,
  });

  final UserSettings currentSettings; // Current saved settings
  final Future<void> Function(UserSettings settings) onSave; // Callback when settings are saved
  final VoidCallback? onCancel; // Optional callback when user cancels (for backward compatibility)

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Text controllers for form fields
  late final TextEditingController _courtNameController;
  late final TextEditingController _courtRateController;
  late final TextEditingController _shuttleCockPriceController;
  late bool _divideCourtEqually;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current settings
    _courtNameController = TextEditingController(text: widget.currentSettings.defaultCourtName);
    _courtRateController = TextEditingController(
      text: widget.currentSettings.defaultCourtRate > 0 
        ? widget.currentSettings.defaultCourtRate.toStringAsFixed(2) 
        : '',
    );
    _shuttleCockPriceController = TextEditingController(
      text: widget.currentSettings.defaultShuttleCockPrice > 0 
        ? widget.currentSettings.defaultShuttleCockPrice.toStringAsFixed(2) 
        : '',
    );
    _divideCourtEqually = widget.currentSettings.divideCourtEqually;
  }

  @override
  void dispose() {
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttleCockPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Main settings container
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
                        // Header with title and save button
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'User Settings',
                                style: TextStyle(
                                  color: Color(0xFF1C2B5A),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _isSaving ? null : _handleSave,
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Color(0xFF3D73FF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Court name field
                        _buildTextField(
                          controller: _courtNameController,
                          label: 'Default Court Name',
                          icon: Icons.location_city_outlined,
                          validator: _nonEmptyValidator,
                        ),
                        const SizedBox(height: 20),
                        // Court rate field
                        _buildTextField(
                          controller: _courtRateController,
                          label: 'Default Court Rate (per hour)',
                          icon: Icons.attach_money,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _priceValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Shuttlecock price field
                        _buildTextField(
                          controller: _shuttleCockPriceController,
                          label: 'Default Shuttle Cock Price (per piece)',
                          icon: Icons.sports_tennis,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _priceValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Checkbox for dividing court equally
                        _buildCheckboxTile(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Optional cancel button (for backward compatibility with non-nav bar usage)
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: _isSaving ? null : widget.onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6C7A92),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Cancel'),
                  ),
              ],
            ),
          ),
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
    List<TextInputFormatter>? inputFormatters,
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
          inputFormatters: inputFormatters,
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

  Widget _buildCheckboxTile() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: CheckboxListTile(
        title: const Text(
          'Divide the court equally among players',
          style: TextStyle(
            color: Color(0xFF1C2B5A),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _divideCourtEqually 
            ? 'Court cost will be split equally among all players'
            : 'Court cost will be calculated per game',
          style: const TextStyle(
            color: Color(0xFF7A88A8),
            fontSize: 12,
          ),
        ),
        value: _divideCourtEqually,
        activeColor: const Color(0xFF3D73FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onChanged: (value) {
          setState(() {
            _divideCourtEqually = value ?? true;
          });
        },
      ),
    );
  }

  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    final price = double.tryParse(value.trim());
    if (price == null || price < 0) {
      return 'Enter a valid price';
    }
    return null;
  }

  void _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final settings = UserSettings(
        defaultCourtName: _courtNameController.text.trim(),
        defaultCourtRate: double.parse(_courtRateController.text.trim()),
        defaultShuttleCockPrice: double.parse(_shuttleCockPriceController.text.trim()),
        divideCourtEqually: _divideCourtEqually,
      );

      await widget.onSave(settings);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
