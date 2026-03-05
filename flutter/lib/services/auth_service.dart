import '../models/user.dart';
import '../models/auth_request.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Service d'authentification
class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;
  
  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;
  
  /// Connexion utilisateur
  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(email: email, password: password);
    
    final response = await _apiService.post<LoginResponse>(
      '/auth/login',
      body: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
    
    if (response.success && response.data != null) {
      // Sauvegarder les tokens et informations utilisateur
      await _storageService.saveAccessToken(response.data!.accessToken);
      await _storageService.saveRefreshToken(response.data!.refreshToken);
      await _storageService.saveUser(response.data!.user);
      await _storageService.saveTokenExpiry(response.data!.expiresAt);
    }
    
    return response;
  }
  
  /// Déconnexion utilisateur
  Future<ApiResponse<void>> logout() async {
    try {
      final token = await _storageService.getAccessToken();
      
      // Appeler l'endpoint de déconnexion
      if (token != null) {
        await _apiService.post('/auth/logout', token: token);
      }
      
      // Nettoyer le stockage local
      await _clearLocalData();
      
      return ApiResponse.success(null);
    } catch (e) {
      // Même en cas d'erreur, nettoyer les données locales
      await _clearLocalData();
      return ApiResponse.error('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }
  
  /// Rafraîchir le token d'accès
  Future<ApiResponse<String>> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) {
        return ApiResponse.error('Token de rafraîchissement non disponible');
      }
      
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
      );
      
      if (response.success && response.data != null) {
        final newAccessToken = response.data!['accessToken'] as String;
        final expiresAt = DateTime.parse(response.data!['expiresAt'] as String);
        
        await _storageService.saveAccessToken(newAccessToken);
        await _storageService.saveTokenExpiry(expiresAt);
        
        return ApiResponse.success(newAccessToken);
      }
      
      return ApiResponse.error(response.error ?? 'Erreur lors du rafraîchissement');
    } catch (e) {
      return ApiResponse.error('Erreur lors du rafraîchissement: ${e.toString()}');
    }
  }
  
  /// Mot de passe oublié
  Future<ApiResponse<void>> forgotPassword(String email) async {
    final request = ForgotPasswordRequest(email: email);
    
    final response = await _apiService.post<void>(
      '/auth/forgot-password',
      body: request.toJson(),
    );
    
    return response;
  }
  
  /// Inscription utilisateur
  Future<ApiResponse<LoginResponse>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    
    final response = await _apiService.post<LoginResponse>(
      '/auth/register',
      body: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
    
    if (response.success && response.data != null) {
      // Sauvegarder automatiquement après inscription
      await _storageService.saveAccessToken(response.data!.accessToken);
      await _storageService.saveRefreshToken(response.data!.refreshToken);
      await _storageService.saveUser(response.data!.user);
      await _storageService.saveTokenExpiry(response.data!.expiresAt);
    }
    
    return response;
  }
  
  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAccessToken();
    final expiry = await _storageService.getTokenExpiry();
    
    if (token == null || expiry == null) {
      return false;
    }
    
    // Vérifier si le token n'est pas expiré
    if (expiry.isBefore(DateTime.now())) {
      // Essayer de rafraîchir le token
      final refreshResult = await refreshToken();
      return refreshResult.success;
    }
    
    return true;
  }
  
  /// Obtenir l'utilisateur actuel
  Future<User?> getCurrentUser() async {
    return await _storageService.getUser();
  }
  
  /// Obtenir le token d'accès actuel (avec rafraîchissement automatique si nécessaire)
  Future<String?> getValidAccessToken() async {
    final token = await _storageService.getAccessToken();
    final expiry = await _storageService.getTokenExpiry();
    
    if (token == null) return null;
    
    // Si le token expire dans moins de 5 minutes, le rafraîchir
    if (expiry != null && expiry.isBefore(DateTime.now().add(Duration(minutes: 5)))) {
      final refreshResult = await refreshToken();
      if (refreshResult.success) {
        return refreshResult.data;
      }
      return null;
    }
    
    return token;
  }
  
  /// Nettoyer les données locales
  Future<void> _clearLocalData() async {
    await _storageService.clearAccessToken();
    await _storageService.clearRefreshToken();
    await _storageService.clearUser();
    await _storageService.clearTokenExpiry();
  }
}