import 'package:dongsoop/core/social_auth_service.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

class SocialLoginUseCase {
  final AuthRepository _authRepository;
  final DeviceTokenRepository _fcmRepository;

  SocialLoginUseCase(this._authRepository, this._fcmRepository);

  Future<void> execute(LoginPlatform platform) async {
    final fcmToken = await _fcmRepository.getFcmToken();
    final tokenToSend = fcmToken ?? '';

    final auth = SocialAuthService();

    final socialToken = await switch (platform) {
      LoginPlatform.kakao => await auth.kakaoLogin(),
      LoginPlatform.google => await auth.googleLogin(),
      LoginPlatform.apple => await auth.appleLogin(),
    };

    print('${platform.label} 로그인 성공 - $socialToken');

    if (socialToken == null) return;
    final response = await _authRepository.socialLogin(platform, socialToken, tokenToSend,);

    final storedUser = StoredUser(
      id: response.id,
      nickname: response.nickname,
      departmentType: response.departmentType,
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      role: response.role,
    );
    await _authRepository.saveUser(storedUser);
  }
}
