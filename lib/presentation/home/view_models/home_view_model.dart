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
      return await useCase.execute(
        departmentCode: departmentCode,
        fid: fid,
        deviceToken: deviceToken,
      );
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
        return await useCase.execute(
          departmentCode: departmentCode,
          fid: fid,
          deviceToken: deviceToken,
        );
      } on SessionExpiredException {
        throw const SessionExpiredException();
      } catch (e) {
        rethrow;
      }
    });
  }

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
