import 'dart:async';
import 'dart:io' show Platform;
import 'package:dongsoop/providers/splash_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:dongsoop/domain/report/model/report_sanction_status.dart';
import 'package:dongsoop/domain/report/use_case/get_sanction_status_use_case.dart';
import 'package:dongsoop/presentation/splash/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/domain/device_token/enum/failure_type.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  final LoadUserUseCase _loadUserUseCase;
  final GetSanctionStatusUseCase _getSanctionStatusUseCase;
  final Ref _ref;
  StreamSubscription<String>? _fcmSub;
  bool _started = false;

  SplashViewModel(
    this._loadUserUseCase,
    this._getSanctionStatusUseCase,
    this._ref,
    ) : super(SplashState(isLoading: true, isSuccessed: false)) {
    _ref.onDispose(() async {
      await _fcmSub?.cancel();
      _fcmSub = null;
      _started = false;
    });
  }

  // 자동로그인
  Future<void> autoLogin() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _loadUserUseCase.execute();
      if (user == null) {
        state = state.copyWith(isLoading: false, isSuccessed: true);
      } else {
        _ref.read(userSessionProvider.notifier).state = user;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: '동숲 실행 중 오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

  // 제재 상태 확인
  Future<ReportSanctionStatus?> checkSanction() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final sanction = await _getSanctionStatusUseCase.execute();
      if (sanction != null) {
        _ref.invalidate(userSessionProvider);
        _ref.invalidate(myPageViewModelProvider);
        state = state.copyWith(isLoading: false, isSuccessed: false);
      } else {
        state = state.copyWith(isLoading: false, isSuccessed: true);
      }
      return sanction;
    } catch (e) {
      state = state.copyWith(
        errorMessage: '동숲 실행 중 오류가 발생했습니다.',
        isLoading: false,
      );
      return null;
    }
  }

  Future<String?> requestDeviceTokenPreAuthOnce({Duration? tokenTimeout}) async {
    final user = _ref.read(userSessionProvider);
    if (user != null) return null;

    try {
      await _ensureFcmInitialized();
      final stream = _ref.read(observeFcmTokenUseCaseProvider).execute()
          .where((t) => t.isNotEmpty).distinct();

      final token = tokenTimeout == null
          ? await stream.first
          : await stream.first.timeout(tokenTimeout);
      final failure = await _ref.read(registerDeviceTokenUseCaseProvider).execute(
        DeviceTokenRequest(deviceToken: token, type: _deviceType()),
      );
      if (failure == null) return null;

      return switch (failure) {
        FailureType.permissionDenied => '앱 알림 권한이 꺼져 있어 알림을 받을 수 없어요',
        FailureType.registerFailed   => '알림 설정에 실패했어요. 잠시 후 다시 시도해주세요',
      };
    } catch (_) {
      return '일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요';
    }
  }

  Future<void> initFcmAfterAuthGate() async {
    if (_started) return;
    final user = _ref.read(userSessionProvider);
    if (user != null) return;
    await _startFcmObservation();
  }

  Future<void> _ensureFcmInitialized() async {
    if (_started) return;
    _started = true;
    try {
      await _ref.read(initFcmUseCaseProvider).execute();
    } catch (_) {
      _emitTransientErrorMessage('일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요');
    }
  }

  Future<void> _startFcmObservation() async {
    await _ensureFcmInitialized();
    await _fcmSub?.cancel();
    _fcmSub = _ref
        .read(observeFcmTokenUseCaseProvider)
        .execute()
        .where((t) => t.isNotEmpty)
        .distinct()
        .listen((token) async {
      final user = _ref.read(userSessionProvider);
      if (user != null) return;

      await _registerOnce(DeviceTokenRequest(
        deviceToken: token,
        type: _deviceType(),
      ));
    }, onError: (_, __) {
      _emitTransientErrorMessage('일시적인 오류가 발생했어요. 잠시 후 다시 시도해주세요');
    });
  }

  Future<void> _registerOnce(DeviceTokenRequest req) async {
    final failure = await _ref.read(registerDeviceTokenUseCaseProvider).execute(req);
    if (failure == null) return;

    final message = switch (failure) {
      FailureType.permissionDenied => '앱 알림 권한이 꺼져 있어 알림을 받을 수 없어요',
      FailureType.registerFailed   => '알림 설정에 실패했어요. 잠시 후 다시 시도해주세요',
    };
    _emitTransientErrorMessage(message);
  }

  void _emitTransientErrorMessage(String message) {
    _ref.read(fcmSnackMessageProvider.notifier).state = message;
  }

  String _deviceType() {
    if (kIsWeb) return 'WEB';
    if (Platform.isIOS) return 'IOS';
    if (Platform.isAndroid) return 'ANDROID';
    return 'UNKNOWN';
  }
}