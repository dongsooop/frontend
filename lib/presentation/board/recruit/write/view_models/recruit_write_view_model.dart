import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final RecruitWriteUseCase useCase;
  final ValidateWriteUseCase validator;

  bool _isSubmitting = false;

  RecruitWriteViewModel(this.useCase, this.validator)
      : super(const AsyncValue.data(null));

  bool validateForm({
    required int? selectedIndex,
    required String title,
    required String content,
    required List<String> tags,
  }) {
    return validator.isValidRecruitType(selectedIndex) &&
        validator.isValidTitle(title) &&
        validator.isValidContent(content) &&
        validator.isValidTags(tags);
  }

  Future<void> submit({
    required RecruitType type,
    required String accessToken,
    required RecruitWriteEntity entity,
  }) async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    state = const AsyncValue.loading();
    try {
      await useCase(
        type: type,
        accessToken: accessToken,
        entity: entity,
      );
      if (mounted) {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      print('[ViewModel] 요청 실패: $e');
      if (mounted) {
        state = AsyncValue.error(e, st);
      }
    } finally {
      _isSubmitting = false;
    }
  }
}
