import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _supportController = TextEditingController();

  // Form values
  String _selectedSession = 'Morning';
  String _selectedCategory = 'Academic';
  int? _selectedCounselorId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Categories
  final List<String> _categories = [
    'Academic',
    'Personal',
    'Career',
    'Social',
    'Mental Health',
    'Other'
  ];

  // Counselors with availability
  final List<Map<String, dynamic>> _counselors = [
    {
      'id': 1,
      'name': 'Cikgu Diana',
      'image': 'assets/images/counselor1.png',
      'availableMorning': true,
      'availableEvening': false,
    },
    {
      'id': 2,
      'name': 'Mr. John Tan',
      'image': 'assets/images/counselor2.png',
      'availableMorning': false,
      'availableEvening': true,
    },
    {
      'id': 3,
      'name': 'Cikgu Jayil',
      'image': 'assets/images/counselor3.png',
      'availableMorning': true,
      'availableEvening': false,
    },
    {
      'id': 4,
      'name': 'Mr. David Lim',
      'image': 'assets/images/counselor4.png',
      'availableMorning': false,
      'availableEvening': true,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _supportController.dispose();
    super.dispose();
  }

  // Get available counselors based on selected session
  List<Map<String, dynamic>> get _availableCounselors {
    return _counselors.where((counselor) {
      return _selectedSession == 'Morning'
          ? counselor['availableMorning']
          : counselor['availableEvening'];
    }).toList();
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  // Format time for display
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Submit the booking form
  void _submitBooking() {
    // Validate form
    if (_nameController.text.isEmpty) {
      _showErrorSnackBar('Please enter your name');
      return;
    }

    if (_classController.text.isEmpty) {
      _showErrorSnackBar('Please enter your class');
      return;
    }

    if (_selectedCounselorId == null) {
      _showErrorSnackBar('Please select a counselor');
      return;
    }

    // All validations passed, proceed to confirm booking
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking Confirmed!')),
    );
    // Optionally pop the screen or navigate to a confirmation page
    Navigator.of(context).pop();
  }

  // Show error in a SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Booking',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save as draft functionality (example)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved as draft')),
              );
            },
            child: const Text('Save as Draft'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              _buildSectionTitle('Name'),
              _buildTextField(
                controller: _nameController,
                hintText: 'Enter your full name',
              ),
              const SizedBox(height: 20),

              // Class field
              _buildSectionTitle('Class'),
              _buildTextField(
                controller: _classController,
                hintText: 'Enter your class',
              ),
              const SizedBox(height: 20),

              // Session selection
              _buildSectionTitle('Session'),
              _buildSessionSelector(),
              const SizedBox(height: 20),

              // Category selection
              _buildSectionTitle('Category'),
              _buildCategorySelector(),
              const SizedBox(height: 20),

              // Counselor selection
              _buildSectionTitle('Counselor'),
              _buildCounselorSelector(),
              const SizedBox(height: 20),

              // Date and Time selection
              _buildSectionTitle('Date and Time'),
              _buildDateTimePicker(),
              const SizedBox(height: 20),

              // Support text field
              _buildSectionTitle('How can we support you? (Optional)'),
              _buildTextField(
                controller: _supportController,
                hintText: 'Tell us how we can help you...',
                maxLines: 4,
              ),
              const SizedBox(height: 30),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildSessionSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildSelectionButton(
            title: 'Morning',
            isSelected: _selectedSession == 'Morning',
            onTap: () => setState(() => _selectedSession = 'Morning'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSelectionButton(
            title: 'Evening',
            isSelected: _selectedSession == 'Evening',
            onTap: () => setState(() => _selectedSession = 'Evening'),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCounselorSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _counselors.length,
      itemBuilder: (context, index) {
        final counselor = _counselors[index];
        final isAvailable = _selectedSession == 'Morning'
            ? counselor['availableMorning']
            : counselor['availableEvening'];
        final isSelected = _selectedCounselorId == counselor['id'];

        return GestureDetector(
          onTap: isAvailable
              ? () => setState(() => _selectedCounselorId = counselor['id'])
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(counselor['image']),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    counselor['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (!isAvailable)
                    const Text(
                      'Not available',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        // Date picker
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 8),
                  Text(_formatDate(_selectedDate)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Time picker
        Expanded(
          child: GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 8),
                  Text(_formatTime(_selectedTime)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
