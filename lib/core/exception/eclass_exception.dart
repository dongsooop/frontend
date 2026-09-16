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

class EclassAssignmentException extends EclassException {
  const EclassAssignmentException([
    super.message = 'Eclass 과제를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
  ]);
}

class EclassSyncException extends EclassException {
  const EclassSyncException([
    super.message = 'Eclass 과제를 동기화하지 못했어요. 잠시 후 다시 시도해 주세요.',
  ]);
}

class EclassNotLinkedException extends EclassException {
  const EclassNotLinkedException([
    super.message = 'Eclass 연동 정보가 없어요. 먼저 Eclass를 연동해 주세요.',
  ]);
}

class EclassMalformedResponseException extends EclassException {
  const EclassMalformedResponseException([
    super.message = 'Eclass 응답을 처리할 수 없어요. 잠시 후 다시 시도해 주세요.',
  ]);
}

class EclassCredentialsStorageException extends EclassException {
  const EclassCredentialsStorageException([
    super.message = 'Eclass 자동 로그인 정보를 처리할 수 없어요. 잠시 후 다시 시도해 주세요.',
  ]);
}
