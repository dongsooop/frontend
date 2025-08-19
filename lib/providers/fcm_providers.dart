import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/fcm_token/data_source/fcm_token_data_source.dart';
import 'package:dongsoop/data/fcm_token/repository/fcm_token_repository_impl.dart';
import 'package:dongsoop/domain/fcm_token/repository/fcm_token_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmDataSourceProvider = Provider<FcmTokenDataSource>((ref) {
  return FcmTokenDataSource(ref.read(secureStorageProvider));
});

final fcmTokenRepositoryProvider = Provider<FcmTokenRepository>((ref) {
  return FcmTokenRepositoryImpl(ref.read(fcmDataSourceProvider));
});
