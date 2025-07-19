import 'package:dongsoop/domain/chat/use_case/create_group_chat_room_use_case.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitGroupChatUseCaseProvider = Provider<CreateGroupChatRoomUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return CreateGroupChatRoomUseCase(repository);
});
