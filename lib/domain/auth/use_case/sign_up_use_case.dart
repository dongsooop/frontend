import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(
    this._authRepository,
  );

  Future<void> execute(SignUpRequest request) async {
    await _authRepository.signUp(request);
  }
}
