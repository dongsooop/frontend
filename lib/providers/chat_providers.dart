import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/socket_io_service.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source_impl.dart';
import 'package:dongsoop/data/chat/repository/chat_repository_impl.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_choice_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_connect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_disconnect_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/blind_send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/connect_chat_list_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/create_QNA_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/delete_chat_data_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/blind_date/get_blind_date_open_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_offline_messages_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_paged_messages.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_room_detail_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_user_nicknames_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/get_chat_rooms_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/kick_user_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/leave_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/save_chat_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/disconnect_chat_list_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/send_message_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_broadcast_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_disconnect_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_ended_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_freeze_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_join_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_joined_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_match_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_participants_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_start_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/blind_system_stream_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/subscribe_chat_list_use_case.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_state.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_view_model.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_state.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_view_model.dart';
import 'package:dongsoop/presentation/chat/chat_detail_state.dart';
import 'package:dongsoop/presentation/chat/chat_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/network/stomp_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/chat/use_case/chat/connect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/chat/disconnect_chat_room_use_case.dart';
import 'package:dongsoop/domain/chat/use_case/stream/subscribe_messages_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_detail_view_model.dart';
import 'package:dongsoop/presentation/chat/chat_state.dart';
import 'package:dongsoop/domain/chat/use_case/stream/subscribe_block_use_case.dart';


final aiDioProvider = Provider<Dio>((ref) => createAuthDio(ref: ref, useAi: true));

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

final blindEndedStreamUseCaseProvider = Provider<BlindEndedStreamUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return BlindEndedStreamUseCase(repository);
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

final connectChatListUseCaseProvider = Provider<ConnectChatListUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ConnectChatListUseCase(repository);
});

final disconnectChatListUseCaseProvider = Provider<DisconnectChatListUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return DisconnectChatListUseCase(repository);
});

final subscribeChatListUseCaseProvider = Provider<SubscribeChatListUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SubscribeChatListUseCase(repository);
});


// View Model
final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final loadChatRoomsUseCase = ref.watch(loadChatRoomsUseCaseProvider);
  final getBlindDateOpenUseCase = ref.watch(getBlindDateOpenUseCaseProvider);
  final connectChatListUseCase = ref.watch(connectChatListUseCaseProvider);
  final disconnectChatListUseCase = ref.watch(disconnectChatListUseCaseProvider);
  final subscribeChatListUseCase = ref.watch(subscribeChatListUseCaseProvider);

  return ChatViewModel(loadChatRoomsUseCase, getBlindDateOpenUseCase, connectChatListUseCase, disconnectChatListUseCase, subscribeChatListUseCase);
});

final chatDetailViewModelProvider = StateNotifierProvider<ChatDetailViewModel, ChatDetailState>((ref) {
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

final blindDateViewModelProvider =
StateNotifierProvider.autoDispose<BlindDateViewModel, BlindDateState>((ref) {
  final getBlindDateOpenUseCase = ref.watch(getBlindDateOpenUseCaseProvider);

  return BlindDateViewModel(getBlindDateOpenUseCase);
});

final blindDateDetailViewModelProvider = StateNotifierProvider.autoDispose<BlindDateDetailViewModel, BlindDateDetailState>((ref) {
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
  final blindEndedStreamUseCase = ref.watch(blindEndedStreamUseCaseProvider);
  final blindDisconnectStreamUseCase = ref.watch(blindDisconnectStreamUseCaseProvider);

  return BlindDateDetailViewModel(
    ref,
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
    blindEndedStreamUseCase,
    blindDisconnectStreamUseCase,
  );
});

final blindDateMessagesProvider = StateNotifierProvider<BlindDateMessagesNotifier, List<BlindDateMessage>>((ref) {
    return BlindDateMessagesNotifier();
  },
);

