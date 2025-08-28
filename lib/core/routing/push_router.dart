import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class PushRouter {
  static Future<void> routeFromTypeValue({
    required String type,
    required String value,
  }) async {
    final t = type.toUpperCase();

    switch (t) {
      case 'CHAT':
        await router.push(RoutePaths.chatDetail, extra: value);
        return;

      case 'NOTICE':
        final uri = router.namedLocation(
          'noticeWebView',
          queryParameters: {'path': value},
        );
        await router.push(uri);
        return;

      // 작성자
      case 'RECRUITMENT_STUDY_APPLY':
      case 'RECRUITMENT_PROJECT_APPLY':
      case 'RECRUITMENT_TUTORING_APPLY': {
        final boardId = _coerceInt(value);
        final category = _extractRecruitCategory(t);
        await router.push(
          RoutePaths.recruitApplicantList,
          extra: {
            'id': boardId,
            'type': category,
          },
        );
        return;
      }

      // 지원자
      case 'RECRUITMENT_STUDY_APPLY_RESULT':
      case 'RECRUITMENT_PROJECT_APPLY_RESULT':
      case 'RECRUITMENT_TUTORING_APPLY_RESULT': {
        final boardId = _coerceInt(value);
        final category = _extractRecruitCategory(t);
        await router.push(
          RoutePaths.recruitApplicantDetail,
          extra: {
            'viewer': RecruitApplicantViewer.APPLICANT,
            'id': boardId,
            'type': category,
          },
        );
        return;
      }

      default:
      // 알 수 없는 타입이면 알림 리스트로 이동
        print('[PushRouter] unknown type=$type value=$value');
        await router.push(RoutePaths.notificationList);
    }
  }

  static int _coerceInt(String v) {
    final parsed = int.tryParse(v);
    if (parsed == null) {
      print('[PushRouter] invalid int value="$v"');
      return 0;
    }
    return parsed;
  }

  static RecruitType _extractRecruitCategory(String upperType) {
    if (upperType.contains('_STUDY')) return RecruitType.STUDY;
    if (upperType.contains('_PROJECT')) return RecruitType.PROJECT;
    if (upperType.contains('_TUTORING')) return RecruitType.TUTORING;
    // 임시
    return RecruitType.STUDY;
  }
}
