import 'package:flutter_dotenv/flutter_dotenv.dart';

enum RecruitType {
  tutoring,
  study,
  project;

  String get label {
    switch (this) {
      case RecruitType.tutoring:
        return '튜터링';
      case RecruitType.study:
        return '스터디';
      case RecruitType.project:
        return '프로젝트';
    }
  }
}

extension RecruitTypeExtension on RecruitType {
  String get recruitEndpoint {
    switch (this) {
      case RecruitType.tutoring:
        return dotenv.get('TUTORING_ENDPOINT');
      case RecruitType.study:
        return dotenv.get('STUDY_ENDPOINT');
      case RecruitType.project:
        return dotenv.get('PROJECT_ENDPOINT');
    }
  }

  String get applyEndpoint {
    final endpoint = switch (this) {
      RecruitType.tutoring => dotenv.get('TUTORING_APPLY_ENDPOINT'),
      RecruitType.study => dotenv.get('STUDY_APPLY_ENDPOINT'),
      RecruitType.project => dotenv.get('PROJECT_APPLY_ENDPOINT'),
    };

    return endpoint.endsWith('/')
        ? endpoint.substring(0, endpoint.length - 1)
        : endpoint;
  }
}
