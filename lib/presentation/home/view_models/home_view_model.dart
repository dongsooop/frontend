import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/presentation/home/providers/home_use_case_provider.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/core/exception/exception.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeEntity> build({required String? departmentCode}) async {
    final code = (departmentCode == null || departmentCode.trim().isEmpty)
        ? null
        : departmentCode.trim();
    final useCase = ref.read(homeUseCaseProvider);

    try {
      final deviceToken = code == null ? await _resolveDeviceToken() : null;
      return await useCase.execute(departmentType: code, deviceToken: deviceToken);
    } on SessionExpiredException {
      throw const SessionExpiredException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    final code = (departmentCode == null || departmentCode!.trim().isEmpty)
        ? null
        : departmentCode!.trim();
    final useCase = ref.read(homeUseCaseProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final deviceToken = code == null ? await _resolveDeviceToken() : null;
        return await useCase.execute(departmentType: code, deviceToken: deviceToken);
      } on SessionExpiredException {
        throw const SessionExpiredException();
      } catch (e) {
        rethrow;
      }
    });
  }

  /// 관심 학과 기반 홈 개인화를 위한 디바이스 토큰을 가져온다.
  ///
  /// 토큰을 못 가져와도 홈 화면 자체는 떠야 하므로, 실패 시 null을 반환해
  /// 서버가 기본(대학 공지만) 홈으로 폴백하게 둔다.
  Future<String?> _resolveDeviceToken() async {
    try {
      return await ref.read(getFcmTokenUseCaseProvider).execute();
    } catch (_) {
      return null;
    }
  }
}
