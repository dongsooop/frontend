import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_use_case_provider.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/write/providers/recruit_write_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/recruit_write_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_write_view_model.g.dart';

@riverpod
class RecruitWriteViewModel extends _$RecruitWriteViewModel {
  RecruitWriteUseCase get _useCase => ref.watch(recruitWriteUseCaseProvider);
  ValidateWriteUseCase get _validator =>
      ref.watch(validateWriteUseCaseProvider);

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
  }) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await _useCase.execute(
        type: type,
        entity: entity,
      );
      ref.invalidateSelf();
    } catch (e) {
      debugPrint('[Submit Error] $e');
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
