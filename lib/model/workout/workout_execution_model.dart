class WorkoutExecution {
  String exerciseId;
  List<SetExecution> sets;

  WorkoutExecution({required this.exerciseId, List<SetExecution>? sets})
    : sets = sets ?? [];

  Map<String, dynamic> toJson() {
    return {
      "exerciseId": exerciseId,
      "sets": sets.map((e) => e.toJson()).toList(),
    };
  }
}

class SetExecution {
  int setNumber;
  int? reps;
  double? weight;
  int? durationSeconds;

  SetExecution({
    required this.setNumber,
    this.reps,
    this.weight,
    this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      "setNumber": setNumber,
      "reps": reps,
      "weight": weight,
      "durationSeconds": durationSeconds,
    };
  }
}
