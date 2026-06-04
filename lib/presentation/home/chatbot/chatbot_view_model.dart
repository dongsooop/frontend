import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/chat/model/chatbot.dart';
import 'package:dongsoop/domain/chat/use_case/send_chatbot_message_use_case.dart';
import 'package:dongsoop/presentation/home/providers/chatbot_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chatbot_state.dart';

class ChatbotViewModel extends StateNotifier<ChatbotState> {
  final Ref _ref;
  final SendChatbotMessageUseCase _sendChatbotMessageUseCase;

  ChatbotViewModel(
    this._ref,
    this._sendChatbotMessageUseCase,
  ) : super(ChatbotState(isLoading: false, isEnabled: false));

  String _prevTextValue = '';

  void init() {
    _ref.read(chatbotMessagesProvider.notifier).addSystemOnce(
      '동냥이와의 대화 내용은 저장되지 않아요',
    );
  }

  Future<void> sendChatbotMessage(String text) async {
    if (state.isLoading || text.isEmpty) return;

    state = state.copyWith(isLoading: true);

    final messages = _ref.read(chatbotMessagesProvider.notifier);
    messages.addUser(text);
    final pendingId = messages.addBotTyping();

    try {
      // AI 통신
      final result = await _sendChatbotMessageUseCase.execute(text);
      final String answerText = result['text'] ?? '';
      final String? url = result['url'];

      messages.resolveBot(pendingId, answerText, url);

    } on ChatbotException catch (e) {
      messages.resolveBot(pendingId, e.message, null);

    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void onChanged(String text) {
    if (_prevTextValue == text) return;
    _prevTextValue = text;

    state = state.copyWith(isEnabled: false);

    var enabled = false;
    if (text.isNotEmpty && text.length <= 64) {
      enabled = true;
    }
    state = state.copyWith(isEnabled: enabled);
  }
}

class ChatbotMessagesNotifier extends StateNotifier<List<Chatbot>> {
  ChatbotMessagesNotifier() : super([]);

  void addMessage(Chatbot message) => state = [message, ...state];

  void addSystemOnce(String text) {
    final hasSystem = state.any((m) => m.isSystem == true);
    if (hasSystem) return;
    final id = 'sys_${DateTime.now().microsecondsSinceEpoch}';
    addMessage(Chatbot(id: id, isMe: false, text: text, isSystem: true));
  }

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

  void resolveBot(String id, String text, String? url) {
    state = [
      for (final m in state)
        if (m.id == id) m.copyWith(text: text, url: url, typing: false) else m,
    ];
  }
}