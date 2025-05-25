import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';
  static const _memberId = 'member_id';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveMemberId(String memberId) async {
    await _storage.write(key: _memberId, value: memberId);
  }

  Future<String?> readMemberId() async {
    return await _storage.read(key: _memberId);
  }

  Future<void> deleteMemberId() async {
    await _storage.delete(key: _memberId);
  }
}
