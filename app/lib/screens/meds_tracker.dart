import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lebui_modsu/globals.dart';
import 'package:lebui_modsu/services/clinic_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/medical_adherence_service.dart';
import '../services/notifications.dart'; // Import NotificationsService
import '../dataframe/medical_adherence_df.dart';

import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final Logger _logger = Logger();

class MedsTrackerPage extends StatefulWidget {
  final String clinicId;

  const MedsTrackerPage({super.key, required this.clinicId});

  @override
  MedsTrackerPageState createState() => MedsTrackerPageState();
}


class MedsTrackerPageState extends State<MedsTrackerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final MedicalAdherenceService _service = MedicalAdherenceService();
  final NotificationsService _notificationsService = NotificationsService(); // Instance of NotificationsService

  String _selectedUnit = 'mg';
  int _selectedTimesPerDay = 1;
  final List<MedicalAdherence> _medications = [];
  List<TimeOfDay> _reminderTimes = [];
  bool _isFormVisible = false;
  bool _isSaving = false; // State variable to track saving status

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadAdherence();
    _logger.i('Initialized MedsTrackerPage'); // Debug log
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationsService.initNotification();
      _logger.i('Notifications initialized successfully');
    } catch (e) {
      _logger.e('Error initializing notifications: $e');
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    if (_reminderTimes.length >= _selectedTimesPerDay) {
      _logger.w('Maximum number of reminder times reached: $_selectedTimesPerDay');
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(AppLocalizations.of(context)!.medsTrackerMaximumReminder)),
      );
      return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _reminderTimes.add(picked);
      });
      _logger.i('Added reminder time: ${picked.format(context)}. Total reminders: ${_reminderTimes.length}');
    }
  }

  Future<void> _saveAdherence() async {
    _logger.i('Entered _saveAdherence method');
    if (_isSaving) return; // Prevent multiple clicks
    setState(() {
      _isSaving = true; // Indicate saving in progress
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final adherence = MedicalAdherence(
        userId: user.uid,
        medicationName: _medicationNameController.text,
        dosage: _dosageController.text,
        unit: _selectedUnit,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        frequency: 'Daily',
        timesPerDay: _selectedTimesPerDay,
        reminderTimes: _reminderTimes.map((t) => {'hour': t.hour, 'minute': t.minute}).toList(),
      );

      try {
        final clinicService = ClinicService();
        assignedClinicId = await clinicService.getAssignedClinicId(user.uid);
        if (assignedClinicId == null) {
        print('❌ assignedClinicId is null. Cannot save medication.');
        return;
      }

        // Now it's safe:
        await _service.saveMedicalAdherence(widget.clinicId, adherence);


        _logger.i('Saved adherence: $adherence');

        // Schedule notifications for the reminder times
        int notificationId = 0; // Unique ID for each notification
        for (final reminder in _reminderTimes) {
          _logger.i('Scheduling notification for time: ${reminder.hour}:${reminder.minute}');
          await _notificationsService.scheduleNotification(
            id: notificationId++,
            title: 'Medication Reminder',
            body: 'It\'s time to take your medication: ${adherence.medicationName} (${adherence.dosage} ${adherence.unit})',
            hour: reminder.hour,
            minute: reminder.minute,
          );
          _logger.i('Notification scheduled for ${reminder.hour}:${reminder.minute}');
        }

        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.medsTrackerSaveSuccess)),
        );

        _loadAdherence();
        if (mounted) {
          setState(() {
            _isFormVisible = false;
            _reminderTimes.clear();
            _medicationNameController.clear();
            _dosageController.clear();
            _startDateController.clear();
            _endDateController.clear();
          });
        }
      } catch (e) {
        _logger.e('Error saving adherence: $e'); // Log error
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.medsTrackerSaveError)),
        );
      } finally {
        setState(() {
          _isSaving = false; // Reset saving status
        });
      }
    }
  }

  Future<void> _loadAdherence() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        _logger.i('Loading adherence data for user: ${user.uid}');
        final adherenceList = await _service.getMedicalAdherence(widget.clinicId, user.uid);


        setState(() {
          _medications.clear();
          _medications.addAll(adherenceList);
        });
        _logger.i('Loaded medications: ${_medications.length}');
      } catch (e) {
        _logger.e('Error loading adherence data: $e');
      }
    } else {
      _logger.i('No user logged in');
    }
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

  void openAppSettings() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;

      if (packageName.isNotEmpty) {
        final url = 'package:$packageName';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
          _logger.i('Opened app settings for package: $packageName');
        } else {
          _logger.e('Cannot launch app settings URL.');
          ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.medsTrackerUnableToOpenApp)),
          );
        }
      } else {
        _logger.e('Package name is empty. Cannot open app settings.');
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.medsTrackerPackageNotFound)),
        );
      }
    } catch (e) {
      _logger.e('Error opening app settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(AppLocalizations.of(context)!.medsTrackerFailedToOpenApp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final List<MedicalAdherence> activeMedications = _medications.where((med) => med.endDate.isAfter(now)).toList();
    final List<MedicalAdherence> pastMedications = _medications.where((med) => med.endDate.isBefore(now)).toList();

    _logger.i('Active medications: ${activeMedications.length}'); // Debug log
    _logger.i('Past medications: ${pastMedications.length}'); // Debug log

    if (_isSaving) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(AppLocalizations.of(context)!.medsTrackerActiveMedications, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...activeMedications.map((med) => ListTile(
              title: Text(med.medicationName),
              subtitle: Text(AppLocalizations.of(context)!.medsTrackerDosage + '${med.dosage} ${med.unit}, '+ AppLocalizations.of(context)!.medsTrackerTimesPerDay + '${med.timesPerDay}'),
            )),
            const SizedBox(height: 20),
            if (!_isFormVisible)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isFormVisible = true;
                  });
                },
                child: Text(AppLocalizations.of(context)!.medsTrackerAddReminderTime),
              ),
            if (_isFormVisible) ...[
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _medicationNameController,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.medsTrackerFormMedName),
                    ),
                    TextFormField(
                      controller: _dosageController,
                      decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.medsTrackerFormDosage),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.medsTrackerUnit),
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
                      decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.medsTrackerStartDate + '(YYYY-MM-DD)'),
                      onTap: () => _selectDate(context, _startDateController),
                    ),
                    TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.medsTrackerEndDate + '(YYYY-MM-DD)'),
                      onTap: () => _selectDate(context, _endDateController),
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedTimesPerDay,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.medsTrackerTimesPerDay),
                      items: [1, 2, 3, 4, 5].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTimesPerDay = newValue!;
                          _reminderTimes.clear();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text(AppLocalizations.of(context)!.medsTrackerReminderTimes, style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            children: _reminderTimes.map((t) => Chip(label: Text(t.format(context)))).toList(),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => _selectReminderTime(context),
                                child: Text(AppLocalizations.of(context)!.medsTrackerAddReminderTime),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isFormVisible = false;
                              _reminderTimes.clear();
                            });
                          },
                          child: Text(AppLocalizations.of(context)!.buttonCancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _logger.i('Confirm button pressed');
                              _saveAdherence();
                            }
                          },
                          child:  Text(AppLocalizations.of(context)!.buttonConfirm),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
           Text(AppLocalizations.of(context)!.medsTrackerPastMedications, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...pastMedications.map((med) => ListTile(
              title: Text(med.medicationName),
              subtitle: Text(AppLocalizations.of(context)!.medsTrackerDosage + '${med.dosage} ${med.unit}, '+ AppLocalizations.of(context)!.medsTrackerTimesPerDay + '${med.timesPerDay}'),
            )),
          ],
        ),
      ),
    );
  }
}
