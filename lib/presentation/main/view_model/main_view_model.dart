import 'dart:async';
import 'dart:io' show Platform;
import 'package:dongsoop/domain/device_token/enum/failure_type.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/auth_providers.dart';
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
        final user = ref.read(userSessionProvider);
        if (user != null) {
          return;
        }

        final req = DeviceTokenRequest(
          deviceToken: token,
          type: _deviceType(),
        );
        await _registerOnce(req);
      }, onError: (e, s) {
        _emitTransientErrorMessage(
          '일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요',
          s,
        );
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
    final failure =
    await ref.read(registerDeviceTokenUseCaseProvider).execute(req);

    if (failure == null) return;

    final msg = switch (failure) {
      FailureType.permissionDenied =>
      '앱 알림 권한이 꺼져 있어 알림을 받을 수 없어요',
      FailureType.registerFailed =>
      '알림 설정에 실패했어요. 잠시 후 다시 시도해주세요',
    };

    _emitTransientErrorMessage(msg, StackTrace.current);
  }

  void _emitTransientErrorMessage(String message, StackTrace s) {
    state = AsyncError(message, s);
    Future.microtask(() => state = const AsyncData(null));
  }

  String _deviceType() {
    if (kIsWeb) return 'WEB';
    if (Platform.isIOS) return 'IOS';
    if (Platform.isAndroid) return 'ANDROID';
    return 'UNKNOWN';
  }
}
