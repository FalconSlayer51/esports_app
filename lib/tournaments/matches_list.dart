import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/tournaments/match_update_screen.dart';
import 'package:flutter/material.dart';

class MatchesList extends StatelessWidget {
  final String tournamentId;
  final bool isOrganizer;

  const MatchesList({
    super.key,
    required this.tournamentId,
    required this.isOrganizer,
  });

  Future<Map<String, dynamic>> getTeamDetails(String teamId) async {
    final teamDoc =
        await FirebaseFirestore.instance.collection('users').doc(teamId).get();
    return teamDoc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .where('tournamentId', isEqualTo: tournamentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final matches = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: matches.length,
                  shrinkWrap:
                      true, // Added shrinkWrap to allow ListView to fit within the Column
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable ListView's scroll to avoid conflicts
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    final matchData = match.data() as Map<String, dynamic>;

                    return FutureBuilder<Map<String, dynamic>>(
                      future: Future.wait([
                        getTeamDetails(matchData['team1Id']),
                        getTeamDetails(matchData['team2Id']),
                      ]).then((teamData) => {
                            'team1': teamData[0],
                            'team2': teamData[1],
                          }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Text("Error loading team data");
                        }

                        final team1 = snapshot.data!['team1'];
                        final team2 = snapshot.data!['team2'];

                        return ScoreCard(
                          matchId: match.id,
                          isOrganizer: isOrganizer,
                          team1Name: team1['displayName'] ?? 'Team 1',
                          team2Name: team2['displayName'] ?? 'Team 2',
                          team1PhotoUrl: team1['photoURL'] ?? '',
                          team2PhotoUrl: team2['photoURL'] ?? '',
                          team1Score: matchData['team1Score'] ?? 0,
                          team2Score: matchData['team2Score'] ?? 0,
                          matchStatus: matchData['status'] ?? 'Pending',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final String matchId;
  final String team1Name;
  final String team2Name;
  final String team1PhotoUrl;
  final String team2PhotoUrl;
  final int team1Score;
  final int team2Score;
  final String matchStatus;
  final bool isOrganizer;

  const ScoreCard({
    super.key,
    required this.matchId,
    required this.team1Name,
    required this.team2Name,
    required this.team1PhotoUrl,
    required this.team2PhotoUrl,
    required this.team1Score,
    required this.team2Score,
    required this.matchStatus,
    required this.isOrganizer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Team 1
            SizedBox(
              height: 70,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(team1PhotoUrl),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      team1Name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Score and Match Status
            Container(
              height: 120,
              margin: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Text(
                    "$team1Score - $team2Score",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      matchStatus.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isOrganizer &&
                      matchStatus ==
                          'scheduled') // Show start button if current user is the organizer
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ActionChip(
                        label: const Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          Navigator.push(
                              context, MatchScreen.getRoute(matchId));
                          await FirebaseFirestore.instance
                              .collection('matches')
                              .doc(matchId)
                              .update({
                            'status': 'live',
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Team 2
            SizedBox(
              height: 70,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(team2PhotoUrl),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      team2Name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
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
