import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(
    this._authRepository,
  );

  Future<void> execute(String email, String password) async {
    final response = await _authRepository.login(email, password);
    final storedUser = StoredUser(
        id: response.id,
        nickname: response.nickname,
        departmentType: response.departmentType,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken);
    await _authRepository.saveUser(storedUser);
  }
}
