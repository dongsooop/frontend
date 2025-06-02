import 'package:dongsoop/data/chat/data_source/chat_data_source.dart';
import 'package:dongsoop/data/chat/data_source/chat_data_source_impl.dart';
import 'package:dongsoop/data/chat/repository/chat_repository_impl.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/use_case/load_chat_rooms_use_case.dart';
import 'package:dongsoop/presentation/chat/chat_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// 추후 기능, 책임 별로 providers 분리

// Data Source
final chatDataSourceProvider = Provider<ChatDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);

  return ChatDataSourceImpl(authDio);
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

// View Model
final chatViewModelProvider =
StateNotifierProvider<ChatViewModel, AsyncValue<List<ChatRoom>?>>((ref) {
  final loadChatRoomsUseCase = ref.watch(loadChatRoomsUseCaseProvider);

  return ChatViewModel(loadChatRoomsUseCase);
});
