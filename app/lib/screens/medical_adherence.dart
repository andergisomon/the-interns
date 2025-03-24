import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/medical_adherence_service.dart';
import '../dataframe/medical_adherence_df.dart';

class MedicalAdherencePage extends StatefulWidget {
  const MedicalAdherencePage({super.key});

  @override
  MedicalAdherencePageState createState() => MedicalAdherencePageState(); // Make the type public
}

class MedicalAdherencePageState extends State<MedicalAdherencePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final MedicalAdherenceService _service = MedicalAdherenceService();

  String _selectedUnit = 'mg';
  String _selectedFrequency = 'Daily';
  int _selectedTimesPerDay = 1;
  final List<MedicalAdherence> _medications = [];
  bool _isFormVisible = false;

  Future<void> _saveAdherence() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final adherence = MedicalAdherence(
        userId: user.uid,
        medicationName: _medicationNameController.text,
        dosage: _dosageController.text,
        unit: _selectedUnit,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        frequency: _selectedFrequency,
        timesPerDay: _selectedTimesPerDay,
      );
      await _service.saveMedicalAdherence(adherence);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medical adherence data saved')),
      );
      _loadAdherence();
      if (mounted) { // Ensure BuildContext is used synchronously
        setState(() {
          _isFormVisible = false;
        });
      }
    }
  }

  Future<void> _loadAdherence() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final adherenceList = await _service.getMedicalAdherence(user.uid);
      setState(() {
        _medications.addAll(adherenceList);
      });
        }
  }

  @override
  void initState() {
    super.initState();
    _loadAdherence();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final List<MedicalAdherence> activeMedications = _medications.where((med) => med.endDate.isAfter(now)).toList();
    final List<MedicalAdherence> pastMedications = _medications.where((med) => med.endDate.isBefore(now)).toList();

    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text('Active Medications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...activeMedications.map((med) => ListTile(
              title: Text(med.medicationName),
              subtitle: Text('Dosage: ${med.dosage} ${med.unit}, Frequency: ${med.frequency}, Times per Day: ${med.timesPerDay}'),
            )),
            const SizedBox(height: 20),
            if (!_isFormVisible)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isFormVisible = true;
                  });
                },
                child: const Text('Add Medication Reminder'),
              ),
            if (_isFormVisible) ...[
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _medicationNameController,
                      decoration: const InputDecoration(labelText: 'Medication Name'),
                    ),
                    TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(labelText: 'Dosage'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: ['mg', 'ml', 'tablet', 'teaspoons'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                      onTap: () => _selectDate(context, _startDateController),
                    ),
                    TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
                      onTap: () => _selectDate(context, _endDateController),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      decoration: const InputDecoration(labelText: 'Frequency'),
                      items: ['Daily', 'Weekly', 'Monthly'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFrequency = newValue!;
                        });
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedTimesPerDay,
                      decoration: const InputDecoration(labelText: 'Times per Day'),
                      items: [1, 2, 3, 4, 5].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTimesPerDay = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isFormVisible = false;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveAdherence();
                            }
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Past Medications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...pastMedications.map((med) => ListTile(
              title: Text(med.medicationName),
              subtitle: Text('Dosage: ${med.dosage} ${med.unit}, Frequency: ${med.frequency}, Times per Day: ${med.timesPerDay}'),
            )),
          ],
        ),
      ),
    );
  }
}