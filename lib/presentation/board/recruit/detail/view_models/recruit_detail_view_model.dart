import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_detail_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/detail/states/recruit_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_detail_view_model.g.dart';

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

@riverpod
class RecruitDetailViewModel extends _$RecruitDetailViewModel {
  RecruitDetailUseCase get _useCase => ref.watch(recruitDetailUseCaseProvider);

  @override
  FutureOr<RecruitDetailState> build(RecruitDetailArgs args) async {
    try {
      final recruitDetail = await _useCase.execute(
        id: args.id,
        type: args.type,
      );

      return RecruitDetailState(
        recruitDetail: recruitDetail,
        isLoading: false,
      );
    } catch (e, stack) {
      logger.e('ViewModel build 실패', error: e, stackTrace: stack);
      return RecruitDetailState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setButtonEnabled(bool enabled) {
    final current = state.value;
    if (current == null) return;
  }
}
