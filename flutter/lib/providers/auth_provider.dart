import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

/// États d'authentification
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Provider pour la gestion de l'état d'authentification
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  
  AuthProvider({required AuthService authService}) : _authService = authService;
  
  // État actuel
  AuthState _state = AuthState.initial;
  AuthState get state => _state;
  
  // Utilisateur connecté
  User? _user;
  User? get user => _user;
  
  // Erreur actuelle
  String? _error;
  String? get error => _error;
  
  // États de loading spécifiques
  bool _isLoggingIn = false;
  bool get isLoggingIn => _isLoggingIn;
  
  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;
  
  bool _isCheckingAuth = false;
  bool get isCheckingAuth => _isCheckingAuth;
  
  // Getters de commodité
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  bool get isUnauthenticated => _state == AuthState.unauthenticated;
  bool get hasError => _state == AuthState.error && _error != null;
  bool get isLoading => _state == AuthState.loading || _isLoggingIn || _isLoggingOut || _isCheckingAuth;
  
  /// Initialiser le provider - vérifier si l'utilisateur est déjà connecté
  Future<void> initialize() async {
    _setCheckingAuth(true);
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn) {
        final currentUser = await _authService.getCurrentUser();
        if (currentUser != null) {
          _setAuthenticated(currentUser);
        } else {
          _setUnauthenticated();
        }
      } else {
        _setUnauthenticated();
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation auth: $e');
      _setUnauthenticated();
    } finally {
      _setCheckingAuth(false);
    }
  }
  
  /// Connexion
  Future<bool> login({required String email, required String password}) async {
    _setLoggingIn(true);
    _clearError();
    
    try {
      final response = await _authService.login(email: email, password: password);
      
      if (response.success && response.data != null) {
        _setAuthenticated(response.data!.user);
        return true;
      } else {
        _setError(response.error ?? 'Erreur de connexion');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de la connexion: ${e.toString()}');
      return false;
    } finally {
      _setLoggingIn(false);
    }
  }
  
  /// Déconnexion
  Future<void> logout() async {
    _setLoggingOut(true);
    
    try {
      await _authService.logout();
      _setUnauthenticated();
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
      // Même en cas d'erreur, on considère l'utilisateur comme déconnecté
      _setUnauthenticated();
    } finally {
      _setLoggingOut(false);
    }
  }
  
  /// Inscription
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _setLoggingIn(true);
    _clearError();
    
    try {
      final response = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      if (response.success && response.data != null) {
        _setAuthenticated(response.data!.user);
        return true;
      } else {
        _setError(response.error ?? 'Erreur lors de l\'inscription');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de l\'inscription: ${e.toString()}');
      return false;
    } finally {
      _setLoggingIn(false);
    }
  }
  
  /// Mot de passe oublié
  Future<bool> forgotPassword({required String email}) async {
    _clearError();
    
    try {
      final response = await _authService.forgotPassword(email);
      
      if (response.success) {
        return true;
      } else {
        _setError(response.error ?? 'Erreur lors de l\'envoi');
        return false;
      }
    } catch (e) {
      _setError('Erreur: ${e.toString()}');
      return false;
    }
  }
  
  /// Rafraîchir les données utilisateur
  Future<void> refreshUser() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        _user = currentUser;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur lors du rafraîchissement utilisateur: $e');
    }
  }
  
  /// Obtenir un token d'accès valide
  Future<String?> getValidAccessToken() async {
    return await _authService.getValidAccessToken();
  }
  
  // === MÉTHODES PRIVÉES POUR GÉRER L'ÉTAT ===
  
  void _setAuthenticated(User user) {
    _user = user;
    _state = AuthState.authenticated;
    _error = null;
    notifyListeners();
  }
  
  void _setUnauthenticated() {
    _user = null;
    _state = AuthState.unauthenticated;
    _error = null;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    _state = AuthState.error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    if (_state == AuthState.error) {
      _state = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    }
    notifyListeners();
  }
  
  void _setLoggingIn(bool loading) {
    _isLoggingIn = loading;
    if (loading) {
      _state = AuthState.loading;
    }
    notifyListeners();
  }
  
  void _setLoggingOut(bool loading) {
    _isLoggingOut = loading;
    notifyListeners();
  }
  
  void _setCheckingAuth(bool checking) {
    _isCheckingAuth = checking;
    if (checking) {
      _state = AuthState.loading;
    }
    notifyListeners();
  }
}