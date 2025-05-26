import 'package:flutter_dotenv/flutter_dotenv.dart';

enum RecruitType {
  tutoring,
  study,
  project,
}

extension RecruitTypeExtension on RecruitType {
  String get writeEndpoint {
    switch (this) {
      case RecruitType.tutoring:
        return dotenv.get('TUTORING_ENDPOINT');
      case RecruitType.study:
        return dotenv.get('STUDY_ENDPOINT');
      case RecruitType.project:
        return dotenv.get('PROJECT_ENDPOINT');
    }
  }

  String get listEndpoint {
    switch (this) {
      case RecruitType.tutoring:
        return dotenv.get('TUTORING_LIST_ENDPOINT');
      case RecruitType.study:
        return dotenv.get('STUDY_LIST_ENDPOINT');
      case RecruitType.project:
        return dotenv.get('PROJECT_LIST_ENDPOINT');
    }
  }

  String get detailEndpointPrefix {
    switch (this) {
      case RecruitType.tutoring:
        return dotenv.get('TUTORING_ENDPOINT');
      case RecruitType.study:
        return dotenv.get('STUDY_ENDPOINT');
      case RecruitType.project:
        return dotenv.get('PROJECT_ENDPOINT');
    }
  }
}
