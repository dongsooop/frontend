import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(
    this._authRepository,
  );

  Future<void> execute(String email, String password) async {
    final response = await _authRepository.login(email, password);
    await _authRepository.saveUser(response.nickname, response.departmentType, response.accessToken);
  }
}