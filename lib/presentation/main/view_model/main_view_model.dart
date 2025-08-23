import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';

part 'main_view_model.g.dart';

@riverpod
class MainViewModel extends _$MainViewModel {
  StreamSubscription<String>? _sub;
  bool _started = false;

  @override
  Future<void> build() async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      if (_started) return;
      _started = true;

      await ref.read(initFcmUseCaseProvider).execute();

      _sub = ref
          .read(observeFcmTokenUseCaseProvider)
          .execute()
          .where((t) => t.isNotEmpty)
          .distinct()
          .listen((token) async {
        final req = DeviceTokenRequest(
          deviceToken: token,
          type: _deviceType(),
        );
        await _registerOnce(req);
      }, onError: (e, s) {
        debugPrint('❌ FCM 토큰 스트림 에러: $e\n$s');
        _emitTransientError(e, s);
      });
    });

    state = result.when(
      data: (_) => const AsyncData(null),
      loading: () => const AsyncLoading(),
      error: (e, st) => AsyncError(e, st),
    );

    ref.onDispose(() async {
      await _sub?.cancel();
      _sub = null;
      _started = false;
    });
  }

  Future<void> _registerOnce(DeviceTokenRequest req) async {
    try {
      await ref.read(registerDeviceTokenUseCaseProvider).execute(req);
    } catch (e, s) {
      debugPrint('❌ FCM 토큰 등록 실패: $e\n$s');
      _emitTransientError(e, s);
    }
  }

  void _emitTransientError(Object e, StackTrace s) {
    state = AsyncError(e, s);
    Future.microtask(() => state = const AsyncData(null));
  }

  String _deviceType() {
    if (kIsWeb) return 'WEB';
    if (Platform.isIOS) return 'IOS';
    if (Platform.isAndroid) return 'ANDROID';
    return 'UNKNOWN';
  }
}
