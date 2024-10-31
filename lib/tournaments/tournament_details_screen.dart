import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/tournaments/matches_list.dart';
import 'package:esports_app/tournaments/organizer_info_widget.dart';
import 'package:esports_app/tournaments/points_table.dart';
import 'package:esports_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'matches_screen.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentDetailsScreen({super.key, required this.tournamentId});

  static Route getRoute(String tournamentId) {
    return MaterialPageRoute(
      builder: (context) => TournamentDetailsScreen(tournamentId: tournamentId),
    );
  }

  @override
  State<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _startTournament() async {
    await _firestore
        .collection('tournaments')
        .doc(widget.tournamentId)
        .update({'status': 'ongoing'});
    showCustomSnackbar(
      context,
      'Tournament has started!',
      Theme.of(context).colorScheme.secondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PointsTable.getRoute(widget.tournamentId),
              );
            },
            icon: const Icon(Icons.table_chart_outlined),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('tournaments')
            .doc(widget.tournamentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final organizerId = data['organizerId'];
          final isRegistered = data['teamsRegistered']
              .contains(FirebaseAuth.instance.currentUser!.uid);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  color: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data['name'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          if (isRegistered)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Registered',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Row
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Teams',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '${(data['teamsRegistered'] as List<dynamic>).length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Status',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            data['status'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Start Date',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            data['startDate'].toDate().toString().split(" ")[0],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('End Date',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            data['endDate'].toDate().toString().split(" ")[0],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Organizer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                OrganizerInfoWidget(organizerId: organizerId),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Matches', style: TextStyle(fontSize: 18)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MatchesScreen.getRoute(
                              widget.tournamentId,
                              data['organizerId'] == currentUser!.uid,
                            ),
                          );
                        },
                        child: const Text(
                          'more',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300, // Adjust height as needed to fit content
                  child: MatchesList(
                    tournamentId: widget.tournamentId,
                    isOrganizer: data['organizerId'] == currentUser!.uid,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('tournaments')
            .doc(widget.tournamentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final organizerId = data['organizerId'];
          final isOrganizer =
              currentUser != null && currentUser.uid == organizerId;
          final isRegistered =
              data['teamsRegistered'].contains(currentUser!.uid);
          final isOngoing = data['status'] == 'ongoing';
          final isUpcoming = data['status'] == 'upcoming';
          final isCompleted = data['status'] == 'completed';

          if (isCompleted) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  'Tournament Ended',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          if (isOrganizer && isUpcoming) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: _startTournament,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  'Start Tournament',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else if (isOrganizer && !isUpcoming) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () async {
                  await _firestore
                      .collection('tournaments')
                      .doc(widget.tournamentId)
                      .update({'status': 'completed'});
                  showCustomSnackbar(
                    context,
                    'Tournament has ended!',
                    Theme.of(context).colorScheme.secondary,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  'End Tournament',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else if (!isOrganizer) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: isRegistered || isOngoing
                    ? null
                    : () async {
                        final docRef = _firestore
                            .collection('tournaments')
                            .doc(widget.tournamentId);
                        await docRef.update({
                          'teamsRegistered': FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser!.uid])
                        });
                        showCustomSnackbar(
                          context,
                          'Successfully registered!',
                          Theme.of(context).colorScheme.secondary,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: Text(
                  isRegistered ? 'Already Registered' : 'Register',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
