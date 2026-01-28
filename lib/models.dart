enum Difficulty { easy, medium, hard }

class Player {
  Player(this.name);
  final String name;
  double score = 0; // you can store time, accuracy, etc.
}

class GameConfig {
  GameConfig({
    required this.difficulty,
    required this.roundSeconds,
    required this.players,
    this.roundsPerPlayer = 1,
  });

  final Difficulty difficulty;
  final int roundSeconds;
  final List<Player> players;
  final int roundsPerPlayer;

  double get speedMultiplier {
    switch (difficulty) {
      case Difficulty.easy:
        return 0.9;
      case Difficulty.medium:
        return 1.2;
      case Difficulty.hard:
        return 1.6;
    }
  }
}
