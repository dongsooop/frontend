import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class PasswordSendEmailCodeUseCase {
  final AuthRepository _authRepository;

  PasswordSendEmailCodeUseCase(this._authRepository,);

  Future<bool> execute(String userEmail) async {
    return await _authRepository.passwordSendEmailCode(userEmail);
  }
}
