import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecruitTypeConfig {
  static String getRecruitEndpoint(RecruitType type) {
    return switch (type) {
      RecruitType.TUTORING => _clean(dotenv.get('TUTORING_ENDPOINT')),
      RecruitType.STUDY => _clean(dotenv.get('STUDY_ENDPOINT')),
      RecruitType.PROJECT => _clean(dotenv.get('PROJECT_ENDPOINT')),
    };
  }

  static String getApplyEndpoint(RecruitType type) {
    return switch (type) {
      RecruitType.TUTORING => _clean(dotenv.get('TUTORING_APPLY_ENDPOINT')),
      RecruitType.STUDY => _clean(dotenv.get('STUDY_APPLY_ENDPOINT')),
      RecruitType.PROJECT => _clean(dotenv.get('PROJECT_APPLY_ENDPOINT')),
    };
  }

  static String _clean(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
