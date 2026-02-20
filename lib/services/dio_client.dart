import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workon_app/screens/login/login.dart';
import 'package:workon_app/utils/loading_overlay.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> _setAuthInterceptor(BuildContext? context) async {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _storage.read(key: 'access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = "Bearer $token";
          }
          // MOSTRAR LOADING
          if (context != null) {
            LoadingOverlay.show(context);
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // ESCONDER LOADING
          if (context != null) {
            LoadingOverlay.hide(context);
          }
          final requestUrl = e.requestOptions.baseUrl;
          const String baseUrl = 'http://10.0.2.2:3000';

          if (requestUrl.startsWith(baseUrl)) {
            if (e.response?.statusCode == 422) {
              Fluttertoast.showToast(
                msg: "Something went wrong...",
                backgroundColor: const Color(0xFFC03942),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                fontSize: 18.0,
                timeInSecForIosWeb: 8,
                textColor: Colors.white,
              );
            }

            if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.unknown) {
              Fluttertoast.showToast(
                msg:
                    "Connection error. Check your internet or try again later.",
                backgroundColor: const Color(0xFFC03942),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                fontSize: 18.0,
                timeInSecForIosWeb: 8,
                textColor: Colors.white,
              );
            }

            if (e.response?.statusCode == 401) {
              await _storage.delete(key: 'access_token');
              navigatorKey.currentState?.pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          }
          return handler.next(e);
        },
        onResponse: (response, handler) async {
          // ESCONDER LOADING
          if (context != null) {
            LoadingOverlay.hide(context);
          }
          final data = response.data;
          const String baseUrl = 'http://10.0.2.2:3000';

          if (data != null && data is Map<String, dynamic>) {
            // Verifica e mostra mensagem de sucesso
            if (response.requestOptions.baseUrl.startsWith(baseUrl)) {
              if (data.containsKey('detail')) {
                final detail = data['detail'];
                if (detail != null && detail is String && detail.isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: detail,
                    backgroundColor: const Color(0xFFC03942),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    fontSize: 18.0,
                    timeInSecForIosWeb: 8,
                    textColor: Colors.white,
                  );
                  if (data['detail'] == 'Invalid token') {
                    await _storage.delete(key: 'access_token');
                    navigatorKey.currentState?.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                }
              }

              if (data.containsKey('message')) {
                final message = data['message'];

                if (message != null &&
                    message is String &&
                    message.isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: message,
                    backgroundColor: const Color(0xFF39C08A),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    fontSize: 18.0,
                    timeInSecForIosWeb: 8,
                    textColor: Colors.white,
                  );
                }
              }
            }

            // redirecionamento específico
            // if (data['detail'] == 'Documents pending') {
            //   if (navigatorKey.currentState?.canPop() ?? false) {
            //     navigatorKey.currentState?.pop();
            //   }

            //   navigatorKey.currentState?.pushReplacement(
            //     MaterialPageRoute(
            //         builder: (context) => const CertificationsScreen()),
            //   );
            // } else if (data['detail'] == 'Signature pending') {
            //   if (navigatorKey.currentState?.canPop() ?? false) {
            //     navigatorKey.currentState?.pop();
            //   }

            //   navigatorKey.currentState?.pushReplacement(
            //     MaterialPageRoute(builder: (context) => const MySignatureScreen()),
            //   );
            // }
          }

          return handler.next(response);
        },
      ),
    );
  }

  static Future<Dio> getInstance({BuildContext? context}) async {
    await _setAuthInterceptor(context);
    return _dio;
  }
}
