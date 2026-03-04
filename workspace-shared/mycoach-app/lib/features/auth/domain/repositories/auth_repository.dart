import '../../../../shared/models/auth.dart';
import '../../../../shared/models/user.dart';

abstract class AuthRepository {
  /// Check if user is authenticated and return user data
  Future<User?> getCurrentUser();
  
  /// Login with email and password
  Future<AuthResponse> login(String email, String password);
  
  /// Register new user
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? phone,
  });
  
  /// Logout current user
  Future<void> logout();
  
  /// Send forgot password email
  Future<void> forgotPassword(String email);
  
  /// Check if user has valid token
  Future<bool> hasValidToken();
  
  /// Refresh authentication token
  Future<AuthResponse> refreshToken();
}