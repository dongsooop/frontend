import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/params/recruit_detail_params.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitDetailState {
  final RecruitDetailEntity? recruitDetail;
  final bool isLoading;
  final String? error;

  const RecruitDetailState({
    this.recruitDetail,
    this.isLoading = false,
    this.error,
  });

  RecruitDetailState copyWith({
    RecruitDetailEntity? detail,
    bool? isLoading,
    String? error,
  }) {
    return RecruitDetailState(
      recruitDetail: detail ?? this.recruitDetail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RecruitDetailViewModel extends StateNotifier<RecruitDetailState> {
  final RecruitDetailUseCase useCase;

  RecruitDetailViewModel({
    required this.useCase,
    required RecruitDetailParams params,
  }) : super(const RecruitDetailState()) {
    loadDetail(params);
  }

  Future<void> loadDetail(RecruitDetailParams params) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final detail = await useCase(params);
      state = state.copyWith(detail: detail, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
