import 'package:injectable/injectable.dart';

import '../../../../shared/models/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class CheckAuthStatusUseCase {
  final AuthRepository _authRepository;

  CheckAuthStatusUseCase(this._authRepository);

  Future<User?> call() async {
    try {
      // Check if we have a valid token first
      final hasToken = await _authRepository.hasValidToken();
      if (!hasToken) {
        return null;
      }
      
      // Get current user data
      return await _authRepository.getCurrentUser();
    } catch (e) {
      // If any error occurs (token expired, network issue, etc.), consider as unauthenticated
      return null;
    }
  }
}