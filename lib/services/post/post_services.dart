import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  Future<void> createPost({
    required BuildContext context,
    required String caption,
    File? imageFile,
  }) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      FormData formData = FormData.fromMap({
        "caption": caption,
        if (imageFile != null)
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      await dio.post("/posts/my-posts", data: formData);
    } catch (e) {
      print("Erro ao criar post: $e");
      rethrow;
    }
  }

  Future<void> removePost(String postId) async {
    Dio dio = await DioClient.getInstance();
    try {
      final response = await dio.delete('/posts/my-posts/$postId');
    } catch (e) {
      print("Erro ao criar post: $e");
    }
  }

  Future<List<PostModel>> getGeneralPosts(context) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      final response = await dio.get('/posts/feed');

      final List data = response.data;

      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      print("Erro ao buscar posts do usuário: $e");
      return [];
    }
  }
}
