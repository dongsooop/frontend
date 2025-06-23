import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecruitTypeConfig {
  static String getRecruitEndpoint(RecruitType type) {
    return switch (type) {
      RecruitType.tutoring => _clean(dotenv.get('TUTORING_ENDPOINT')),
      RecruitType.study => _clean(dotenv.get('STUDY_ENDPOINT')),
      RecruitType.project => _clean(dotenv.get('PROJECT_ENDPOINT')),
    };
  }

  static String getApplyEndpoint(RecruitType type) {
    return switch (type) {
      RecruitType.tutoring => _clean(dotenv.get('TUTORING_APPLY_ENDPOINT')),
      RecruitType.study => _clean(dotenv.get('STUDY_APPLY_ENDPOINT')),
      RecruitType.project => _clean(dotenv.get('PROJECT_APPLY_ENDPOINT')),
    };
  }

  static String _clean(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
