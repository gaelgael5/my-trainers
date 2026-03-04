import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _authRepository;

  ForgotPasswordUseCase(this._authRepository);

  Future<void> call({required String email}) async {
    if (email.trim().isEmpty) {
      throw Exception('L\'email est requis');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Format d\'email invalide');
    }
    
    return await _authRepository.forgotPassword(email.trim());
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}