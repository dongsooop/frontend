import 'package:dongsoop/core/social_auth_service.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class UnlinkSocialUseCase {
  final MypageRepository _mypageRepository;

  UnlinkSocialUseCase(this._mypageRepository,);

  Future<bool?> execute(LoginPlatform platform) async {
    // 소셜 로그인
    final auth = SocialAuthService();

    final socialToken = await switch (platform) {
      LoginPlatform.kakao => await auth.kakaoLogin(),
      LoginPlatform.google => await auth.googleLogin(),
      LoginPlatform.apple => await auth.appleLogin(),
    };

    print('${platform.label} 로그인 성공 - $socialToken');
    if (socialToken == null) return null;

    // 카카오의 경우 kakao SDK를 사용하여 연결 해제 진행
    await auth.kakaoUnlink();

    // 소셜 해제 진행
    final isSuccess = await _mypageRepository.unlinkSocialAccount(platform, socialToken);
    return isSuccess;
  }
}