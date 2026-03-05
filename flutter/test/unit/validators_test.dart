import 'package:flutter_test/flutter_test.dart';
import 'package:mycoach/utils/validators.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    initializeTestEnvironment();
  });
  group('Validators', () {
    group('email', () {
      test('should return null for valid emails', () {
        expect(Validators.email('test@example.com'), null);
        expect(Validators.email('user.name@domain.co.uk'), null);
        expect(Validators.email('user+label@example.org'), null);
        expect(Validators.email('123@456.com'), null);
      });

      test('should return error for invalid emails', () {
        expect(Validators.email(''), isNotNull);
        expect(Validators.email(null), isNotNull);
        expect(Validators.email('test'), isNotNull);
        expect(Validators.email('test@'), isNotNull);
        expect(Validators.email('@example.com'), isNotNull);
        expect(Validators.email('test..test@example.com'), isNotNull);
        expect(Validators.email('test@.com'), isNotNull);
      });

      test('should return appropriate error messages', () {
        expect(Validators.email(''), 'L\'email est requis');
        expect(Validators.email(null), 'L\'email est requis');
        expect(Validators.email('invalid'), 'Format d\'email invalide');
      });
    });

    group('password', () {
      test('should return null for valid passwords', () {
        expect(Validators.password('123456'), null);
        expect(Validators.password('password'), null);
        expect(Validators.password('very_long_password'), null);
      });

      test('should return error for invalid passwords', () {
        expect(Validators.password(''), isNotNull);
        expect(Validators.password(null), isNotNull);
        expect(Validators.password('12345'), isNotNull);
        expect(Validators.password('short'), isNotNull);
      });

      test('should return appropriate error messages', () {
        expect(Validators.password(''), 'Le mot de passe est requis');
        expect(Validators.password(null), 'Le mot de passe est requis');
        expect(Validators.password('12345'), 'Le mot de passe doit contenir au moins 6 caractères');
      });
    });

    group('strongPassword', () {
      test('should return null for strong passwords', () {
        expect(Validators.strongPassword('Password123'), null);
        expect(Validators.strongPassword('MyStrongPass1'), null);
        expect(Validators.strongPassword('ComplexP@ss1'), null);
      });

      test('should return error for weak passwords', () {
        expect(Validators.strongPassword('password'), isNotNull);
        expect(Validators.strongPassword('PASSWORD'), isNotNull);
        expect(Validators.strongPassword('password123'), isNotNull);
        expect(Validators.strongPassword('Password'), isNotNull);
        expect(Validators.strongPassword('Pass123'), isNotNull);
      });

      test('should return appropriate error messages', () {
        expect(Validators.strongPassword(''), 'Le mot de passe est requis');
        expect(Validators.strongPassword('short'), 'Le mot de passe doit contenir au moins 8 caractères');
        expect(Validators.strongPassword('password123'), 'Le mot de passe doit contenir au moins une lettre majuscule');
        expect(Validators.strongPassword('PASSWORD123'), 'Le mot de passe doit contenir au moins une lettre minuscule');
        expect(Validators.strongPassword('Password'), 'Le mot de passe doit contenir au moins un chiffre');
      });
    });

    group('confirmPassword', () {
      test('should return null when passwords match', () {
        expect(Validators.confirmPassword('password123', 'password123'), null);
        expect(Validators.confirmPassword('ComplexPass1', 'ComplexPass1'), null);
      });

      test('should return error when passwords do not match', () {
        expect(Validators.confirmPassword('password1', 'password2'), isNotNull);
        expect(Validators.confirmPassword('', 'password'), isNotNull);
        expect(Validators.confirmPassword(null, 'password'), isNotNull);
      });

      test('should return appropriate error messages', () {
        expect(Validators.confirmPassword('', 'password'), 'La confirmation du mot de passe est requise');
        expect(Validators.confirmPassword(null, 'password'), 'La confirmation du mot de passe est requise');
        expect(Validators.confirmPassword('password1', 'password2'), 'Les mots de passe ne correspondent pas');
      });
    });

    group('name', () {
      test('should return null for valid names', () {
        expect(Validators.name('John'), null);
        expect(Validators.name('Marie-Claire'), null);
        expect(Validators.name('Jean-Baptiste'), null);
        expect(Validators.name('O\'Connor'), null);
      });

      test('should return error for invalid names', () {
        expect(Validators.name(''), isNotNull);
        expect(Validators.name(null), isNotNull);
        expect(Validators.name('J'), isNotNull);
        expect(Validators.name('A' * 51), isNotNull);
      });

      test('should return appropriate error messages', () {
        expect(Validators.name(''), 'Ce champ est requis');
        expect(Validators.name(null), 'Ce champ est requis');
        expect(Validators.name('J'), 'Le nom doit contenir au moins 2 caractères');
        expect(Validators.name('A' * 51), 'Le nom ne peut pas dépasser 50 caractères');
      });
    });

    group('phone', () {
      test('should return null for valid French phone numbers', () {
        expect(Validators.phone('0123456789'), null);
        expect(Validators.phone('01 23 45 67 89'), null);
        expect(Validators.phone('01-23-45-67-89'), null);
        expect(Validators.phone('01.23.45.67.89'), null);
        expect(Validators.phone('+33123456789'), null);
        expect(Validators.phone('+33 1 23 45 67 89'), null);
      });

      test('should return error for invalid phone numbers', () {
        expect(Validators.phone(''), isNotNull);
        expect(Validators.phone(null), isNotNull);
        expect(Validators.phone('123'), isNotNull);
        expect(Validators.phone('0023456789'), isNotNull);
        expect(Validators.phone('1234567890'), isNotNull);
      });

      test('should return appropriate error messages', () {
        expect(Validators.phone(''), 'Le numéro de téléphone est requis');
        expect(Validators.phone(null), 'Le numéro de téléphone est requis');
        expect(Validators.phone('123'), 'Format de téléphone invalide');
      });
    });

    group('required', () {
      test('should return null for non-empty values', () {
        expect(Validators.required('test'), null);
        expect(Validators.required('123'), null);
        expect(Validators.required(' '), null); // Spaces count as non-empty
      });

      test('should return error for empty values', () {
        expect(Validators.required(''), isNotNull);
        expect(Validators.required(null), isNotNull);
      });

      test('should use custom field name', () {
        expect(Validators.required('', 'Email'), 'Email est requis');
        expect(Validators.required(null, 'Nom'), 'Nom est requis');
      });
    });

    group('minLength', () {
      test('should return null for strings meeting minimum length', () {
        final validator = Validators.minLength(5);
        expect(validator('12345'), null);
        expect(validator('longer string'), null);
      });

      test('should return error for strings shorter than minimum', () {
        final validator = Validators.minLength(5);
        expect(validator('1234'), isNotNull);
        expect(validator(''), isNotNull);
        expect(validator(null), isNotNull);
      });

      test('should use custom field name', () {
        final validator = Validators.minLength(5, 'Mot de passe');
        expect(validator('1234'), 'Mot de passe doit contenir au moins 5 caractères');
      });
    });

    group('maxLength', () {
      test('should return null for strings within maximum length', () {
        final validator = Validators.maxLength(10);
        expect(validator('12345'), null);
        expect(validator('1234567890'), null);
        expect(validator(''), null);
        expect(validator(null), null);
      });

      test('should return error for strings exceeding maximum', () {
        final validator = Validators.maxLength(10);
        expect(validator('12345678901'), isNotNull);
      });

      test('should use custom field name', () {
        final validator = Validators.maxLength(10, 'Commentaire');
        expect(validator('12345678901'), 'Commentaire ne peut pas dépasser 10 caractères');
      });
    });

    group('combine', () {
      test('should return first error from multiple validators', () {
        final validator = Validators.combine([
          Validators.required,
          Validators.minLength(5),
          Validators.email,
        ]);

        expect(validator(''), 'Ce champ est requis');
        expect(validator('1234'), 'Ce champ doit contenir au moins 5 caractères');
        expect(validator('12345'), 'Format d\'email invalide');
        expect(validator('test@example.com'), null);
      });

      test('should return null if all validators pass', () {
        final validator = Validators.combine([
          Validators.required,
          Validators.minLength(5),
        ]);

        expect(validator('valid input'), null);
      });
    });
  });
}