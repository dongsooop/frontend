import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_text_filter_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_use_case_provider.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_text_filter_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_write_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/recruit_write_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_write_view_model.g.dart';

@riverpod
class RecruitWriteViewModel extends _$RecruitWriteViewModel {
  RecruitWriteUseCase get _useCase => ref.watch(recruitWriteUseCaseProvider);
  ValidateWriteUseCase get _validator =>
      ref.watch(validateWriteUseCaseProvider);
  RecruitTextFilterUseCase get _textFilterUseCase =>
      ref.watch(recruitTextFilterUseCaseProvider);

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

  Future<bool> submit({
    required RecruitType type,
    required RecruitWriteEntity entity,
    required int userId,
  }) async {
    if (state.isLoading) return false;

    final start = entity.startAt;
    final end = entity.endAt;

    if (!_validator.isValidStartTime(start)) {
      state = state.copyWith(errMessage: '모집 시작일은 오늘부터 가능해요.');
      return false;
    }

    if (!_validator.isWithinThreeMonths(start)) {
      state = state.copyWith(errMessage: '모집 시작일은 오늘로부터 3개월 이내여야 해요.');
      return false;
    }
    if (!_validator.isWithinRecruitPeriod(start, end)) {
      state = state.copyWith(errMessage: '모집 기간은 최소 24시간 이상, 최대 28일 이내여야 해요.');
      return false;
    }

    String? prevProfanityMessage;

    state = state.copyWith(
      isLoading: true,
      errMessage: null,
      profanityMessage: null,
    );

    try {
      final filteredTitle = state.title.replaceAll('|', '');
      final filteredTags =
          state.tags.map((e) => e.replaceAll('|', '')).join(' ');
      final filteredContent = state.content.replaceAll('|', '');

      await _textFilterUseCase.execute(
        entity: RecruitTextFilterEntity(
          title: filteredTitle,
          tags: filteredTags,
          content: filteredContent,
        ),
      );

      await _useCase.execute(type: type, entity: entity);
      return true;
    } on ProfanityDetectedException catch (e) {
      _setProfanityMessage(e);
      prevProfanityMessage = state.profanityMessage;
      return false;
    } on LoginRequiredException catch (e) {
      state = state.copyWith(errMessage: e.message);
      return false;
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(
        isLoading: false,
        profanityMessage: prevProfanityMessage ?? state.profanityMessage,
      );
    }
  }

  void _setProfanityMessage(ProfanityDetectedException e) {
    final badSentences = <String>[];
    final Map<String, dynamic> data = e.responseData;

    // 서버 → 클라이언트 키 변환 맵
    final fieldNameMap = {
      '제목': '제목',
      '태그': '태그',
      '본문': '내용',
    };

    // 사용자에게 보여줄 필드 순서
    final displayOrder = ['제목', '내용', '태그'];

    for (final field in displayOrder) {
      final serverKey =
          fieldNameMap.entries.firstWhere((entry) => entry.value == field).key;

      final section = data[serverKey];
      if (section != null && section['results'] is List) {
        for (final result in section['results']) {
          if (result['label'] == '비속어') {
            final sentence = result['sentence'];
            badSentences.add('[$field]에서 "$sentence" 에 비속어가 포함되어 있습니다.');
          }
        }
      }
    }

    if (badSentences.isNotEmpty) {
      final message = badSentences.join('\n');
      state = state.copyWith(
        profanityMessage: message,
        profanityMessageTriggerKey: state.profanityMessageTriggerKey + 1,
      );
    }
  }

  void clearProfanityMessage() {
    state = state.copyWith(
      profanityMessage: null,
      profanityMessageTriggerKey: null,
    );
  }
}
