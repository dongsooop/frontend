import 'package:dongsoop/domain/feedback/enum/service_feature.dart';

class ServiceFeatureMapper {
  static String toServerString(ServiceFeature feature) {
    switch (feature) {
      case ServiceFeature.noticeAlert:
        return 'NOTICE_ALERT';
      case ServiceFeature.mealInformation:
        return 'MEAL_INFORMATION';
      case ServiceFeature.academicSchedule:
        return 'ACADEMIC_SCHEDULE';
      case ServiceFeature.timetableAutoManage:
        return 'TIMETABLE_AUTO_MANAGE';
      case ServiceFeature.teamRecruitment:
        return 'TEAM_RECRUITMENT';
      case ServiceFeature.marketplace:
        return 'MARKETPLACE';
      case ServiceFeature.chatbotCampusInfo:
        return 'CHATBOT_CAMPUS_INFO';
    }
  }

  static ServiceFeature fromServerString(String raw) {
    switch (raw) {
      case '교내 공지 알림 서비스':
        return ServiceFeature.noticeAlert;
      case '학식 정보 확인 서비스':
        return ServiceFeature.mealInformation;
      case '학사 일정 확인 및 개인 일정 관리':
        return ServiceFeature.academicSchedule;
      case '시간표 자동 입력 및 관리':
        return ServiceFeature.timetableAutoManage;
      case '팀원 모집(스터디/튜터링/프로젝트)':
        return ServiceFeature.teamRecruitment;
      case '장터(교재 등 중고 거래)':
        return ServiceFeature.marketplace;
      case '챗봇을 통한 교내 정보 확인':
        return ServiceFeature.chatbotCampusInfo;
      default:
        throw Exception('Unknown ServiceFeature: $raw');
    }
  }
}