import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/detail/providers/recruit_detail_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_detail_view_model.g.dart';

class RecruitDetailState {
  final RecruitDetailEntity? recruitDetail;
  final bool isLoading;
  final bool isButtonEnabled;
  final String? error;

  const RecruitDetailState({
    this.recruitDetail,
    this.isLoading = false,
    this.isButtonEnabled = true,
    this.error,
  });

  RecruitDetailState copyWith({
    RecruitDetailEntity? recruitDetail,
    bool? isLoading,
    bool? isButtonEnabled,
    String? error,
  }) {
    return RecruitDetailState(
      recruitDetail: recruitDetail ?? this.recruitDetail,
      isLoading: isLoading ?? this.isLoading,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      error: error,
    );
  }
}

class RecruitDetailArgs {
  final int id;
  final RecruitType type;

  const RecruitDetailArgs({
    required this.id,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecruitDetailArgs &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

@Riverpod(keepAlive: true)
class RecruitDetailViewModel extends _$RecruitDetailViewModel {
  RecruitDetailUseCase get _useCase => ref.watch(recruitDetailUseCaseProvider);

  @override
  FutureOr<RecruitDetailState> build(RecruitDetailArgs args) async {
    try {
      final recruitDetail = await _useCase(id: args.id, type: args.type);
      return RecruitDetailState(
        recruitDetail: recruitDetail,
        isLoading: false,
        isButtonEnabled: true,
      );
    } catch (e) {
      return RecruitDetailState(
        isLoading: false,
        isButtonEnabled: false,
        error: e.toString(),
      );
    }
  }

  void setButtonEnabled(bool enabled) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(isButtonEnabled: enabled),
    );
  }
}
