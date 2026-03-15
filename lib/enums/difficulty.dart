enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  static Difficulty fromString(String value) {
    switch (value) {
      case "EASY":
        return Difficulty.easy;
      case "MEDIUM":
        return Difficulty.medium;
      case "HARD":
        return Difficulty.hard;
      default:
        return Difficulty.easy;
    }
  }

  String toApi() {
    switch (this) {
      case Difficulty.easy:
        return "EASY";
      case Difficulty.medium:
        return "MEDIUM";
      case Difficulty.hard:
        return "HARD";
    }
  }

  /// 🔹 Tradução para UI
  String toPtBr() {
    switch (this) {
      case Difficulty.easy:
        return "Iniciante";
      case Difficulty.medium:
        return "Intermediário";
      case Difficulty.hard:
        return "Avançado";
    }
  }
}
