class EclassException implements Exception {
  final String message;

  const EclassException([
    this.message = 'Eclass 처리 중 오류가 발생했어요. 잠시 후 다시 시도해 주세요.',
  ]);

  @override
  String toString() => message;
}

class EclassInvalidCredentialsException extends EclassException {
  const EclassInvalidCredentialsException([
    super.message = 'Eclass 아이디 또는 비밀번호를 확인해 주세요.',
  ]);
}

class EclassTokenException extends EclassException {
  const EclassTokenException([
    super.message = 'Eclass 로그인에 실패했어요. 잠시 후 다시 시도해 주세요.',
  ]);
}

class EclassDeviceIdentityException extends EclassException {
  const EclassDeviceIdentityException([
    super.message = '기기 정보를 확인할 수 없어요. 잠시 후 다시 시도해 주세요.',
  ]);
}

class EclassLinkException extends EclassException {
  const EclassLinkException([
    super.message = 'Eclass 연동에 실패했어요. 잠시 후 다시 시도해 주세요.',
  ]);
}

class EclassMalformedResponseException extends EclassException {
  const EclassMalformedResponseException([
    super.message = 'Eclass 응답을 처리할 수 없어요. 잠시 후 다시 시도해 주세요.',
  ]);
}
