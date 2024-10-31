import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/tournaments/models/team_model.dart';
import 'package:flutter/material.dart';

class PointsTable extends StatelessWidget {
  final String tournamentId;

  const PointsTable({super.key, required this.tournamentId});

  static Route getRoute(String tournamentId) {
    return MaterialPageRoute(
      builder: (context) => PointsTable(tournamentId: tournamentId),
    );
  }

  Stream<List<Team>> getPointsTableStream() {
    return FirebaseFirestore.instance
        .collection('matches')
        .where('tournamentId', isEqualTo: tournamentId)
        .snapshots()
        .asyncMap((snapshot) async {
      log('Snapshot docs count: ${snapshot.docs.length}');
      Map<String, Team> teamMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        log('Document Data: $data');

        final String team1Id = data['team1Id'];
        final String team2Id = data['team2Id'];
        final String winnerId = data['winnerId'] ?? '';

        final team1Name = await _getTeamName(team1Id);
        final team2Name = await _getTeamName(team2Id);
        teamMap.putIfAbsent(
          team1Id,
          () => Team(name: team1Name, teamId: team1Id),
        );
        teamMap.putIfAbsent(
          team2Id,
          () => Team(name: team2Name, teamId: team2Id),
        );

        if (data['status'] == 'completed') {
          if (winnerId == team1Id) {
            teamMap[team1Id]!.wins++;
            teamMap[team2Id]!.losses++;
          } else if (winnerId == team2Id) {
            teamMap[team2Id]!.wins++;
            teamMap[team1Id]!.losses++;
          }
        }
      }

      final teams = teamMap.values.toList();
      teams.sort((a, b) => b.points - a.points);
      return teams;
    });
  }

  Future<String> _getTeamName(String teamId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(teamId).get();
    return doc.data()?['displayName'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Points Table")),
      body: StreamBuilder<List<Team>>(
        stream: getPointsTableStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log("Stream error: ${snapshot.error}");
            return const Center(child: Text("An error occurred"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            log("Snapshot has no data or data is empty");
            return const Center(child: Text("No data available"));
          }

          final teams = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                  4: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Team",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Matches",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Wins",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Losses",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Points",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  ...teams.map((team) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(team.name),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${team.matches}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${team.wins}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${team.losses}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${team.points}"),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
