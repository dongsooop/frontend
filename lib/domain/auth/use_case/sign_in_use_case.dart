import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final DeviceTokenRepository _fcmRepository;

  SignInUseCase(this._authRepository, this._fcmRepository);

  Future<void> execute(
      String email,
      String password,
      ) async {
    final fcmToken = await _fcmRepository.getFcmToken();
    final tokenToSend = fcmToken ?? '';

    final response = await _authRepository.signIn(
      email,
      password,
      tokenToSend,
    );

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
