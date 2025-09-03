import 'package:dongsoop/domain/chat/model/chatbot.dart';
import 'package:dongsoop/presentation/chat/chatbot/chatbot_state.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatbotViewModel extends StateNotifier<ChatbotState> {
  final Ref _ref;

  ChatbotViewModel(
    this._ref,
  ) : super(ChatbotState(isLoading: false,));

  Future<void> sendChatbotMessage(String text) async {
    state = state.copyWith(isLoading: true);
    _ref.read(chatbotMessagesProvider.notifier).addMessage(Chatbot(isMe: true, text: text));

    try {
      // AI 통신
      // final result = await _sendChatbot(text);
      state = state.copyWith(isLoading: false);
      _ref.read(chatbotMessagesProvider.notifier).addMessage(Chatbot(isMe: false, text: result));

    } catch (e) {
      state = state.copyWith(isLoading: false,);
      _ref.read(chatbotMessagesProvider.notifier).addMessage(Chatbot(isMe: false, text: '응답에 실패했습니다. 잠시 후에 다시 시도해 주세요.'));
    }
  }
}

class ChatbotMessagesNotifier extends StateNotifier<List<Chatbot>> {
  ChatbotMessagesNotifier() : super([]);

  void addMessage(Chatbot message) {
    state = [message, ...state];
  }

  void clear() {
    state = [];
  }
}