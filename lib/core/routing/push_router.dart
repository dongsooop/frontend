import 'dart:async';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/utils/eclass_assignment_link_launcher.dart';
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

  static bool get hasPendingRoute => _nextRoute != null;

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
    final uri = router.routeInformationProvider.value.uri.toString();
    return uri.isEmpty || uri == '/';
  }

  static bool get _isAtSplash {
    final currentPath = router.routeInformationProvider.value.uri.path;
    return currentPath == RoutePaths.splash;
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
    bool isColdStart = false,
  }) {
    final completer = Completer<bool>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final result = await _routeFromTypeValueInternal(
          type: type,
          value: value,
          fromNotificationList: fromNotificationList,
          isColdStart: isColdStart,
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
    required bool isColdStart,
    bool fromNotificationList = false,
  }) async {
    if (_isRouting) return false;
    _isRouting = true;

    try {
      await _waitRouterReady();

      type = type.trim().toUpperCase();
      value = value.trim();

      if (type == 'FORCE_LOGOUT') {
        return true;
      }

      if (_shouldSkipAsDuplicate(type, value)) {
        return true;
      }

      if (type == 'ECLASS_ASSIGNMENT' && value.isEmpty) {
        return await _fallbackToEclassAssignments(
          isColdStart: isColdStart || _isAtSplash,
        );
      }

      final needsValue = _requiresValue(type);
      if (type.isEmpty || (needsValue && value.isEmpty)) {
        return await _fallbackToNotificationList(isColdStart: isColdStart || _isAtSplash);
      }

    if (isColdStart || _isAtSplash) {
      switch (type) {
        case 'CHAT':
          return await _routeChatCold(value);

        case 'BLINDDATE':
          return await _routeBlindChatCold();

        case 'NOTICE':
          return await _routeNoticeCold(value, fromNotificationList);

        case 'CALENDAR':
          return await _routeHomeCold(RoutePaths.schedule);

        case 'TIMETABLE':
          return await _routeHomeCold(RoutePaths.timetable);

        case 'ECLASS_ASSIGNMENT':
          return await _routeEclassAssignmentCold(value);

        case 'NEW_DEVICE_LOGIN':
          return await _routeDeviceManagementCold();

        default:
          return await _fallbackToNotificationList(isColdStart: true);
        }
        }
        return await _routeWarmByType(type, value, fromNotificationList);

      } catch (_) {
        return await _fallbackToNotificationList(isColdStart: isColdStart || _isAtSplash);
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
          router.go(RoutePaths.chat);
          router.push(RoutePaths.chatDetail, extra: value);
          return true;

      case 'BLINDDATE':
        router.go(RoutePaths.chat);
        router.pushNamed('blindDate');
        return true;

      case 'NOTICE':
        router.pushNamed(
          'noticeWebView',
          queryParameters: {
            'path': value,
            if (fromNotificationList) 'from': 'notificationList',
          },
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

        case 'ECLASS_ASSIGNMENT':
          return await _routeEclassAssignmentWarm(value);

        case 'NEW_DEVICE_LOGIN':
          router.go(RoutePaths.mypage);
          if (router.routeInformationProvider.value.uri.path != RoutePaths.setting) {
            router.push(RoutePaths.setting);
          }
          if (router.routeInformationProvider.value.uri.path != RoutePaths.deviceManagement) {
            router.push(RoutePaths.deviceManagement);
          }
          return true;

        default:
          router.goNamed('notificationList');
          return false;
      }
    }

    // cold
    static Future<bool> _routeChatCold(String roomId) async {
      _setNextRoute(RoutePaths.chat, extra: roomId);
      if (!_isAtSplash) router.go(RoutePaths.splash);
      return true;
    }

    // cold
    static Future<bool> _routeBlindChatCold() async {
      _setNextNamedRoute('blindDate');
      if (!_isAtSplash) router.go(RoutePaths.splash);
      return true;
    }

    // cold
    static Future<bool> _routeNoticeCold(String path, bool from) async {
      _setNextNamedRoute(
        'noticeWebView',
        queryParameters:
        from ? {'path': path, 'from': 'notificationList'} : {'path': path},
      );
      if (!_isAtSplash) router.go(RoutePaths.splash);
      return true;
    }

  static Future<bool> _routeEclassAssignmentWarm(String value) async {
    final opened = await openEclassAssignmentLink(value);
    if (opened) return true;

    return _fallbackToEclassAssignments(isColdStart: false);
  }

  static Future<bool> _routeEclassAssignmentCold(String value) async {
    final uri = parseEclassAssignmentLink(value);
    if (uri == null) {
      return _fallbackToEclassAssignments(isColdStart: true);
    }

    _setNextRoute(RoutePaths.eclassAssignments, extra: uri.toString());
    if (!_isAtSplash) router.go(RoutePaths.splash);
    return true;
  }

  static Future<bool> _routeHomeCold(String route) async {
    _setNextRoute(route);
    if (!_isAtSplash) router.go(RoutePaths.splash);
    return true;
  }

  static Future<bool> _routeDeviceManagementCold() async {
    _setNextRoute(RoutePaths.deviceManagement);
    if (!_isAtSplash) router.go(RoutePaths.splash);
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
      case 'BLINDDATE':
      case 'NEW_DEVICE_LOGIN':
        return false;
      default:
        return true;
    }
  }

  static Future<bool> _fallbackToNotificationList({
    required bool isColdStart,
  }) async {
    if (isColdStart) {
      _setNextNamedRoute('notificationList');
      if (!_isAtSplash) router.go(RoutePaths.splash);
    } else {
      router.goNamed('notificationList');
    }
    return false;
  }

  static Future<bool> _fallbackToEclassAssignments({
    required bool isColdStart,
  }) async {
    if (isColdStart) {
      _setNextRoute(RoutePaths.eclassAssignments);
      if (!_isAtSplash) router.go(RoutePaths.splash);
      return true;
    }

    if (router.routeInformationProvider.value.uri.path !=
        RoutePaths.eclassAssignments) {
      router.push(RoutePaths.eclassAssignments);
    }
    return true;
  }
}
