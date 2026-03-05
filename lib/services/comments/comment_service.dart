import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workon_app/model/post/comment_model.dart';
import 'package:workon_app/model/post/post_model.dart';
import 'package:workon_app/services/dio_client.dart';

class CommentServices {
  Future<List<CommentModel>> getComments(context, String postId) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);
      final response = await dio.get('/comments/$postId');

      final List data = response.data;

      return data.map((json) => CommentModel.fromJson(json)).toList();
    } catch (e) {
      print("Erro ao buscar posts do usuário: $e");
      return [];
    }
  }

  Future<void> createComment({
    required BuildContext context,
    required String postId,
    required String content,
  }) async {
    try {
      Dio dio = await DioClient.getInstance(context: context);

      final result = await dio.post(
        "/comments/comment/$postId",
        data: {'content': content},
      );
      print(result);
    } catch (e) {
      print("Erro ao criar post: $e");
      rethrow;
    }
  }

  Future<void> removeComment(String commentId) async {
    Dio dio = await DioClient.getInstance();
    try {
      final response = await dio.delete('/comments/$commentId');
    } catch (e) {
      print("Erro ao criar post: $e");
    }
  }
}
