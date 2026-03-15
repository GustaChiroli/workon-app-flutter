import 'workout_exercise_model.dart';

class Workout {
  final String id;
  final String? description;
  final String name;
  final int order;
  final List<WorkoutExercise> exercises;

  Workout({
    required this.id,
    this.description,
    required this.name,
    required this.order,
    required this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      order: json['order'],
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e))
          .toList(),
    );
  }
}
