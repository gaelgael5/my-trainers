import 'package:injectable/injectable.dart';

import '../../../../shared/models/auth.dart';
import '../../../../shared/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<User?> getCurrentUser() async {
    try {
      // First check if we have a valid token
      final hasToken = await _localDataSource.hasValidToken();
      if (!hasToken) {
        return null;
      }

      // Try to get user from local storage first
      User? user = await _localDataSource.getUser();
      
      if (user != null) {
        return user;
      }

      // If no local user, fetch from remote
      user = await _remoteDataSource.getCurrentUser();
      
      // Save to local storage
      await _localDataSource.saveUser(user);
      
      return user;
    } catch (e) {
      // If remote fetch fails, try local data one more time
      return await _localDataSource.getUser();
    }
  }

  @override
  Future<AuthResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    
    // Perform remote login
    final response = await _remoteDataSource.login(request);
    
    // Save token and user data locally
    await _localDataSource.saveToken(response.accessToken);
    await _localDataSource.saveUser(response.user);
    
    return response;
  }

  @override
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? phone,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role == UserRole.coach ? 'coach' : 'client',
      phone: phone,
    );
    
    return await _remoteDataSource.register(request);
  }

  @override
  Future<void> logout() async {
    // Clear local storage
    await _localDataSource.deleteToken();
    await _localDataSource.deleteUser();
    
    // TODO: Notify server about logout if needed
  }

  @override
  Future<void> forgotPassword(String email) async {
    final request = ForgotPasswordRequest(email: email);
    return await _remoteDataSource.forgotPassword(request);
  }

  @override
  Future<bool> hasValidToken() async {
    return await _localDataSource.hasValidToken();
  }

  @override
  Future<AuthResponse> refreshToken() async {
    try {
      final response = await _remoteDataSource.refreshToken();
      
      // Update local storage with new token
      await _localDataSource.saveToken(response.accessToken);
      await _localDataSource.saveUser(response.user);
      
      return response;
    } catch (e) {
      // If refresh fails, clear local data
      await logout();
      throw e;
    }
  }
}