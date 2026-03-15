import 'exercise_model.dart';

class WorkoutExercise {
  final int? sets;
  final int? reps;
  final int? durationSeconds;
  final int? restSeconds;
  final Exercise exercise;

  WorkoutExercise({
    this.sets,
    this.reps,
    this.durationSeconds,
    this.restSeconds,
    required this.exercise,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      sets: json['sets'],
      reps: json['reps'],
      durationSeconds: json['durationSeconds'],
      restSeconds: json['restSeconds'],
      exercise: Exercise.fromJson(json['exercise']),
    );
  }
}
