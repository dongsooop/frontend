import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';

class SocialLoginUseCase {
  final AuthRepository _authRepository;
  final DeviceTokenRepository _fcmRepository;

  SocialLoginUseCase(this._authRepository, this._fcmRepository);

  Future<void> execute(LoginPlatform platform) async {
    final fcmToken = await _fcmRepository.getFcmToken();
    final tokenToSend = fcmToken ?? '';

    final socialToken = await switch (platform) {
      LoginPlatform.kakao => kakaoLogin(),
      LoginPlatform.google => googleLogin(),
      LoginPlatform.apple => appleLogin(),
    };

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

  Future<String?> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공! token: ${token.accessToken}');
        return token.accessToken;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공! token: ${token.accessToken}');
          return token.accessToken;
        } catch (error) {
          if (error is PlatformException && error.code == 'CANCELED') {
            return null;
          }
          print('카카오계정으로 로그인 실패 $error');
          rethrow;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공! token: ${token.accessToken}');
        return token.accessToken;
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        print('카카오계정으로 로그인 실패 $error');
        rethrow;
      }
    }
  }

  Future<String?> googleLogin() async {
    // 코드 작성 필요
    return null;
  }

  Future<String?> appleLogin() async {
    // 코드 작성 필요
    return null;
  }
}
