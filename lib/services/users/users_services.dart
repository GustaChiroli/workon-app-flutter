import 'package:dio/dio.dart';
import 'package:workon_app/model/user_model.dart';
import 'package:workon_app/services/dio_client.dart';

class UsersServices {
  Future<UserModel?> getMe(context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      final response = await dio.get('/users/me');
      print("\n\n\n\nResponse getMe: ${response.data}\n\n\n\n");
      return UserModel.fromJson(response.data);
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
      return null;
    }
  }

  Future<Response?> editUser(user, context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      Response response = await dio.patch(
        '/users/me',
        data: user,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<Response?> logout(context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      Response response = await dio.post('/auth/sign-out');
      return response;
    } catch (e) {
      return null;
    }
  }
}
