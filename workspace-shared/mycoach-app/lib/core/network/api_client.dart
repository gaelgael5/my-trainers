import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';

@singleton
class ApiClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;

  ApiClient(this._secureStorage) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor for adding auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.getAccessToken();
        if (token != null) {
          options.headers['X-API-Key'] = token;
        }
        
        // Log request in debug mode
        // print('🚀 ${options.method} ${options.uri}');
        // if (options.data != null) {
        //   print('📤 Request Body: ${options.data}');
        // }
        
        handler.next(options);
      },
      
      onResponse: (response, handler) {
        // print('✅ ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      
      onError: (error, handler) async {
        // print('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
        // print('Error: ${error.message}');
        
        // Handle token refresh for 401 errors
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the original request
            final clonedRequest = await _dio.request(
              error.requestOptions.path,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              ),
            );
            return handler.resolve(clonedRequest);
          } else {
            // Token refresh failed, redirect to login
            await _secureStorage.clearTokens();
            // TODO: Navigate to login screen
          }
        }
        
        handler.next(error);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _secureStorage.storeTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      }
    } catch (e) {
      // print('Token refresh failed: $e');
    }
    return false;
  }

  // Auth endpoints
  Future<Response> login(String email, String password) {
    return _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(String email, String password, String role, {
    String? firstName,
    String? lastName,
  }) {
    return _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
    });
  }

  Future<Response> getCurrentUser() {
    return _dio.get('/auth/me');
  }

  Future<Response> logout() {
    return _dio.post('/auth/logout');
  }

  // Coach endpoints
  Future<Response> getCoachDashboard() {
    return _dio.get('/coach/dashboard');
  }

  Future<Response> getCoachClients() {
    return _dio.get('/coach/clients');
  }

  Future<Response> getCoachPrograms() {
    return _dio.get('/coach/programs');
  }

  Future<Response> getCoachSessions({DateTime? date}) {
    final params = date != null 
        ? {'date': date.toIso8601String().split('T')[0]}
        : null;
    return _dio.get('/coach/sessions', queryParameters: params);
  }

  // Client endpoints
  Future<Response> getClientDashboard() {
    return _dio.get('/client/dashboard');
  }

  Future<Response> searchCoaches({
    String? query,
    String? speciality,
    String? location,
  }) {
    return _dio.get('/client/coaches/search', queryParameters: {
      if (query != null) 'q': query,
      if (speciality != null) 'speciality': speciality,
      if (location != null) 'location': location,
    });
  }

  Future<Response> getClientBookings() {
    return _dio.get('/client/bookings');
  }

  // Chat endpoints
  Future<Response> getConversations() {
    return _dio.get('/chat/conversations');
  }

  Future<Response> getConversationMessages(String conversationId) {
    return _dio.get('/chat/conversations/$conversationId/messages');
  }

  Future<Response> sendMessage(String conversationId, String content) {
    return _dio.post('/chat/conversations/$conversationId/messages', data: {
      'content': content,
    });
  }

  // Generic HTTP methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}