import 'dart:io';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  const SocialAuthService();

  Future<String?> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        final token = await UserApi.instance.loginWithKakaoTalk();
        return token.accessToken;
      } catch (error) {
        if (_isCanceledPlatformException(error)) return null;

        // 카카오톡 실패 시 카카오계정으로 fallback
        try {
          final token = await UserApi.instance.loginWithKakaoAccount();
          return token.accessToken;
        } catch (error) {
          if (_isCanceledPlatformException(error)) return null;
          throw SocialException();
        }
      }
    } else {
      try {
        final token = await UserApi.instance.loginWithKakaoAccount();
        return token.accessToken;
      } catch (error) {
        if (_isCanceledPlatformException(error)) return null;
        throw SocialException();
      }
    }
  }

  Future<String?> googleLogin() async {
    final clientId = dotenv.get('GOOGLE_WEB_CLIENT_ID');

    try {
      final signIn = GoogleSignIn.instance;

      if (Platform.isAndroid) {
        await signIn.initialize(serverClientId: clientId);
      }

      final user = await signIn.authenticate();

      const scopes = <String>[
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ];

      final authorization = await user.authorizationClient.authorizeScopes(scopes);
      final token = authorization.accessToken;

      if (token.isEmpty) return null;
      return token;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw SocialException();
    }
  }

  Future<String?> appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final token = credential.identityToken;
      if (token == null) return null;

      return token;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      throw SocialException();
    }
  }

  Future<void> kakaoUnlink() async {
    try {
      await UserApi.instance.unlink();
    } catch (error) {
      throw SocialException();
    }
  }

  bool _isCanceledPlatformException(Object error) {
    return error is PlatformException && error.code == 'CANCELED';
  }
}