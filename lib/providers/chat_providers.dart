import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source_impl.dart';
import 'package:dongsoop/data/chat/repository/chat_repository_impl.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/use_case/delete_chat_data_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_offline_messages_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_paged_messages.dart';
import 'package:dongsoop/domain/chat/use_case/get_user_nicknames_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_chat_rooms_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/save_chat_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/update_read_status_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_detail_state.dart';
import 'package:dongsoop/presentation/chat/chat_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/stomp_service.dart';
import '../core/storage/secure_storage_service.dart';
import '../domain/chat/model/chat_message.dart';
import '../domain/chat/use_case/connect_chat_room_use_case.dart';
import '../domain/chat/use_case/disconnect_chat_room_use_case.dart';
import '../domain/chat/use_case/send_message_use_case.dart';
import '../domain/chat/use_case/subscribe_messages_use_case.dart';
import '../main.dart';
import '../presentation/chat/chat_detail_view_model.dart';
import '../presentation/chat/chat_state.dart';


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
  final hiveService = ref.watch(hiveServiceProvider);

  return ChatDataSourceImpl(authDio, stompService, hiveService);
});

// Repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatDataSource = ref.watch(chatDataSourceProvider);

  return ChatRepositoryImpl(chatDataSource);
});

// Use Case
final loadChatRoomsUseCaseProvider = Provider<GetChatRoomsUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);

  return GetChatRoomsUseCase(repository);
});

final connectChatRoomUseCaseProvider = Provider<ConnectChatRoomUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ConnectChatRoomUseCase(repository);
});

final disconnectChatRoomUseCaseProvider = Provider<DisconnectChatRoomUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return DisconnectChatRoomUseCase(repository);
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendMessageUseCase(repository);
});

final subscribeMessagesUseCaseProvider = Provider<SubscribeMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SubscribeMessagesUseCase(repository);
});

final getUserNicknamesUseCaseProvider = Provider<GetUserNicknamesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetUserNicknamesUseCase(repository);
});

final saveChatMessageUseCaseProvider = Provider<SaveChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SaveChatMessageUseCase(repository);
});

final getPagedMessagesUseCaseProvider = Provider<GetPagedMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetPagedMessagesUseCase(repository);
});

final deleteChatDattaUseCaseProvider = Provider<DeleteChatDataUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return DeleteChatDataUseCase(repository);
});

final getOfflineMessagesUseCaseProvider = Provider<GetOfflineMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetOfflineMessagesUseCase(repository);
});

final updateReadStatusUseCaseProvider = Provider<UpdateReadStatusUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return UpdateReadStatusUseCase(repository);
});

// View Model
final chatViewModelProvider =
StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  logger.i("provider created");
  ref.onDispose(() {
    logger.i("provider disposed");
  });
  final loadChatRoomsUseCase = ref.watch(loadChatRoomsUseCaseProvider);
  final deleteChatDataUseCase = ref.watch(deleteChatDattaUseCaseProvider);

  return ChatViewModel(loadChatRoomsUseCase, deleteChatDataUseCase);
});

final chatDetailViewModelProvider =
StateNotifierProvider<ChatDetailViewModel, ChatDetailState>((ref) {
  final connectUseCase = ref.watch(connectChatRoomUseCaseProvider);
  final disconnectUseCase = ref.watch(disconnectChatRoomUseCaseProvider);
  final sendMessageUseCase = ref.watch(sendMessageUseCaseProvider);
  final subscribeMessagesUseCase = ref.watch(subscribeMessagesUseCaseProvider);
  final getUserNicknamesUseCase = ref.watch(getUserNicknamesUseCaseProvider);
  final saveChatMessageUseCase = ref.watch(saveChatMessageUseCaseProvider);
  final getPagedMessagesUseCase = ref.watch(getPagedMessagesUseCaseProvider);
  final getOfflineMessagesUseCase = ref.watch(getOfflineMessagesUseCaseProvider);
  final updateReadStatusUseCase = ref.watch(updateReadStatusUseCaseProvider);

  return ChatDetailViewModel(
    connectUseCase,
    disconnectUseCase,
    sendMessageUseCase,
    subscribeMessagesUseCase,
    getUserNicknamesUseCase,
    saveChatMessageUseCase,
    getPagedMessagesUseCase,
    getOfflineMessagesUseCase,
    updateReadStatusUseCase,
    ref,
  );
});

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
      (ref) {
    final viewModel = ref.watch(chatDetailViewModelProvider.notifier);
    return ChatMessagesNotifier(viewModel.getPagedMessages);
  },
);