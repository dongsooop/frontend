import 'dart:async';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:flutter/widgets.dart';

class NextRoute {
  final String? path;
  final String? name;
  final Object? extra;
  final Map<String, dynamic>? queryParameters;

  const NextRoute({
    this.path,
    this.name,
    this.extra,
    this.queryParameters,
  });
}

class PushRouter {
  static bool _isRouting = false;

  static String? _lastRouteKey;
  static DateTime? _lastRouteAt;
  static const _dedupeWindow = Duration(milliseconds: 800);

  static NextRoute? _nextRoute;

  static NextRoute? takeNextRoute() {
    final route = _nextRoute;
    _nextRoute = null;
    return route;
  }

  static void _setNextRoute(String path, {Object? extra}) {
    _nextRoute = NextRoute(path: path, extra: extra);
  }

  static void _setNextNamedRoute(
      String name, {
        Object? extra,
        Map<String, dynamic>? queryParameters,
      }) {
    _nextRoute = NextRoute(
      name: name,
      extra: extra,
      queryParameters: queryParameters,
    );
  }

  static bool get _isColdStart {
    return router.routeInformationProvider.value.uri.toString().isEmpty;
  }

  static Future<void> _waitRouterReady() async {
    int retry = 0;
    while (_isColdStart && retry < 15) {
      await Future.delayed(const Duration(milliseconds: 100));
      retry++;
    }
  }

  static Future<bool> routeFromTypeValue({
    required String type,
    required String value,
    bool fromNotificationList = false,
  }) {
    final completer = Completer<bool>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final result = await _routeFromTypeValueInternal(
          type: type,
          value: value,
          fromNotificationList: fromNotificationList,
        );
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } catch (_) {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      }
    });

    return completer.future;
  }

  static Future<bool> _routeFromTypeValueInternal({
    required String type,
    required String value,
    bool fromNotificationList = false,
  }) async {
    if (_isRouting) return false;
    _isRouting = true;

    try {
      await _waitRouterReady();

      type = type.trim().toUpperCase();
      value = value.trim();

      if (_shouldSkipAsDuplicate(type, value)) {
        return true;
      }

      final needsValue = _requiresValue(type);
      if (type.isEmpty || (needsValue && value.isEmpty)) {
        return await _fallbackToNotificationList();
      }

      if (!_isColdStart) {
        return await _routeWarmByType(type, value, fromNotificationList);
      }

      // cold
      switch (type) {
        case 'CHAT':
          return await _routeChatCold(value);

        case 'NOTICE':
          return await _routeNoticeCold(value, fromNotificationList);

        case 'CALENDAR':
          return await _routeHomeCold(RoutePaths.schedule);

        case 'TIMETABLE':
          return await _routeHomeCold(RoutePaths.timetable);

        case 'RECRUITMENT_STUDY_APPLY':
        case 'RECRUITMENT_PROJECT_APPLY':
        case 'RECRUITMENT_TUTORING_APPLY':
          return await _routeRecruitApplyCold(type, value);

        case 'RECRUITMENT_STUDY_APPLY_RESULT':
        case 'RECRUITMENT_PROJECT_APPLY_RESULT':
        case 'RECRUITMENT_TUTORING_APPLY_RESULT':
          return await _routeRecruitResultCold(type, value);

        default:
          return await _fallbackToNotificationList();
        }
      } catch (_) {
        return await _fallbackToNotificationList();
      } finally {
        _isRouting = false;
      }
    }

    // warm
    static Future<bool> _routeWarmByType(
        String type,
        String value,
        bool fromNotificationList,
        ) async {
      switch (type) {
        case 'CHAT':
          router.push(RoutePaths.chat);
          router.push(RoutePaths.chatDetail, extra: value);
          return true;

      case 'NOTICE':
        router.pushNamed(
          'noticeWebView',
          queryParameters: fromNotificationList
              ? {'path': value, 'from': 'notificationList'}
              : {'path': value},
        );
        return true;

      // 캘린더 (value 불필요)
        case 'CALENDAR':
          router.push(RoutePaths.schedule);
          return true;

      // 시간표 (value 불필요)
        case 'TIMETABLE':
          router.push(RoutePaths.timetable);
          return true;

        case 'RECRUITMENT_STUDY_APPLY':
        case 'RECRUITMENT_PROJECT_APPLY':
        case 'RECRUITMENT_TUTORING_APPLY':
          return await _routeRecruitApplyWarm(type, value);

        case 'RECRUITMENT_STUDY_APPLY_RESULT':
        case 'RECRUITMENT_PROJECT_APPLY_RESULT':
        case 'RECRUITMENT_TUTORING_APPLY_RESULT':
          return await _routeRecruitResultWarm(type, value);

        default:
          router.push(RoutePaths.notificationList);
          return false;
      }
    }

    // warm
    static Future<bool> _routeRecruitApplyWarm(
        String type,
        String value,
        ) async {
      final id = int.tryParse(value);
      if (id == null || id <= 0) return false;

      final recruitType = _parseRecruitTypeSafe(type);
      if (recruitType == null) return false;

      router.push(
        RoutePaths.recruitDetail,
        extra: {'id': id, 'type': recruitType},
      );

      router.push(
        RoutePaths.recruitApplicantList,
        extra: {'id': id, 'type': recruitType},
      );

      return true;
    }

    // warm
    static Future<bool> _routeRecruitResultWarm(
        String type,
        String value,
        ) async {
      final id = int.tryParse(value);
      if (id == null || id <= 0) return false;

      final recruitType = _parseRecruitTypeSafe(type);
      if (recruitType == null) return false;

      router.push(
        RoutePaths.recruitDetail,
        extra: {'id': id, 'type': recruitType},
      );

      router.push(
        RoutePaths.recruitApplicantDetail,
        extra: {
          'viewer': RecruitApplicantViewer.APPLICANT,
          'id': id,
          'type': recruitType,
        },
      );

      return true;
    }

    // cold
    static Future<bool> _routeChatCold(String roomId) async {
      _setNextRoute(RoutePaths.chat, extra: roomId);
      router.go(RoutePaths.splash);
      return true;
    }

    // cold
    static Future<bool> _routeNoticeCold(String path, bool from) async {
      _setNextNamedRoute(
        'noticeWebView',
        queryParameters:
        from ? {'path': path, 'from': 'notificationList'} : {'path': path},
      );
      router.go(RoutePaths.splash);
      return true;
    }

    // cold
    static Future<bool> _routeHomeCold(String route) async {
      _setNextRoute(route);
      router.go(RoutePaths.splash);
      return true;
    }

    // cold
    static Future<bool> _routeRecruitApplyCold(String type, String value) async {
      final id = int.tryParse(value);
      if (id == null || id <= 0) return _fallbackToNotificationList();

      final recruitType = _parseRecruitTypeSafe(type);
      if (recruitType == null) return _fallbackToNotificationList();

      _setNextRoute(
        RoutePaths.recruitDetail,
        extra: {
          'id': id,
          'type': recruitType,
          'first': {
            'path': RoutePaths.recruitApplicantList,
            'extra': {'id': id, 'type': recruitType},
          },
        },
      );

      router.go(RoutePaths.splash);
      return true;
    }

    // cold
    static Future<bool> _routeRecruitResultCold(String type, String value) async {
      final id = int.tryParse(value);
      if (id == null || id <= 0) return _fallbackToNotificationList();

      final recruitType = _parseRecruitTypeSafe(type);
      if (recruitType == null) return _fallbackToNotificationList();

      _setNextRoute(
        RoutePaths.recruitDetail,
        extra: {
          'id': id,
          'type': recruitType,
          'first': {
            'path': RoutePaths.recruitApplicantDetail,
            'extra': {
              'viewer': RecruitApplicantViewer.APPLICANT,
              'id': id,
              'type': recruitType,
            },
          },
        },
      );

      router.go(RoutePaths.splash);
      return true;
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
      default:
        return true;
    }
  }

  static RecruitType? _parseRecruitTypeSafe(String type) {
    if (type.contains('_STUDY')) return RecruitType.STUDY;
    if (type.contains('_PROJECT')) return RecruitType.PROJECT;
    if (type.contains('_TUTORING')) return RecruitType.TUTORING;
    return null;
  }

  static Future<bool> _fallbackToNotificationList() async {
    _setNextRoute(RoutePaths.notificationList);
    router.go(RoutePaths.splash);
    return false;
  }
}
