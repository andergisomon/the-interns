import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/first_time_form_service.dart';
import '../dataframe/first_time_form_df.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirstTimeLoginPage extends StatefulWidget {
  const FirstTimeLoginPage({super.key});

  @override
  FirstTimeLoginPageState createState() => FirstTimeLoginPageState();
}

class FirstTimeLoginPageState extends State<FirstTimeLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _preExistingConditionsController = TextEditingController();
  final TextEditingController _regularMedicationController = TextEditingController();
  final TextEditingController _disabilityController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final FirstTimeLoginService _service = FirstTimeLoginService();

  String _selectedGender = 'Male';

  Future<void> _saveFirstTimeLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final double height = double.parse(_heightController.text);
      final double weight = double.parse(_weightController.text);
      final double bmi = weight / ((height / 100) * (height / 100));

      final firstTimeLogin = FirstTimeLogin(
        userId: user.uid,
        nickname: _nicknameController.text,
        dateOfBirth: DateTime.parse(_dateOfBirthController.text),
        gender: _selectedGender,
        preExistingConditions: _preExistingConditionsController.text,
        regularMedication: _regularMedicationController.text,
        disability: _disabilityController.text,
        height: height,
        weight: weight,
        bmi: bmi,
      );
      await _service.saveFirstTimeLogin(firstTimeLogin);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.firstTimeLoginDataSaved)),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTimeLogin();
  }

  Future<void> _checkFirstTimeLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firstTimeLogin = await _service.getFirstTimeFormData(user.uid);
      if (firstTimeLogin != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.firstTimeLoginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginNickname),
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginDateOfBirth),
                onTap: () => _selectDate(context),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginGender),
                items: [AppLocalizations.of(context)!.firstTimeLoginGenderItem1 , AppLocalizations.of(context)!.firstTimeLoginGenderItem2 , AppLocalizations.of(context)!.firstTimeLoginGenderItem3 ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _preExistingConditionsController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginPreExistingConditions),
              ),
              TextFormField(
                controller: _regularMedicationController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginRegularMedication),
              ),
              TextFormField(
                controller: _disabilityController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginDisability),
              ),
              TextFormField(
                controller: _heightController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginHeight),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weightController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context)!.firstTimeLoginWeight),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveFirstTimeLogin();
                  }
                },
                child:  Text(AppLocalizations.of(context)!.firstTimeLoginSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}