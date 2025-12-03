import 'package:flutter/material.dart';
import 'main.dart';

// Doctor Dashboard Page
class DoctorDashboard extends StatefulWidget {
  final String username;

  const DoctorDashboard({
    super.key,
    required this.username,
  });

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final _patientNameController = TextEditingController();
  final _patientPhoneController = TextEditingController();
  final _medicationNameController = TextEditingController();
  final _partitionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<TimeOfDay> _timesOfTaking = [];
  int _dosesPerDay = 1;
  bool _isTimesSectionExpanded = false;
  bool _isAddMedicationExpanded = false;
  bool _isPatientLoaded = false;
  String? _currentPatientName;

  // Dummy patient medications data
  List<PatientMedication> patientMedications = [
    PatientMedication(
      name: 'Metformin',
      partitionNumber: 2,
      timesOfTaking: [
        const TimeOfDay(hour: 7, minute: 30),
        const TimeOfDay(hour: 19, minute: 30)
      ],
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 50)),
    ),
    PatientMedication(
      name: 'Lisinopril',
      partitionNumber: 1,
      timesOfTaking: [const TimeOfDay(hour: 19, minute: 0)],
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 87)),
    ),
    PatientMedication(
      name: 'Atorvastatin',
      partitionNumber: 1,
      timesOfTaking: [const TimeOfDay(hour: 21, minute: 30)],
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 179)),
    ),
  ];

  void _deletePatientMedication(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Medication'),
          content: const Text('Are you sure you want to delete this medication for the patient?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  patientMedications.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientPhoneController.dispose();
    _medicationNameController.dispose();
    _partitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Dr. ${widget.username}',
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
            // Patient Search Section
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
                      const Icon(Icons.search, color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Search Patient',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Patient Name
                  TextField(
                    controller: _patientNameController,
                    decoration: InputDecoration(
                      labelText: 'Patient Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Patient Phone Number
                  TextField(
                    controller: _patientPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Patient Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _searchPatient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Search Patient',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Patient Medications Section (only show if patient is loaded)
            if (_isPatientLoaded) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.green[800], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Patient',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _currentPatientName ?? 'Unknown Patient',
                            style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${patientMedications.length} medications',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Add New Medication Section for Patient
              Container(
                width: double.infinity,
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
                    // Header that's always visible
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isAddMedicationExpanded = !_isAddMedicationExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle, color: Colors.green, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Add New Medication for ${_currentPatientName}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                            Icon(
                              _isAddMedicationExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Expandable content
                    if (_isAddMedicationExpanded) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    
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
                                icon: Icon(Icons.remove, color: _dosesPerDay > 1 ? Colors.green : Colors.grey),
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
                                icon: Icon(Icons.add, color: _dosesPerDay < 6 ? Colors.green : Colors.grey),
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
                                                  color: Colors.green[50],
                                                  border: Border.all(color: Colors.green[200]!),
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
                        onPressed: _addMedicationForPatient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add Medication for Patient',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

              const SizedBox(height: 16),

              Text(
                'Patient Medications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 12),

              // Patient Medication List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patientMedications.length,
                itemBuilder: (context, index) {
                  final medication = patientMedications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
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
                                color: Colors.green,
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
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${medication.partitionNumber}',
                                style: TextStyle(
                                  color: Colors.green[800],
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
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.green[200]!),
                                    ),
                                    child: Text(
                                      time.format(context),
                                      style: TextStyle(
                                        color: Colors.green[800],
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
                            const Spacer(),
                            // Delete button aligned with date
                            TextButton.icon(
                              onPressed: () => _deletePatientMedication(index),
                              icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange[800], size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Doctor prescribed',
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              // Empty state when no patient is selected
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Search for a patient to view their medications',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _searchPatient() {
    // Validate inputs
    if (_patientNameController.text.isEmpty) {
      _showError('Please enter patient name');
      return;
    }
    if (_patientPhoneController.text.isEmpty) {
      _showError('Please enter patient phone number');
      return;
    }

    // Simulate patient search and load medications
    setState(() {
      _isPatientLoaded = true;
      _currentPatientName = _patientNameController.text;
    });

    _showSuccess('Patient found! Medications loaded successfully.');
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

  void _addMedicationForPatient() {
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

    final newMedication = PatientMedication(
      name: _medicationNameController.text,
      partitionNumber: int.parse(_partitionController.text),
      timesOfTaking: List.from(_timesOfTaking),
      startDate: _startDate!,
      endDate: _endDate!,
    );

    setState(() {
      patientMedications.add(newMedication);
      _medicationNameController.clear();
      _partitionController.clear();
      _timesOfTaking.clear();
      _dosesPerDay = 1;
      _isTimesSectionExpanded = false;
      _startDate = null;
      _endDate = null;
      _endDate = null;
    });

    _showSuccess('Medication added for ${_currentPatientName} successfully!');
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

// Patient Medication model for doctor view
class PatientMedication {
  final String name;
  final int partitionNumber;
  final List<TimeOfDay> timesOfTaking;
  final DateTime startDate;
  final DateTime endDate;

  PatientMedication({
    required this.name,
    required this.partitionNumber,
    required this.timesOfTaking,
    required this.startDate,
    required this.endDate,
  });
}