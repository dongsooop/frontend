import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class PushRouter {
  static bool _isRouting = false;

  static String? _lastRouteKey;
  static DateTime? _lastRouteAt;
  static const _dedupeWindow = Duration(milliseconds: 800);

  static Future<bool> routeFromTypeValue({
    required String type,
    required String value,
    bool fromNotificationList = false,
  }) async {
    if (_isRouting) return false;
    _isRouting = true;

    try {
      type = type.trim().toUpperCase();
      value = value.trim();

      if (_shouldSkipAsDuplicate(type, value)) {
        return true;
      }

      final needsValue = _requiresValue(type);
      if (type.isEmpty || (needsValue && value.isEmpty)) {
        return await _fallbackToNotificationList();
      }

      switch (type) {
        case 'CHAT':
          await _goHomeThen(() async {
            await router.push(RoutePaths.chatDetail, extra: value);
          });
          return true;

        case 'NOTICE':
          await _goToNoticeInHomeBranch(
            value,
            fromNotificationList: fromNotificationList,
          );
          return true;

      // 캘린더 (value 불필요)
        case 'CALENDAR':
          await _goHomeThen(() async {
            await router.push(RoutePaths.schedule);
          });
          return true;

      // 시간표 (value 불필요)
        case 'TIMETABLE':
          await _goHomeThen(() async {
            await router.push(RoutePaths.timetable);
          });
          return true;

        case 'RECRUITMENT_STUDY_APPLY':
        case 'RECRUITMENT_PROJECT_APPLY':
        case 'RECRUITMENT_TUTORING_APPLY': {
          final id = int.tryParse(value);
          if (id == null || id <= 0) {
            return await _fallbackToNotificationList();
          }

          final recruitType = _parseRecruitTypeSafe(type);
          if (recruitType == null) return await _fallbackToNotificationList();
          await _goHomeThen(() async {
            await router.push(
              RoutePaths.recruitApplicantList,
              extra: {'id': id, 'type': recruitType},
            );
          });
          return true;
        }

        case 'RECRUITMENT_STUDY_APPLY_RESULT':
        case 'RECRUITMENT_PROJECT_APPLY_RESULT':
        case 'RECRUITMENT_TUTORING_APPLY_RESULT': {
          final id = int.tryParse(value);
          if (id == null || id <= 0) {
            return await _fallbackToNotificationList();
          }

          final recruitType = _parseRecruitTypeSafe(type);
          if (recruitType == null) return await _fallbackToNotificationList();

          await _goHomeThen(() async {
            await router.push(
              RoutePaths.recruitApplicantDetail,
              extra: {
                'viewer': RecruitApplicantViewer.APPLICANT,
                'id': id,
                'type': recruitType,
              },
            );
          });
          return true;
        }
        default:
          return await _fallbackToNotificationList();
      }
    } catch (_) {
      return await _fallbackToNotificationList();
    } finally {
      _isRouting = false;
    }
  }

  static bool _shouldSkipAsDuplicate(String type, String value) {
    final now = DateTime.now();
    final key = '$type|$value';
    if (_lastRouteKey == key && _lastRouteAt != null &&
        now.difference(_lastRouteAt!) < _dedupeWindow) {
      return true;
    }
    _lastRouteKey = key;
    _lastRouteAt = now;
    return false;
  }

  static bool _requiresValue(String type) {
    switch (type) {
      case 'CALENDAR':
      case 'TIMETABLE':
        return false;
      case 'CHAT':
      case 'NOTICE':
      case 'RECRUITMENT_STUDY_APPLY':
      case 'RECRUITMENT_PROJECT_APPLY':
      case 'RECRUITMENT_TUTORING_APPLY':
      case 'RECRUITMENT_STUDY_APPLY_RESULT':
      case 'RECRUITMENT_PROJECT_APPLY_RESULT':
      case 'RECRUITMENT_TUTORING_APPLY_RESULT':
        return true;
      default:
        return true;
    }
  }

  static Future<void> _goToNoticeInHomeBranch(
      String path, {
        bool fromNotificationList = false,
      }) async {
    final currentUri = router.routeInformationProvider.value.uri;
    final isInHomeBranch =
    currentUri.toString().startsWith(RoutePaths.home);

    Map<String, String> _buildQuery(String p) {
      final qp = <String, String>{'path': p};
      if (fromNotificationList) {
        qp['from'] = 'notificationList';
      }
      return qp;
    }

    Future<void> navigateToNotice() async {
      router.goNamed(
        'noticeWebView',
        queryParameters: _buildQuery(path),
      );
    }

    if (!isInHomeBranch) {
      router.go(RoutePaths.home);
      await Future.microtask(navigateToNotice);
    } else {
      await navigateToNotice();
    }
  }

  static Future<void> _goHomeThen(Future<void> Function() action) async {
    final currentUri = router.routeInformationProvider.value.uri;
    final isInHomeBranch = currentUri.toString().startsWith(RoutePaths.home);

    if (!isInHomeBranch) {
      router.go(RoutePaths.home);
      await Future.microtask(action);
    } else {
      await action();
    }
  }

  static RecruitType? _parseRecruitTypeSafe(String type) {
    if (type.contains('_STUDY')) return RecruitType.STUDY;
    if (type.contains('_PROJECT')) return RecruitType.PROJECT;
    if (type.contains('_TUTORING')) return RecruitType.TUTORING;
    return null;
  }

  static Future<bool> _fallbackToNotificationList() async {
    await router.push(RoutePaths.notificationList);
    return false;
  }
}
