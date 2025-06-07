import 'dart:convert';

import 'package:dongsoop/data/board/recruit/models/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_use_case_provider.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/write/providers/recruit_write_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/date_time_state.dart';
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
  RecruitFormState build() {
    // DateTimeState 포함된 기본 상태
    final now = DateTime.now();
    final rounded = _roundUpTo10(now);
    return RecruitFormState(
      dateTime: DateTimeState(
        currentMonth: DateTime(now.year, now.month),
        startDateTime: rounded,
        endDateTime: rounded.add(const Duration(hours: 24)),
        startTimePicked: false,
        endTimePicked: false,
      ),
    );
  }

  DateTime _roundUpTo10(DateTime dt) {
    final roundedMinute = ((dt.minute + 9) ~/ 10) * 10;
    if (roundedMinute == 60) {
      dt = dt.add(const Duration(hours: 1));
      return DateTime(dt.year, dt.month, dt.day, dt.hour, 0);
    }
    return DateTime(dt.year, dt.month, dt.day, dt.hour, roundedMinute);
  }

  void updateForm(RecruitFormState updated) {
    state = updated;
  }

  bool get isFormValid {
    return _validator.isValidRecruitType(state.selectedTypeIndex) &&
        _validator.isValidTitle(state.title) &&
        _validator.isValidContent(state.content) &&
        _validator.isValidTags(state.tags) &&
        _validator.isValidStartTime(state.dateTime.startDateTime) &&
        _validator.isValidEndDateTime(
          start: state.dateTime.startDateTime,
          end: state.dateTime.endDateTime,
        );
  }

  Future<void> submit({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true); // trigger rebuild

    try {
      debugPrint(
          '[Submit] Payload: ${jsonEncode(RecruitWriteModel.fromEntity(entity).toJson())}');
      await _useCase(type: type, entity: entity);
      ref.invalidateSelf(); // 상태 초기화
    } catch (e) {
      debugPrint('[ViewModel] 요청 실패: $e');
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
