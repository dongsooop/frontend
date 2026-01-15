import 'package:dongsoop/domain/auth/use_case/delete_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/logout_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/delete_chat_data_use_case.dart';
import 'package:dongsoop/domain/mypage/use_case/get_social_state_use_case.dart';
import 'package:dongsoop/presentation/setting/setting_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SettingViewModel extends StateNotifier<SettingState> {
  final LogoutUseCase _logoutUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final DeleteChatDataUseCase _deleteChatDataUseCase;
  final GetSocialStateUseCase _getSocialStateUseCase;
  final Ref _ref;

  bool _shouldReturnToSettingAfterOsSettings = false;

  SettingViewModel(
    this._logoutUseCase,
    this._deleteUserUseCase,
    this._deleteChatDataUseCase,
    this._getSocialStateUseCase,
    this._ref,
  ) : super(SettingState(isLoading: false));

  bool consumeShouldReturnToSetting() {
    final current = _shouldReturnToSettingAfterOsSettings;
    _shouldReturnToSettingAfterOsSettings = false;
    return current;
  }

  // 채팅 캐시 삭제
  Future<void> localDataDelete() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _deleteChatDataUseCase.execute();
      state = state.copyWith(isLoading: false);
    } catch (e) {
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
    } catch (e) {
      state.copyWith(isLoading: false, errorMessage: '로그아웃 중 오류가 발생했습니다.');
    }
  }

  // 회원 탈퇴
  Future<void> deleteUser() async {
    state =state.copyWith(isLoading: true, errorMessage: null);

    try {
      final socialLogin = await _getSocialStateUseCase.execute();

      if (socialLogin != null || socialLogin!.isNotEmpty) {
        state = state.copyWith(isLoading: false, errorTitle: '소셜 연동 해제', errorMessage: '연결된 소셜 계정이 있어요\n마이페이지에서 소셜 계정을 모두 연동 해제해 주세요');
        return;
      }

      await _deleteUserUseCase.execute();
      _ref.invalidate(userSessionProvider);
      _ref.invalidate(myPageViewModelProvider);

      state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      state.copyWith(isLoading: false, errorMessage: '탈퇴 중 오류가 발생했습니다.');
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null, errorTitle: null);
  }
}
