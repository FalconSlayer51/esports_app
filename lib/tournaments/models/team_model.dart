class Team {
  final String teamId;
  final String name;

  int wins;
  int losses;

  Team({
    required this.teamId,
    required this.name,
    this.wins = 0,
    this.losses = 0,
  });
  int get points => wins * 3;
  int get matches => wins + losses;
}
