import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_use_case_provider.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_group_chat_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_write_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/recruit_write_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/domain/chat/use_case/create_group_chat_room_use_case.dart';

part 'recruit_write_view_model.g.dart';

@riverpod
class RecruitWriteViewModel extends _$RecruitWriteViewModel {
  RecruitWriteUseCase get _useCase => ref.watch(recruitWriteUseCaseProvider);
  ValidateWriteUseCase get _validator =>
      ref.watch(validateWriteUseCaseProvider);
  CreateGroupChatRoomUseCase get _chatRoomUseCase => ref.watch(recruitGroupChatUseCaseProvider);

  @override
  RecruitFormState build() => RecruitFormState();

  void updateForm(RecruitFormState updated) {
    state = updated;
  }

  void updateTitle(String value) {
    state = state.copyWith(title: value);
  }

  void updateContent(String value) {
    state = state.copyWith(content: value);
  }

  void updateTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  void updateMajors(List<String> majors) {
    state = state.copyWith(majors: majors);
  }

  void updateRecruitTypeIndex(int index) {
    state = state.copyWith(
      selectedTypeIndex: index,
      majors: index == 0 ? [] : state.majors,
      tags: index == 0 ? [] : state.tags,
    );
  }

  bool get isFormValid =>
      _validator.isValidRecruitType(state.selectedTypeIndex) &&
      _validator.isValidTitle(state.title) &&
      _validator.isValidContent(state.content) &&
      _validator.isValidTags(state.tags);

  Future<void> submit({
    required RecruitType type,
    required RecruitWriteEntity entity,
    required int userId,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errMessage: null,
    );

    try {
      await _useCase.execute(
        type: type,
        entity: entity,
      );
      await _chatRoomUseCase.execute(entity.title, userId);
      
      ref.invalidateSelf();
      logger.i('[Submit Success] 게시글 작성 완료');
    } on LoginRequiredException catch (e) {
      logger.w('[Submit Error] 로그인 필요: ${e.message}');
      state = state.copyWith(errMessage: e.message);
    } catch (e, stack) {
      logger.e('[Submit Error] 예외 발생: $e', stackTrace: stack);
      state = state.copyWith(errMessage: '알 수 없는 오류가 발생했어요.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
