import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_home_use_case.dart';
import 'package:dongsoop/presentation/home/providers/notice_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notice_view_model.g.dart';

@riverpod
class NoticeViewModel extends _$NoticeViewModel {
  NoticeHomeUseCase? _useCase;

  @override
  Future<List<NoticeEntity>> build(String? departmentType) async {
    _useCase = await ref.read(NoticeHomeUseCaseProvider.future);

    final result = await _useCase!.execute(
      page: 0,
      departmentType: departmentType,
      force: true,
    );

    return result.take(3).toList();
  }

  Future<void> refresh({required String? departmentType}) async {
    if (_useCase == null) return;
    state = const AsyncLoading();

    final result = await _useCase!.execute(
      page: 0,
      departmentType: departmentType,
      force: true,
    );

    state = AsyncValue.data(result.take(3).toList());
  }
}
