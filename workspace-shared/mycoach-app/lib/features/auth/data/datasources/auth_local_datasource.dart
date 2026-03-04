import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/models/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> deleteUser();
  Future<bool> hasValidToken();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(
    @Named('secureStorage') this._secureStorage,
    this._prefs,
  );

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> saveUser(User user) async {
    final userJson = json.encode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  @override
  Future<User?> getUser() async {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      // If parsing fails, remove corrupted data
      await deleteUser();
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await _prefs.remove(_userKey);
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    
    // TODO: Add JWT token expiration validation
    // For now, assume token exists = valid
    return true;
  }
}