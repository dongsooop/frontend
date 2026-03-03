import 'package:dongsoop/domain/device/entity/device_entity.dart';

class DeviceManagementState {
  final bool isLoading;
  final List<DeviceEntity> devices;

  final String? errorTitle;
  final String? errorMessage;

  const DeviceManagementState({
    required this.isLoading,
    required this.devices,
    this.errorTitle,
    this.errorMessage,
  });

  factory DeviceManagementState.initial() => const DeviceManagementState(
    isLoading: false,
    devices: [],
  );

  DeviceManagementState copyWith({
    bool? isLoading,
    List<DeviceEntity>? devices,
    String? errorTitle,
    String? errorMessage,
  }) {
    return DeviceManagementState(
      isLoading: isLoading ?? this.isLoading,
      devices: devices ?? this.devices,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
    );
  }
}