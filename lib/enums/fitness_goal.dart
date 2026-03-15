enum FitnessGoal { buildMuscle, loseWeight, stayFit, increaseStrength }

extension FitnessGoalExtension on FitnessGoal {
  static FitnessGoal fromString(String value) {
    switch (value) {
      case "BUILD_MUSCLE":
        return FitnessGoal.buildMuscle;
      case "LOSE_WEIGHT":
        return FitnessGoal.loseWeight;
      case "STAY_FIT":
        return FitnessGoal.stayFit;
      case "INCREASE_STRENGTH":
        return FitnessGoal.increaseStrength;
      default:
        return FitnessGoal.stayFit;
    }
  }

  String toApi() {
    switch (this) {
      case FitnessGoal.buildMuscle:
        return "BUILD_MUSCLE";
      case FitnessGoal.loseWeight:
        return "LOSE_WEIGHT";
      case FitnessGoal.stayFit:
        return "STAY_FIT";
      case FitnessGoal.increaseStrength:
        return "INCREASE_STRENGTH";
    }
  }
}
