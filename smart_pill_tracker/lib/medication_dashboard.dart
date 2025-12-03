import 'package:flutter/material.dart';
import 'main.dart';

// Medication model
class Medication {
  final String name;
  final int partitionNumber;
  final List<TimeOfDay> timesOfTaking;
  final DateTime startDate;
  final DateTime endDate;

  Medication({
    required this.name,
    required this.partitionNumber,
    required this.timesOfTaking,
    required this.startDate,
    required this.endDate,
  });
}

// Medication Dashboard Page
class MedicationDashboard extends StatefulWidget {
  final String username;
  final UserType userType;

  const MedicationDashboard({
    super.key,
    required this.username,
    required this.userType,
  });

  @override
  State<MedicationDashboard> createState() => _MedicationDashboardState();
}

class _MedicationDashboardState extends State<MedicationDashboard> {
  final _medicationNameController = TextEditingController();
  final _partitionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<TimeOfDay> _timesOfTaking = [];
  int _dosesPerDay = 1;
  bool _isTimesSectionExpanded = false;

  List<Medication> medications = [
    Medication(
      name: 'Vitamin D',
      partitionNumber: 1,
      timesOfTaking: [const TimeOfDay(hour: 8, minute: 0)],
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 25)),
    ),
    Medication(
      name: 'Aspirin',
      partitionNumber: 2,
      timesOfTaking: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 20, minute: 0)
      ],
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 28)),
    ),
    Medication(
      name: 'Blood Pressure Pills',
      partitionNumber: 1,
      timesOfTaking: [const TimeOfDay(hour: 20, minute: 0)],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 90)),
    ),
  ];

  @override
  void dispose() {
    _medicationNameController.dispose();
    _partitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medication Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Welcome, ${widget.username}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add New Medication Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.add_circle, color: Colors.blue, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Add New Medication',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Medication Name
                  TextField(
                    controller: _medicationNameController,
                    decoration: InputDecoration(
                      labelText: 'Medication Name',
                      prefixIcon: const Icon(Icons.medical_services),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Partition Number
                  TextField(
                    controller: _partitionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Partition Number',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Doses per day selector
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Doses per day:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _dosesPerDay > 1 ? () => _updateDosesPerDay(_dosesPerDay - 1) : null,
                              icon: Icon(Icons.remove, color: _dosesPerDay > 1 ? Colors.blue : Colors.grey),
                              visualDensity: VisualDensity.compact,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Text(
                                '$_dosesPerDay',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _dosesPerDay < 6 ? () => _updateDosesPerDay(_dosesPerDay + 1) : null,
                              icon: Icon(Icons.add, color: _dosesPerDay < 6 ? Colors.blue : Colors.grey),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Times of taking section
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isTimesSectionExpanded = !_isTimesSectionExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.grey),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _timesOfTaking.isEmpty 
                                        ? 'Set times for taking medication'
                                        : '${_timesOfTaking.length} time${_timesOfTaking.length > 1 ? 's' : ''} set',
                                    style: TextStyle(
                                      color: _timesOfTaking.isEmpty ? Colors.grey[600] : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _isTimesSectionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isTimesSectionExpanded) ...[
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                ...List.generate(_dosesPerDay, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Dose ${index + 1}:',
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: () => _selectTimeForDose(context, index),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                border: Border.all(color: Colors.blue[200]!),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                _timesOfTaking.length > index 
                                                    ? _timesOfTaking[index].format(context)
                                                    : 'Select time',
                                                style: TextStyle(
                                                  color: _timesOfTaking.length > index ? Colors.black : Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                if (_timesOfTaking.length < _dosesPerDay)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Please set all ${_dosesPerDay} times before proceeding',
                                      style: TextStyle(
                                        color: Colors.orange[700],
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Start and End Date
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectStartDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _startDate != null
                                        ? 'Start: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                        : 'Start Date',
                                    style: TextStyle(
                                      color: _startDate != null ? Colors.black : Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectEndDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _endDate != null
                                        ? 'End: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                        : 'End Date',
                                    style: TextStyle(
                                      color: _endDate != null ? Colors.black : Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addMedication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add Medication',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Current Medications Section
            Text(
              'Your Medications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),

            // Medication List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.medication,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              medication.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'x${medication.partitionNumber}',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Times section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: medication.timesOfTaking.map((time) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blue[200]!),
                                  ),
                                  child: Text(
                                    time.format(context),
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Date section
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${medication.startDate.day}/${medication.startDate.month}/${medication.startDate.year} - ${medication.endDate.day}/${medication.endDate.month}/${medication.endDate.year}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateDosesPerDay(int newDoses) {
    setState(() {
      _dosesPerDay = newDoses;
      // Adjust times list to match new doses count
      if (_timesOfTaking.length > newDoses) {
        _timesOfTaking = _timesOfTaking.take(newDoses).toList();
      }
      // Reset expansion state when changing doses
      _isTimesSectionExpanded = true;
    });
  }

  Future<void> _selectTimeForDose(BuildContext context, int doseIndex) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Ensure list is large enough
        while (_timesOfTaking.length <= doseIndex) {
          _timesOfTaking.add(const TimeOfDay(hour: 0, minute: 0));
        }
        _timesOfTaking[doseIndex] = picked;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _addMedication() {
    if (_medicationNameController.text.isEmpty) {
      _showError('Please enter medication name');
      return;
    }
    if (_partitionController.text.isEmpty) {
      _showError('Please enter partition number');
      return;
    }
    if (_timesOfTaking.length != _dosesPerDay) {
      _showError('Please set all ${_dosesPerDay} times for taking medication');
      return;
    }
    if (_startDate == null) {
      _showError('Please select start date');
      return;
    }
    if (_endDate == null) {
      _showError('Please select end date');
      return;
    }

    final newMedication = Medication(
      name: _medicationNameController.text,
      partitionNumber: int.parse(_partitionController.text),
      timesOfTaking: List.from(_timesOfTaking),
      startDate: _startDate!,
      endDate: _endDate!,
    );

    setState(() {
      medications.add(newMedication);
      _medicationNameController.clear();
      _partitionController.clear();
      _timesOfTaking.clear();
      _dosesPerDay = 1;
      _isTimesSectionExpanded = false;
      _startDate = null;
      _endDate = null;
      _endDate = null;
    });

    _showSuccess('Medication added successfully!');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}