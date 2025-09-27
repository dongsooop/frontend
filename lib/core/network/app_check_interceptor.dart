import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppCheckInterceptor extends Interceptor {
  String? _cached;
  Future<String?>? _inFlight;

  AppCheckInterceptor() {
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      _cached = token;
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

  bool _isOurBackend(Uri uri) {
    final base = dotenv.maybeGet('BASE_URL');
    if (base == null || base.isEmpty) return false;
    final baseUri = Uri.parse(base);
    return uri.host == baseUri.host;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (_isOurBackend(options.uri)) {
        final token = await _getTokenOnce();
        if (token != null) {
          options.headers['X-Firebase-AppCheck'] = token;
          print('[AppCheckInterceptor] header attached for ${options.uri}');
        } else {
          print('[AppCheckInterceptor] token is null (${options.uri})');
        }
      }
    } catch (e) {
      print('[AppCheckInterceptor] error: $e');
    }
    handler.next(options);
  }
}
