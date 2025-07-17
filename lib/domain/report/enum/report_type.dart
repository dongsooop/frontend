import '../../board/market/enum/market_type.dart';
import '../../board/recruit/enum/recruit_type.dart';

enum ReportType {
  PROJECT_BOARD,
  STUDY_BOARD,
  MARKETPLACE_BOARD,
  TUTORING_BOARD,
  MEMBER;
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