import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  Dio get dio {
    final dio = Dio();
    
    // Configure base URL for development
    dio.options.baseUrl = 'http://localhost:8000'; // Dev backend URL
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Add interceptors for auth token
    dio.interceptors.add(AuthInterceptor());
    
    return dio;
  }

  @Named('secureStorage')
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}

// Auth interceptor to add Bearer token to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token if available
    try {
      final secureStorage = getIt<FlutterSecureStorage>();
      final token = await secureStorage.read(key: 'auth_token');
      
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Continue without token if there's an error
    }
    
    // Add content type
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // Clear stored token and redirect to login
      _handleTokenExpired();
    }
    
    super.onError(err, handler);
  }

  void _handleTokenExpired() async {
    try {
      final secureStorage = getIt<FlutterSecureStorage>();
      await secureStorage.delete(key: 'auth_token');
      
      final prefs = getIt<SharedPreferences>();
      await prefs.remove('user_data');
    } catch (e) {
      // Ignore errors during cleanup
    }
  }
}