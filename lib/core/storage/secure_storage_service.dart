import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _accessToken = 'accessToken';
  static const _refreshToken = 'refreshToken';

  Future<void> write(String key, String token) async {
    await _storage.write(key: key, value: token);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
  }
}

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});