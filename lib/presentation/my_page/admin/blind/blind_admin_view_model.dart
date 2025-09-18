import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/use_case/blind_date_open_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/blind/blind_admin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlindAdminViewModel extends StateNotifier<BlindAdminState> {
  final BlindDateOpenUseCase _blindDateOpenUseCase;

  BlindAdminViewModel(
    this._blindDateOpenUseCase,
  ) : super(BlindAdminState(isLoading: false, result: false));

  Future<void> open(BlindDateOpenRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null,);

    try {
      final result = await _blindDateOpenUseCase.execute(request);
      state = state.copyWith(
        isLoading: false,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '과팅을 오픈하는 중\n오류가 발생했습니다.\n$e',
      );
    }
  }

  bool validateSelectedTime(
      DateTime selected, {
        int minLeadMinutes = 5,
        bool inclusive = true,
      }) {
    state = state.copyWith(isLoading: true, errorMessage: null,);
    final now = DateTime.now();

    // 과거/현재 불가
    if (!selected.isAfter(now)) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '현재 이후 시간으로 선택해 주세요.',
      );
      return false;
    }

    final diff = selected.difference(now);
    final threshold = Duration(minutes: minLeadMinutes);
    final tooSoon = inclusive ? diff <= threshold : diff < threshold;

    if (tooSoon) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '최소 ${minLeadMinutes}분 이후로 설정해 주세요.',
      );
      return false;
    }
    return true;
  }
}
