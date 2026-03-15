enum MuscleGroup {
  chest,
  back,
  legs,
  shoulders,
  biceps,
  triceps,
  core,
  fullBody,
  cardio,
}

extension MuscleGroupExtension on MuscleGroup {
  static MuscleGroup fromString(String value) {
    switch (value) {
      case "CHEST":
        return MuscleGroup.chest;
      case "BACK":
        return MuscleGroup.back;
      case "LEGS":
        return MuscleGroup.legs;
      case "SHOULDERS":
        return MuscleGroup.shoulders;
      case "BICEPS":
        return MuscleGroup.biceps;
      case "TRICEPS":
        return MuscleGroup.triceps;
      case "CORE":
        return MuscleGroup.core;
      case "FULL_BODY":
        return MuscleGroup.fullBody;
      case "CARDIO":
        return MuscleGroup.cardio;
      default:
        return MuscleGroup.fullBody;
    }
  }
}
