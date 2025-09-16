import 'dart:async';
import 'package:flutter/services.dart';
import 'push_event.dart';

class PushChannel {
  PushChannel._();
  static final PushChannel _instance = PushChannel._();
  factory PushChannel.instance() => _instance;

  static const _channel = MethodChannel('app/push');

  final StreamController<PushPayload> _onPushController = StreamController<PushPayload>.broadcast();
  final StreamController<PushPayload> _onPushTapController = StreamController<PushPayload>.broadcast();

  Stream<PushPayload> get onPush => _onPushController.stream;
  Stream<PushPayload> get onPushTap => _onPushTapController.stream;

  bool _isBound = false;
  bool get isBound => _isBound;

  void bind() {
    if (_isBound) return;
    _isBound = true;

    _channel.setMethodCallHandler((MethodCall methodCall) async {
      final Object? arguments = methodCall.arguments;

      if (arguments is! Map) {return null;}

      final Map<String, dynamic> payloadMap = Map<String, dynamic>.from(arguments);
      final PushPayload payload = PushPayload.fromMap(payloadMap);

      switch (methodCall.method) {
        case 'onPush':
          _onPushController.add(payload);
          break;
        case 'onPushTap':
          _onPushTapController.add(payload);
          break;
        default:
      }
      return null;
    });
  }

  void dispose() {
    if (!_isBound) return;
    _isBound = false;
    _channel.setMethodCallHandler(null);
  }
}