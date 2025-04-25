import 'package:flutter/material.dart';
import '../dataframe/medical_adherence_df.dart';
import '../dataframe/patient_df.dart';
import '../services/clinic_service.dart';

class PatientTrackerPage extends StatefulWidget {
  final String clinicId;

  const PatientTrackerPage({Key? key, required this.clinicId}) : super(key: key);

  @override
  _PatientTrackerPageState createState() => _PatientTrackerPageState();
}

class _PatientTrackerPageState extends State<PatientTrackerPage> {
  final ClinicService _clinicService = ClinicService();
  List<Patient> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {

    super.initState();
    _fetchPatients();
    print('📍 PatientTrackerPage using clinicId: ${widget.clinicId}');
  }

  Future<void> _fetchPatients() async {
    try {
      final patients = await _clinicService.fetchPatients(widget.clinicId);
      setState(() {
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching patients: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMedicationForPatient(Patient patient) {
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        final TextEditingController medicationNameController = TextEditingController();
        final TextEditingController dosageController = TextEditingController();
        final TextEditingController frequencyController = TextEditingController();
        final TextEditingController timesPerDayController = TextEditingController();
        final List<Map<String, int>> reminderTimes = [];

        return AlertDialog(
          title: Text('Add Medication for ${patient.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: medicationNameController,
                  decoration: const InputDecoration(labelText: 'Medication Name'),
                ),
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(labelText: 'Dosage'),
                ),
                TextField(
                  controller: frequencyController,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                ),
                TextField(
                  controller: timesPerDayController,
                  decoration: const InputDecoration(labelText: 'Times Per Day'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add a reminder time
                    setState(() {
                      reminderTimes.add({'hour': 8, 'minute': 0}); // Example reminder
                    });
                  },
                  child: const Text('Add Reminder Time'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newMedication = MedicalAdherence(
                  userId: patient.patientId,
                  medicationName: medicationNameController.text,
                  dosage: dosageController.text,
                  unit: 'mg', // Example unit
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 30)),
                  frequency: frequencyController.text,
                  timesPerDay: int.parse(timesPerDayController.text),
                  reminderTimes: reminderTimes,
                );

                await _clinicService.addMedicationToPatient(widget.clinicId, patient.patientId, newMedication);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Medication added successfully!')),
                );

                Navigator.pop(context);
                _fetchPatients(); // Refresh the patient list
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Tracker'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];
                final activeMedications = patient.medications.where((med) => med.isMedicationActive()).length;

                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('Active Medications: $activeMedications'),
                  trailing: ElevatedButton(
                    onPressed: () => _addMedicationForPatient(patient),
                    child: const Text('Add Medication'),
                  ),
                );
              },
            ),
    );
  }
}