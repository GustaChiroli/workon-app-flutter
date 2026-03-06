import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workon_app/screens/login/login.dart';
import 'package:workon_app/services/dio_client.dart';
import 'package:workon_app/storage/token_storage.dart';
import 'package:workon_app/storage/user_logged_storage.dart';

class AuthService {
  final TokenStorage _tokenStorage = TokenStorage();
  final UserLoggedStorage _userLoggedStorage = UserLoggedStorage();
  final UserLoggedStorage _userIdStorage = UserLoggedStorage();
  String url = 'http://10.0.2.2:3000/';

  Future<bool> login(String email, String password) async {
    try {
      final Dio dio = await DioClient.getInstance();
      final response = await dio.post(
        '${url}auth/sign-in',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await _tokenStorage.saveToken(response.data['access_token']);
        await _userIdStorage.saveUser(response.data['user']['id']);
        await _userIdStorage.saveUserImage(response.data['user']['imageUrl']);
        var teste = await _userIdStorage.getUserImage();
        print("\n\n\nResponse login: ${teste}\n\n\n");
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
    await _userLoggedStorage.deleteUser();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}
