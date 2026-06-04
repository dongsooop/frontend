import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class CheckEmailCodeUseCase {
  final AuthRepository _authRepository;

  CheckEmailCodeUseCase(
    this._authRepository,
  );

  Future<bool> execute(String userEmail, String code) async {
    return await _authRepository.checkEmailCode(userEmail, code);
  }
}
