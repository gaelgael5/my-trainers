/// Constantes globales de l'application MyCoach
class AppConstants {
  // Informations de l'application
  static const String appName = 'MyCoach';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Votre application de coaching sportif';
  
  // Design sobre v2
  static const String designVersion = 'Sobre v2';
  static const String logoText = 'MC';
  
  // API Configuration
  static const String apiBaseUrl = 'https://your-api-endpoint.com/api';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String storagePrefix = 'mycoach_';
  static const String firstLaunchKey = '${storagePrefix}first_launch';
  static const String themeKey = '${storagePrefix}theme';
  
  // Navigation
  static const String loginRoute = '/login';
  static const String homeRoute = '/';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 255;
  
  // UI Timings
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);
  
  // Error Messages
  static const String networkError = 'Vérifiez votre connexion internet';
  static const String serverError = 'Erreur du serveur, veuillez réessayer';
  static const String unknownError = 'Une erreur inattendue s\'est produite';
  static const String timeoutError = 'Délai d\'attente dépassé';
  
  // Success Messages
  static const String loginSuccess = 'Connexion réussie';
  static const String logoutSuccess = 'Déconnexion réussie';
  static const String passwordResetSent = 'Email de réinitialisation envoyé';
  
  // Form Labels (pour la cohérence)
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Mot de passe';
  static const String firstNameLabel = 'Prénom';
  static const String lastNameLabel = 'Nom';
  static const String phoneLabel = 'Téléphone';
  
  // Placeholders
  static const String emailPlaceholder = 'votre@email.com';
  static const String phonePlaceholder = '06 12 34 56 78';
  
  // Button Labels
  static const String loginButton = 'Se connecter';
  static const String signUpButton = 'S\'inscrire';
  static const String forgotPasswordButton = 'Mot de passe oublié ?';
  static const String confirmButton = 'Confirmer';
  static const String cancelButton = 'Annuler';
  static const String continueButton = 'Continuer';
  
  // Features Flags (pour le développement progressif)
  static const bool enableBiometrics = false;
  static const bool enablePushNotifications = false;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  
  // Debug
  static const bool isDebugMode = true; // À désactiver en production
  static const bool showDebugLogs = true;
  
  /// Vérifier si on est en mode debug
  static bool get isDebugging => isDebugMode;
  
  /// URL complète pour un endpoint
  static String apiUrl(String endpoint) => '$apiBaseUrl$endpoint';
  
  /// Clé de stockage avec préfixe
  static String storageKey(String key) => '$storagePrefix$key';
}

/// Constantes pour les analytics et le tracking
class AnalyticsConstants {
  // Events
  static const String loginAttempt = 'login_attempt';
  static const String loginSuccess = 'login_success';
  static const String loginFailure = 'login_failure';
  static const String signUpAttempt = 'signup_attempt';
  static const String signUpSuccess = 'signup_success';
  static const String logoutAction = 'logout';
  static const String forgotPassword = 'forgot_password';
  
  // Screen Names
  static const String loginScreen = 'login_screen';
  static const String homeScreen = 'home_screen';
  static const String profileScreen = 'profile_screen';
  
  // User Properties
  static const String userRole = 'user_role';
  static const String subscriptionStatus = 'subscription_status';
  static const String registrationDate = 'registration_date';
}