import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizerInfoWidget extends StatelessWidget {
  final String organizerId;

  const OrganizerInfoWidget({super.key, required this.organizerId});

  Future<Map<String, dynamic>?> _fetchOrganizerData() async {
    final organizerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(organizerId)
        .get();

    return organizerDoc.data();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchOrganizerData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Failed to load organizer info"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Organizer info not available"));
        }

        final organizerData = snapshot.data!;
        final name = organizerData['displayName'] ?? 'No Name';
        final email = organizerData['email'] ?? 'No Email';
        final profilePhotoUrl = organizerData['photoURL'];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Photo with border
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profilePhotoUrl != null
                      ? NetworkImage(profilePhotoUrl)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 12),
                // Organizer Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Organizer Email with Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider for visual separation
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
