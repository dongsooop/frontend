import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/use_case/get_blind_date_open_use_case.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlindDateViewModel extends StateNotifier<BlindDateState> {
  final GetBlindDateOpenUseCase _getBlindDateOpenUseCase;

  BlindDateViewModel(
    this._getBlindDateOpenUseCase,
  ) : super(BlindDateState(isLoading: false));

  Future<bool> isOpened() async {
    state = state.copyWith(errorMessage: null);

    try {
      return await _getBlindDateOpenUseCase.execute();
    } on BlindDateOpenException catch (e) {
      state = state.copyWith(
        isBlindDateOpened: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: '과팅 오픈 확인 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}