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
    final useCase = ref.read(homeUseCaseProvider);

    try {
      final (fid, deviceToken) = await _resolveDeviceIds();
      return await useCase.execute(fid: fid, deviceToken: deviceToken);
    } on SessionExpiredException {
      throw const SessionExpiredException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    final useCase = ref.read(homeUseCaseProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final (fid, deviceToken) = await _resolveDeviceIds();
        return await useCase.execute(fid: fid, deviceToken: deviceToken);
      } on SessionExpiredException {
        throw const SessionExpiredException();
      } catch (e) {
        rethrow;
      }
    });
  }

  /// 구독 학과 기반 홈 개인화를 위한 fid/deviceToken을 가져온다 (회원/비회원 공통).
  ///
  /// 못 가져와도 홈 화면 자체는 떠야 하므로, 실패한 항목은 null로 두어
  /// 서버가 기본(대학 공지만) 홈으로 폴백하게 둔다.
  Future<(String?, String?)> _resolveDeviceIds() async {
    final fid = await _tryGet(() => ref.read(getFidUseCaseProvider).execute());
    final deviceToken = await _tryGet(() => ref.read(getFcmTokenUseCaseProvider).execute());
    return (fid, deviceToken);
  }

  Future<String?> _tryGet(Future<String?> Function() action) async {
    try {
      return await action();
    } catch (_) {
      return null;
    }
  }
}
