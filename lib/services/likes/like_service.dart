import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workon_app/services/dio_client.dart';

class LikeService {
  Future<String> createLike({
    required BuildContext context,
    required String postId,
  }) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      final result = await dio.post("/likes/like/$postId");

      print('\n\n\n\n AQUI ${result.data}\n\n\n\n');

      return result.data['id']; // ✅ pega o id direto
    } catch (e) {
      print("Erro ao criar like: $e");
      rethrow;
    }
  }

  Future<void> removeLike(String likeId) async {
    Dio dio = await DioClient.getInstance();
    try {
      final response = await dio.delete('/likes/$likeId');
    } catch (e) {
      print("Erro ao criar post: $e");
    }
  }
}
