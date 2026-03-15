import 'workout_model.dart';

class WorkoutGroup {
  final String id;
  final String name;
  final String goal;
  final String difficulty;
  final int estimatedDurationMinutes;
  final List<Workout> workouts;

  WorkoutGroup({
    required this.id,
    required this.name,
    required this.goal,
    required this.difficulty,
    required this.estimatedDurationMinutes,
    required this.workouts,
  });

  factory WorkoutGroup.fromJson(Map<String, dynamic> json) {
    return WorkoutGroup(
      id: json['id'],
      name: json['name'],
      goal: json['goal'],
      difficulty: json['difficulty'],
      estimatedDurationMinutes: json['estimatedDurationMinutes'],
      workouts: (json['workouts'] as List)
          .map((e) => Workout.fromJson(e))
          .toList(),
    );
  }
}
