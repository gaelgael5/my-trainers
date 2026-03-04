import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/models/auth.dart';
import '../../../../shared/models/user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<User> getCurrentUser();
  Future<AuthResponse> refreshToken();
  Future<void> forgotPassword(ForgotPasswordRequest request);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/auth/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponse> refreshToken() async {
    try {
      final response = await _dio.post('/api/auth/refresh');
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await _dio.post(
        '/api/auth/forgot-password',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Délai de connexion dépassé');
      case DioExceptionType.connectionError:
        return Exception('Pas de connexion internet');
      case DioExceptionType.badResponse:
        if (e.response?.data is Map<String, dynamic>) {
          final errorData = e.response!.data as Map<String, dynamic>;
          if (errorData.containsKey('message')) {
            return Exception(errorData['message']);
          }
        }
        return Exception('Erreur serveur (${e.response?.statusCode})');
      default:
        return Exception('Erreur de réseau: ${e.message}');
    }
  }
}