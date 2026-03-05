import 'package:flutter_test/flutter_test.dart';

// Version ultra-simplifiée pour diagnostic
void main() {
  group('Simple Validators', () {
    test('basic validation logic', () {
      // Test simple de logique d'email
      String? validateEmail(String? value) {
        if (value == null || value.isEmpty) {
          return 'Email requis';
        }
        if (!value.contains('@')) {
          return 'Email invalide';
        }
        return null;
      }
      
      expect(validateEmail('test@example.com'), null);
      expect(validateEmail(''), 'Email requis');
      expect(validateEmail('invalid'), 'Email invalide');
    });
    
    test('basic password validation', () {
      String? validatePassword(String? value) {
        if (value == null || value.isEmpty) {
          return 'Mot de passe requis';
        }
        if (value.length < 6) {
          return 'Trop court';
        }
        return null;
      }
      
      expect(validatePassword('123456'), null);
      expect(validatePassword(''), 'Mot de passe requis');
      expect(validatePassword('123'), 'Trop court');
    });
  });
}