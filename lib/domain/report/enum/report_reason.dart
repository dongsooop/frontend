enum ReportReason {
  SPAM('SPAM', '스팸/도배'),
  INAPPROPRIATE_CONTENT('INAPPROPRIATE_CONTENT', '부적절한 내용'),
  HATE_SPEECH('HATE_SPEECH', '혐오 발언'),
  FRAUD('FRAUD', '사기/허위 정보'),
  PRIVACY_VIOLATION('PRIVACY_VIOLATION', '개인정보 침해'),
  COPYRIGHT_INFRINGEMENT('COPYRIGHT_INFRINGEMENT', '저작권 침해'),
  OTHER('OTHER', '기타');

  final String reason;
  final String message;
  const ReportReason(this.reason, this.message);
}