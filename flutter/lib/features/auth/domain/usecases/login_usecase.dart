import 'package:injectable/injectable.dart';

import '../../../../shared/models/auth.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<AuthResponse> call({
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (email.trim().isEmpty) {
      throw Exception('L\'email est requis');
    }
    
    if (password.trim().isEmpty) {
      throw Exception('Le mot de passe est requis');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Format d\'email invalide');
    }
    
    // Attempt login
    return await _authRepository.login(email.trim(), password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}