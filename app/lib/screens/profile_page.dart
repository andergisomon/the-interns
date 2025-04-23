import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart'; // Import MyApp to call setLocale

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _selectedLanguage = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(), // Remove underline
             icon: const Icon(Icons.language), // Ensure the language icon is displayed
              dropdownColor: Colors.white,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'zh', child: Text('中文')),
                DropdownMenuItem(value: 'my', child: Text('Malay')),
                DropdownMenuItem(value: 'th', child: Text('ไทย')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  MyApp.setLocale(context, Locale(newValue));
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/images/harold.jpeg"), // Placeholder image
            ),
            const SizedBox(height: 10),
            const Text(
              "Harold", // Sample name
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "johndoe@example.com", // Sample email
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // User Info Section
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.deepPurple),
                    title: const Text("+123 456 7890"),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                    title: const Text("New York, USA"),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.cake, color: Colors.deepPurple),
                    title: const Text("January 1, 2000"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons (For Show Only)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: Text(AppLocalizations.of(context)!.profileEdit),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 187, 209, 220),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                    label: Text(AppLocalizations.of(context)!.profileSettings),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 187, 209, 220),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout),
                    label: Text(AppLocalizations.of(context)!.profileLogout),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 187, 209, 220),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}