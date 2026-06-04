import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppCheckInterceptor extends Interceptor {
  String? _cached;
  Future<String?>? _inFlight;
  Timer? _refreshTimer;

  AppCheckInterceptor() {
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      _cached = token;
    });

    _refreshTimer = Timer.periodic(const Duration(minutes: 55), (_) async {
      try {
        final refreshed = await FirebaseAppCheck.instance.getToken();
        _cached = refreshed;
      } catch (_) {}
    });
  }

  Future<String?> _getTokenOnce() {
    if (_cached != null) return Future.value(_cached);
    if (_inFlight != null) return _inFlight!;
    _inFlight = FirebaseAppCheck.instance.getToken().then((t) {
      _cached = t;
      _inFlight = null;
      return t;
    }).catchError((e) {
      _inFlight = null;
      throw e;
    });
    return _inFlight!;
  }

  Future<String?> getToken() => _getTokenOnce();

  Future<void> attachTo(Map<String, dynamic> headers) async {
    final t = await getToken();
    if (t != null && t.isNotEmpty) {
      headers['X-Firebase-AppCheck'] = t;
    }
  }

  bool _isOurBackend(Uri uri) {
    final base = dotenv.maybeGet('BASE_URL');
    if (base == null || base.isEmpty) return false;
    final baseHost = Uri.parse(base).host;
    return uri.host == baseHost || uri.host.endsWith('.$baseHost');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (_isOurBackend(options.uri)) {
        await attachTo(options.headers);
      }
    } catch (_) {}
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  void dispose() {
    _refreshTimer?.cancel();
  }
}
