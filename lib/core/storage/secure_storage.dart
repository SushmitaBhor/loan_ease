import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyLoggedIn = 'is_logged_in';

  static Future<void> setLoggedIn(bool value) async {
    await _storage.write(key: _keyLoggedIn, value: value.toString());
  }

  static Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _keyLoggedIn);
    return value == 'true';
  }

  static Future<void> clear() async {
    await _storage.delete(key: _keyLoggedIn);
  }
}
