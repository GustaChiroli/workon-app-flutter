import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workon_app/screens/login/login.dart';
import 'package:workon_app/services/dio_client.dart';
import 'package:workon_app/storage/token_storage.dart';

class AuthService {
  final TokenStorage _tokenStorage = TokenStorage();
  String url = 'http://10.0.2.2:3000/';

  Future<bool> login(String email, String password) async {
    try {
      final Dio dio = await DioClient.getInstance();
      final response = await dio.post(
        '${url}auth/sign-in',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print("\n\n\nResponse login: ${response.data}\n\n\n");
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await _tokenStorage.saveToken(response.data['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password, String role) async {
    try {
      final Dio dio = await DioClient.getInstance();
      final response = await dio.post(
        '${url}auth/sign-up',
        data: {'email': email, 'password': password, 'role': role},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print("\n\n\nResponse register: ${response.data}\n\n\n");
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout(context) async {
    await _tokenStorage.deleteToken();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}
