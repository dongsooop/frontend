import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source_impl.dart';
import 'package:dongsoop/data/chat/repository/chat_repository_impl.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/use_case/create_QNA_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/delete_chat_data_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_offline_messages_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_paged_messages.dart';
import 'package:dongsoop/domain/chat/use_case/get_room_detail_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_user_nicknames_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_chat_rooms_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/kick_user_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/leave_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/save_chat_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/update_read_status_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_detail_state.dart';
import 'package:dongsoop/presentation/chat/chat_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/network/stomp_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/use_case/connect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/create_one_to_one_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/disconnect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/subscribe_messages_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_detail_view_model.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:dongsoop/domain/chat/use_case/subscribe_block_use_case.dart';


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
final createOneToOneChatRoomUseCaseProvider = Provider<CreateOneToOneChatRoomUseCase>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return CreateOneToOneChatRoomUseCase(repository);
});

final createQNAChatRoomUseCaseProvider = Provider<CreateQnaChatRoomUseCase>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return CreateQnaChatRoomUseCase(repository);
});

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

final subscribeBlockUseCaseProvider = Provider<SubscribeBlockUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SubscribeBlockUseCase(repository);
});

final getUserNicknamesUseCaseProvider = Provider<GetUserNicknamesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetUserNicknamesUseCase(repository);
});

final getRoomDetailUseCaseProvider = Provider<GetRoomDetailUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetRoomDetailUseCase(repository);
});

final saveChatMessageUseCaseProvider = Provider<SaveChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SaveChatMessageUseCase(repository);
});

final getPagedMessagesUseCaseProvider = Provider<GetPagedMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetPagedMessagesUseCase(repository);
});

final deleteChatDataUseCaseProvider = Provider<DeleteChatDataUseCase>((ref) {
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

final leaveChatRoomUseCaseProvider = Provider<LeaveChatRoomUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return LeaveChatRoomUseCase(repository);
});

final kickUserUseCaseProvider = Provider<KickUserUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return KickUserUseCase(repository);
});

// View Model
final chatViewModelProvider =
StateNotifierProvider.autoDispose<ChatViewModel, ChatState>((ref) {
  final loadChatRoomsUseCase = ref.watch(loadChatRoomsUseCaseProvider);

  return ChatViewModel(loadChatRoomsUseCase);
});

final chatDetailViewModelProvider =
StateNotifierProvider<ChatDetailViewModel, ChatDetailState>((ref) {
  final connectUseCase = ref.watch(connectChatRoomUseCaseProvider);
  final disconnectUseCase = ref.watch(disconnectChatRoomUseCaseProvider);
  final sendMessageUseCase = ref.watch(sendMessageUseCaseProvider);
  final subscribeMessagesUseCase = ref.watch(subscribeMessagesUseCaseProvider);
  final subscribeBlockUseCase = ref.watch(subscribeBlockUseCaseProvider);
  final getUserNicknamesUseCase = ref.watch(getUserNicknamesUseCaseProvider);
  final getRoomDetailUseCase = ref.watch(getRoomDetailUseCaseProvider);
  final saveChatMessageUseCase = ref.watch(saveChatMessageUseCaseProvider);
  final getPagedMessagesUseCase = ref.watch(getPagedMessagesUseCaseProvider);
  final getOfflineMessagesUseCase = ref.watch(getOfflineMessagesUseCaseProvider);
  final updateReadStatusUseCase = ref.watch(updateReadStatusUseCaseProvider);
  final leaveChatRoomUseCase = ref.watch(leaveChatRoomUseCaseProvider);
  final kickUserUseCase = ref.watch(kickUserUseCaseProvider);
  final userBlockUseCase = ref.watch(userBlockUseCaseProvider);

  return ChatDetailViewModel(
    connectUseCase,
    disconnectUseCase,
    sendMessageUseCase,
    subscribeMessagesUseCase,
    subscribeBlockUseCase,
    getUserNicknamesUseCase,
    getRoomDetailUseCase,
    saveChatMessageUseCase,
    getPagedMessagesUseCase,
    getOfflineMessagesUseCase,
    updateReadStatusUseCase,
    leaveChatRoomUseCase,
    kickUserUseCase,
    userBlockUseCase,
    ref,
  );
});

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
      (ref) {
    final viewModel = ref.watch(chatDetailViewModelProvider.notifier);
    return ChatMessagesNotifier(viewModel.getPagedMessages);
  },
);

final chatBlockProvider = StateNotifierProvider<ChatBlockNotifier, String>((ref) {
    return ChatBlockNotifier();
  },
);