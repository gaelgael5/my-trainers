import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports des services et providers
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'providers/auth_provider.dart';

// Imports des constantes et utils
import 'constants/app_theme.dart';
import 'utils/app_router.dart';

void main() async {
  // S'assurer que les widgets sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les services
  final storageService = StorageService();
  await storageService.init();
  
  final apiService = ApiService();
  final authService = AuthService(
    apiService: apiService,
    storageService: storageService,
  );
  
  // Créer le provider d'authentification
  final authProvider = AuthProvider(authService: authService);
  
  // Initialiser l'état d'authentification
  await authProvider.initialize();
  
  runApp(MyCoachApp(
    authProvider: authProvider,
    storageService: storageService,
    apiService: apiService,
    authService: authService,
  ));
}

class MyCoachApp extends StatelessWidget {
  final AuthProvider authProvider;
  final StorageService storageService;
  final ApiService apiService;
  final AuthService authService;
  
  const MyCoachApp({
    super.key,
    required this.authProvider,
    required this.storageService,
    required this.apiService,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<StorageService>.value(value: storageService),
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        
        // Providers d'état
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        
        // Futurs providers à ajouter :
        // ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        // ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'MyCoach - Design Sobre v2',
            
            // Thème sobre v2
            theme: AppTheme.darkTheme,
            
            // Configuration du routeur
            routerConfig: AppRouter.router,
            
            // Configuration du debug
            debugShowCheckedModeBanner: false,
            
            // Builder pour gérer les redirections avec loading
            builder: (context, child) {
              return AuthRedirectWrapper(child: child ?? const SizedBox());
            },
          );
        },
      ),
    );
  }
}

/// Widget de démarrage avec écran de chargement
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Simuler un délai de chargement minimal
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      // L'initialisation se fait maintenant dans main()
      // Le router gère automatiquement la redirection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748), // AppColors.darkBackground
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animé pendant le chargement
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF6B47),
                    Color(0xFFFF8E53),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'MC',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Indicateur de chargement
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFFF6B47), // AppColors.primaryOrange
              ),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            
            // Texte de chargement
            const Text(
              'MyCoach',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chargement de votre application...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9CA3AF), // AppColors.lightGrey
              ),
            ),
          ],
        ),
      ),
    );
  }
}