import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/model/chatbot.dart';
import 'package:dongsoop/domain/chat/use_case/send_chatbot_message_use_case.dart';
import 'package:dongsoop/presentation/chat/chatbot/chatbot_state.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatbotViewModel extends StateNotifier<ChatbotState> {
  final Ref _ref;
  final SendChatbotMessageUseCase _sendChatbotMessageUseCase;

  ChatbotViewModel(
    this._ref,
    this._sendChatbotMessageUseCase,
  ) : super(ChatbotState(isLoading: false, isEnabled: false));

  String _prevTextValue = '';

  Future<void> sendChatbotMessage(String text) async {
    state = state.copyWith(isLoading: true);
    _ref.read(chatbotMessagesProvider.notifier).addMessage(Chatbot(isMe: true, text: text));

    try {
      // AI 통신
      final result = await _sendChatbotMessageUseCase.execute(text);
      await Future.delayed(const Duration(seconds: 5));

      state = state.copyWith(isLoading: false);
      _ref.read(chatbotMessagesProvider.notifier).addMessage(Chatbot(isMe: false, text: result));

    } on ChatbotException catch (e) {
      state = state.copyWith(isLoading: false,);
      _ref.read(chatbotMessagesProvider.notifier).addMessage(Chatbot(isMe: false, text: e.message));
    }
  }

  void onChanged(String text) {
    if (_prevTextValue == text) {
      return;
    }
    _prevTextValue = text;

    state = state.copyWith(isEnabled: false);

    if (text.length > 64 || text.isEmpty || text == '') {
      return;
    }

    state = state.copyWith(isEnabled: true);
  }
}

class ChatbotMessagesNotifier extends StateNotifier<List<Chatbot>> {
  ChatbotMessagesNotifier() : super([]);

  void addMessage(Chatbot message) {
    state = [message, ...state];
  }
}