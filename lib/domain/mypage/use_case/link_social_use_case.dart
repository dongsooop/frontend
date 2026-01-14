import 'package:dongsoop/core/social_auth_service.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class LinkSocialUseCase {
  final MypageRepository _mypageRepository;

  LinkSocialUseCase(this._mypageRepository,);

  Future<DateTime?> execute(LoginPlatform platform) async {
    final auth = SocialAuthService();

    final socialToken = await switch (platform) {
      LoginPlatform.kakao => await auth.kakaoLogin(),
      LoginPlatform.google => await auth.googleLogin(),
      LoginPlatform.apple => await auth.appleLogin(),
    };

    print('${platform.label} 로그인 성공 - $socialToken');
    if (socialToken == null) return null;

    // 소셜 토큰 서버로 전송
    // final createdAt = await _mypageRepository.linkSocialAccount(platform, socialToken);
    final createdAtStr = "2025-01-01 10:00:00";
    final createdAt = DateTime.parse(createdAtStr.replaceFirst(' ', 'T'));

    return createdAt;
  }
}