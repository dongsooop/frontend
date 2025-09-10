import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlindDateDetailViewModel extends StateNotifier<BlindDateDetailState> {

  BlindDateDetailViewModel(

  ) : super(BlindDateDetailState(isLoading: false, participants: 0));

  Future<void> joinBlindDate() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(participants: 2);
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(participants: 3);
    await Future.delayed(const Duration(seconds: 3));

    state = state.copyWith(participants: 6);
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(participants: 7);
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(isLoading: false);
  }
}