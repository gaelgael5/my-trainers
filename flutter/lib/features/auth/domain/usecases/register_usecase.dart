import 'package:injectable/injectable.dart';

import '../../../../shared/models/auth.dart';
import '../../../../shared/models/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<RegisterResponse> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? phone,
  }) async {
    // Validate inputs
    _validateInputs(email, password, firstName, lastName);
    
    // Attempt registration
    return await _authRepository.register(
      email: email.trim(),
      password: password,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      role: role,
      phone: phone?.trim(),
    );
  }

  void _validateInputs(String email, String password, String firstName, String lastName) {
    if (email.trim().isEmpty) {
      throw Exception('L\'email est requis');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Format d\'email invalide');
    }
    
    if (password.trim().isEmpty) {
      throw Exception('Le mot de passe est requis');
    }
    
    if (password.length < 8) {
      throw Exception('Le mot de passe doit contenir au moins 8 caractères');
    }
    
    if (firstName.trim().isEmpty) {
      throw Exception('Le prénom est requis');
    }
    
    if (lastName.trim().isEmpty) {
      throw Exception('Le nom de famille est requis');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}