import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';

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
    RecruitDetailEntity? recruitDetail,
    bool? isLoading,
    String? error,
  }) {
    return RecruitDetailState(
      recruitDetail: recruitDetail ?? this.recruitDetail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
