import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(
    this._authRepository,
  );

  Future<void> execute(String email, String password) async {
    final response = await _authRepository.signIn(email, password);
    final storedUser = StoredUser(
      id: response.id,
      nickname: response.nickname,
      departmentType: response.departmentType,
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      role: response.role.first,
    );
    await _authRepository.saveUser(storedUser);
  }
}
