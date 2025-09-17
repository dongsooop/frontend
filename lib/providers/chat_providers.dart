import 'package:dongsoop/core/network/socket_io_service.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source_impl.dart';
import 'package:dongsoop/data/chat/repository/chat_repository_impl.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/use_case/blind_choice_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_connect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_disconnect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/create_QNA_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/delete_chat_data_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_blind_date_open_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_offline_messages_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_paged_messages.dart';
import 'package:dongsoop/domain/chat/use_case/get_room_detail_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_user_nicknames_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/get_chat_rooms_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/kick_user_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/leave_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/save_chat_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_broadcast_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_disconnect_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_freeze_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_join_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_joined_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_match_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_participants_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_start_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_system_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/update_read_status_use_case.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_state.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_view_model.dart';
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
  final socketIoService = ref.watch(socketIoServiceProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  return ChatDataSourceImpl(authDio, stompService, socketIoService, hiveService);
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

final blindConnectUseCaseProvider = Provider<BlindConnectUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindConnectUseCase(repository);
});

final blindDisconnectUseCaseProvider = Provider<BlindDisconnectUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindDisconnectUseCase(repository);
});

final blindJoinedStreamUseCaseProvider = Provider<BlindJoinedStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindJoinedStreamUseCase(repository);
});

final blindStartStreamUseCaseProvider = Provider<BlindStartStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindStartStreamUseCase(repository);
});

final blindSystemStreamUseCaseProvider = Provider<BlindSystemStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindSystemStreamUseCase(repository);
});

final blindFreezeStreamUseCaseProvider = Provider<BlindFreezeStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindFreezeStreamUseCase(repository);
});

final blindBroadcastStreamUseCaseProvider = Provider<BlindBroadcastStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindBroadcastStreamUseCase(repository);
});

final blindJoinStreamUseCaseProvider = Provider<BlindJoinStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindJoinStreamUseCase(repository);
});

final blindParticipantsStreamUseCaseProvider = Provider<BlindParticipantsStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindParticipantsStreamUseCase(repository);
});

final blindMatchStreamUseCaseProvider = Provider<BlindMatchStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindMatchStreamUseCase(repository);
});

final blindDisconnectStreamUseCaseProvider = Provider<BlindDisconnectStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindDisconnectStreamUseCase(repository);
});

final blindSendMessageUseCaseProvider = Provider<BlindSendMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindSendMessageUseCase(repository);
});

final blindChoiceUseCaseProvider = Provider<BlindChoiceUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindChoiceUseCase(repository);
});

final getBlindDateOpenUseCaseProvider = Provider<GetBlindDateOpenUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetBlindDateOpenUseCase(repository);
});

// View Model
final chatViewModelProvider =
StateNotifierProvider.autoDispose<ChatViewModel, ChatState>((ref) {
  final loadChatRoomsUseCase = ref.watch(loadChatRoomsUseCaseProvider);
  final getBlindDateOpenUseCase = ref.watch(getBlindDateOpenUseCaseProvider);

  return ChatViewModel(loadChatRoomsUseCase, getBlindDateOpenUseCase);
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


// blind date
final socketIoServiceProvider = Provider<SocketIoService>((ref) {
  return SocketIoService();
});

final blindDateDetailViewModelProvider = StateNotifierProvider.autoDispose<BlindDateDetailViewModel, BlindDateDetailState>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);

  final blindConnectUseCase = ref.watch(blindConnectUseCaseProvider);
  final blindDisconnectUseCase = ref.watch(blindDisconnectUseCaseProvider);
  final blindSendMessageUseCase = ref.watch(blindSendMessageUseCaseProvider);
  final blindChoiceUseCase = ref.watch(blindChoiceUseCaseProvider);

  final blindJoinedStreamUseCase = ref.watch(blindJoinedStreamUseCaseProvider);
  final blindStartStreamUseCase = ref.watch(blindStartStreamUseCaseProvider);
  final blindSystemStreamUseCase = ref.watch(blindSystemStreamUseCaseProvider);
  final blindFreezeStreamUseCase = ref.watch(blindFreezeStreamUseCaseProvider);
  final blindBroadcastStreamUseCase = ref.watch(blindBroadcastStreamUseCaseProvider);
  final blindJoinStreamUseCase = ref.watch(blindJoinStreamUseCaseProvider);
  final blindParticipantsStreamUseCase = ref.watch(blindParticipantsStreamUseCaseProvider);
  final blindMatchStreamUseCase = ref.watch(blindMatchStreamUseCaseProvider);
  final blindDisconnectStreamUseCase = ref.watch(blindDisconnectStreamUseCaseProvider);

  return BlindDateDetailViewModel(
    ref,
    hiveService,
    blindConnectUseCase,
    blindDisconnectUseCase,
    blindSendMessageUseCase,
    blindChoiceUseCase,
    blindJoinedStreamUseCase,
    blindStartStreamUseCase,
    blindSystemStreamUseCase,
    blindFreezeStreamUseCase,
    blindBroadcastStreamUseCase,
    blindJoinStreamUseCase,
    blindParticipantsStreamUseCase,
    blindMatchStreamUseCase,
    blindDisconnectStreamUseCase,
  );
});

final blindDateMessagesProvider = StateNotifierProvider<BlindDateMessagesNotifier, List<BlindDateMessage>>((ref) {
    // final viewModel = ref.watch(chatDetailViewModelProvider.notifier);
    return BlindDateMessagesNotifier();
  },
);