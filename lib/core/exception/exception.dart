class LoginException implements Exception {
  final String message;
  LoginException([this.message = "아이디 또는 비밀번호가 잘못되었습니다. 다시 확인해 주세요"]);

  @override
  String toString() => message;
}

class ReIssueException implements Exception {
  final String message;
  ReIssueException([this.message = "refresh Token이 만료됐습니다. 다시 로그인 해 주세요"]);

  @override
  String toString() => message;
}