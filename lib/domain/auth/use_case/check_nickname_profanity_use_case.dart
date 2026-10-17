import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class CheckNicknameProfanityUseCase {
  final AuthRepository _authRepository;

  CheckNicknameProfanityUseCase(this._authRepository);

  Future<bool> execute(String nickname) async {
    return await _authRepository.checkNicknameProfanity(nickname);
  }
}
