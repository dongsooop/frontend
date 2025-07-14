import 'package:dongsoop/presentation/report/report_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportViewModel extends StateNotifier<ReportState> {

  ReportViewModel(

  ) : super(
    ReportState(isLoading: false, isSelected: false)
  );

  // Future<bool> report() {
  //   state = state.copyWith(isLoading: true);
  //
  //   try {
  //
  //     return true;
  //   } catch(e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       errorMessage: '신고 중 오류가 발생했습니다.',
  //     );
  //     return false;
  //   }
  // }
}