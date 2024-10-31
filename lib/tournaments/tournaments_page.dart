import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/tournaments/add_tournament_screen.dart';
import 'package:esports_app/tournaments/tournament_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TournamentsPage extends StatelessWidget {
  const TournamentsPage({super.key});

  Future<QuerySnapshot> _fetchActiveTournaments() {
    return FirebaseFirestore.instance
        .collection('tournaments')
        .where('endDate', isGreaterThan: Timestamp.now())
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournaments')
            .where('endDate', isGreaterThan: Timestamp.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No active tournaments available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final tournament = snapshot.data!.docs[index];
              final tournamentData = tournament.data() as Map<String, dynamic>;

              // Parse dates for display
              final startDate =
                  (tournamentData['startDate'] as Timestamp).toDate();
              final endDate = (tournamentData['endDate'] as Timestamp).toDate();
              final prizePool = tournamentData['prizePool'] ?? "TBD";

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    TournamentDetailsScreen.getRoute(tournament.id),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tournamentData['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tournamentData['description'] ??
                                'No description available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 16, // spacing between items horizontally
                            runSpacing: 8, // spacing between rows when wrapping
                            alignment: WrapAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.monetization_on,
                                      color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Prize Pool: $prizePool',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Start: ${DateFormat('MMM dd, yyyy').format(startDate)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'End: ${DateFormat('MMM dd, yyyy').format(endDate)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Register button
                          tournament['status'] == 'completed' ||
                                  tournamentData['status'] == 'ongoing'
                              ? const Text(
                                  'Registration closed',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : tournament['organizerId'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? const Text(
                                      'You are the organizer of this tournament',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : tournament['teamsRegistered'].contains(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    )
                                      ? const Text(
                                          'You are registered for this tournament',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: () async {
                                            final doc = FirebaseFirestore
                                                .instance
                                                .collection('tournaments')
                                                .doc(tournament.id);
                                            await doc.update({
                                              'teamsRegistered':
                                                  FieldValue.arrayUnion([
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                              ]),
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Register',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(AddTournamentScreen.getRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showRegistrationDialog(
      BuildContext context, Map<String, dynamic> tournamentData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register for Tournament'),
          content: Text('You are registering for ${tournamentData['name']}.'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle registration logic here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
