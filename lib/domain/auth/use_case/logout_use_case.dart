import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(
    this._authRepository,
  );

  Future<void> execute() async {
    await _authRepository.logout();
  }
}