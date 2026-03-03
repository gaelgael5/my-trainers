import 'package:flutter/foundation.dart';

class AppConfig {
  // API Configuration
  static const String _devApiBaseUrl = 'http://localhost:8000/api';
  static const String _prodApiBaseUrl = 'https://api.mycoach.com/api';
  
  static String get apiBaseUrl {
    if (kDebugMode) {
      return _devApiBaseUrl;
    }
    return _prodApiBaseUrl;
  }
  
  // App Configuration
  static const String appName = 'MyCoach';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(minutes: 5);
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themePreferenceKey = 'theme_preference';
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
  static const List<String> allowedVideoTypes = [
    'mp4', 'mov', 'avi', 'mkv'
  ];
  
  // Features Flags
  static const bool enableGoogleSignIn = true;
  static const bool enableAppleSignIn = true;
  static const bool enablePushNotifications = true;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = false; // GDPR compliance
  
  // Theme Configuration
  static const bool enableDynamicTheme = true; // Coach/Client auto-switching
  static const bool enableSystemTheme = false; // System dark/light mode
  
  // Development flags
  static const bool enableApiLogs = kDebugMode;
  static const bool enablePerformanceLogs = kDebugMode;
  static const bool enableMockData = false; // Use for offline development
}