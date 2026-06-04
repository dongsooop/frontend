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

    if (socialToken == null) return null;

    final createdAt = await _mypageRepository.linkSocialAccount(platform, socialToken);

    return createdAt;
  }
}