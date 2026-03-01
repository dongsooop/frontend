import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/presentation/home/providers/home_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeEntity> build({required String? departmentCode}) async {
    final code = (departmentCode == null || departmentCode.trim().isEmpty)
        ? null
        : departmentCode.trim();
    final useCase = ref.read(homeUseCaseProvider);
    return useCase.execute(departmentType: code);
  }

  Future<void> refresh() async {
    final code = (departmentCode == null || departmentCode!.trim().isEmpty)
        ? null
        : departmentCode!.trim();
    final useCase = ref.read(homeUseCaseProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => useCase.execute(departmentType: code));
  }
}