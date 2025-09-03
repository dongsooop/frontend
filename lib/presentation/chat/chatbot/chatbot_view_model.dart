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

    _ref.read(chatbotMessagesProvider.notifier).addUser(text);
    final pendingId = _ref.read(chatbotMessagesProvider.notifier).addBotTyping();

    try {
      // AI 통신
      final result = await _sendChatbotMessageUseCase.execute(text);
      await Future.delayed(const Duration(seconds: 5));
      _ref.read(chatbotMessagesProvider.notifier).resolveBot(pendingId, result);

      state = state.copyWith(isLoading: false);
    } on ChatbotException catch (e) {
      _ref.read(chatbotMessagesProvider.notifier).resolveBot(pendingId, e.message);

      state = state.copyWith(isLoading: false);
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

  void addMessage(Chatbot message) => state = [message, ...state];

  String addUser(String text) {
    final id = 'user_${DateTime.now().microsecondsSinceEpoch}';
    addMessage(Chatbot(id: id, isMe: true, text: text));
    return id;
  }

  String addBotTyping() {
    final id = 'bot_${DateTime.now().microsecondsSinceEpoch}';
    addMessage(Chatbot(id: id, isMe: false, text: '', typing: true));
    return id;
  }

  void resolveBot(String id, String text) {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(text: text, typing: false) else m,
    ];
  }
}