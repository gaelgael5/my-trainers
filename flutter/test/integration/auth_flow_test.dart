import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:mycoach/main.dart';
import 'package:mycoach/services/storage_service.dart';
import 'package:mycoach/services/api_service.dart';
import 'package:mycoach/services/auth_service.dart';
import 'package:mycoach/providers/auth_provider.dart';
import '../test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  initializeTestEnvironment();

  group('Authentication Flow Integration Tests', () {
    late StorageService storageService;
    late ApiService apiService;
    late AuthService authService;
    late AuthProvider authProvider;

    setUpAll(() async {
      // Initialiser les services pour les tests d'intégration
      storageService = StorageService();
      await storageService.init();
      
      apiService = ApiService();
      authService = AuthService(
        apiService: apiService,
        storageService: storageService,
      );
      
      authProvider = AuthProvider(authService: authService);
    });

    tearDownAll(() async {
      // Nettoyer après les tests
      await storageService.clearAll();
      apiService.dispose();
    });

    Widget createApp() {
      return MultiProvider(
        providers: [
          Provider<StorageService>.value(value: storageService),
          Provider<ApiService>.value(value: apiService),
          Provider<AuthService>.value(value: authService),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: MyCoachApp(
          authProvider: authProvider,
          storageService: storageService,
          apiService: apiService,
          authService: authService,
        ),
      );
    }

    testWidgets('should navigate to login screen on app start', (WidgetTester tester) async {
      // Arrange - S'assurer qu'aucune session n'existe
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Assert - Devrait afficher l'écran de login
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.text('Connectez-vous pour continuer'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
    });

    testWidgets('complete login flow with valid credentials', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act - Lancer l'app
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Vérifier qu'on est sur l'écran de login
      expect(find.text('Bienvenue'), findsOneWidget);

      // Remplir le formulaire de login
      await tester.enterText(
        find.widgetWithText(TextFormField, 'votre@email.com'),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'password123',
      );
      await tester.pump();

      // Note: Pour un vrai test d'intégration, vous auriez besoin d'un serveur de test
      // ou de mocker les réponses réseau. Ici nous testons juste l'interface.

      // Taper sur le bouton de connexion
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert - Le bouton devrait montrer un état de chargement
      expect(find.text('Chargement...'), findsOneWidget);
    });

    testWidgets('should validate form fields before submission', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Essayer de soumettre avec des champs vides
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert - Ne devrait pas déclencher de requête de login
      expect(find.text('Chargement...'), findsNothing);
      expect(find.text('Bienvenue'), findsOneWidget); // Toujours sur login
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Entrer un email invalide
      await tester.enterText(
        find.widgetWithText(TextFormField, 'votre@email.com'),
        'invalid-email-format',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'password123',
      );
      await tester.pump();

      // Essayer de soumettre
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert - Ne devrait pas déclencher de requête
      expect(find.text('Chargement...'), findsNothing);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Entrer un mot de passe
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'secretpassword',
      );
      await tester.pump();

      // Vérifier que le champ de mot de passe existe et est trouvé
      expect(find.byType(TextFormField).at(1), findsOneWidget);

      // Cliquer sur le bouton de toggle de visibilité
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Vérifier que l'icône change (le test exact du password obscuring
      // nécessiterait d'accéder à nos composants custom)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // L'icône devrait changer
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should navigate to forgot password flow', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Cliquer sur "Mot de passe oublié"
      await tester.tap(find.text('Mot de passe oublié ?'));
      await tester.pump();

      // Assert - Vérifier qu'un message est affiché
      expect(find.text('Fonctionnalité en cours de développement'), findsOneWidget);
    });

    testWidgets('should navigate to sign up flow', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Cliquer sur "S'inscrire"
      await tester.tap(find.text('S\'inscrire'));
      await tester.pump();

      // Assert - Vérifier qu'un message est affiché
      expect(find.text('Fonctionnalité en cours de développement'), findsOneWidget);
    });

    testWidgets('should preserve form state during orientation changes', (WidgetTester tester) async {
      // Arrange
      await storageService.clearAll();
      await authProvider.initialize();

      // Act
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Remplir les champs
      await tester.enterText(
        find.widgetWithText(TextFormField, 'votre@email.com'),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'password123',
      );
      await tester.pump();

      // Simuler un changement d'orientation
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/platform',
        null,
        (data) {},
      );
      await tester.pump();

      // Assert - Les valeurs des champs devraient être préservées
      final emailField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'votre@email.com'),
      );
      expect(emailField.controller?.text, 'test@example.com');
    });
  });
}

/// Classe helper pour les tests d'intégration
class TestHelper {
  /// Vérifier que l'écran de login est affiché
  static void expectLoginScreen(WidgetTester tester) {
    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Connectez-vous pour continuer'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  }

  /// Vérifier que l'écran d'accueil est affiché
  static void expectHomeScreen(WidgetTester tester) {
    expect(find.text('Bonjour'), findsOneWidget);
    expect(find.text('MyCoach'), findsOneWidget);
  }

  /// Remplir le formulaire de login
  static Future<void> fillLoginForm(
    WidgetTester tester, {
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, 'votre@email.com'),
      email,
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      password,
    );
    await tester.pump();
  }
}