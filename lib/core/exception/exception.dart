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

class RecruitListException implements Exception {
  final String message;
  RecruitListException([
    this.message = "모집 게시글 목록을 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class RecruitDetailException implements Exception {
  final String message;
  RecruitDetailException([
    this.message = "모집 게시글 상세 정보를 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class RecruitWriteException implements Exception {
  final String message;

  RecruitWriteException([
    this.message = "모집 게시글 작성에 실패했습니다. 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class CafeteriaException implements Exception {
  final String message;
  CafeteriaException([this.message = "학식 조회에 실패했습니다. 잠시 후 다시 시도해주세요"]);

  @override
  String toString() => message;
}

class NoticeException implements Exception {
  final String message;
  NoticeException([this.message = "공지 조회에 실패했습니다. 잠시 후 다시 시도해주세요"]);

  @override
  String toString() => message;
}

class RecruitApplyException implements Exception {
  final String message;
  RecruitApplyException([this.message = "모집 지원하기에 실패했습니다. 잠시 후 다시 시도해주세요"]);

  @override
  String toString() => message;
}
