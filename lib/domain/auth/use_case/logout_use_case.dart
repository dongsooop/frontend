import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/providers/secure_storage_provider.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  LogoutUseCase(
    this._authRepository,
    this._secureStorage,
  );

  Future<void> execute() async {
    await _authRepository.clearUser();
    await _secureStorage.delete("accessToken");
  }
}