import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/court_schedule.dart';
import '../models/game_session.dart';

// Screen for editing an existing game session
class EditGameScreen extends StatefulWidget {
  const EditGameScreen({
    super.key,
    required this.game,
    required this.onSave,
    required this.onCancel,
  });

  final GameSession game; // Game being edited
  final Future<void> Function({
    String? gameTitle,
    required String courtName,
    required List<CourtSchedule> schedules,
    required double courtRate,
    required double shuttleCockPrice,
    required bool divideCourtEqually,
  }) onSave;
  final VoidCallback onCancel;

  @override
  State<EditGameScreen> createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  late final TextEditingController _gameTitleController;
  late final TextEditingController _courtNameController;
  late final TextEditingController _courtRateController;
  late final TextEditingController _shuttleCockPriceController;
  late bool _divideCourtEqually;
  
  late List<CourtSchedule> _schedules;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing game data
    _gameTitleController = TextEditingController(text: widget.game.gameTitle ?? '');
    _courtNameController = TextEditingController(text: widget.game.courtName);
    _courtRateController = TextEditingController(
      text: widget.game.courtRate.toStringAsFixed(2),
    );
    _shuttleCockPriceController = TextEditingController(
      text: widget.game.shuttleCockPrice.toStringAsFixed(2),
    );
    _divideCourtEqually = widget.game.divideCourtEqually;
    _schedules = List<CourtSchedule>.from(widget.game.schedules);
  }

  @override
  void dispose() {
    _gameTitleController.dispose();
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
                // Main form container
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
                                'Edit Game',
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
                                'Save Changes',
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
                        // Game title field (optional)
                        _buildTextField(
                          controller: _gameTitleController,
                          label: 'Game Title (Optional)',
                          icon: Icons.title,
                          hint: 'Leave blank to use scheduled date',
                        ),
                        const SizedBox(height: 20),
                        // Court name field
                        _buildTextField(
                          controller: _courtNameController,
                          label: 'Court Name',
                          icon: Icons.location_city_outlined,
                          validator: _nonEmptyValidator,
                        ),
                        const SizedBox(height: 20),
                        // Court rate field
                        _buildTextField(
                          controller: _courtRateController,
                          label: 'Court Rate (per hour)',
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
                          label: 'Shuttle Cock Price (per piece)',
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
                        const SizedBox(height: 24),
                        // Schedules section
                        _buildSchedulesSection(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Cancel button
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
    String? hint,
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
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9AA5BD)),
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

  Widget _buildSchedulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'COURT SCHEDULES',
              style: TextStyle(
                color: Color(0xFF7A88A8),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addSchedule,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Schedule'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3D73FF),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_schedules.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE1E8F5)),
            ),
            child: const Center(
              child: Text(
                'No schedules added yet\nTap "Add Schedule" to begin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9AA5BD),
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ..._schedules.asMap().entries.map((entry) {
            final index = entry.key;
            final schedule = entry.value;
            return _buildScheduleCard(index, schedule);
          }).toList(),
      ],
    );
  }

  Widget _buildScheduleCard(int index, CourtSchedule schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event, color: Color(0xFF3D73FF), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule.courtNumber,
                  style: const TextStyle(
                    color: Color(0xFF1C2B5A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF3D73FF)),
                onPressed: () => _editSchedule(index, schedule),
                iconSize: 20,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFFF6B6B)),
                onPressed: () => _removeSchedule(index),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatScheduleTime(schedule),
            style: const TextStyle(
              color: Color(0xFF7A88A8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Duration: ${schedule.durationInHours.toStringAsFixed(1)} hours',
            style: const TextStyle(
              color: Color(0xFF9AA5BD),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatScheduleTime(CourtSchedule schedule) {
    final startDate = schedule.startTime;
    final endDate = schedule.endTime;
    
    String formatTime(DateTime dt) {
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    final dateStr = '${_monthName(startDate.month)} ${startDate.day}, ${startDate.year}';
    return '$dateStr • ${formatTime(startDate)} - ${formatTime(endDate)}';
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  void _addSchedule() async {
    final result = await showDialog<CourtSchedule>(
      context: context,
      builder: (context) => _ScheduleDialog(),
    );

    if (result != null) {
      setState(() {
        _schedules.add(result);
      });
    }
  }

  void _editSchedule(int index, CourtSchedule schedule) async {
    final result = await showDialog<CourtSchedule>(
      context: context,
      builder: (context) => _ScheduleDialog(initialSchedule: schedule),
    );

    if (result != null) {
      setState(() {
        _schedules[index] = result;
      });
    }
  }

  void _removeSchedule(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
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

    if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one schedule'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave(
        gameTitle: _gameTitleController.text.trim().isEmpty
            ? null
            : _gameTitleController.text.trim(),
        courtName: _courtNameController.text.trim(),
        schedules: _schedules,
        courtRate: double.parse(_courtRateController.text.trim()),
        shuttleCockPrice: double.parse(_shuttleCockPriceController.text.trim()),
        divideCourtEqually: _divideCourtEqually,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

// Dialog for adding/editing a schedule
class _ScheduleDialog extends StatefulWidget {
  final CourtSchedule? initialSchedule;

  const _ScheduleDialog({this.initialSchedule});

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _courtNumberController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialSchedule != null) {
      _courtNumberController = TextEditingController(text: widget.initialSchedule!.courtNumber);
      _selectedDate = widget.initialSchedule!.startTime;
      _startTime = TimeOfDay.fromDateTime(widget.initialSchedule!.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.initialSchedule!.endTime);
    } else {
      _courtNumberController = TextEditingController();
      _selectedDate = DateTime.now();
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
    }
  }

  @override
  void dispose() {
    _courtNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialSchedule == null ? 'Add Schedule' : 'Edit Schedule'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _courtNumberController,
                decoration: const InputDecoration(
                  labelText: 'Court Number',
                  hintText: 'e.g., Court 1',
                  prefixIcon: Icon(Icons.sports_tennis),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(
                  '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                ),
                onTap: _pickDate,
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Start Time'),
                subtitle: Text(_startTime.format(context)),
                onTap: () => _pickTime(true),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('End Time'),
                subtitle: Text(_endTime.format(context)),
                onTap: () => _pickTime(false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveSchedule,
          child: Text(widget.initialSchedule == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  void _saveSchedule() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (!endDateTime.isAfter(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final schedule = CourtSchedule(
      courtNumber: _courtNumberController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
    );

    Navigator.of(context).pop(schedule);
  }
}
