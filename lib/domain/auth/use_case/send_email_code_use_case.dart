import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class SendEmailCodeUseCase {
  final AuthRepository _authRepository;

  SendEmailCodeUseCase(
    this._authRepository,
  );

  Future<bool> execute(String userEmail) async {
    return await _authRepository.sendEmailCode(userEmail);
  }
}
