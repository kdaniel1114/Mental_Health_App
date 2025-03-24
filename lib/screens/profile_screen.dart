import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Light blue background
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture & Name
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile_placeholder.png"),
            ),
            const SizedBox(height: 10),
            Text(
              "John Doe",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "johndoe@email.com",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Mood Stats
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.bar_chart, color: Colors.lightBlue),
                title: Text("Most Common Mood: Happy"),
                subtitle: Text("Logged 15 times this month"),
              ),
            ),
            const SizedBox(height: 10),

            // Settings
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.dark_mode, color: Colors.lightBlue),
                    title: Text("Dark Mode"),
                    trailing: Switch(value: false, onChanged: (bool value) {}),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Colors.lightBlue),
                    title: Text("Notifications"),
                    trailing: Switch(value: true, onChanged: (bool value) {}),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.lightBlue),
                    title: Text("Privacy Settings"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.exit_to_app),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
