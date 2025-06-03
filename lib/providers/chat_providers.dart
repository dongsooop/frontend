import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source_impl.dart';
import 'package:dongsoop/data/chat/repository/chat_repository_impl.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/use_case/load_chat_rooms_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import '../core/network/stomp_service.dart';
import '../core/storage/secure_storage_service.dart';
import '../domain/chat/model/chat_message.dart';
import '../domain/chat/use_case/chat_room_connect_use_case.dart';
import '../domain/chat/use_case/chat_room_disconnect_use_case.dart';
import '../domain/chat/use_case/send_message_use_case.dart';
import '../domain/chat/use_case/subscribe_messages_use_case.dart';
import '../presentation/chat/chat_detail_view_model.dart';


// 추후 기능, 책임 별로 providers 분리

// stomp
final stompServiceProvider = Provider<StompService>((ref) {
  final secureStorageService = ref.watch(secureStorageProvider);
  return StompService(secureStorageService);
});

// Data Source
final chatDataSourceProvider = Provider<ChatDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);
  final stompService = ref.watch(stompServiceProvider);

  return ChatDataSourceImpl(authDio, stompService);
});

// Repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatDataSource = ref.watch(chatDataSourceProvider);

  return ChatRepositoryImpl(chatDataSource);
});

// Use Case
final loadChatRoomsUseCaseProvider = Provider<LoadChatRoomsUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);

  return LoadChatRoomsUseCase(repository);
});

final chatRoomConnectUseCaseProvider = Provider<ChatRoomConnectUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatRoomConnectUseCase(repository);
});

final chatRoomDisconnectUseCaseProvider = Provider<ChatRoomDisconnectUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatRoomDisconnectUseCase(repository);
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendMessageUseCase(repository);
});

final subscribeMessagesUseCaseProvider = Provider<SubscribeMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SubscribeMessagesUseCase(repository);
});


// View Model
final chatViewModelProvider =
StateNotifierProvider<ChatViewModel, AsyncValue<List<UiChatRoom>?>>((ref) {
  final loadChatRoomsUseCase = ref.watch(loadChatRoomsUseCaseProvider);

  return ChatViewModel(loadChatRoomsUseCase);
});

final chatDetailViewModelProvider =
StateNotifierProvider<ChatDetailViewModel, AsyncValue<void>>((ref) {
  final connectUseCase = ref.watch(chatRoomConnectUseCaseProvider);
  final disconnectUseCase = ref.watch(chatRoomDisconnectUseCaseProvider);
  final sendMessageUseCase = ref.watch(sendMessageUseCaseProvider);
  final subscribeMessagesUseCase = ref.watch(subscribeMessagesUseCaseProvider);

  return ChatDetailViewModel(
    connectUseCase,
    disconnectUseCase,
    sendMessageUseCase,
    subscribeMessagesUseCase,
    ref,
  );
});

final chatMessagesProvider =
StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});