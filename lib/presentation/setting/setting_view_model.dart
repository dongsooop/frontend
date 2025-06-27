import 'package:dongsoop/domain/auth/use_case/delete_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/logout_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/delete_chat_data_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/setting/setting_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SettingViewModel extends StateNotifier<SettingState> {
  final LogoutUseCase _logoutUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final DeleteChatDataUseCase _deleteChatDataUseCase;
  final Ref _ref;

  SettingViewModel(
    this._logoutUseCase,
    this._deleteUserUseCase,
    this._deleteChatDataUseCase,
    this._ref,
  ) : super(SettingState(isLoading: false));

  // 채팅 캐시 삭제
  Future<void> localDataDelete() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _deleteChatDataUseCase.execute();
      logger.i('local data delete');
      state = state.copyWith(isLoading: false);
    } catch (e, st) {
      logger.e('local data delete error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '캐시 삭제 중 오류가 발생했습니다.',
      );
    }
  }

  // 로그아웃
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _logoutUseCase.execute();
      _ref.invalidate(userSessionProvider);
      _ref.invalidate(myPageViewModelProvider);

      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state.copyWith(isLoading: false, errorMessage: '로그아웃 중 오류가 발생했습니다.');
    }
  }

  // 회원 탈퇴
  Future<void> deleteUser() async {
    state =state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _deleteUserUseCase.execute();
      _ref.invalidate(userSessionProvider);
      _ref.invalidate(myPageViewModelProvider);

      state.copyWith(isLoading: false, errorMessage: null);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state.copyWith(isLoading: false, errorMessage: '탈퇴 중 오류가 발생했습니다.');
    }
  }
}