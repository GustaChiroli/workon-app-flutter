import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLoggedStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  Future<void> saveUserImage(String imageUrl) async {
    print('\n\n\n\n entrou\n\n\n\n\n');
    print('\n\n\n\n imageeee $imageUrl\n\n\n\n\n');
    if (imageUrl != null) {
      await _storage.write(key: 'user_image', value: imageUrl);
    }
  }

  Future<String?> getUser() async {
    return await _storage.read(key: 'user_id');
  }

  Future<String?> getUserImage() async {
    return await _storage.read(key: 'user_image');
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: 'user_id');
  }
}
