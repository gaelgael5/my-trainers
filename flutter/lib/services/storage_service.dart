import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service de stockage sécurisé pour les données sensibles
class StorageService {
  // Stockage sécurisé pour les données sensibles (tokens)
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  // Clés pour le stockage
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _appSettingsKey = 'app_settings';
  
  // Shared Preferences pour les données non-sensibles
  SharedPreferences? _prefs;
  
  /// Initialiser le service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // === GESTION DES TOKENS ===
  
  /// Sauvegarder le token d'accès
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }
  
  /// Récupérer le token d'accès
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }
  
  /// Supprimer le token d'accès
  Future<void> clearAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }
  
  /// Sauvegarder le token de rafraîchissement
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }
  
  /// Récupérer le token de rafraîchissement
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }
  
  /// Supprimer le token de rafraîchissement
  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }
  
  /// Sauvegarder la date d'expiration du token
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _secureStorage.write(
      key: _tokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }
  
  /// Récupérer la date d'expiration du token
  Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryString != null) {
      return DateTime.parse(expiryString);
    }
    return null;
  }
  
  /// Supprimer la date d'expiration du token
  Future<void> clearTokenExpiry() async {
    await _secureStorage.delete(key: _tokenExpiryKey);
  }
  
  // === GESTION DES DONNÉES UTILISATEUR ===
  
  /// Sauvegarder les données utilisateur
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _secureStorage.write(key: _userKey, value: userJson);
  }
  
  /// Récupérer les données utilisateur
  Future<User?> getUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
  }
  
  /// Supprimer les données utilisateur
  Future<void> clearUser() async {
    await _secureStorage.delete(key: _userKey);
  }
  
  // === GESTION DES PRÉFÉRENCES ===
  
  /// Vérifier si c'est le premier lancement
  Future<bool> isFirstLaunch() async {
    await _ensurePrefsInitialized();
    return _prefs!.getBool(_isFirstLaunchKey) ?? true;
  }
  
  /// Marquer que l'application a été lancée
  Future<void> setFirstLaunchComplete() async {
    await _ensurePrefsInitialized();
    await _prefs!.setBool(_isFirstLaunchKey, false);
  }
  
  /// Sauvegarder les paramètres de l'application
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await _ensurePrefsInitialized();
    final settingsJson = jsonEncode(settings);
    await _prefs!.setString(_appSettingsKey, settingsJson);
  }
  
  /// Récupérer les paramètres de l'application
  Future<Map<String, dynamic>?> getAppSettings() async {
    await _ensurePrefsInitialized();
    final settingsJson = _prefs!.getString(_appSettingsKey);
    if (settingsJson != null) {
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    }
    return null;
  }
  
  /// Supprimer tous les paramètres
  Future<void> clearAppSettings() async {
    await _ensurePrefsInitialized();
    await _prefs!.remove(_appSettingsKey);
  }
  
  // === UTILITAIRES ===
  
  /// Nettoyer toutes les données stockées
  Future<void> clearAll() async {
    await _ensurePrefsInitialized();
    
    // Nettoyer le stockage sécurisé
    await _secureStorage.deleteAll();
    
    // Nettoyer les préférences partagées
    await _prefs!.clear();
  }
  
  /// Vérifier l'état de la connexion (helper)
  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    final expiry = await getTokenExpiry();
    
    if (token == null || expiry == null) {
      return false;
    }
    
    return expiry.isAfter(DateTime.now());
  }
  
  /// S'assurer que SharedPreferences est initialisé
  Future<void> _ensurePrefsInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}