import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitTypeConfig {
  static String getRecruitEndpoint(RecruitType type) {
    return switch (type) {
      RecruitType.TUTORING => _clean('/tutoring-board'),
      RecruitType.STUDY => _clean('/study-board'),
      RecruitType.PROJECT => _clean('/project-board'),
    };
  }

  static String getApplyEndpoint(RecruitType type) {
    return switch (type) {
      RecruitType.TUTORING => _clean('/tutoring-apply'),
      RecruitType.STUDY => _clean('/study-apply'),
      RecruitType.PROJECT => _clean('/project-apply'),
    };
  }

  static String _clean(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
