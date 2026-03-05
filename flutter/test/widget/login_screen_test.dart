import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:mycoach/screens/login_screen.dart';
import 'package:mycoach/providers/auth_provider.dart';
import 'package:mycoach/constants/app_theme.dart';
import 'package:mycoach/widgets/custom_text_field.dart';


import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    
    // Configuration par défaut du mock
    when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);
    when(mockAuthProvider.isLoggingIn).thenReturn(false);
    when(mockAuthProvider.isAuthenticated).thenReturn(false);
    when(mockAuthProvider.hasError).thenReturn(false);
    when(mockAuthProvider.error).thenReturn(null);
  });

  Widget createLoginScreen() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('should display all required elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());

      // Assert - Vérifier la présence des éléments principaux
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.text('Connectez-vous pour continuer'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Mot de passe oublié ?'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
      expect(find.text('OU'), findsOneWidget);
      expect(find.text('Pas encore de compte ?'), findsOneWidget);
      expect(find.text('S\'inscrire'), findsOneWidget);
    });

    testWidgets('should display logo', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());

      // Assert - Vérifier la présence du logo "MC"
      expect(find.text('MC'), findsOneWidget);
    });

    testWidgets('should have email and password fields', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());

      // Assert - Vérifier la présence des champs de saisie
      expect(find.byType(CustomTextField), findsNWidgets(2));
      
      // Vérifier les placeholders
      expect(find.text('votre@email.com'), findsOneWidget);
    });

    testWidgets('should validate empty email field', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());
      
      // Tenter de soumettre le formulaire sans email
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert - Le bouton ne devrait pas être activé
      verifyNever(mockAuthProvider.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    testWidgets('should enable login button when fields are valid', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());
      
      // Remplir les champs
      await tester.enterText(
        find.widgetWithText(TextFormField, 'votre@email.com'),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1), // Champ mot de passe
        'password123',
      );
      await tester.pump();

      // Appuyer sur le bouton de connexion
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert - Le login devrait être appelé
      verify(mockAuthProvider.login(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    testWidgets('should show loading state during login', (WidgetTester tester) async {
      // Arrange - Configurer le mock pour indiquer un état de chargement
      when(mockAuthProvider.isLoggingIn).thenReturn(true);

      // Act
      await tester.pumpWidget(createLoginScreen());

      // Assert - Vérifier l'affichage du loading
      expect(find.text('Chargement...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when login fails', (WidgetTester tester) async {
      // Arrange - Configurer le mock pour indiquer une erreur
      when(mockAuthProvider.hasError).thenReturn(true);
      when(mockAuthProvider.error).thenReturn('Email ou mot de passe incorrect');

      // Act
      await tester.pumpWidget(createLoginScreen());

      // Assert - Vérifier l'affichage de l'erreur
      expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());

      // Trouver le bouton de toggle du mot de passe
      final passwordToggle = find.byIcon(Icons.visibility);
      expect(passwordToggle, findsOneWidget);

      // Cliquer pour afficher le mot de passe
      await tester.tap(passwordToggle);
      await tester.pump();

      // Assert - L'icône devrait changer
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('should handle forgot password tap', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());
      
      await tester.tap(find.text('Mot de passe oublié ?'));
      await tester.pump();

      // Assert - Vérifier qu'un SnackBar est affiché (temporairement)
      expect(find.text('Fonctionnalité en cours de développement'), findsOneWidget);
    });

    testWidgets('should handle sign up tap', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());
      
      await tester.tap(find.text('S\'inscrire'));
      await tester.pump();

      // Assert - Vérifier qu'un SnackBar est affiché (temporairement)
      expect(find.text('Fonctionnalité en cours de développement'), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());
      
      // Entrer un email invalide
      await tester.enterText(
        find.widgetWithText(TextFormField, 'votre@email.com'),
        'invalid-email',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'password123',
      );
      
      // Déclencher la validation
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      // Assert - Le login ne devrait pas être appelé avec un email invalide
      verifyNever(mockAuthProvider.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });

    testWidgets('should submit on password field enter', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginScreen());
      
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

      // Simuler l'appui sur Entrée dans le champ mot de passe
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Le login devrait être appelé
      verify(mockAuthProvider.login(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });
  });
}