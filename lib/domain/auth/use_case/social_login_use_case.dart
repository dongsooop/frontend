import 'dart:io';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    final clientId = dotenv.get('GOOGLE_WEB_CLIENT_ID');

    try {
      final GoogleSignIn _signIn = GoogleSignIn.instance;
      if (Platform.isAndroid) {
        await _signIn.initialize(
          serverClientId: clientId,
        );
      }
      final GoogleSignInAccount? user = await _signIn.authenticate();
      if (user == null) return null;

      const scopes = <String>[
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ];

      final authorization = await user.authorizationClient.authorizeScopes(scopes);

      final token = authorization.accessToken;
      if (token.isEmpty) return null;

      print('구글 로그인 성공! token: $token');
      return token;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    } catch (e) {
      print('구글 로그인 실패: ${e}');
      rethrow;
    }
  }

  Future<String?> appleLogin() async {
    try {
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('애플 로그인 성공! token: ${credential.authorizationCode}');
      return credential.authorizationCode;
    }  on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return null;
      }

      // 그 외(unknown/failed 등)는 상위에서 처리
      print('애플 로그인 실패: $e');
      rethrow;
    } catch (e) {
      print('애플 로그인 실패: ${e}');
      rethrow;
    }
  }
}
