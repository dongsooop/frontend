import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/social_login_use_case.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/use_case/sign_in_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';

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

      // 로그인한 유저 정보 로딩
      final user = await _loadUserUseCase.execute();
      _ref.read(userSessionProvider.notifier).state = user;
      state = state.copyWith(isLoading: false,);
    } on LoginException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "로그인 중 오류가 발생했습니다.");
    }
  }

  Future<void> socialLogin(LoginPlatform platform) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, errorMessage: null, dialogMessage: null);

    try {
      // 소셜 로그인
      await _socialLoginUseCase.execute(platform);

      // 로그인한 유저 정보 로딩
      final user = await _loadUserUseCase.execute();
      _ref.read(userSessionProvider.notifier).state = user;
      state = state.copyWith(isLoading: false,);
    } on OAuthException catch (e) {
      state = state.copyWith(isLoading: false, dialogMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, dialogMessage: "소셜 로그인 중 오류가 발생했습니다.\n${e}");
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null, dialogMessage: null);
  }
}