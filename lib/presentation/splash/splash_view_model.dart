import 'package:dongsoop/domain/report/model/report_sanction_status.dart';
import 'package:dongsoop/domain/report/use_case/get_sanction_status_use_case.dart';
import 'package:dongsoop/presentation/splash/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  final LoadUserUseCase _loadUserUseCase;
  final GetSanctionStatusUseCase _getSanctionStatusUseCase;
  final Ref _ref;

  SplashViewModel(
    this._loadUserUseCase,
    this._getSanctionStatusUseCase,
    this._ref,
  ) : super(SplashState(isLoading: true, isSuccessed: false));

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
}