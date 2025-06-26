import 'package:dongsoop/domain/auth/use_case/delete_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/logout_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SettingViewModel extends StateNotifier<AsyncValue<void>> {
  final LogoutUseCase _logoutUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final Ref _ref;

  SettingViewModel(
    this._logoutUseCase,
    this._deleteUserUseCase,
    this._ref,
  ) : super(const AsyncValue.data(null));

  // 로그아웃
  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      await _logoutUseCase.execute();
      _ref.invalidate(userSessionProvider);
      _ref.invalidate(myPageViewModelProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("로그아웃 중 오류가 발생했습니다.", st);
    }
  }

  // 회원 탈퇴
  Future<void> deleteUser() async {
    state = const AsyncValue.loading();

    try {
      await _deleteUserUseCase.execute();
      _ref.invalidate(userSessionProvider);
      _ref.invalidate(myPageViewModelProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("탈퇴 중 오류가 발생했습니다.", st);
    }
  }
}