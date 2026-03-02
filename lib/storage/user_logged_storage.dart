import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLoggedStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: 'user_id');
  }
}
