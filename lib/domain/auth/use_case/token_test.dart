import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class TokenTestUseCase {
  final AuthRepository _authRepository;

  TokenTestUseCase(this._authRepository,);

  Future<void> execute() async {
    await _authRepository.tokenTest();
  }
}