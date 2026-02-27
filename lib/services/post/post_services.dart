import 'package:dio/dio.dart';
import 'package:workon_app/model/post/post_model.dart';
import 'package:workon_app/services/dio_client.dart';

class PostsServices {
  Future<List<PostModel>> getMyPosts(context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      final response = await dio.get('/posts/my-posts');

      final List data = response.data;

      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      print("Erro ao buscar posts do usuário: $e");
      return [];
    }
  }
}
