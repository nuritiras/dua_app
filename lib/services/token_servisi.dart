import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenServisi {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_access_token';

  Future<void> tokenKaydet(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> tokenGetir() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> tokenSil() async {
    await _storage.delete(key: _tokenKey);
  }
}