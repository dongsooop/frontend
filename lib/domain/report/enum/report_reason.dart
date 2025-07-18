enum ReportReason {
  SPAM,
  INAPPROPRIATE_CONTENT,
  HATE_SPEECH,
  FRAUD,
  PRIVACY_VIOLATION,
  COPYRIGHT_INFRINGEMENT,
  OTHER;

  String get message {
    switch (this) {
      case ReportReason.SPAM: return '스팸/도배';
      case ReportReason.INAPPROPRIATE_CONTENT: return '부적절한 내용';
      case ReportReason.HATE_SPEECH: return '혐오 발언';
      case ReportReason.FRAUD: return '사기/허위 정보';
      case ReportReason.PRIVACY_VIOLATION: return '개인정보 침해';
      case ReportReason.COPYRIGHT_INFRINGEMENT: return '저작권 침해';
      case ReportReason.OTHER: return '기타';
    }
  }

  static ReportReason fromString(String value) {
    switch (value) {
      case 'SPAM': return ReportReason.SPAM;
      case 'INAPPROPRIATE_CONTENT': return ReportReason.INAPPROPRIATE_CONTENT;
      case 'HATE_SPEEC': return ReportReason.HATE_SPEECH;
      case 'FRAUD': return ReportReason.FRAUD;
      case 'PRIVACY_VIOLATION': return ReportReason.PRIVACY_VIOLATION;
      case 'COPYRIGHT_INFRINGEMENT': return ReportReason.COPYRIGHT_INFRINGEMENT;
      case 'OTHER': return ReportReason.OTHER;

      default: return ReportReason.OTHER;
    }
  }
}