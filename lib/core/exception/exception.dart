class LoginRequiredException implements Exception {
  final String message;

  LoginRequiredException([
    this.message = "로그인이 필요한 서비스예요. 로그인 페이지로 이동하시겠어요?",
  ]);

  @override
  String toString() => message;
}

class SignUpException implements Exception {
  final String message;

  SignUpException([
    this.message = "입력 정보를 다시 확인해 주세요",
  ]);

  @override
  String toString() => message;
}

class PWResetException implements Exception {
  final String message;

  PWResetException([
    this.message = "입력 정보를 다시 확인해 주세요",
  ]);

  @override
  String toString() => message;
}


class LoginException implements Exception {
  final String message;
  const LoginException([this.message = "알 수 없는 오류가 발생했습니다."]);

  @override
  String toString() => message;
}

class LogoutException implements Exception {
  final String message;
  const LogoutException([this.message = "알 수 없는 오류가 발생했습니다."]);

  @override
  String toString() => message;
}

class InvalidCredentialsException extends LoginException {
  const InvalidCredentialsException(
      [String message = "아이디 또는 비밀번호가 잘못되었습니다. 다시 확인해 주세요"])
      : super(message);

  @override
  String toString() => message;
}

class UserSanctionedException extends LoginException {
  const UserSanctionedException(
      [String message = "현재 제재 중인 계정입니다. 자세한 내용은 고객센터에 문의해 주세요."])
      : super(message);

  @override
  String toString() => message;
}

class UserNotFoundException extends LoginException {
  const UserNotFoundException(
      [String message = "등록된 회원 정보를 찾을 수 없습니다."])
      : super(message);

  @override
  String toString() => message;
}

class ReIssueException implements Exception {
  final String message;
  ReIssueException([this.message = "refresh Token이 만료됐습니다. 다시 로그인 해 주세요"]);

  @override
  String toString() => message;
}

class ChatLeaveException implements Exception {
  final String message;
  ChatLeaveException([this.message = "채팅방을 떠나는 중 오류가 발생했습니다"]);

  @override
  String toString() => message;
}

class ChatForbiddenException implements Exception {
  final String message;
  ChatForbiddenException([this.message = "강퇴된 채팅방입니다"]);

  @override
  String toString() => message;
}

class RecruitListException implements Exception {
  final String message;
  RecruitListException([
    this.message = "모집 게시글 리스트를 불러오는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class RecruitDetailException implements Exception {
  final String message;
  RecruitDetailException([
    this.message = "모집 게시글의 상세 정보를\n 불러오는 과정에서 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class RecruitDeleteException implements Exception {
  final String message;
  RecruitDeleteException([
    this.message = "해당 모집 게시글 삭제 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class RecruitWriteException implements Exception {
  final String message;

  RecruitWriteException([
    this.message = "모집 게시글을 작성하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class CalendarException implements Exception {
  final String message;

  CalendarException([
    this.message = "일정 데이터를 불러오는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class CalendarActionException implements Exception {
  final String message;

  CalendarActionException([
    this.message = "일정을 처리하는 과정에서 문제가 발생했어요.\n잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class CafeteriaException implements Exception {
  final String message;
  CafeteriaException(
      [this.message = "학식을 조회하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class NoticeException implements Exception {
  final String message;
  NoticeException(
      [this.message = "공지를 조회하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class RecruitApplyException implements Exception {
  final String message;
  RecruitApplyException(
      [this.message = "해당 모집에 지원하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class RecruitApplicantListException implements Exception {
  final String message;
  RecruitApplicantListException(
      [this.message = "해당 모집 지원 리스트\n 조회 과정에서 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class RecruitApplicantDetailException implements Exception {
  final String message;
  RecruitApplicantDetailException(
      [this.message = "해당 지원자의 지원 내용을 확인하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class RecruitApplicantStatusException implements Exception {
  final String message;
  RecruitApplicantStatusException(
      [this.message = "지원 상태를 조회하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class RecruitApplicantException implements Exception {
  final String message;
  RecruitApplicantException(
      [this.message = "결과를 처리하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

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
    this.message = "장터 게시글 리스트를 불러오는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class MarketDetailException implements Exception {
  final String message;
  MarketDetailException([
    this.message = "장터 게시글의 상세 정보를\n 불러오는 과정에서 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class MarketWriteException implements Exception {
  final String message;

  MarketWriteException([
    this.message = "장터 게시글을 작성하는 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요.",
  ]);

  @override
  String toString() => message;
}

class MarketUpdateException implements Exception {
  final String message;

  MarketUpdateException([
    this.message = "장터 게시글 수정 중 문제가 발생했어요.\n 잠시 후 다시 시도해주세요",
  ]);

  @override
  String toString() => message;
}

class MarketDeleteException implements Exception {
  final String message;

  MarketDeleteException([
    this.message = "장터 게시글 삭제 과정에서\n 문제가 발생했어요.\n 잠시 후 다시 시도해주세요",
  ]);

  @override
  String toString() => message;
}

class MarketCloseException implements Exception {
  final String message;

  MarketCloseException([
    this.message = "거래 완료 중 문제가 발생했어요.\n 잠시 후 다시 시도해주세요",
  ]);

  @override
  String toString() => message;
}

class MarketContactException implements Exception {
  final String message;

  MarketContactException([
    this.message = "거래 연결 중 문제가 발생했어요.\n 잠시 후 다시 시도해주세요",
  ]);

  @override
  String toString() => message;
}

class MarketAlreadyContactException implements Exception {
  final String message;

  MarketAlreadyContactException([
    this.message = "이미 연락한 게시글이예요.",
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

class ReportException implements Exception {
  final String message;
  const ReportException([this.message = "알 수 없는 오류가 발생했습니다."]);

  @override
  String toString() => message;
}

class SelfReportException extends ReportException {
  const SelfReportException([String message = '본인은 신고할 수 없어요.'])
      : super(message);

  @override
  String toString() => message;
}

class AlreadySanctionedException extends ReportException {
  const AlreadySanctionedException([String message = "이미 제제 중인 사용자예요."])
      : super(message);

  @override
  String toString() => message;
}

class NotFoundException extends ReportException {
  const NotFoundException([String message = "신고 대상이 존재하지 않아요."])
      : super(message);

  @override
  String toString() => message;
}

class DuplicateReportException extends ReportException {
  const DuplicateReportException([String message = "중복 신고는 불가능해요."])
      : super(message);

  @override
  String toString() => message;
}

class SanctionException implements Exception {
  final String message;
  const SanctionException([this.message = "알 수 없는 오류가 발생했습니다."]);

  @override
  String toString() => message;
}
class SanctionRequestValidationException extends SanctionException {
  const SanctionRequestValidationException([String message = '요청 데이터 검증에 실패했어요.']) : super(message);

  @override
  String toString() => message;
}
class AlreadyProcessedException extends SanctionException {
  const AlreadyProcessedException([String message = "이미 처리된 신고예요."]) : super(message);

  @override
  String toString() => message;
}
class NotFoundSanctionException extends SanctionException {
  const NotFoundSanctionException([String message = "신고 또는 회원을 찾을 수 없어요."]) : super(message);

  @override
  String toString() => message;
}
class BadRequestParameterException extends SanctionException {
  const BadRequestParameterException([String message = '필터 또는 페이질 파라미터가 잘못됐어요.']) : super(message);

  @override
  String toString() => message;
}
class NoAdminAuthorityException extends SanctionException {
  const NoAdminAuthorityException([String message = '관리자 권한이 없어요.']) : super(message);

  @override
  String toString() => message;
}

class NotificationListException implements Exception {
  final String message;
  NotificationListException(
      [this.message = "알림 목록을 불러오는 과정에서 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class NotificationReadException implements Exception {
  final String message;
  NotificationReadException(
      [this.message = "해당 알림을 확인하는 과정에서 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class NotificationDeleteException implements Exception {
  final String message;
  NotificationDeleteException(
      [this.message = "알림을 삭제하는 과정에서 문제가 발생했어요.\n 잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}

class NotFoundBoardException implements Exception {
  final String message;
  const NotFoundBoardException([this.message = "존재하지 않거나 삭제된 게시글이에요."]);

  @override
  String toString() => message;
}

class TimetableException implements Exception {
  final String message;
  const TimetableException([this.message = "알 수 없는 오류가 발생했습니다."]);

  @override
  String toString() => message;
}

class TimetableAnalysisFailedException extends TimetableException {
  const TimetableAnalysisFailedException([
    String message = "시간표 분석에 실패했어요\n이미지를 다시 첨부해 주세요"
  ]) : super(message);

  @override
  String toString() => message;
}

class TimetableConflictException extends TimetableException {
  const TimetableConflictException([
    String message = "시간표 저장에 실패했어요\n겹치는 시간이 있다면 삭제해 주세요"
  ]) : super(message);

  @override
  String toString() => message;
}

class TimetableMultiStatusException extends TimetableException {
  const TimetableMultiStatusException([
    String message = "강의 저장에 실패했어요\n겹치는 시간이 있다면 삭제해 주세요"
  ]) : super(message);

  @override
  String toString() => message;
}

class HomeException implements Exception {
  final String message;
  HomeException(
      [this.message = "화면을 불러오는 중 오류가 발생했어요\n잠시 후 다시 시도해주세요."]);

  @override
  String toString() => message;
}