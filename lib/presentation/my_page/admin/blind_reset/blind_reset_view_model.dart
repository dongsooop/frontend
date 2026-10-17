import 'package:dongsoop/domain/mypage/use_case/blind_date_reset_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/blind_reset/blind_reset_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlindResetViewModel extends StateNotifier<BlindResetState> {
  final BlindDateResetUseCase _blindDateResetUseCase;

  BlindResetViewModel(this._blindDateResetUseCase)
      : super(const BlindResetState());

  Future<void> reset() async {
    if (state.isLoading) return;
    state = const BlindResetState(isLoading: true);

    try {
      await _blindDateResetUseCase.execute();
      state = const BlindResetState(isSuccess: true);
    } catch (_) {
      state = const BlindResetState(
        errorMessage: '과팅 참여 정보를 리셋하는 중 오류가 발생했습니다.',
      );
    }
  }
}
