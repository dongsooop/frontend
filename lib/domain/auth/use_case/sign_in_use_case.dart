import 'package:dongsoop/core/utils/device_type_util.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/fcm_token/repository/fcm_token_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final FcmTokenRepository _fcmRepository;

  SignInUseCase(this._authRepository, this._fcmRepository);

  Future<void> execute(
      String email,
      String password,
      ) async {
    final fcmToken = await _fcmRepository.getFcmToken();
    final tokenToSend = fcmToken ?? '';

    final type = deviceType();

    final response = await _authRepository.signIn(
      email,
      password,
      tokenToSend,
      type,
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
