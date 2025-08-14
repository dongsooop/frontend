import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class PasswordCheckEmailCodeUseCase {
  final AuthRepository _authRepository;

  PasswordCheckEmailCodeUseCase(this._authRepository,);

  Future<bool> execute(String userEmail, String code) async {
    return await _authRepository.passwordCheckEmailCode(userEmail, code);
  }
}
