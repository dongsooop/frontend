enum LoginPlatform {
  kakao,
  google,
  apple;

  String get label {
    switch (this) {
      case LoginPlatform.kakao: return '카카오';
      case LoginPlatform.google: return '구글';
      case LoginPlatform.apple: return '애플';
    }
  }
}