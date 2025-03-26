import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
        //centerTitle: true,
        //backgroundColor: const Color.fromARGB(255, 214, 109, 10),
      //),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture
            SizedBox(height: 30),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/images/harold.jpeg"), // Placeholder image
            ),
            SizedBox(height: 10),
            Text(
              "Harold", // Sample name
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "johndoe@example.com", // Sample email
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // User Info Section
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.deepPurple),
                    title: Text("+123 456 7890"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.deepPurple),
                    title: Text("New York, USA"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.deepPurple),
                    title: Text("January 1, 2000"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Buttons (For Show Only)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile",),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 187, 209, 220),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 187, 209, 220),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.logout),
                    label: Text("Log Out"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
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
