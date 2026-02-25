import 'package:dongsoop/domain/device/use_case/device_delete_use_case.dart';
import 'package:dongsoop/domain/device/use_case/force_logout_use_case.dart';
import 'package:dongsoop/presentation/setting/device_management/view_model/device_management_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceManagementViewModel extends StateNotifier<DeviceManagementState> {
  final DeviceListUseCase _deviceListUseCase;
  final ForceLogoutDeviceUseCase _forceLogoutDeviceUseCase;

  DeviceManagementViewModel(
      this._deviceListUseCase,
      this._forceLogoutDeviceUseCase,
      ) : super(DeviceManagementState.initial());

  Future<void> loadDevices() async {
    state = state.copyWith(isLoading: true, errorTitle: null, errorMessage: null);

    try {
      final list = await _deviceListUseCase.execute();
      state = state.copyWith(isLoading: false, devices: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorTitle: '오류',
        errorMessage: '디바이스 목록 조회에 실패했습니다.',
      );
    }
  }

  Future<void> forceLogout(int deviceId) async {
    state = state.copyWith(isLoading: true, errorTitle: null, errorMessage: null);

    try {
      await _forceLogoutDeviceUseCase.execute(deviceId);
      final list = await _deviceListUseCase.execute();
      state = state.copyWith(isLoading: false, devices: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorTitle: '오류',
        errorMessage: '디바이스 로그아웃에 실패했습니다.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorTitle: null, errorMessage: null);
  }
}