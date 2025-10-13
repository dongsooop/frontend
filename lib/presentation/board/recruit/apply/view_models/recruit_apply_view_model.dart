import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_apply_text_filter_use_case.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_apply_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/providers/recruit/apply/recruit_apply_text_filter_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/recruit/apply/recruit_apply_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/apply/state/recruit_apply_state.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_apply_view_model.g.dart';

@riverpod
class RecruitApplyViewModel extends _$RecruitApplyViewModel {
  late final RecruitApplyUseCase _useCase;
  late final RecruitApplyTextFilterUseCase _textFilterUseCase;

  bool _submitting = false;

  @override
  RecruitApplyState build() {
    _useCase = ref.read(recruitApplyUseCaseProvider);
    _textFilterUseCase = ref.read(recruitApplyTextFilterUseCaseProvider);
    return const RecruitApplyState();
  }

  Future<bool> submitRecruitApply({
    required int boardId,
    required String introduction,
    required String motivation,
    required RecruitType type,
    required String departmentCode,
  }) async {
    if (_submitting) {
      return false;
    }
    _submitting = true;

    if (state.isLoading) {
      _submitting = false;
      return false;
    }

    state = state.copyWith(isLoading: true, profanityMessage: null);

    try {
      final filteredIntroduction = introduction.replaceAll('|', '');
      final filteredMotivation = motivation.replaceAll('|', '');

      state = state.copyWith(isFiltering: true);

      await _textFilterUseCase.execute(
        entity: RecruitApplyTextFilterEntity(
          introduction: filteredIntroduction,
          motivation: filteredMotivation,
        ),
      );

      state = state.copyWith(isFiltering: false);

      await _useCase.execute(
        entity: RecruitApplyEntity(
          boardId: boardId,
          introduction: introduction,
          motivation: motivation,
        ),
        type: type,
      );

      ref.invalidate(recruitDetailViewModelProvider(
        RecruitDetailArgs(id: boardId, type: type),
      ));

      ref
          .read(
            recruitListViewModelProvider(
              type: type,
              departmentCode: departmentCode,
            ).notifier,
          )
          .refresh();

      state = const RecruitApplyState();
      return true;
    } on ProfanityDetectedException catch (e) {
      final badSentences = <String>[];
      final data = e.responseData;

      for (final field in ['자기소개', '지원동기']) {
        final section = data[field];
        if (section != null && section['results'] is List) {
          for (final result in section['results']) {
            if (result['label'] == '비속어') {
              final sentence = result['sentence'];
              badSentences.add('[$field]에서 "$sentence" 에 비속어가 포함되었습니다.');
            }
          }
        }
      }

      state = state.copyWith(
        isLoading: false,
        isFiltering: false,
        profanityMessage: badSentences.join('\n'),
        profanityMessageTriggerKey: state.profanityMessageTriggerKey + 1,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFiltering: false,
      );
      return false;
    } finally {
      _submitting = false;
    }
  }

  void clearProfanityMessage() {
    state = state.copyWith(profanityMessage: null);
  }
}
