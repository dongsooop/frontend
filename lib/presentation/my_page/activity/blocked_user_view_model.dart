import 'package:dongsoop/domain/mypage/use_case/get_blocked_user_list_use_case.dart';
import 'package:dongsoop/domain/mypage/use_case/un_block_use_case.dart';
import 'package:dongsoop/presentation/my_page/activity/blocked_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockedUserViewModel extends StateNotifier<BlockedUserState> {
  final GetBlockedUserListUseCase _getBlockedUserListUseCase;
  final UnBlockUseCase _unBlockUseCase;

  BlockedUserViewModel(
    this._getBlockedUserListUseCase,
    this._unBlockUseCase,
  ) : super(BlockedUserState(isLoading: false));

  Future<void> loadList() async {
    state = state.copyWith(isLoading: true, errorMessage: null,);

    try {
      final list = await _getBlockedUserListUseCase.execute() ?? [];
      state = state.copyWith(
        isLoading: false,
        list: list,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '차단된 사용자 목록을 불러오는 중\n오류가 발생했습니다.\n${e}',
      );
    }
  }

  Future<void> unBlock(int blockerId, int blockedMemberId) async {
    state = state.copyWith(isLoading: true);

    try {
      await _unBlockUseCase.execute(blockerId, blockedMemberId);
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '차단 해제 중 오류가 발생했습니다.');
    }
  }
}
