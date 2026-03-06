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

  Future<UserModel?> getUserByEmail(context, String email) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      final response = await dio.get('/users/user-by-email/$email');
      print("\n\n\n\nResponse search by email: ${response.data}\n\n\n\n");
      return UserModel.fromJson(response.data);
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
      return null;
    }
  }

  Future<Response?> editUser(FormData formData, context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);

      Response response = await dio.patch(
        '/users/me',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return response;
    } catch (e) {
      print(e);
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
