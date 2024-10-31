import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String matchId;
  final String tournamentId;
  final String team1Id;
  final String team2Id;
  final int team1Score;
  final int team2Score;
  final String status;
  final String? winnerId;

  Match({
    required this.matchId,
    required this.tournamentId,
    required this.team1Id,
    required this.team2Id,
    required this.team1Score,
    required this.team2Score,
    required this.status,
    this.winnerId,
  });

  // Factory constructor to create a Match from Firestore document
  factory Match.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map; // Ensure you cast to Map
    return Match(
      matchId: doc.id,
      tournamentId: data['tournamentId'],
      team1Id: data['team1Id'],
      team2Id: data['team2Id'],
      team1Score: data['team1Score'],
      team2Score: data['team2Score'],
      status: data['status'],
      winnerId: data['winnerId'],
    );
  }
}
