import 'package:dongsoop/core/utils/current_device_type.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/social_login_use_case.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/use_case/sign_in_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/device_providers.dart';

class SignInViewModel extends StateNotifier<SignInState> {
  final SignInUseCase _loginUseCase;
  final SocialLoginUseCase _socialLoginUseCase;
  final LoadUserUseCase _loadUserUseCase;
  final Ref _ref;

  SignInViewModel(
    this._loginUseCase,
    this._socialLoginUseCase,
    this._loadUserUseCase,
    this._ref,
  ) : super(SignInState(isLoading: false));

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _loginUseCase.execute(email + '@dongyang.ac.kr', password);
      await _registerCurrentDeviceAfterLogin();

      // 로그인한 유저 정보 로딩
      final user = await _loadUserUseCase.execute();
      _ref.read(userSessionProvider.notifier).state = user;
      state = state.copyWith(
        isLoading: false,
      );
    } on LoginException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, errorMessage: "로그인 중 오류가 발생했습니다.");
    }
  }

  Future<void> socialLogin(LoginPlatform platform) async {
    if (state.isLoading) return;
    state = state.copyWith(
        isLoading: true, errorMessage: null, dialogMessage: null);

    try {
      // 소셜 로그인
      await _socialLoginUseCase.execute(platform);
      await _registerCurrentDeviceAfterLogin();

      // 로그인한 유저 정보 로딩
      final user = await _loadUserUseCase.execute();
      _ref.read(userSessionProvider.notifier).state = user;
      state = state.copyWith(
        isLoading: false,
      );
    } on OAuthException catch (e) {
      state = state.copyWith(isLoading: false, dialogMessage: e.message);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, dialogMessage: "소셜 로그인 중 오류가 발생했습니다.");
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null, dialogMessage: null);
  }

  Future<void> _registerCurrentDeviceAfterLogin() async {
    try {
      final deviceToken = await _ref.read(getFcmTokenUseCaseProvider).execute();
      if (deviceToken == null || deviceToken.isEmpty) return;

      final fid = await _ref.read(getFidUseCaseProvider).execute();
      await _ref.read(registerDeviceTokenUseCaseProvider).execute(
            DeviceTokenRequest(
              deviceToken: deviceToken,
              fid: fid,
              type: currentDeviceType(),
            ),
            force: true,
          );
    } catch (_) {
      // 기기 재등록 실패가 완료된 로그인을 되돌리지는 않게 한다.
    }
  }
}
