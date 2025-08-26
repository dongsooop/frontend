import 'package:dongsoop/domain/device_token/use_case/device_token_register_use_case.dart';
import 'package:dongsoop/domain/device_token/use_case/fcm_token_init_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/device_token/data_source/fcm_token_data_source_impl.dart';
import 'package:dongsoop/data/device_token/data_source/fcm_token_data_source.dart';
import 'package:dongsoop/data/device_token/data_source/device_token_data_source.dart';
import 'package:dongsoop/data/device_token/data_source/device_token_data_source_impl.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';
import 'package:dongsoop/data/device_token/repository/device_token_repository_impl.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fcm_token_use_case.dart';
import 'package:dongsoop/domain/device_token/use_case/observe_fcm_token_use_case.dart';

// DataSources
final fcmTokenDataSourceProvider = Provider<FcmTokenDataSource>((ref) {
  final storage = ref.read(secureStorageProvider);
  final ds = FcmTokenDataSourceImpl(storage);
  ref.onDispose(() => ds.dispose());
  return ds;
});

final deviceTokenRemoteDataSourceProvider = Provider<DeviceTokenDataSource>((ref) {
  final dio = ref.read(plainDioProvider);
  final storage = ref.read(secureStorageProvider);
  return DeviceTokenDataSourceImpl(dio, storage);
});

// Repository
final deviceTokenRepositoryProvider = Provider<DeviceTokenRepository>((ref) {
  final fcmDs = ref.read(fcmTokenDataSourceProvider);
  final remoteDs = ref.read(deviceTokenRemoteDataSourceProvider);
  return DeviceTokenRepositoryImpl(fcmDs, remoteDs);
});

// UseCases
final initFcmUseCaseProvider = Provider<FcmInitUseCase>((ref) {
  final repo = ref.read(deviceTokenRepositoryProvider);
  return FcmInitUseCase(repo);
});

final getFcmTokenUseCaseProvider = Provider<GetFcmTokenUseCase>((ref) {
  final repo = ref.read(deviceTokenRepositoryProvider);
  return GetFcmTokenUseCase(repo);
});

final observeFcmTokenUseCaseProvider = Provider<ObserveFcmTokenUseCase>((ref) {
  final repo = ref.read(deviceTokenRepositoryProvider);
  return ObserveFcmTokenUseCase(repo);
});

final registerDeviceTokenUseCaseProvider = Provider<DeviceRegisterTokenUseCase>((ref) {
  final repo = ref.read(deviceTokenRepositoryProvider);
  return DeviceRegisterTokenUseCase(repo);
});
