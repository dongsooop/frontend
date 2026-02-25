import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/device/data_source/device_data_source.dart';
import 'package:dongsoop/data/device/data_source/device_data_source_impl.dart';
import 'package:dongsoop/data/device/repository/device_repository_impl.dart';
import 'package:dongsoop/domain/device/repository/device_repository.dart';
import 'package:dongsoop/domain/device/use_case/force_logout_device_use_case.dart';
import 'package:dongsoop/domain/device/use_case/device_list_use_case.dart';
import 'package:dongsoop/presentation/setting/device_management/view_model/device_management_state.dart';
import 'package:dongsoop/presentation/setting/device_management/view_model/device_management_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DataSource
final deviceDataSourceProvider = Provider<DeviceDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return DeviceDataSourceImpl(authDio, secureStorage);
});

// Repository
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final dataSource = ref.watch(deviceDataSourceProvider);
  return DeviceRepositoryImpl(dataSource);
});

// UseCase
final deviceListUseCaseProvider = Provider<DeviceListUseCase>((ref) {
  final repo = ref.watch(deviceRepositoryProvider);
  return DeviceListUseCase(repo);
});

final forceLogoutDeviceUseCaseProvider = Provider<ForceLogoutDeviceUseCase>((ref) {
  final repo = ref.watch(deviceRepositoryProvider);
  return ForceLogoutDeviceUseCase(repo);
});

// ViewModel
final deviceManagementViewModelProvider = StateNotifierProvider<DeviceManagementViewModel, DeviceManagementState>((ref) {
  return DeviceManagementViewModel(
    ref.watch(deviceListUseCaseProvider),
    ref.watch(forceLogoutDeviceUseCaseProvider),
  );
});