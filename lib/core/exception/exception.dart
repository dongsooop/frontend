class LoginRequiredException implements Exception {
  final String message;

  LoginRequiredException([
    this.message = "로그인이 필요한 서비스예요. 로그인 페이지로 이동하시겠어요?",
  ]);

  @override
  String toString() => message;
}

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

class CalendarException implements Exception {
  final String message;

  CalendarException([
    this.message = "일정 데이터를 불러오는 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class CalendarActionException implements Exception {
  final String message;

  CalendarActionException([
    this.message = "일정을 처리하는 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.",
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
  RecruitApplyException(
      [this.message = "해당 모집에 지원하는 과정에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요"]);

  @override
  String toString() => message;
}

class ApplyIntroductionException implements Exception {
  final String message;
  ApplyIntroductionException(
      [this.message = "자기소개 부분에서 비속어가 발견되었습니다. 다시 작성해주세요"]);

  @override
  String toString() => message;
}

class ApplyMotivationException implements Exception {
  final String message;
  ApplyMotivationException(
      [this.message = "지원동기 부분에서 비속어가 발견되었습니다. 다시 작성해주세요"]);

  @override
  String toString() => message;
}

class MarketListException implements Exception {
  final String message;
  MarketListException([
    this.message = "장터 게시글 목록을 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class MarketDetailException implements Exception {
  final String message;
  MarketDetailException([
    this.message = "장터 게시글 상세 정보를 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class MarketWriteException implements Exception {
  final String message;

  MarketWriteException([
    this.message = "장터 게시글 작성에 실패했습니다. 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class MarketUpdateException implements Exception {
  final String message;

  MarketUpdateException([
    this.message = "장터 게시글 수정 중 문제가 발생했어요. 잠시 후 다시 시도해주세요",
  ]);

  @override
  String toString() => message;
}

class MarketDeleteException implements Exception {
  final String message;

  MarketDeleteException([
    this.message = "장터 게시글 삭제 중 문제가 발생했어요. 잠시 후 다시 시도해주세요",
  ]);

  @override
  String toString() => message;
}

class ProfanityDetectedException implements Exception {
  final Map<String, dynamic> responseData;

  ProfanityDetectedException(this.responseData);

  @override
  String toString() => '수정 후 다시 작성 버튼을 눌러주세요. \n $responseData';
}
