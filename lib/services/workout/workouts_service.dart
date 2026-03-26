import 'package:dio/dio.dart';
import 'package:workon_app/model/workout/workout_execution_model.dart';
import 'package:workon_app/model/workout/workout_group_model.dart';
import 'package:workon_app/services/dio_client.dart';

class WorkoutsService {
  WorkoutsService();

  Future<List<WorkoutGroup>> getFreeWorkouts({context}) async {
    Dio dio = await DioClient.getInstance(context: context);
    final response = await dio.get("/workouts/free");

    return (response.data as List)
        .map((e) => WorkoutGroup.fromJson(e))
        .toList();
  }

  Future<void> startUserWorkout(context, String workoutId) async {
    Dio dio = await DioClient.getInstance(context: context);
    await dio.post("/user-workouts/start", data: {"workoutId": workoutId});
  }

  Future<void> finishUserWorkout(
    context,
    String workoutId,
    List<WorkoutExecution> workoutExecuted,
  ) async {
    Dio dio = await DioClient.getInstance(context: context);
    await dio.post(
      "/user-workouts/finish",
      data: {
        "workout": workoutId,
        "exercises": workoutExecuted.map((e) => e.toJson()).toList(),
      },
    );
  }
}
