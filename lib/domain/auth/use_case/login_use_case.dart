import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/providers/secure_storage_provider.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  LoginUseCase(
    this._authRepository,
    this._secureStorage,
  );

  Future<void> execute(String email, String password) async {
    final response = await _authRepository.login(email, password);
    await _secureStorage.write('accessToken', response.accessToken);
    await _authRepository.saveUser(User(nickname: response.nickname, departmentType: response.departmentType));
  }
}