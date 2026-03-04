import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> call() async {
    return await _authRepository.logout();
  }
}