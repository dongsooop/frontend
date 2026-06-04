import 'package:dongsoop/domain/chat/model/chatbot.dart';
import 'package:dongsoop/domain/chat/use_case/send_chatbot_message_use_case.dart';
import 'package:dongsoop/presentation/home/chatbot/chatbot_state.dart';
import 'package:dongsoop/presentation/home/chatbot/chatbot_view_model.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendChatbotMessageUseCaseProvider = Provider<SendChatbotMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendChatbotMessageUseCase(repository);
});

final chatbotViewModelProvider =
StateNotifierProvider.autoDispose<ChatbotViewModel, ChatbotState>((ref) {
  final sendChatbotMessageUseCase = ref.watch(sendChatbotMessageUseCaseProvider);

  return ChatbotViewModel(ref, sendChatbotMessageUseCase);
});

final chatbotMessagesProvider = StateNotifierProvider<ChatbotMessagesNotifier, List<Chatbot>>((ref) {
  return ChatbotMessagesNotifier();
});