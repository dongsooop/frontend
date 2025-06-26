import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/splash/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  final LoadUserUseCase _loadUserUseCase;
  final Ref _ref;

  SplashViewModel(
    this._loadUserUseCase,
    this._ref,
  ) : super(SplashState(isLoading: true, isSuccessed: false));

  // 자동로그인
  Future<void> autoLogin() async {
    try {
      final user = await _loadUserUseCase.execute();
      logger.i('user: ${user?.nickname}');
      _ref.read(userSessionProvider.notifier).state = user;
      state = state.copyWith(isLoading: false, isSuccessed: true);
    } catch (e) {
      state = state.copyWith(
        errorMessage: '동숲 실행 중 오류가 발생했습니다.',
        isLoading: false,
      );
    }
  }

}