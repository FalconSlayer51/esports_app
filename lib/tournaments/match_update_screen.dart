import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/tournaments/matches_list.dart';
import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  final String matchId;

  const MatchScreen({super.key, required this.matchId});

  static Route getRoute(String matchId) {
    return MaterialPageRoute(
      builder: (context) => MatchScreen(matchId: matchId),
    );
  }

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int team1Score = 0;
  int team2Score = 0;
  String? team1Id;
  String? team2Id;
  String? team1Name;
  String? team2Name;
  String? team1PhotoUrl;
  String? team2PhotoUrl;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController team1ScoreController = TextEditingController();
  final TextEditingController team2ScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMatchData();
  }

  // Method to fetch match data and team IDs
  void _fetchMatchData() async {
    DocumentSnapshot matchData =
        await _firestore.collection('matches').doc(widget.matchId).get();
    setState(() {
      team1Id = matchData['team1Id'];
      team2Id = matchData['team2Id'];
    });

    // Fetch team user data
    await _fetchUserData();
  }

  // Method to fetch user data for both teams
  Future<void> _fetchUserData() async {
    DocumentSnapshot team1Data =
        await _firestore.collection('users').doc(team1Id).get();
    DocumentSnapshot team2Data =
        await _firestore.collection('users').doc(team2Id).get();

    setState(() {
      team1Name = team1Data['displayName'];
      team1PhotoUrl = team1Data['photoURL'];
      team2Name = team2Data['displayName'];
      team2PhotoUrl = team2Data['photoURL'];
    });
  }

  // Method to update team scores
  void updateScores() async {
    await _firestore.collection('matches').doc(widget.matchId).update({
      'team1Score': int.parse(team1ScoreController.text),
      'team2Score': int.parse(team2ScoreController.text),
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scores updated successfully!')),
    );
  }

  // Method to end the match and determine the winner
  void endMatch() async {
    if (team1Score == team2Score) {
      // Show error message for draw
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot be a draw match!')),
      );
      return;
    }

    // Determine winner
    String? winnerId = (team1Score > team2Score) ? team1Id : team2Id;

    // Update Firestore with the winner and status
    await _firestore.collection('matches').doc(widget.matchId).update({
      'winnerId': winnerId,
      'status': 'completed',
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Match ended! Winner is Team ID: $winnerId')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('matches').doc(widget.matchId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          // Update scores from Firestore data
          team1Score = snapshot.data!['team1Score'] ?? 0;
          team2Score = snapshot.data!['team2Score'] ?? 0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScoreCard(
                    matchId: widget.matchId,
                    team1Name: team1Name ?? 'Team 1',
                    team2Name: team2Name ?? 'Team 2',
                    team1PhotoUrl: team1PhotoUrl ?? '',
                    team2PhotoUrl: team2PhotoUrl ?? '',
                    team1Score: team1Score,
                    team2Score: team2Score,
                    matchStatus: snapshot.data!['status'] ?? 'Pending',
                    isOrganizer: false,
                  ),
                  // Score Inputs
                  const SizedBox(height: 100),
                  const Text('Update Team 1 Score:'),
                  TextField(
                    controller: team1ScoreController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Text('Update Team 2 Score:'),
                  TextField(
                    controller: team2ScoreController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: updateScores,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                    ),
                    child: const Text('Update Scores'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: endMatch,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                    ),
                    child: const Text('End Match'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
