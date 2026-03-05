import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../providers/auth_provider.dart';

/// Configuration du routeur de l'application
class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  
  static GoRouter get router => _router;
  
  static final GoRouter _router = GoRouter(
    initialLocation: login,
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isCheckingAuth = authProvider.isCheckingAuth;
      
      // Si on vérifie l'authentification, ne pas rediriger
      if (isCheckingAuth) return null;
      
      // Si on est sur la page de login et qu'on est connecté, aller à l'accueil
      if (state.fullPath == login && isAuthenticated) {
        return home;
      }
      
      // Si on n'est pas sur la page de login et qu'on n'est pas connecté, aller au login
      if (state.fullPath != login && !isAuthenticated) {
        return login;
      }
      
      // Sinon, laisser passer
      return null;
    },
    refreshListenable: Listenable.merge([
      // Le router écoute les changements du provider d'authentification
      // pour rediriger automatiquement selon l'état de connexion
    ]),
    routes: [
      // Route de connexion
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Route d'inscription
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Route de mot de passe oublié
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // Route d'accueil (protégée)
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      
      // Routes futures pour l'extension de l'app
      // GoRoute(
      //   path: '/profile',
      //   name: 'profile',
      //   builder: (context, state) => const ProfileScreen(),
      // ),
      // 
      // GoRoute(
      //   path: '/workouts',
      //   name: 'workouts',
      //   builder: (context, state) => const WorkoutsScreen(),
      // ),
      // 
      // GoRoute(
      //   path: '/progress',
      //   name: 'progress',
      //   builder: (context, state) => const ProgressScreen(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF2D3748), // AppColors.darkBackground
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFFF6B47), // AppColors.primaryOrange
            ),
            const SizedBox(height: 16),
            const Text(
              'Page non trouvée',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La page "${state.fullPath}" n\'existe pas.',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF9CA3AF), // AppColors.lightGrey
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B47),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Extension sur BuildContext pour faciliter la navigation
extension GoRouterExtension on BuildContext {
  /// Naviguer vers l'écran de connexion
  void goToLogin() => go(AppRouter.login);
  
  /// Naviguer vers l'écran d'inscription
  void goToRegister() => go(AppRouter.register);
  
  /// Naviguer vers l'écran de mot de passe oublié
  void goToForgotPassword() => go(AppRouter.forgotPassword);
  
  /// Naviguer vers l'accueil
  void goToHome() => go(AppRouter.home);
  
  /// Naviguer vers le profil (futur)
  // void goToProfile() => go('/profile');
  
  /// Naviguer vers les entraînements (futur)
  // void goToWorkouts() => go('/workouts');
  
  /// Naviguer vers les progrès (futur)
  // void goToProgress() => go('/progress');
}

/// Wrapper pour la gestion des redirections avec loading
class AuthRedirectWrapper extends StatelessWidget {
  final Widget child;
  
  const AuthRedirectWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Afficher un écran de chargement pendant la vérification d'auth
        if (authProvider.isCheckingAuth) {
          return const Scaffold(
            backgroundColor: Color(0xFF2D3748), // AppColors.darkBackground
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF6B47), // AppColors.primaryOrange
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chargement...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        return child;
      },
    );
  }
}