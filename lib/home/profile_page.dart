import 'package:esports_app/auth/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Profile Picture and User Information
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 10),

            // User Name
            Text(
              user?.displayName ?? 'User Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // User Email
            Text(
              user?.email ?? 'user@example.com',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1),

            // Account Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Join Date
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                    ),
                    title: const Text("Joined Date"),
                    subtitle: Text(
                      user?.metadata.creationTime
                              ?.toLocal()
                              .toString()
                              .split(' ')[0] ??
                          "N/A",
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (_) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  minimumSize:
                      const Size(double.infinity, 48), // Full width button
                ),
                child: const Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
