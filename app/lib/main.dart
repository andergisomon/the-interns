import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  _setupLogging();
  runApp(const MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // Set the logging level to ALL
  Logger.root.onRecord.listen((record) {
    // ...existing code...
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> _medications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _medications = prefs.getStringList('medications') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: ListView.builder(
        itemCount: _medications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_medications[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MedicationAdherenceScreen()),
          ).then((_) => _loadMedications());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MedicationAdherenceScreen extends StatelessWidget {
  const MedicationAdherenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medication Adherence")),
      body: const MedicationForm(),
    );
  }
}

class MedicationForm extends StatefulWidget {
  const MedicationForm({super.key});

  @override
  MedicationFormState createState() => MedicationFormState();
}

class MedicationFormState extends State<MedicationForm> {
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger('MedicationFormState');
  String _medicationName = '';
  String _dosage = '';
  String _unit = 'mg';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  String _frequency = 'Daily';
  int _timesPerDay = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Medication Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _medicationName = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Dosage',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _dosage = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _unit,
                  items: <String>['teaspoon', 'pills', 'mg', 'g'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _unit = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _startDate) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_startDate),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _endDate) {
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_endDate),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency of Intake',
              ),
              items: <String>['Daily', 'X times a day'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                });
              },
            ),
            if (_frequency == 'X times a day')
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Times per Day',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _timesPerDay = int.tryParse(value) ?? 1;
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save medication data and set reminder
                  _saveMedicationData();
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMedicationData() async {
    // Logic to save medication data and set reminders
    final prefs = await SharedPreferences.getInstance();
    final medicationData = {
      'medicationName': _medicationName,
      'dosage': _dosage,
      'unit': _unit,
      'startDate': DateFormat('yyyy-MM-dd').format(_startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(_endDate),
      'frequency': _frequency,
      'timesPerDay': _timesPerDay.toString(),
    };
    final medications = prefs.getStringList('medications') ?? [];
    medications.add(medicationData.toString());
    await prefs.setStringList('medications', medications);

    _logger.info('Medication Name: $_medicationName');
    _logger.info('Dosage: $_dosage');
    _logger.info('Unit: $_unit');
    _logger.info('Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate)}');
    _logger.info('End Date: ${DateFormat('yyyy-MM-dd').format(_endDate)}');
    _logger.info('Frequency: $_frequency');
    if (_frequency == 'X times a day') {
      _logger.info('Times per Day: $_timesPerDay');
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

