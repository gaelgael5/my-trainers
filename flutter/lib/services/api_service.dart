import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

/// Service de base pour les appels API
class ApiService {
  static const String baseUrl = 'https://your-api-endpoint.com/api';
  static const Duration timeoutDuration = Duration(seconds: 30);
  
  final http.Client _client = http.Client();
  
  /// Headers par défaut
  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  /// Headers avec authentification
  Map<String, String> _authHeaders(String? token) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
  
  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .get(uri, headers: _authHeaders(token))
          .timeout(timeoutDuration);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .post(
            uri,
            headers: _authHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .put(
            uri,
            headers: _authHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .delete(uri, headers: _authHeaders(token))
          .timeout(timeoutDuration);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// Traitement des réponses HTTP
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (fromJson != null && jsonData['data'] != null) {
          final data = fromJson(jsonData['data']);
          return ApiResponse.success(data, message: jsonData['message']);
        } else {
          return ApiResponse.success(jsonData as T);
        }
      } else {
        return ApiResponse.error(
          jsonData['error'] ?? jsonData['message'] ?? 'Erreur inconnue',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Erreur lors du traitement de la réponse: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }
  
  /// Gestion des erreurs
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is SocketException) {
      return ApiResponse.error(
        'Pas de connexion internet. Vérifiez votre réseau.',
      );
    } else if (error is HttpException) {
      return ApiResponse.error('Erreur de connexion au serveur.');
    } else {
      return ApiResponse.error(
        'Une erreur inattendue est survenue: ${error.toString()}',
      );
    }
  }
  
  /// Libération des ressources
  void dispose() {
    _client.close();
  }
}