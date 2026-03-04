import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../../shared/models/user.dart';

@singleton
class SecureStorage {
  late final SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('SecureStorage must be initialized before use');
    }
  }

  // Token management
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _ensureInitialized();
    await Future.wait([
      _prefs.setString(AppConfig.accessTokenKey, accessToken),
      _prefs.setString(AppConfig.refreshTokenKey, refreshToken),
    ]);
  }

  Future<String?> getAccessToken() async {
    _ensureInitialized();
    return _prefs.getString(AppConfig.accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    _ensureInitialized();
    return _prefs.getString(AppConfig.refreshTokenKey);
  }

  Future<void> clearTokens() async {
    _ensureInitialized();
    await Future.wait([
      _prefs.remove(AppConfig.accessTokenKey),
      _prefs.remove(AppConfig.refreshTokenKey),
    ]);
  }

  Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  // User data management
  Future<void> storeUser(User user) async {
    _ensureInitialized();
    final userData = jsonEncode(user.toJson());
    await _prefs.setString(AppConfig.userDataKey, userData);
  }

  Future<User?> getUser() async {
    _ensureInitialized();
    final userData = _prefs.getString(AppConfig.userDataKey);
    if (userData == null) return null;
    
    try {
      final json = jsonDecode(userData) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (e) {
      debugPrint('Error parsing user data: $e');
      return null;
    }
  }

  Future<void> clearUser() async {
    _ensureInitialized();
    await _prefs.remove(AppConfig.userDataKey);
  }

  // Theme preference
  Future<void> setThemeMode(String themeMode) async {
    _ensureInitialized();
    await _prefs.setString(AppConfig.themePreferenceKey, themeMode);
  }

  Future<String?> getThemeMode() async {
    _ensureInitialized();
    return _prefs.getString(AppConfig.themePreferenceKey);
  }

  // Onboarding status
  Future<void> setOnboardingCompleted(bool completed) async {
    _ensureInitialized();
    await _prefs.setBool(AppConfig.onboardingCompletedKey, completed);
  }

  Future<bool> isOnboardingCompleted() async {
    _ensureInitialized();
    return _prefs.getBool(AppConfig.onboardingCompletedKey) ?? false;
  }

  // Generic storage methods
  Future<void> setString(String key, String value) async {
    _ensureInitialized();
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    _ensureInitialized();
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    _ensureInitialized();
    await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    _ensureInitialized();
    return _prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    _ensureInitialized();
    await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    _ensureInitialized();
    return _prefs.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    _ensureInitialized();
    await _prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    _ensureInitialized();
    return _prefs.getDouble(key);
  }

  Future<void> remove(String key) async {
    _ensureInitialized();
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    _ensureInitialized();
    await _prefs.clear();
  }

  // Complete logout - clear all user-related data
  Future<void> logout() async {
    await Future.wait([
      clearTokens(),
      clearUser(),
      remove(AppConfig.themePreferenceKey),
      // Keep onboarding status to avoid showing it again
    ]);
  }
}