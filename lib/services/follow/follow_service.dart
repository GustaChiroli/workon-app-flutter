import 'package:dio/dio.dart';
import 'package:workon_app/model/user_model.dart';
import 'package:workon_app/services/dio_client.dart';

class FollowServices {
  // Future<FollowModel?> getMe(context) async {
  //   try {
  //     Dio dio = await DioClient.getInstance(context: context);
  //     final response = await dio.get('/users/me');
  //     print("\n\n\n\nResponse getMe: ${response.data}\n\n\n\n");
  //     return FollowModel.fromJson(response.data);
  //   } catch (e) {
  //     print("Erro ao buscar dados do usuário: $e");
  //     return null;
  //   }
  // }

  // Future<UserModel?> getUserByEmail(context, String email) async {
  //   try {
  //     Dio dio = await DioClient.getInstance(context: context);
  //     final response = await dio.get('/users/user-by-email/$email');
  //     print("\n\n\n\nResponse search by email: ${response.data}\n\n\n\n");
  //     return UserModel.fromJson(response.data);
  //   } catch (e) {
  //     print("Erro ao buscar dados do usuário: $e");
  //     return null;
  //   }
  // }

  Future<Response?> createFollow(followingUserId, context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      Response response = await dio.post(
        '/follows/follow',
        data: {"followingId": followingUserId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('\n\n\naqui entriou tbm\n\n\n');
      return response;
    } catch (e) {
      print('\n\n\n\nolha deu error $e\n\n\n');
      return null;
    }
  }

  Future<Response?> deleteFollow(followingUserId, context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      Response response = await dio.delete(
        '/follows/unfollow/$followingUserId',
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
