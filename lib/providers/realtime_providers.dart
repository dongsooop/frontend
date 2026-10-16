import 'package:dongsoop/core/network/blind_date_stomp_service.dart';
import 'package:dongsoop/core/network/stomp_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stompServiceProvider = Provider<StompService>((ref) {
  final secureStorageService = ref.watch(secureStorageProvider);
  return StompService(secureStorageService);
});

final blindDateStompServiceProvider = Provider<BlindDateStompService>((ref) {
  final secureStorageService = ref.watch(secureStorageProvider);
  return BlindDateStompService(secureStorageService);
});
