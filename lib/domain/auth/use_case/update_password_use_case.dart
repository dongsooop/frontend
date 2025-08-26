import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository _authRepository;

  UpdatePasswordUseCase(
    this._authRepository,
  );

  Future<bool> execute(String email, String password) async {
    return await _authRepository.passwordReset(email, password);
  }
}
