/// Modèles pour les réponses API et gestion d'erreurs

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
  });
  
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
    );
  }
  
  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
  
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    if (json['success'] == true || json['error'] == null) {
      return ApiResponse.success(
        fromJson(json['data']),
        message: json['message'] as String?,
      );
    } else {
      return ApiResponse.error(
        json['error'] as String? ?? 'Une erreur est survenue',
        statusCode: json['statusCode'] as int?,
      );
    }
  }
}

class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final String? details;
  
  ApiError({
    required this.message,
    this.statusCode,
    this.details,
  });
  
  @override
  String toString() {
    return 'ApiError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

class ValidationError {
  final String field;
  final String message;
  
  ValidationError({
    required this.field,
    required this.message,
  });
  
  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
    );
  }
}