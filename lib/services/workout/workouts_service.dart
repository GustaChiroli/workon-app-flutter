import 'package:dio/dio.dart';
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
}
