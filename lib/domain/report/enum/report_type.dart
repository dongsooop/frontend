import '../../board/market/enum/market_type.dart';
import '../../board/recruit/enum/recruit_type.dart';

enum ReportType {
  PROJECT_BOARD,
  STUDY_BOARD,
  MARKETPLACE_BOARD,
  TUTORING_BOARD,
  MEMBER;

  String get message {
    switch (this) {
      case ReportType.PROJECT_BOARD: return '프로젝트';
      case ReportType.STUDY_BOARD: return '스터디';
      case ReportType.MARKETPLACE_BOARD: return '장터';
      case ReportType.TUTORING_BOARD: return '튜터링';
      case ReportType.MEMBER: return '유저';
    }
  }

  static ReportType fromString(String value) {
    switch (value) {
      case 'PROJECT_BOARD': return ReportType.PROJECT_BOARD;
      case 'STUDY_BOARD': return ReportType.STUDY_BOARD;
      case 'MARKETPLACE_BOARD': return ReportType.MARKETPLACE_BOARD;
      case 'TUTORING_BOARD': return ReportType.TUTORING_BOARD;
      case 'MEMBER': return ReportType.MEMBER;

      default: return ReportType.MEMBER;
    }
  }
}

extension RecruitTypeToReportType on RecruitType {
  ReportType get reportType {
    switch (this) {
      case RecruitType.tutoring:
        return ReportType.TUTORING_BOARD;
      case RecruitType.study:
        return ReportType.STUDY_BOARD;
      case RecruitType.project:
        return ReportType.PROJECT_BOARD;
    }
  }
}

extension MarketTypeToReportType on MarketType {
  ReportType get reportType {
    return ReportType.MARKETPLACE_BOARD;
  }
}