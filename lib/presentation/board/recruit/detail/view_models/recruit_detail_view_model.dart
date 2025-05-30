import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitDetailState {
  final RecruitDetailEntity? detail;
  final bool isLoading;
  final String? error;

  const RecruitDetailState({
    this.detail,
    this.isLoading = false,
    this.error,
  });

  RecruitDetailState copyWith({
    RecruitDetailEntity? detail,
    bool? isLoading,
    String? error,
  }) {
    return RecruitDetailState(
      detail: detail ?? this.detail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RecruitDetailViewModel extends StateNotifier<RecruitDetailState> {
  final RecruitDetailUseCase useCase;
  final RecruitType type;
  final String accessToken;
  final String departmentType;

  RecruitDetailViewModel({
    required this.useCase,
    required this.type,
    required this.accessToken,
    required this.departmentType,
    required int id,
  }) : super(const RecruitDetailState()) {
    loadDetail(id);
  }

  Future<void> loadDetail(int id) async {
    print('[RecruitDetailViewModel] 요청 시작: id=$id, type=$type');

    state = state.copyWith(isLoading: true, error: null);

    try {
      final detail = await useCase(
        id: id,
        type: type,
        accessToken: accessToken,
      );
      print('[RecruitDetailViewModel] 요청 성공: ${detail.title}');
      state = state.copyWith(detail: detail, isLoading: false);
    } catch (e, stack) {
      print('[RecruitDetailViewModel] 요청 실패: $e');
      print(stack);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
