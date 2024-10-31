import 'package:esports_app/tournaments/matches_list.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    super.key,
    required this.tournamentId,
    required this.isOrganizer,
  });
  final String tournamentId;
  final bool isOrganizer;
  static Route getRoute(String tournamentId, bool isOrganizer) {
    return MaterialPageRoute(
      builder: (context) => MatchesScreen(
        tournamentId: tournamentId,
        isOrganizer: isOrganizer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: MatchesList(
        tournamentId: tournamentId,
        isOrganizer: isOrganizer,
      ),
    );
  }
}
